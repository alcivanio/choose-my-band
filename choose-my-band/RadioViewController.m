//
//  RadioViewController.m
//  choose-my-band
//
//  Created by BEPiD on 27/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "RadioViewController.h"

@interface RadioViewController ()

@end

@implementation RadioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initImplementation];
    [self startConfigurations];
    [self initElements];
    
    //[self getMusics];
    
    //[self testesInicial];
    //[self addDependenciaTeste];
    
}

-(void)startConfigurations
{
    self.pointOfScrollY = 0;
    self.topBar = [[CMBTopBar alloc]initWithNavigationController:self.navigationController];
    [self.view addSubview:self.topBar];
    self.bottomBar = [[CMBBottomBar alloc]initWithY:self.view.frame.size.height width:self.view.frame.size.width navigationController:self.navigationController andScroll:self.radioScroll];
    self.bottomBar.myTabBar = self.tabBarController;
    [self.view addSubview:self.bottomBar];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.bottomBar.viewControllers = self.viewControllers;
    
    
    [self.topBar.returnButton setEnabled:NO];
    [self.topBar.returnButton setHidden:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initElements
{
    //MAKING THE COVER OF ALBUM
    CGRect frameAlbumCover = CGRectMake(5, 10, self.view.frame.size.width-10, self.view.frame.size.width-10);
    self.albumCover = [[UIImageView alloc]initWithFrame:frameAlbumCover];
    [self.albumCover setImage:[UIImage imageNamed:@"album-cover"]];
    [self.albumCover.layer setCornerRadius:5];
    [self.albumCover setClipsToBounds:YES];
    [self.albumCover setContentMode:UIViewContentModeScaleAspectFill];//no images stretching
    
    
    
    //PLAYER AND STOP
    int yOfPlayer = ((self.view.frame.size.height - self.bottomBar.frame.size.height - frameAlbumCover.origin.y + frameAlbumCover.size.height)/2) - 60;
    CGRect framePlayer = CGRectMake(5, yOfPlayer, 80, 80);
    self.controlRadio = [[UIButton alloc]initWithFrame:framePlayer];
    [self.controlRadio setTitle:@"" forState:UIControlStateNormal];
    [self.controlRadio setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
    [self.controlRadio.layer setCornerRadius:40];
    [self.controlRadio setClipsToBounds:YES];
    [self.controlRadio addTarget:self action:@selector(alterateControlRadio:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //MUSIC TITLE
    CGRect frameMusicTitle = CGRectMake(framePlayer.origin.x + framePlayer.size.width + 5, framePlayer.origin.y , self.view.frame.size.width - (framePlayer.origin.x + framePlayer.size.width), framePlayer.size.height - 20);
    self.musicTitle = [[UILabel alloc] initWithFrame:frameMusicTitle];
    [self.musicTitle setText:@"Title of the music"];
    
    //Layout of the Music title
    //[self.musicTitle setFont:[UIFont systemFontOfSize:22.0]];
    [self.musicTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:19.0]];
    [self.musicTitle setTextColor:[UIColor colorWithRed:77.0f/255.0f green:205.0f/255.0f blue:242.0f/255.0f alpha:1]];
    
    
    
    //BAND NAME + ALBUM TITLE
    CGRect frameTitleAlbum = frameMusicTitle;
    frameTitleAlbum.origin.y += 20;
    self.artistAlbumTitle = [[UILabel alloc]initWithFrame:frameTitleAlbum];
    [self.artistAlbumTitle setText:@"Artist | Album"];
    
    //Layout of the band name + album title
    [self.artistAlbumTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
    [self.artistAlbumTitle setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1]];
    
    
    
    //ADDING ELEMENTS ON SCROLL
    [self.radioScroll addSubview:self.albumCover];
    [self.radioScroll addSubview:self.controlRadio];
    [self.radioScroll addSubview:self.musicTitle];
    [self.radioScroll addSubview:self.artistAlbumTitle];
}

-(void)initImplementation
{
    self.sharedPlayer = [SingletonPlayer sharedInstance];
    //self.sharedPlayer.playList = [NSMutableArray new];
    //self.listOfMusics = self.sharedPlayer.playList;
    self.sharedPlayer.currentController = self;
    //[self.sharedPlayer.player setDelegate:self];
    
}

-(IBAction)alterateControlRadio:(UIButton *)sender
{
    if ([self.sharedPlayer.typePlayer isEqualToString:@"player"]) {
        [self.sharedPlayer.player stop];
    }
    
    [self alterateColorButton];
    if (sender.tag == 0)
    {
        [self getMusics];
        self.sharedPlayer.tryPlay = YES;
        self.sharedPlayer.play = YES;
        [sender setTag:1];
        if (self.bufferOfPlay)
        {
            
            self.sharedPlayer.typePlayer = @"radio";
            [self.sharedPlayer playListMusic];
            [self loadInformations];
        }
    }
    else {
        [self.sharedPlayer.player pause];
        self.sharedPlayer.play = NO;
        [self.sharedPlayer.player setCurrentTime:0];
        [sender setTag:0];
    }
    
}

-(void)alterateColorButton
{
    if(!self.player.isPlaying)
    {
        [self.controlRadio setBackgroundColor:[UIColor colorWithRed:77.0f/255.0f green:205.0f/255.0f blue:242.0f/255.0f alpha:1]];
        //[self.musicTitle setText:@"Loading the music"];
        //[self.artistAlbumTitle setText:@"Wait for a moment :)"];
    }
    else
        [self.controlRadio setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
}


#pragma mark delegate player

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self.sharedPlayer generateNextMusic];
        [self.sharedPlayer.player setCurrentTime:1];
        
        [self.sharedPlayer playListMusic];
        [self loadInformations];
    }
}


//Coisas novas

-(void) getMusics{
    
    PFQuery *query = [PFQuery queryWithClassName:@"MusicTop100"];
    // [query selectKeys:@[@"coverPictureUrl", @"title", @"streamUrl", @"ScId"]];
    //[query whereKey:@"ScId" notEqualTo:@"0"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (!self.listOfMusics)
                self.listOfMusics = [NSMutableArray new];
            
            if (!self.artists)
                self.artists = [NSMutableArray new];
            
            for (PFObject *object in objects) {
                Music *newMusic = [[Music alloc] initWithPFObject:object];
                [self.listOfMusics addObject:newMusic];
                
                [self.artists addObject:[object objectForKey:@"artist"]];
            }
            self.sharedPlayer.playList = self.listOfMusics;
            self.bufferOfPlay = YES;
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        if (self.sharedPlayer.tryPlay) {
            self.sharedPlayer.typePlayer = @"radio";
            [self.sharedPlayer playListMusic];
            [self loadInformations];
            
        }
    }];
    
    
}

-(void) generateNextMusic{
    
    int next = [self.nextMusic intValue];
    
    while (next == [self.nextMusic intValue]) {
        srand(time(NULL));
        next = rand()%[self.sharedPlayer.playList count];
    }
    
    self.nextMusic = @(next);
}

- (void) loadInformations{
    
    Music *musicPlaying = [self.sharedPlayer.playList objectAtIndex:[self.sharedPlayer.nextMusic intValue]];
    
    NSString *coverUrl = [musicPlaying.imageUrl stringByReplacingOccurrencesOfString:@"large.jpg" withString:@"t500x500.jpg"];
    if (!([coverUrl isEqualToString:@""]) && coverUrl != nil )
        [self.albumCover setImageWithURL:[NSURL URLWithString:coverUrl]];
    
    else
        [self.albumCover setImage:[UIImage imageNamed:@"album-cover"]];
    
    [self.musicTitle setText:musicPlaying.title];
    [self.artistAlbumTitle setText:[self.artists objectAtIndex:[self.sharedPlayer.nextMusic intValue]]];
    
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl)
    {
        if (event.subtype == UIEventSubtypeRemoteControlPlay)
        {
            [[[SingletonPlayer sharedInstance] player] play];
        }
        else if (event.subtype == UIEventSubtypeRemoteControlPause)
        {
            [[[SingletonPlayer sharedInstance] player] pause];
        }

    }
}

-(void)addDependenciaTeste
{
    
    //    NSLog(@"Opa");
    //    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    //    [query whereKey:@"scId" equalTo:@"112661768"];
    //    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    //
    //        NSLog(@"segundo");
    //        PFObject *fistUser = [objects objectAtIndex:0];
    //
    //        PFQuery *twoQuery = [PFQuery queryWithClassName:@"Album"];
    //        [twoQuery whereKey:@"objectId" equalTo:@"Iz18KtLeoB"];
    //        [twoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    //            if(!error)
    //            {
    //                NSLog(@"terceiro");
    //                PFRelation *relation = [fistUser relationForKey:@"albuns"];
    //                PFObject *objAlbum = [objects objectAtIndex:0];
    //
    //                [relation addObject:objAlbum];
    //                [fistUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    //                    if(!error)
    //                        NSLog(@"sucesso");
    //                }];
    //            }
    //        }];
    //
    //    }];
    
    //    PFQuery *qrUser = [PFQuery queryWithClassName:@"User"];
    //    [qrUser whereKey:@"scId" equalTo:@"112661768"];
    //    PFObject *user = [[qrUser findObjects]objectAtIndex:0];
    //
    //    PFQuery *albumQuery = [PFQuery queryWithClassName:@"Album"];
    //    [albumQuery whereKey:@"title" equalTo:@"Dois Legiao Urbana"];
    //    PFObject *album = [[albumQuery findObjects]objectAtIndex:0];
    //
    //    PFRelation *relacaoUserAlbum = [user relationForKey:@"albuns"];
    //    [relacaoUserAlbum addObject:album];
    //    [user save];
    //
    //    NSLog(@"SALVO COM SUCESSO");
    
    
    
    //    NSLog(@"Opa");
    //    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    //    [query whereKey:@"scId" equalTo:@"112661768"];
    //    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    //
    //        NSLog(@"segundo");
    //        PFObject *fistUser = [objects objectAtIndex:0];
    //
    //        PFObject *album = [PFObject objectWithClassName:@"Album"];
    //        album[@"title"] = @"Dois Legiao Urbana";
    //        album[@"coverUrl"] = @"http://ecx.images-amazon.com/images/I/51whxW0WoWL.jpg";
    //        album[@"owner"] = fistUser;
    //        album[@"albumType"] = @"Album";
    //
    //        PFQuery *queryMusic = [PFQuery queryWithClassName:@"Music"];
    //        [queryMusic findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    //         {
    //             for (PFObject *objMusic in objects)
    //             {
    //                 PFRelation *relationAlbumMusic = [album relationForKey:@"musics"];
    //                 [relationAlbumMusic addObject:objMusic];
    //             }
    //
    //         }];
    //
    //
    //        [album saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    //            if(!error)
    //            {
    //                PFRelation *relacao = [fistUser relationForKey:@"albuns"];
    //                [relacao addObject:album];
    //                [fistUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    //                    if(!error)
    //                        NSLog(@"sucesso ao salvar album");
    //                }];
    //
    //            }
    //        }];
    //
    //    }];
    
    //    PFQuery *minhaQuery = [PFQuery queryWithClassName:@"Album"];
    //    [minhaQuery whereKey:@"objectId" equalTo:@"Th4xzLlFey"];
    //    [minhaQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    //        if(!error)
    //        {
    //            PFObject *album = [objects objectAtIndex:0];
    //
    //            PFQuery *queryMusic = [PFQuery queryWithClassName:@"Music"];
    //            [queryMusic findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    //            {
    //                PFRelation *relationAlbumMusic = [album relationForKey:@"musics"];
    //                for (PFObject *objMusic in objects)
    //                {
    //                    [relationAlbumMusic addObject:objMusic];
    //                }
    //
    //                [album saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    //                    if(!error)
    //                        NSLog(@"SUCESSO");
    //                }];
    //            }];
    //
    //
    //        }
    //    }];
    
    
    
    
    
    
    
    //RELATION OF THE USER IN FOLLOWERS
    
    //    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    //    [query whereKey:@"scId" equalTo:@"112661768"];
    //    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    //
    //        PFObject *fistUser = [objects objectAtIndex:0];
    //        PFRelation *relation = [fistUser relationForKey:@"followers"];
    //
    //        PFQuery *queryTwo = [PFQuery queryWithClassName:@"CustomUser"];
    //        [queryTwo whereKey:@"scId" equalTo:@"333333333"];
    //
    //        [queryTwo findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    //            [relation addObject:[objects objectAtIndex:0]];
    //            [fistUser saveInBackground];
    //            NSLog(@"terminado");
    //        }];
    //
    //
    //    }];
}

@end


























