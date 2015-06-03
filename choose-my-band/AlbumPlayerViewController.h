//
//  AlbumPlayerViewController.h
//  choose-my-band
//
//  Created by Alcivanio on 02/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBBottomBar.h"
#import "CMBTopBar.h"
#import "Album.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "CMBAlbumTableCell.h"
#import "SingletonPlayer.h"
#import "ShareContentViewController.h"

@interface AlbumPlayerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) UIButton *play;
@property(nonatomic) UIButton *prev;
@property(nonatomic) UIButton *next;
@property(nonatomic) UIImageView *albumCover;
@property(nonatomic) UITextView *albumTitle;
@property(nonatomic) UILabel *albumBandAndYear;
@property(nonatomic) UILabel *albumDuration;
@property(nonatomic) UIButton *shareButton;
@property(nonatomic) UITableView *tableListMusics;
@property(nonatomic) IBOutlet UIScrollView *scroll;
@property(nonatomic) NSMutableArray *listMusics;
@property(nonatomic) Album *album;
@property(nonatomic) SingletonPlayer *sharedPlayer;

//ADDS OF THE PROJECT
@property (nonatomic) CMBTopBar *topBar;
@property (nonatomic) CMBBottomBar *bottomBar;
@property (nonatomic) NSMutableArray *viewControllers;


-(void) playMusicOfSearchAtIndex:(int)index;
-(void)loadInfosOfAlbum;


@end
