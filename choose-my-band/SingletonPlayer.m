//
//  SingletonPlayer.m
//  choose-my-band
//
//  Created by BEPiD on 03/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "SingletonPlayer.h"
#import "RadioViewController.h"
#import "AlbumPlayerViewController.h"


@implementation SingletonPlayer

+(id)sharedInstance
{
    static dispatch_once_t obj = 0;
    __strong static id _sharedObject = nil; //pode ser qualquer nome
    
    dispatch_once(&obj, ^{
        _sharedObject = [[self alloc]init];
    });
    
    // Retorna o objeto para o método de classe
    return _sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        //self.player = [[AVAudioPlayer alloc] init];
        
        [self initializeUserPreferences];
        
        self.generalSReference = [GeneralSingleton sharedInstance];
        self.playList = [NSMutableArray new];
        //[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkPlaying) userInfo:nil repeats:YES];
        srand(time(NULL));
        self.nextMusic = @(rand()%100);
    }
    return self;
}

-(void)playMusicWithStringUrlOfStream:(NSString *)streamUrl
{
    
    int numberOfMusic = (int) self.musicToPlay;
    //[self.player prepareToPlay];

    
    [SCRequest performMethod:SCRequestMethodGET onResource:[NSURL URLWithString:streamUrl] usingParameters:nil
                 withAccount:self.generalSReference.scAccount sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (([self.typePlayer isEqualToString:@"player"] || self.play) && !error && (numberOfMusic == self.musicToPlay || [self.typePlayer isEqualToString:@"radio"])) {
             
             NSError *playerError;
             self.player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
             
             [self.player setDelegate:self];
             
             [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
             [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
             [[AVAudioSession sharedInstance] setActive:YES error:nil];
             
             [self.player prepareToPlay];
             [self.player play];
             [self loadInformationOfInfoCenter];
             [self publishActionInFacebook];
             NSLog(@"tocando");
             
             self.play = YES;
         }
     }];
    
    
    //
    //    NSDictionary *dict = [self.tracks objectAtIndex:[self.nextMusic intValue]];
    //
    //    NSString *streamUrl = [dict objectForKey:@"streamUrl"];
    //
    //    [SCRequest performMethod:SCRequestMethodGET
    //                  onResource:[NSURL URLWithString:streamUrl]
    //             usingParameters:nil
    //                 withAccount:account
    //      sendingProgressHandler:nil
    //             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    //                 if (self.play) {
    //                     NSError *playerError;
    //                     self.player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
    //                     [self.player setDelegate:self];
    //                     [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //                     [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    //                     [[AVAudioSession sharedInstance] setActive:YES error:nil];
    //
    //                     NSString *stringCoverUrl = [dict objectForKey:@"coverPictureUrl"];
    //                     stringCoverUrl = [stringCoverUrl stringByReplacingOccurrencesOfString:@"large.jpg" withString:@"t500x500.jpg"];
    //                     NSString *string = [dict objectForKey:@"title"];
    //
    //                     [self.musicTitle setText:string];
    //
    //                     if(!([stringCoverUrl isEqualToString:@""]) && stringCoverUrl != nil)
    //                         [self.albumCover setImageWithURL:[NSURL URLWithString:stringCoverUrl]];
    //                     else
    //                         [self.albumCover setImage:[UIImage imageNamed:@"album-cover"]];//The default cover
    //                     //[self.albumCover setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:urlCover]]];
    //
    //                     [self.player play];
    //                 }
    //
    //                 self.play = YES;
    //             }];
    //}
    
}

#pragma mark Facebook Share
//public something at facebook
-(void)publishActionInFacebook{
    if (self.preferences.isAutoShare) {
        if ([self.typePlayer isEqualToString:@"radio"])
            self.currentMusicIndex = [self.nextMusic intValue];
        
        Music *musicPlaying = [self.playList objectAtIndex:self.currentMusicIndex];
        
        // Get the image
        UIImage *image;
        
        if (musicPlaying.imageUrl != (NSString *) [NSNull null] && musicPlaying.imageUrl){
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[musicPlaying.imageUrl stringByReplacingOccurrencesOfString:@"large.jpg" withString:@"t500x500.jpg"]]]];
        }
        else{
            image = [UIImage imageNamed:@"album-cover"];
        }
        
        // stage an image
        [FBRequestConnection startForUploadStagingResourceWithImage:image completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(!error) {
                NSLog(@"Successfuly staged image with staged URI: %@", [result objectForKey:@"uri"]);
                
                NSMutableDictionary<FBOpenGraphObject> *object = [FBGraphObject openGraphObjectForPost];
                object.provisionedForPost = YES;
                object[@"title"] = musicPlaying.title;
                object[@"type"] = @"mybandchoose:music";
                object[@"url"] = @"http://www.fb.com";
                object[@"image"] = @[@{@"url": [result objectForKey:@"uri"], @"user_generated" : @"false" }];
                
                id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
                [action setObject:object forKey:@"music"];
                
                // create action referencing user owned object
                [FBRequestConnection startForPostWithGraphPath:@"/me/mybandchoose:play" graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if(!error) {
                        NSLog([NSString stringWithFormat:@"OG story posted, story id: %@", [result objectForKey:@"id"]]);
                        
                    } else {
                        // An error occurred
                        NSLog(@"Encountered an error posting to Open Graph: %@", error);
                    }
                }];
                
            }
        }];

    }
    
}

-(void)loadInformationOfInfoCenter{
    if ([self.typePlayer isEqualToString:@"radio"])
        self.currentMusicIndex = [self.nextMusic integerValue];
    
    Music *musicPlaying = [self.playList objectAtIndex:self.currentMusicIndex];
    
    MPMediaItemArtwork *albumArt;
    
    if(![musicPlaying.imageUrl isEqual:(NSString *) [NSNull null]] && musicPlaying.imageUrl)
        albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[musicPlaying.imageUrl stringByReplacingOccurrencesOfString:@"large.jpg" withString:@"t500x500.jpg"]]]]];
    else
        albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"album-cover"]];
    
    NSDictionary *info = @{ MPMediaItemPropertyAlbumTitle: musicPlaying.title,
                            MPMediaItemPropertyTitle: @"Choose My Band",
                            MPMediaItemPropertyPlaybackDuration: @(self.player.duration),
                            MPMediaItemPropertyArtwork: albumArt,
                            MPMediaItemPropertyPlayCount : @(self.player.currentTime)};
    
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;
}

-(void)changeInfoMusic
{
    NSDictionary *info = @{ MPMediaItemPropertyAlbumTitle: @"",
                            MPMediaItemPropertyTitle: @"Choose My Band"
                            };
    
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;
}

-(void)playListMusic{
    
    if (self.player.currentTime == 0 && self.player)
        [self.player play];
    
    else{
        Music *musicToPlay = [self.playList objectAtIndex:[self.nextMusic intValue]];
        [self playMusicWithStringUrlOfStream:musicToPlay.streamUrl];
        self.musicToPlay = [self.nextMusic integerValue];
        
    }
}

-(void)playMusicOfPlayListAtIndex:(int)index
{
    self.currentMusicIndex = index;
    self.musicToPlay = self.currentMusicIndex;
    Music *musicPlay = [self.playList objectAtIndex:index];
    [self playMusicWithStringUrlOfStream:musicPlay.streamUrl];
}

-(void)playNextMusic
{
    [self.player stop];
    [self changeInfoMusic];
    
    if(self.currentMusicIndex == [self.playList count]-1)
        [self playMusicOfPlayListAtIndex:0];
    else
        [self playMusicOfPlayListAtIndex:self.currentMusicIndex+1];
    
    [self showWhichMusicIsPlaying];
}

-(void)playPrevMusic
{
    
    [self.player stop];
    [self changeInfoMusic];

    
    if (self.currentMusicIndex == 0)
        [self playMusicOfPlayListAtIndex:[self.playList count]-1];
    else
        [self playMusicOfPlayListAtIndex:self.currentMusicIndex-1];
    
    [self showWhichMusicIsPlayingPrev];
}

-(void)reloadInfosOfScreen
{
    if([self.typePlayer isEqualToString:@"radio"])
    {
        RadioViewController *controller = (RadioViewController *)self.currentController;
        [controller loadInformations];
    }
    else if([self.typePlayer isEqualToString:@"player"])
    {
        [self showWhichMusicIsPlaying];
        
    }
    else{return;}
}

-(void)showWhichMusicIsPlaying
{
    AlbumPlayerViewController *albumView = (AlbumPlayerViewController *) self.currentController;
    NSIndexPath *indexNext = [NSIndexPath indexPathForRow:self.currentMusicIndex inSection:0];
    NSIndexPath *indexPrev;
    
    if (self.currentMusicIndex == 0)
        indexPrev = [NSIndexPath indexPathForRow:(int)[albumView.album.musics count] -1  inSection:0];
    else
        indexPrev = [NSIndexPath indexPathForRow:self.currentMusicIndex-1 inSection:0];
    
    [[albumView.tableListMusics cellForRowAtIndexPath:indexNext] setSelected:YES];
    [[albumView.tableListMusics cellForRowAtIndexPath:indexPrev] setSelected:NO];

}

-(void)showWhichMusicIsPlayingPrev
{
    AlbumPlayerViewController *albumView = (AlbumPlayerViewController *) self.currentController;
    NSIndexPath *indexNext = [NSIndexPath indexPathForRow:self.currentMusicIndex inSection:0];
    NSIndexPath *indexPrev;
    
    if (self.currentMusicIndex == (int)[albumView.album.musics count] -1)
        indexPrev = [NSIndexPath indexPathForRow:0  inSection:0];
    else
        indexPrev = [NSIndexPath indexPathForRow:self.currentMusicIndex+1 inSection:0];
    
    [[albumView.tableListMusics cellForRowAtIndexPath:indexNext] setSelected:YES];
    [[albumView.tableListMusics cellForRowAtIndexPath:indexPrev] setSelected:NO];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        if ([self.typePlayer isEqualToString:@"radio"]) {
            [self generateNextMusic];
            [self.player setCurrentTime:1];
            [self reloadInfosOfScreen];
            
            Music *nextMusic = [self.playList objectAtIndex:[self.nextMusic intValue]];
            [self playMusicWithStringUrlOfStream:nextMusic.streamUrl];
        }
        else if ([self.typePlayer isEqualToString:@"player"])
            [self playNextMusic];
            [self reloadInfosOfScreen];
    }
}

-(void) generateNextMusic{
    
    int next = [self.nextMusic intValue];
    
    while (next == [self.nextMusic intValue]) {
        srand(time(NULL));
        next = rand()%[self.playList count];
    }
    
    self.nextMusic = @(next);
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{}

-(void)checkPlaying
{
    if(![self.player isPlaying])
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
    
}


#pragma mark userPreferences

-(void)initializeUserPreferences
{
    //Getting the sound cloud accout
    self.preferences = [UserPreferences new];
    /* Load the data if file exists. We need make it, just one time */
    if([self fileExists])
        [self loadDataSaveClass];
    
}


-(NSString *)pathOfSavedClassDirectory
{
    /* The path where the archives are (may be) saved */
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [pathDocuments stringByAppendingPathComponent:@"cmbPreferences.cmb"];
}

-(BOOL)saveDataSaveClass
{
    /* Save the data of the self.dataClass, with basic infos of the user */
    [NSKeyedArchiver archiveRootObject:self.preferences toFile:[self pathOfSavedClassDirectory]];
    
    NSFileManager *mng = [NSFileManager defaultManager];
    NSLog(@"%@", [self pathOfSavedClassDirectory]);
    BOOL breakDois = [mng fileExistsAtPath:[self pathOfSavedClassDirectory]];
    
    return YES;
}

-(UserPreferences *)loadDataSaveClass
{
    /* Load the data saved */
    self.preferences = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathOfSavedClassDirectory]];
    
    NSFileManager *mng = [NSFileManager defaultManager];
    NSLog(@"%@", [self pathOfSavedClassDirectory]);
    [mng fileExistsAtPath:[self pathOfSavedClassDirectory]];
    
    /* return, if the user wants to user the data */
    return self.preferences;
}

/* Remove the data class of the system. Return YES if it is finished with sucess */
-(BOOL)deleteDataClass
{
    NSFileManager *fManager = [NSFileManager defaultManager];
    return [fManager removeItemAtPath:[self pathOfSavedClassDirectory] error:nil];
}

/* If the archive exists, return YES */
-(BOOL)fileExists
{
    NSFileManager *mng = [NSFileManager defaultManager];
    return [mng fileExistsAtPath:[self pathOfSavedClassDirectory]];
}


@end