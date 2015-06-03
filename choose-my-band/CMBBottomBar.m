//
//  CMBBottomBar.m
//  choose-my-band
//
//  Created by Alcivanio on 22/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "CMBBottomBar.h"
#import "RadioViewController.h"
#import "AlbumPlayerViewController.h"
#import "FeedViewController.h"
#import "ProfileViewController.h"
#import "SearchViewController.h"

@implementation CMBBottomBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithY:(int)originY width:(int)width navigationController:(UINavigationController *)navController andScroll:(UIScrollView *)scroll
{
    //RECT of the view
    CGRect frameBottom = CGRectMake(0, originY-52, width, 52);
    self = [self initWithFrame:frameBottom];
    
    //Atribuitions
    self.navController = navController;
    self.scroll = scroll;
    self.contentOffSetOnScroll = 0;
    self.fullHeightView = originY;
    
    //Info the delegate
    if (self.scroll)
        [self.scroll setDelegate:self];
    
    [self initElements];
    return self;
}

-(void)initElements
{
    self.generalSingletonReference = [GeneralSingleton sharedInstance];
    //Changing the background color
    [self setBackgroundColor:[UIColor colorWithRed:34/255.f green:34/255.f blue:34/255.f alpha:0.9]];
    
    //CGRect positionOfButton = CGRectMake(20, 15, 21, 21);
    CGRect positionOfButton = CGRectMake(0, 0, self.frame.size.width/5, self.frame.size.width/5);
    CGRect positionOfImageButton = CGRectMake(20, 16, 21, 21);
    
    self.buttonUser = [[UIButton alloc]init];
    self.buttonSpecial = [[UIButton alloc]init];
    self.buttonFeed = [[UIButton alloc]init];
    self.buttonRadio = [[UIButton alloc]init];
    self.buttonSearch = [[UIButton alloc]init];
    
    self.viewControllers = [NSMutableArray new];
    
    //buttons
    NSArray *buttonsArray = [[NSArray alloc] initWithObjects:_buttonUser, _buttonSpecial, _buttonFeed, _buttonRadio, _buttonSearch, nil];
    
    //Images of the icons
    NSArray *imagesIcons = [[NSArray alloc] initWithObjects:@"tbusericon", @"tbespecialicon", @"tbfeedicon-active", @"tbradioicon", @"tbsearchicon", nil];
    
   
    UIButton *button;
    
    for (int i=0; i<[imagesIcons count]; i++)
    {
        button = [buttonsArray objectAtIndex:i];
        //[button setBackgroundColor:[UIColor redColor]];
        [button setFrame:positionOfButton];
        
        UIImageView *imgButton = [[UIImageView alloc]initWithFrame:positionOfImageButton];
        [imgButton setImage:[UIImage imageNamed:[imagesIcons objectAtIndex:i]]];
        [button addSubview:imgButton];
        
        [button addTarget:self action:@selector(buttonBottomPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i+100];
        [self addSubview:button];
        
        positionOfButton.origin.x += (self.frame.size.width/5);

    }

}


-(void)buttonBottomPressed:(UIButton *)sender
{
    [self.myTabBar setSelectedIndex:sender.tag-99];
   
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideBottomBarOrShow: self.scroll];
}

-(void)hideBottomBarOrShow:(UIScrollView *)scrollView
{
    //Caso o y do scroll seja menor que zero, ele nao deve fazer nada
    if(scrollView.contentOffset.y < 0)
        return;
    
    CGRect frameBotBar = self.frame;
    
    //Se a bottom bar estiver acima de onde deve ficar
    if(self.frame.origin.y < (self.fullHeightView - self.frame.size.height))
    {
        frameBotBar.origin.y = self.fullHeightView - self.frame.size.height;
        self.frame = frameBotBar;
    }
    
    //Se estiver baixando o scroll
    else if((scrollView.contentOffset.y > self.contentOffSetOnScroll) && (self.frame.origin.y < self.fullHeightView))
    {
        frameBotBar.origin.y += (scrollView.contentOffset.y - self.contentOffSetOnScroll);
        self.frame = frameBotBar;
    }
    
    //Se estiver aumentando - o que sobrou de op - e se a botbar nao estiver acima do que deve
    else if((self.frame.origin.y > (self.fullHeightView - 52)) && (scrollView.contentOffset.y < self.contentOffSetOnScroll))
    {
        frameBotBar.origin.y -= self.contentOffSetOnScroll - scrollView.contentOffset.y;
        self.frame = frameBotBar;
    }
    
    if(self.frame.origin.y > self.fullHeightView -52){
        
    }
    
    //Atualiza o valor do scrolloffset
    self.contentOffSetOnScroll = scrollView.contentOffset.y;
}



@end










