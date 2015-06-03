//
//  SingletonPlayer.h
//  choose-my-band
//
//  Created by BEPiD on 03/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SCUI.h"
#import "UIImageView+AFNetworking.h"
#import "GeneralSingleton.h"
#import "UserPreferences.h"
#import <FacebookSDk/FacebookSDK.h>

@interface SingletonPlayer : NSObject<AVAudioPlayerDelegate>

//Atributes of player
@property (nonatomic) AVAudioPlayer *player;
@property (nonatomic) NSMutableArray *playList;
@property (nonatomic) NSNumber *nextMusic;
@property (nonatomic) BOOL play;
@property (nonatomic) BOOL read;
@property (nonatomic) BOOL bufferOfPlay;
@property (nonatomic) BOOL tryPlay;
@property (nonatomic) GeneralSingleton *generalSReference;
@property (nonatomic) UIViewController *currentController;
@property (nonatomic) NSString *typePlayer;
@property (nonatomic) NSInteger currentMusicIndex;
@property (nonatomic) NSInteger musicToPlay;

/* Share Preferences */
@property (nonatomic) UserPreferences *preferences;



/* Methods */
-(void)playMusicWithStringUrlOfStream:(NSString *)streamUrl;
-(void)playListMusic;
-(void) generateNextMusic;
-(void)playMusicOfPlayListAtIndex:(int)index;
-(void)playPrevMusic;
-(void)playNextMusic;




+(id)sharedInstance;

//preferences

-(void)initializeGeneralSingleton;
-(UserPreferences *)loadDataSaveClass;
-(BOOL)deleteDataClass;
-(BOOL)saveDataSaveClass;
-(BOOL)fileExists;


@end
