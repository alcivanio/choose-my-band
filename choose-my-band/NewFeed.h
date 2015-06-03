//
//  NewFeed.h
//  choose-my-band
//
//  Created by Alcivanio on 16/09/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "Status.h"
#import "AlbumPlayerViewController.h"
#import "SingletonPlayer.h"


@interface NewFeed : UIView<UIGestureRecognizerDelegate>

//Properties
@property(weak, nonatomic) NSString *urlProfileImage;
@property(weak, nonatomic) NSString *urlAlbumImage;
@property(weak, nonatomic) NSString *userName;
@property(weak, nonatomic) NSString *statusText;
@property(nonatomic) Status *statusReference;
@property(nonatomic) UITextView *statusTextView;
@property(nonatomic) UIImageView *albumImageView;
@property(nonatomic) UIImageView *profilePictureView;
@property(nonatomic) SingletonPlayer *sharedPlayer;
@property(nonatomic) UITabBarController *tabBarReference;

//Metholds
- (id)initProfileImage:(NSString *)urlProfileImage andAlbumImage:(NSString *)urlAlbumImage userName:(NSString *)userName statusText:(NSString *)statusText frame:(CGRect)frame;
- (id)initProfileImage:(NSString *)urlProfileImage andAlbumImage:(NSString *)urlAlbumImage userName:(NSString *)userName statusText:(NSString *)statusText frame:(CGRect)frame andStatus:(Status *)status;


@end
