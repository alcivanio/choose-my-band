//
//  RadioViewController.h
//  choose-my-band
//
//  Created by BEPiD on 27/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "ViewController.h"
#import "CMBBottomBar.h"
#import "CMBTopBar.h"
#import <AVFoundation/AVFoundation.h>
#import "SCUI.h"
#import <Parse/Parse.h>
#import "UIImageView+AFNetworking.h"
#import "Music.h"
#import "SingletonPlayer.h"
#import <MediaPlayer/MediaPlayer.h>

@interface RadioViewController : UIViewController<AVAudioPlayerDelegate, UIAlertViewDelegate>
@property(nonatomic)UIImageView *albumCover;
@property (nonatomic) CMBTopBar *topBar;
@property (nonatomic) CMBBottomBar *bottomBar;
@property (nonatomic) NSInteger pointOfScrollY;
@property (weak, nonatomic) IBOutlet UIScrollView *radioScroll;
@property (nonatomic) UIButton *controlRadio;//Start - stop
@property (nonatomic) UILabel *musicTitle;
@property (nonatomic) UILabel *artistAlbumTitle;
@property (nonatomic) NSMutableArray *viewControllers;
@property (nonatomic) NSMutableArray *artists;

@property(nonatomic) __block NSMutableArray *listOfMusics;
@property(nonatomic) SingletonPlayer *sharedPlayer;

//Implementação
@property (nonatomic) AVAudioPlayer *player;
@property (nonatomic) NSMutableArray *tracks;
@property (nonatomic) NSNumber *nextMusic;
@property (nonatomic) BOOL play;
@property (nonatomic) BOOL read; //apagar depois
@property (nonatomic) BOOL bufferOfPlay;
@property (nonatomic) BOOL tryPlay;

-(IBAction)alterateControlRadio:(id)sender;
- (void) loadInformations;

@end
