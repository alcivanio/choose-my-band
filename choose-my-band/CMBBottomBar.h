//
//  CMBBottomBar.h
//  choose-my-band
//
//  Created by Alcivanio on 22/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralSingleton.h"

@interface CMBBottomBar : UIView<UIScrollViewDelegate>

@property (nonatomic) UIButton *buttonUser;
@property (nonatomic) UIButton *buttonSpecial;
@property (nonatomic) UIButton *buttonFeed;
@property (nonatomic) UIButton *buttonRadio;
@property (nonatomic) UIButton *buttonSearch;
@property (nonatomic) UIScrollView *scroll;
@property (nonatomic) UINavigationController *navController;
@property (nonatomic) NSMutableArray *vControllers;
@property (nonatomic) int fullHeightView;
@property (nonatomic) NSInteger contentOffSetOnScroll;//to know if the bottom bar have to be hidden
@property (nonatomic) GeneralSingleton *generalSingletonReference;
@property (nonatomic) NSMutableArray *viewControllers;
@property (nonatomic) UITabBarController *myTabBar;

-(id)initWithY:(int)originY width:(int)width navigationController:(UINavigationController *)navController andScroll:(UIScrollView *)scroll;
-(void)hideBottomBarOrShow:(UIScrollView *)scrollView;
@end
