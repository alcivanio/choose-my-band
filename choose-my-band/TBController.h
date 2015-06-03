//
//  TBController.h
//  choose-my-band
//
//  Created by Alcivanio on 04/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBController : UITabBarController

@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
