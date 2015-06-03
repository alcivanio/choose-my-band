//
//  ProfileViewController.h
//  choose-my-band
//
//  Created by Alcivanio on 25/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "ViewController.h"
#import "CMBBottomBar.h"
#import "CMBTopBar.h"
#import "User.h"
#import <Parse/Parse.h>
#import "SCUI.h"
#import "UIImageView+AFNetworking.h"
#import "RadioViewController.h"
#import "AlbumPlayerViewController.h"
#import "ProfileFollowersCollectionController.h"
#import "Status.h"
#import "NewFeed.h"
#import "DetailPostViewController.h"
#import "NewAlbumViewController.h"

@interface ProfileViewController : UIViewController <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) CMBTopBar *topBar;
@property (nonatomic) CMBBottomBar *bottomBar;
@property (nonatomic) BOOL returnButtonIsHidden;
@property (nonatomic) NSInteger pointOfScrollY;
@property (nonatomic) GeneralSingleton *generalSingletonReference;
@property (nonatomic) NSMutableArray *viewControllers;
//informations on screen
@property (nonatomic) IBOutlet UIScrollView *profileScroll;
@property (nonatomic) UIImageView *coverImage;
@property (nonatomic) UIImageView *profilePicture;
@property (nonatomic) UILabel *nameAndLastName;
@property (nonatomic) UILabel *bio;
//collections of screen (following and albuns)
@property (nonatomic) UICollectionViewFlowLayout *layoutFollowers;
@property (nonatomic) UICollectionViewFlowLayout *layoutAlbuns;
@property (strong, nonatomic) UICollectionView *collectionFollowers;
@property (strong, nonatomic) UICollectionView *collectionAlbuns;
@property (nonatomic) ProfileFollowersCollectionController *controllerFollowers;
//Status on screen
@property (nonatomic) NSMutableArray *listOfStatusOnScreen;
@property (nonatomic) NSInteger nextYPositionOfStatus;
//User informations
@property (nonatomic) User *user;
@property (nonatomic) NSString *userId;
@property (nonatomic) UIView *followBt;
@property (nonatomic) UILabel *followLb;
@property (nonatomic) UIImageView *followImg;

-(void)loadDataOfDataBase;

@end
