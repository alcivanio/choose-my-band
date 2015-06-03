//
//  CMBTopBar.m
//  choose-my-band
//
//  Created by Alcivanio on 22/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "CMBTopBar.h"
#import "MenuViewController.h"

@implementation CMBTopBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(id)initWithNavigationController:(UINavigationController *)navController
{
    CGRect frameView = CGRectMake(0, 0, 320, 58);
    self = [self initWithFrame:frameView];
    self.navController = navController;
    self.isAtMenu = NO;
    [self initElements];
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)initElements
{
    //Setting the color of the top bar
    [self setBackgroundColor:[UIColor colorWithRed:77/255.f green:205/255.f blue:251/255.f alpha:1]];
    
    //UIImageView with the return image
    CGRect frameReturnImage = CGRectMake(14, 13, 21, 14);
    UIImageView *imageReturn = [[UIImageView alloc]initWithFrame:frameReturnImage];
    [imageReturn setImage:[UIImage imageNamed:@"return-top"]];
    
    //Return button on top
    CGRect frameReturn = CGRectMake(0, 20, 66, 38);
    self.returnButton = [[UIButton alloc]initWithFrame:frameReturn];
    
    //Para contar quantas vc disponiveis no array NSLog(@"%d", self.navController.viewControllers.count);
    
    if ([self.navController.viewControllers count] >= 2)
        [self.returnButton addSubview:imageReturn];
    
    [self.returnButton addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    //[self.returnButton setBackgroundColor:[UIColor blackColor]];
    
    //Logo button on top
    CGRect frameLogo = CGRectMake(85, 14, 151, 44);
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:frameLogo];
    [logoImage setImage:[UIImage imageNamed:@"logo-top"]];
    
    //Menu button top
    CGRect frameMenuImage = CGRectMake(31, 12, 21, 15);
    UIImageView *imageMenu = [[UIImageView alloc]initWithFrame:frameMenuImage];
    [imageMenu setImage:[UIImage imageNamed:@"menu-top"]];
    
    CGRect frameMenu = CGRectMake(self.frame.size.width-66, 20, 66, 38);
    self.menuButton = [[UIButton alloc]initWithFrame:frameMenu];
    [self.menuButton addSubview:imageMenu];
    [self.menuButton addTarget:self action:@selector(showMenuAction) forControlEvents:UIControlEventTouchUpInside];
    //[self.menuButton setBackgroundColor:[UIColor blackColor]];
    
    //Add subviews
    [self addSubview:self.returnButton];
    [self addSubview:logoImage];
    [self addSubview:self.menuButton];
}

-(void)returnAction
{
    NSLog(@"OI");
    if(self.isAtMenu){
        [self.navController dismissViewControllerAnimated:YES completion:nil];

    }
    else{
        [self.navController popViewControllerAnimated:YES];

    }

}

-(void)showMenuAction
{
    if(self.isAtMenu){
        [self.navController dismissViewControllerAnimated:YES completion:nil];
        //[self.navController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        UIStoryboard *stBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MenuViewController *rvc = [stBoard instantiateViewControllerWithIdentifier:@"MenuStoryboard"];
        
        rvc.navController = self.navController;
        [self.navController presentViewController:rvc animated:YES completion:nil];
        
    }
}
@end


















