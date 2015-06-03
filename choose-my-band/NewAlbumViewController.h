//
//  SignUpViewController.h
//  Choose My Band
//
//  Created by bepid on 08/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CMBUsersToFollowTableViewCell.h"
#import "MusicSelectViewController.h"
#import "UIImageView+AFNetworking.h"
#import "GeneralSingleton.h"
#import "ProfileViewController.h"
#import "CMBBottomBar.h"

@interface NewAlbumViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate>

//Sended data of last screen
@property(nonatomic) NSDictionary *soundCloudData;


//Elements of create album
@property (nonatomic) CMBTopBar *topBar;



@property (weak, nonatomic) IBOutlet UIScrollView *signUpScroll;
@property (nonatomic) UIImageView *coverAlbum;
@property (nonatomic) UILabel *albumTitle;
@property (nonatomic) UILabel *dateOfAlbum;
@property (nonatomic) UILabel *labelTitle;
@property (nonatomic) UILabel *post;
@property (nonatomic) UITextField *fieldTitle;
@property (nonatomic) UITextField *fieldPost;
@property (nonatomic) UIButton *selectSounds;
@property(nonatomic) UIButton *startCMB;

/*Util properties*/
@property(nonatomic) PFObject *user;
@property (nonatomic) NSMutableArray *selectedMusics;
@property (nonatomic) UITabBarController *referenceTabBar;

@property (nonatomic) GeneralSingleton *genSingleton;
@property (nonatomic) CMBBottomBar *bottomBar;//?


//The default colors and fonts
@property UIFont *fontTextViewAndField;
@property UIFont *fontHeaderFields;
@property UIColor *textColorHead;
@property UIColor *textFieldsTextColor;
@property UIColor *textFieldsBgColor;


@end
