//
//  TBController.m
//  choose-my-band
//
//  Created by Alcivanio on 04/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "TBController.h"

#define kAnimationDuration .3

@interface TBController ()

@end

@implementation TBController

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
    [self setTabBarHidden:YES animated:YES];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isTabBarHidden {
	CGRect viewFrame = self.view.frame;
	CGRect tabBarFrame = self.tabBar.frame;
	return tabBarFrame.origin.y >= viewFrame.size.height;
}


- (void)setTabBarHidden:(BOOL)hidden {
	[self setTabBarHidden:hidden animated:NO];
}


- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
	BOOL isHidden = self.tabBarHidden;
	if(hidden == isHidden)
		return;
	UIView *transitionView = [[[self.view.subviews reverseObjectEnumerator] allObjects] lastObject];
	if(transitionView == nil) {
		NSLog(@"could not get the container view!");
		return;
	}
    
	CGRect viewFrame = self.view.frame;
	CGRect tabBarFrame = self.tabBar.frame;
	CGRect containerFrame = transitionView.frame;
	tabBarFrame.origin.y = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height);
	containerFrame.size.height = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height);
	[UIView animateWithDuration:kAnimationDuration
					 animations:^{
						 self.tabBar.frame = tabBarFrame;
						 transitionView.frame = containerFrame;
					 }
	 ];
}

@end
