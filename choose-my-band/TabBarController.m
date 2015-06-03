//
//  TabBarController.m
//  choose-my-band
//
//  Created by Alcivanio on 22/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y+7,
    self.tabBar.frame.size.width, 42);

    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1]];

    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbarbackground"]];
    
//    UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
//    CGRect frameDois = self.tabBar.viewForBaselineLayout.frame;
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
