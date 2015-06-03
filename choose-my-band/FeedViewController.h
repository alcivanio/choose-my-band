//
//  FeedViewController.h
//  choose-my-band
//
//  Created by Alcivanio on 21/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewFeed.h"
#import "CMBTopBar.h"
#import "CMBBottomBar.h"
#import <Parse/Parse.h>
#import "Status.h"
#import "GeneralSingleton.h"
#import "DetailPostViewController.h"

@interface FeedViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *feedScroll;
@property (nonatomic) NSInteger pointOfScrollY;
@property (nonatomic) CMBTopBar *topBar;
@property (nonatomic) CMBBottomBar *bottomBar;
@property (nonatomic) NSInteger contentOffSetOnScroll;//to know if the bottom bar have to be hidden
@property (nonatomic) NSMutableArray *viewControllers;


@property (nonatomic) NSMutableArray *statusOfFeed;//Status
@property (nonatomic) NSMutableArray *statusOfFeedOnScreen;//NewFeed
@property (nonatomic) NSInteger lastYPositionOnScreen;
@property (nonatomic) User *user;
@property (nonatomic) GeneralSingleton *genSingleton;
@property (nonatomic) int skip;
@property (nonatomic) BOOL shouldContinue;

@end
