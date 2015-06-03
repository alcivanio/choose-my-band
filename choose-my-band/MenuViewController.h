//
//  LogoutViewController.h
//  choose-my-band
//
//  Created by BEPiD on 02/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUI.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CMBTopBar.h"
#import "SingletonPlayer.h"
#import "GeneralSingleton.h"
#import "DataSaveClass.h"
#import "ProfileViewController.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) UINavigationController *navController;

@property(nonatomic) UIButton *logoutButton;
@property(nonatomic) UIButton *loginButtonFacebook;

@property(nonatomic) UITableView *tableMenu;
@property(nonatomic) NSMutableArray *optionsMenu;
@property(nonatomic) NSArray *sectionsTitle;

@property(nonatomic) UISwitch *switchNotification;
@property(nonatomic) UISwitch *switchFacebook;
@property(nonatomic) CMBTopBar *topBar;
@property(nonatomic) SingletonPlayer *sharedPlayer;
@property(nonatomic) UITabBar *tabBar;

@property(nonatomic) GeneralSingleton *genSingle;

@end
