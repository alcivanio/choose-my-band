//
//  SignUpViewController.h
//  Choose My Band
//
//  Created by bepid on 08/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"
#import "CMBUsersToFollowTableViewCell.h"
#import "MusicSelectViewController.h"
#import "UIImageView+AFNetworking.h"
@interface SignUpViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>

//Sended data of last screen
@property(nonatomic) NSDictionary *soundCloudData;
@property(nonatomic)UIView *topView;
//Elements of first view
@property(nonatomic) NSMutableArray *coverUrls;
@property(nonatomic) NSMutableArray *suggestedUsers;
@property(nonatomic) NSMutableArray *suggestedUsersSelected;

@property (nonatomic) IBOutlet UIScrollView *signUpScroll;
@property (nonatomic) UILabel *typeYourName;
@property (nonatomic) UILabel *typeYourBio;
@property (nonatomic) UILabel *typeYourEmail;
@property (nonatomic) UILabel *selectYourCover;
@property(nonatomic) UITextField *yourName;
@property(nonatomic) UITextField *yourBio;
@property(nonatomic) UITextField *yourEmail;
@property(nonatomic) UICollectionView *collectionCover;
@property(nonatomic) UIButton *toView2;

//Elements of second view
@property (nonatomic) UITableView *listOfFollowers;
@property(nonatomic) UIButton *createNewAlbum;
@property(nonatomic) UIButton *startCMB; //present in second view and create album

//Elements of create album
@property (nonatomic) UIImageView *coverAlbum;
@property (nonatomic) UILabel *albumTitle;
@property (nonatomic) UILabel *dateOfAlbum;
@property (nonatomic) UILabel *labelTitle;
@property (nonatomic) UILabel *post;
@property (nonatomic) UITextField *fieldTitle;
@property (nonatomic) UITextField *fieldPost;
@property (nonatomic) UIButton *selectSounds;

/*Util properties*/
@property(nonatomic) PFObject *user;
@property (nonatomic) NSMutableArray *selectedMusics;
@property (nonatomic) UITabBarController *referenceTabBar;

//The default colors and fonts
@property UIFont *fontTextViewAndField;
@property UIFont *fontHeaderFields;
@property UIColor *textColorHead;
@property UIColor *textFieldsTextColor;
@property UIColor *textFieldsBgColor;

@end
