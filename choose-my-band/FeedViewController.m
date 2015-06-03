//
//  FeedViewController.m
//  choose-my-band
//
//  Created by Alcivanio on 21/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

//Init with the elements of the view
- (id)init
{
    self = [super init];
    
    if (self)
    {}
    return self;
}


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
    self.shouldContinue = YES;
    
    
    //Alloc the status of feed variable
    if(!self.statusOfFeed)
        self.statusOfFeed = [[NSMutableArray alloc]init];
    
    //And the status of feed on scree
    if(!self.statusOfFeedOnScreen)
        self.statusOfFeedOnScreen = [[NSMutableArray alloc]init];
    
    self.skip = 0;
    self.lastYPositionOnScreen = 5;
    [self.feedScroll setDelegate:self];
    
    self.topBar = [[CMBTopBar alloc]initWithNavigationController:self.navigationController];
    [self.view addSubview:self.topBar];
    self.bottomBar = [[CMBBottomBar alloc]initWithY:self.view.frame.size.height width:self.view.frame.size.width navigationController:self.navigationController andScroll:nil];
    [self.view addSubview:self.bottomBar];
    self.bottomBar.viewControllers = self.viewControllers;
    self.bottomBar.myTabBar = self.tabBarController;
    self.genSingleton = [GeneralSingleton sharedInstance];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.topBar.returnButton setEnabled:NO];
    [self.topBar.returnButton setHidden:YES];
    
    //[self addElementsInScroll];
    
    //[self getAllStatus];
    
    //[self addElementsInScroll];
    [self setNeedsStatusBarAppearanceUpdate];
    //[self loadStatusAndFollowers];
    //[self loadMoreStatus];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(void)addElementsInScroll//DESCONTINUADO??
{
    CGRect frameDois;
    
    for (int i=0; i<[self.statusOfFeed count]; i++)
    {
        Status *newStatus = [self.statusOfFeed objectAtIndex:i];
        
        frameDois = CGRectMake(0, self.pointOfScrollY, 310, 190);
        NewFeed *feed = [[NewFeed alloc]initProfileImage:newStatus.owner.profilePictureUrl andAlbumImage:newStatus.music.imageUrl userName:newStatus.owner.username statusText:newStatus.statusText frame:frameDois andStatus:newStatus];
        feed.tabBarReference = self.tabBarController;
        [self.feedScroll addSubview:feed];
        NSLog(@"Teste");
        self.pointOfScrollY = self.pointOfScrollY + 328;
    }
    
    [self.feedScroll setContentSize:CGSizeMake(310, self.pointOfScrollY)];
    
}

-(void)loadMoreStatus
{
    NSLog(@"%@",[NSString stringWithFormat:@"%d",self.statusOfFeed.count]);
    [PFCloud callFunctionInBackground:@"getLastStatus"withParameters:@{@"objectId":self.genSingleton.currentUser.objectId, @"limit":@"2", @"skip":[NSString stringWithFormat:@"%d",self.skip]}block:^(NSArray *lastStatus, NSError *error)
     {
         if (!error)
         {
             //NSArray *s = lastStatus;
             for(PFObject *obj in lastStatus)
                 [self.statusOfFeed addObject:[[Status alloc]initWithPFObjectOnFeed:obj]];
             [self showMoreStatusOnScreen];
             self.skip+=2;
             self.shouldContinue = YES;
             
             
             
         }
         else{
             NSLog(@"sdasd");
         }
     }];
}

-(void)showMoreStatusOnScreen
{
    CGRect frameStatus;
    for (int i = self.statusOfFeedOnScreen.count; i<self.statusOfFeed.count; i++)
    {
        frameStatus = CGRectMake(0, self.lastYPositionOnScreen, self.view.frame.size.width, 300);
        Status *statusAux = [self.statusOfFeed objectAtIndex:i];
        
        //The new feed
        NewFeed *feed = [[NewFeed alloc]initProfileImage:statusAux.owner.profilePictureUrl andAlbumImage:statusAux.music.imageUrl userName:statusAux.owner.username statusText:statusAux.statusText frame:frameStatus andStatus:statusAux];
        //NewFeed *feed = [[NewFeed alloc]initProfileImage:statusAux.owner.profilePictureUrl andAlbumImage:statusAux.music.imageUrl userName:@"Alcivanio" statusText:statusAux.statusText frame:frameStatus andStatus:statusAux];
        [feed setTag:100+i];
        
        //feed add gesture reconizer
        UITapGestureRecognizer *oneTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onStatusClick:)];
        [oneTouch setNumberOfTapsRequired:1];
        [feed addGestureRecognizer:oneTouch];
        
        feed.tabBarReference = self.tabBarController;
        self.lastYPositionOnScreen += feed.frame.size.height;
        
        [self.statusOfFeedOnScreen addObject:feed];
        [self.feedScroll addSubview:feed];
    }
    [self.feedScroll setContentSize:CGSizeMake(self.view.frame.size.width, self.lastYPositionOnScreen)];

}

-(void)onStatusClick:(UITapGestureRecognizer *)sender
{
    DetailPostViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailPostStoryboard"];
    detail.statusPost = [[self.statusOfFeedOnScreen objectAtIndex:sender.view.tag-100]statusReference];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.bottomBar hideBottomBarOrShow:scrollView];
    if(self.feedScroll.contentOffset.y+self.feedScroll.frame.size.height > self.feedScroll.contentSize.height-30){
        if (self.shouldContinue) {
            self.shouldContinue = NO;
            [self loadMoreStatus];

        }
    }
}




@end















