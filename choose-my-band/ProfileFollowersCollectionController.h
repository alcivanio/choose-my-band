//
//  ProfileFollowersCollectionController.h
//  choose-my-band
//
//  Created by Alcivanio on 29/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "CMBBottomBar.h"

@interface ProfileFollowersCollectionController : UICollectionViewController

@property(strong, nonatomic) NSMutableArray *collectionFollowers;
@property(nonatomic) UIViewController *controllerDados;
@property(nonatomic) CMBBottomBar *bottomBar;
@property(nonatomic) NSMutableArray *viewsLoaded;


- (instancetype)initWithProfileView:(UIViewController *)prof;

@end
