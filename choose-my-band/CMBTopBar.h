//
//  CMBTopBar.h
//  choose-my-band
//
//  Created by Alcivanio on 22/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CMBTopBar : UIView

@property (nonatomic) UIButton *returnButton;
@property (nonatomic) UIButton *menuButton;
@property (nonatomic) UINavigationController *navController;
@property (nonatomic) BOOL isAtMenu;


-(id)initWithNavigationController:(UINavigationController *)navController;

@end
