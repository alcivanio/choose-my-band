//
//  DetailPostViewController.h
//  Choose My Band
//
//  Created by BEPiD on 05/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBTopBar.h"
#import "Status.h"
#import "NewFeed.h"
#import "UIImageView+AFNetworking.h"
#import "GeneralSingleton.h"

@interface DetailPostViewController : UIViewController

@property(nonatomic)UIImageView *albumCover;
@property (nonatomic) CMBTopBar *topBar;
@property (nonatomic) NSInteger pointOfScrollY;
@property (nonatomic) NSInteger contentOffSetOnScroll;//to know if the bottom bar have to be hidden
@property (weak, nonatomic) IBOutlet UIScrollView *postScroll;

@property (nonatomic) UIImageView *coverAlbum;
@property (nonatomic) UIImageView *profilePicture;
@property (nonatomic) UIButton *likeIcon;
@property (nonatomic) UILabel *likeLabel;
@property (nonatomic) UITextView *textStatus;
@property (nonatomic) Status *statusPost;
@property (nonatomic) UIView *linePostToComments;
@property (nonatomic) NSMutableArray *comments;
@property (nonatomic) GeneralSingleton *genSingleton;
@property (nonatomic) SingletonPlayer *sharedPlayer;

@end
