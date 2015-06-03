//
//  ProfileViewController.m
//  choose-my-band
//
//  Created by Alcivanio on 25/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    /*  */
    self.generalSingletonReference = [GeneralSingleton sharedInstance];
    [self refreshUserID];
    [self loadDataOfDataBase];
    //[self reloadUserDataOnScreen];
    //[self reloadStatusOnScreen];

}

-(void)refreshUserID
{
    if(self.generalSingletonReference.isLoggin)
    {
        self.userId = self.generalSingletonReference.dataClass.scID;        
        for(UIView *subview in [self.profileScroll subviews])
           [subview removeFromSuperview];
        [self.bottomBar removeFromSuperview];
        [self.tabBarController removeFromParentViewController];
        [self initializeElements];
        [self startConfigurations];
        [self initProfileTop];

    }
    self.generalSingletonReference.isLoggin = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];//DEFAULT
    //Iniciando as partes superiores do perfil
    self.generalSingletonReference = [GeneralSingleton sharedInstance];
    //[self refreshUserID];
    [self initializeElements];
    [self startConfigurations];
    [self initProfileTop];
    [self loadDataOfDataBase];
    //[self openNewUserProfile];
    //[self startLoadDataOfDataBase];
    
}

-(void)initializeElements
{
    self.controllerFollowers = [[ProfileFollowersCollectionController alloc]initWithProfileView:self];
    self.listOfStatusOnScreen = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startConfigurations
{
    [self.profileScroll setDelegate:self];
    self.pointOfScrollY = 0;
    self.topBar = [[CMBTopBar alloc]initWithNavigationController:self.navigationController];
    [self.view addSubview:self.topBar];
    self.controllerFollowers.bottomBar = self.bottomBar;
    self.bottomBar = [[CMBBottomBar alloc]initWithY:self.view.frame.size.height width:self.view.frame.size.width navigationController:self.navigationController andScroll:self.profileScroll];
    [self.view addSubview:self.bottomBar];
    self.bottomBar.myTabBar = self.tabBarController;
    self.user = [[User alloc]init];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (self.returnButtonIsHidden)
        [self.tabBarController setSelectedIndex:1];
    //self.bottomBar.viewControllers = self.viewControllers;
    
}

#pragma mark "Layout of the app (Profile)"

-(void)initProfileTop
{
    int scrollViewSize = 0;//The size of the content of the scroll view
    
    //COVER PHOTO//
    int defBorder = 5;
    CGRect frameCover = CGRectMake(defBorder, defBorder*2, self.view.frame.size.width-defBorder*2, 190);
    self.coverImage = [[UIImageView alloc]initWithFrame:frameCover];
    [self.coverImage setImage:[UIImage imageNamed:@"user-cover"]];
    [self.coverImage.layer setCornerRadius:5];
    [self.coverImage setClipsToBounds:YES];
    [self.coverImage setContentMode:UIViewContentModeScaleAspectFill];
    scrollViewSize = frameCover.origin.y + frameCover.size.height; //increment the size of the scrollview
    
    
    
    //BUTTON FOLLOW
    CGRect frameFollow = CGRectMake(self.view.frame.size.width-95, frameCover.size.height+frameCover.origin.y-35, 80, 25);
    self.followBt = [[UIView alloc]initWithFrame:frameFollow];
    UITapGestureRecognizer *tapFollow = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickToFollow)];
    [self.followBt addGestureRecognizer:tapFollow];
    //[self.followBt addTarget:self action:@selector(onClickToFollow) forControlEvents:UIControlEventTouchUpInside];
    [self.followBt setBackgroundColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1]];
    [self.followBt.layer setCornerRadius:self.followBt.frame.size.height/2];
    [self.followBt setClipsToBounds:YES];
    
    self.followImg = [[UIImageView alloc]initWithFrame:CGRectMake(9, 6, 13, 13)];
    [self.followImg setImage:[UIImage imageNamed:@"follow-plus"]];
    
    self.followLb = [[UILabel alloc]initWithFrame:CGRectMake(self.followImg.frame.size.width + self.followImg.frame.origin.x + 5, -3, self.followBt.frame.size.width, 30)];
    [self.followLb setText:@"Follow"];
    [self.followLb setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [self.followLb setTextColor:[UIColor colorWithRed:221/244.f green:221/244.f blue:221/244.f alpha:1]];
    
    [self.followBt addSubview:self.followImg];
    [self.followBt addSubview:self.followLb];
    [self.followBt setHidden:YES];
    
    [self reloadFollowButton];
    
    
    //PROFILE PICTURE//
    CGRect frameProfile = CGRectMake(defBorder*3, frameCover.size.height - 25, 80, 80);
    self.profilePicture = [[UIImageView alloc]initWithFrame:frameProfile];
    [self.profilePicture setImage:[UIImage imageNamed:@"user-photo"]];
    [self.profilePicture.layer setCornerRadius:5];
    [self.profilePicture setClipsToBounds:YES];
    [self.coverImage setContentMode:UIViewContentModeScaleAspectFill];
    scrollViewSize  = (frameProfile.origin.y + frameProfile.size.height);
    
    
    //LABEL WITH THE NAME OF THE USER//
    CGRect frameOfTheName = CGRectMake(frameProfile.origin.x + frameProfile.size.width + 5, frameProfile.origin.y + 30, self.view.frame.size.width - frameProfile.origin.x + frameProfile.size.width + 5, 40);
    self.nameAndLastName = [[UILabel alloc]initWithFrame:frameOfTheName];
    [self.nameAndLastName setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:23.0f]];
    //[self.nameAndLastName setFont:[UIFont systemFontOfSize:23.0]];
    [self.nameAndLastName setText:@"loading..."];
    [self.nameAndLastName setTextColor:[UIColor colorWithRed:77.0f/255.0f green:205.0f/255.0f blue:242.0f/255.0f alpha:1]];
    
    
    //LABEL WITH THE BIO OF THE USER//
    CGRect frameBio = frameOfTheName;
    frameBio.origin.y += 20;
    self.bio = [[UILabel alloc]initWithFrame:frameBio];
    [self.bio setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [self.bio setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1]];
    [self.bio setText:@"loading..."];
    
    //LINE DIVISOR PROFILE AND FOLLOWERS
    CGRect frameLBFriends = CGRectMake(60, self.profilePicture.frame.origin.y + self.profilePicture.frame.size.height + 10, self.view.frame.size.width, 1);
    UIView *lineProfToFollowers = [[UIView alloc]initWithFrame:frameLBFriends];
    [lineProfToFollowers setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
    
    //SECOND LINE, DIVISOR OF THE LINE AND FOLLOWERS
    CGRect frameSecondLine = CGRectMake(0, frameLBFriends.origin.y+21, self.view.frame.size.width, 1);
    UIView *secondLine = [[UIView alloc]initWithFrame:frameSecondLine];
    [secondLine setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
    scrollViewSize = frameSecondLine.origin.y + 1;
    
    //LABEL WITH TITLE FOLLOWERS
    CGRect frameLBFollowers = CGRectMake(15, frameSecondLine.origin.y - 8, 71, 16);
    UILabel *lbFollowersTitle = [[UILabel alloc]initWithFrame:frameLBFollowers];
    [lbFollowersTitle setText:@"Followers"];
    [lbFollowersTitle setBackgroundColor:[UIColor colorWithRed:77/255.f green:205/255.f blue:251/255.f alpha:1]];
    [lbFollowersTitle.layer setCornerRadius:frameLBFollowers.size.height/2];
    [lbFollowersTitle setClipsToBounds:YES];
    [lbFollowersTitle setFont:[UIFont systemFontOfSize:13]];
    [lbFollowersTitle setTextAlignment:NSTextAlignmentCenter];
    [lbFollowersTitle setTextColor:[UIColor whiteColor]];
    
    
    //LAYOUT OF THE COLLECTIONS
    self.layoutFollowers = [[UICollectionViewFlowLayout alloc] init];
    [self.layoutFollowers setMinimumLineSpacing:19]; //espaçamento
    [self.layoutFollowers setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    
    //COLLECTION OF FOLLOWERS
    CGRect frameOfFriends = CGRectMake(5, scrollViewSize-4 , self.view.frame.size.width-10, 80);
    self.collectionFollowers = [[UICollectionView alloc]initWithFrame:frameOfFriends collectionViewLayout:self.layoutFollowers];
    [self.collectionFollowers registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"celulaFollowers"];
    [self.collectionFollowers setTag:1];
    [self.collectionFollowers setBackgroundColor:[UIColor whiteColor]];
    [self.collectionFollowers setShowsHorizontalScrollIndicator:NO];
    
    
    //THREE LINE
    CGRect frameThreeLine = CGRectMake(0, frameOfFriends.origin.y + frameOfFriends.size.height + 4, self.view.frame.size.width, 1);
    UIView *threeLine = [[UIView alloc]initWithFrame:frameThreeLine];
    [threeLine setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
    
    
    //LINE FOUR
    CGRect frameLineFour = frameThreeLine;
    frameLineFour.origin.y += 20;
    UIView *lineFour = [[UIView alloc]initWithFrame:frameLineFour];
    [lineFour setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
    
    
    //LAYOUT OF THE COLLECTIONS
    self.layoutAlbuns = [[UICollectionViewFlowLayout alloc] init];
    [self.layoutAlbuns setMinimumLineSpacing:19]; //espaçamento
    [self.layoutAlbuns setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //COLLECTION OF ALBUNS
    CGRect frameOfBands = frameOfFriends;
    frameOfBands.origin.y = frameLineFour.origin.y -3;
    self.collectionAlbuns = [[UICollectionView alloc] initWithFrame:frameOfBands collectionViewLayout:self.layoutAlbuns];
    [self.collectionAlbuns registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"celulaFollowers"];
    [self.collectionAlbuns setTag:2];
    [self.collectionAlbuns setBackgroundColor:[UIColor whiteColor]];
    [self.collectionAlbuns setShowsHorizontalScrollIndicator:NO];
    
    
    //LABEL WITH TITLE MY ALBUNS
    CGRect frameLBAlbuns = CGRectMake(15, frameLineFour.origin.y - 8, 71, 16);
    UILabel *lbAlbunsTitle = [[UILabel alloc]initWithFrame:frameLBAlbuns];
    [lbAlbunsTitle setText:@"Albuns"];
    [lbAlbunsTitle setBackgroundColor:[UIColor colorWithRed:77/255.f green:205/255.f blue:251/255.f alpha:1]];
    [lbAlbunsTitle.layer setCornerRadius:frameLBAlbuns.size.height/2];
    [lbAlbunsTitle setClipsToBounds:YES];
    [lbAlbunsTitle setFont:[UIFont systemFontOfSize:13]];
    [lbAlbunsTitle setTextAlignment:NSTextAlignmentCenter];
    [lbAlbunsTitle setTextColor:[UIColor whiteColor]];
    
    //LAST LINE - LINE FIVE
    CGRect frameLineFive = CGRectMake(0, frameOfBands.origin.y + frameOfBands.size.height + 4, self.view.frame.size.width, 1);
    UIView *lineFive = [[UIView alloc]initWithFrame:frameLineFive];
    [lineFive setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
    self.nextYPositionOfStatus = frameLineFive.origin.y + 20;
    
    //SETTING DELEGATE AND DATASOURCE OF COLLECTIONS VIEWS
    [self.collectionFollowers setDelegate:self.controllerFollowers];
    [self.collectionFollowers setDataSource:self.controllerFollowers];
    [self.collectionAlbuns setDelegate:self];
    [self.collectionAlbuns setDataSource:self];
    
    //ADDING THE COMPONENTS IN SCROOL VIEW//
    [self.profileScroll addSubview:self.coverImage];
    [self.profileScroll addSubview:self.followBt];
    [self.profileScroll addSubview:self.profilePicture];
    [self.profileScroll addSubview:self.nameAndLastName];
    [self.profileScroll addSubview:self.bio];
    [self.profileScroll addSubview:lineProfToFollowers];
    [self.profileScroll addSubview:self.collectionFollowers];
    [self.profileScroll addSubview:secondLine];
    [self.profileScroll addSubview:lbFollowersTitle];
    [self.profileScroll addSubview:threeLine];
    [self.profileScroll addSubview:self.collectionAlbuns];
    [self.profileScroll addSubview:lineFour];
    [self.profileScroll addSubview:lbAlbunsTitle];
    [self.profileScroll addSubview:lineFive];
    //tamanho do profileScroll para conter inicialmente somente os elementos acima
    [self.profileScroll setContentSize:CGSizeMake(self.view.frame.size.width,lineFive.frame.origin.y + lineFive.frame.size.height)];
    
}

#pragma mark content of the data base
//Will read all the data of the data base
-(void)loadDataOfDataBase:(NSString *)soundCloudID
{
    //Get all user data in one time
    [PFCloud callFunctionInBackground:@"getUserInformations" withParameters:@{@"scId":soundCloudID,@"limit":@"3"} block:^(NSArray *object, NSError *error)
     {
         //The data of the user
         self.user = [[User alloc]initWithPFObject:[object objectAtIndex:0]];
         [self reloadUserDataOnScreen];
         
         //The albuns of the user
         for (PFObject *obj in [object objectAtIndex:1])
             [self.user.albuns addObject:[[Album alloc]initWithPFObject:obj]];
         
         
         //the followers of the user
         for (PFObject *obj in [object objectAtIndex:2])
             [self.user.followers addObject:[[User alloc]initWithPFObject:obj]];
         self.controllerFollowers.collectionFollowers = self.user.followers;
         
         
         for (PFObject *obj in [object objectAtIndex:3])
             [self.user.statusList addObject:[[Status alloc]initWithPFObject:obj andOwner:self.user]];
         
         [self.collectionAlbuns reloadData];
         [self.collectionFollowers reloadData];
         [self reloadStatusOnScreen];
         
         //self.generalSingletonReference.currentUser = self.user;
         
     }];
    
}

-(void)loadDataOfDataBase
{
    if(self.userId)
    {
        [self loadDataOfDataBase:self.userId];
    }
    else
    {
        DataSaveClass *bollOr = [self.generalSingletonReference loadDataSaveClass];
        self.userId = self.generalSingletonReference.dataClass.scID;
        [self loadDataOfDataBase];
    }
    


}

-(void)reloadUserDataOnScreen
{
    [self.nameAndLastName setText:self.user.username];
    [self.bio setText:self.user.bio];
    [self.profilePicture setImageWithURL:[NSURL URLWithString:self.user.profilePictureUrl]];
    [self.coverImage setImageWithURL:[NSURL URLWithString:self.user.profileCoverUrl]];
}

-(void)reloadStatusOnScreen
{
    //Frame of status (refreshed everytime)
    CGRect frameStatus;
    
    for (int i = self.listOfStatusOnScreen.count; i<self.user.statusList.count; i++)
    {
        //the new frame positions and size
        frameStatus = CGRectMake(0, self.nextYPositionOfStatus, self.view.frame.size.width, 300);
        
        Status *statusAux = [self.user.statusList objectAtIndex:i];
        
        //the new feed
        NewFeed *feed = [[NewFeed alloc]initProfileImage:self.user.profilePictureUrl andAlbumImage:statusAux.music.imageUrl userName:self.user.username statusText:statusAux.statusText frame:frameStatus andStatus:statusAux];
        feed.tabBarReference = self.tabBarController;
        
        [feed setTag:100+i];
        
        //feed add gesture reconizer
        UITapGestureRecognizer *oneTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onStatusClick:)];
        [oneTouch setNumberOfTapsRequired:1];
        [feed addGestureRecognizer:oneTouch];
        
        //the new position of the next feed
        self.nextYPositionOfStatus += feed.frame.size.height;
        
        //add feed on list and on the screen
        [self.listOfStatusOnScreen addObject:feed];
        [self.profileScroll setContentSize:CGSizeMake(self.profileScroll.contentSize.width, self.profileScroll.contentSize.height+300)];
        [self.profileScroll addSubview:feed];
    }
}

-(void)onStatusClick:(UITapGestureRecognizer *)sender
{
    DetailPostViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailPostStoryboard"];
    detail.statusPost = [[self.listOfStatusOnScreen objectAtIndex:sender.view.tag-100]statusReference];
    [self.navigationController pushViewController:detail animated:YES];
    
}

-(void)openNewUserProfile:(NSString *)userId
{
    UIStoryboard *stBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileViewController *rvc = (ProfileViewController *)[stBoard instantiateViewControllerWithIdentifier:@"ProfileStoryboard"];
    rvc.userId = userId;
    [self.navigationController pushViewController:rvc animated:YES];
}



#pragma mark Follow button configurations

-(void)onClickToFollow
{
    NSLog(@"Entrou aqui");
    PFRelation *relation = [self.generalSingletonReference.currentUser.referenceOfPFObject relationForKey:@"followers"];
    PFQuery *searchFollow = [relation query];
    [searchFollow whereKey:@"scId" equalTo:self.userId];
    [searchFollow findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(!error)
         {
             //if not found result of users
             if(objects.count <= 0)
             {
                 NSLog(@"O cara ainda nao tava seguindo");
                 [relation addObject:self.user.referenceOfPFObject];
                 [self.generalSingletonReference.currentUser.referenceOfPFObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                  {
                      if(succeeded)
                          [self reloadFollowButton:YES];
                  }];
             }
             
             //if the user is atually following
             else
             {
                 NSLog(@"O cara ja seguia, agora vai deixar de seguir");
                 [relation removeObject:self.user.referenceOfPFObject];
                 [self.generalSingletonReference.currentUser.referenceOfPFObject
                  saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                  {
                      if(succeeded)
                          [self reloadFollowButton:NO];
                  }];
             }
         }
     }];
    
    
    
}

-(void)reloadFollowButton
{
    if (!self.generalSingletonReference.isLoggin) {
        PFRelation *relation = [self.generalSingletonReference.currentUser.referenceOfPFObject relationForKey:@"followers"];
        PFQuery *searchFollow = [relation query];
        if(!self.userId)
            self.userId = self.generalSingletonReference.currentUser.scId;
        [searchFollow whereKey:@"scId" equalTo:self.userId];
        [searchFollow findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            [self reloadFollowButton:!(objects.count <= 0)];}];

    }
}

-(void)reloadFollowButton:(BOOL)isFollowing
{
    if (isFollowing)
    {
        //Frame of following blue part
        CGRect frameAux = self.followBt.frame;
        frameAux.size.width = 98;
        frameAux.origin.x = self.coverImage.frame.origin.x+self.coverImage.frame.size.width-frameAux.size.width-10;
        [UIView animateWithDuration:0.5 animations:^{
            [self.followBt setFrame:frameAux];
            [self.followBt setBackgroundColor:[UIColor colorWithRed:77.0f/255.0f green:205.0f/255.0f blue:242.0f/255.0f alpha:1]];
            [self.followImg setImage:[UIImage imageNamed:@"follow-check"]];
            [self.followLb setText:@"Following"];
            [self.followLb setTextColor:[UIColor whiteColor]];
        }];
        
    }
    else
    {
        CGRect frameAux = self.followBt.frame;
        frameAux.size.width = 80;
        frameAux.origin.x = self.view.frame.size.width-95;
        [UIView animateWithDuration:0.5 animations:^{
            [self.followBt setFrame:frameAux];
            [self.followLb setText:@"Follow"];
            [self.followBt setBackgroundColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1]];
            [self.followImg setImage:[UIImage imageNamed:@"follow-plus"]];
        }];
    }
    [UIView animateWithDuration:0.5 animations:^{[self.followBt setHidden:NO];}];
}




#pragma mark Data source of collection view

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    [self.collectionAlbuns.collectionViewLayout invalidateLayout];
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger numberOfItems = [self.user.albuns count];
    
    if ([self.generalSingletonReference.dataClass.scID isEqualToString:self.user.scId])
        numberOfItems++;
    
    return numberOfItems;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"celulaFollowers" forIndexPath:indexPath];
    CGRect frameOfImage = CGRectMake(0, 0, 64, 64);
    UIImageView *profileImageOnCell = [[UIImageView alloc] initWithFrame:frameOfImage];
    [profileImageOnCell setContentMode:UIViewContentModeScaleAspectFill];
    [profileImageOnCell.layer setCornerRadius:5];
    [profileImageOnCell setClipsToBounds:YES];
    [profileImageOnCell setBackgroundColor:[UIColor blackColor]];
    
    if ([self.generalSingletonReference.dataClass.scID isEqualToString:self.user.scId]) {
        if (indexPath.row == 0) {
            [profileImageOnCell setImage:[UIImage imageNamed:@"plus-album"]];
        }
        else if([self.user.albuns count] > 0){
            Album *currentUserAlbum = [self.user.albuns objectAtIndex:indexPath.row - 1];
            if (currentUserAlbum.coverUrl != (NSString *) [NSNull null]) {
                [profileImageOnCell setImageWithURL:[NSURL URLWithString:currentUserAlbum.coverUrl]];
            }
            else{
                [profileImageOnCell setImage:[UIImage imageNamed:@"album-cover"]];
            }
                                                           
        }
    }else{
        Album *albumFr = [self.user.albuns objectAtIndex:indexPath.row];
        
        if(albumFr.coverUrl != (NSString *) [NSNull null])
            [profileImageOnCell setImageWithURL:[NSURL URLWithString:albumFr.coverUrl]];
        else
            [profileImageOnCell setImage:[UIImage imageNamed:@"album-cover"]];
    }
    /*
    
    //Bruno version
     NSUInteger auxNumberOfItens = 0;
    if (indexPath.row == 0 && [self.generalSingletonReference.currentUser.scId isEqualToString:self.user.scId]) {
        [profileImageOnCell setImage:[UIImage imageNamed:@"plus-album"]];
        auxNumberOfItens = 1;
    }
    
    else if([self.user.albuns count] > 0)
    {
        Album *albumFr = [self.user.albuns objectAtIndex:indexPath.row-1];
        
        if(albumFr.coverUrl != (NSString *) [NSNull null])
            [profileImageOnCell setImageWithURL:[NSURL URLWithString:albumFr.coverUrl]];
        else
            [profileImageOnCell setImage:[UIImage imageNamed:@"album-cover"]];
    }*/
    
    [cell.contentView addSubview:profileImageOnCell];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.generalSingletonReference.dataClass.scID isEqualToString:self.user.scId]) {
        if (indexPath.row == 0) {
            UIStoryboard *stBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            NewAlbumViewController *rvc = [stBoard instantiateViewControllerWithIdentifier:@"NewAlbumStoryboard"];
            rvc.user = self.user.referenceOfPFObject;
            
            [self.navigationController pushViewController:rvc animated:YES];
        }
        else if([self.user.albuns count] > 0){
            UINavigationController *albumNavController = [self.tabBarController.viewControllers objectAtIndex:2];
            AlbumPlayerViewController *aps = [albumNavController.viewControllers objectAtIndex:0];
            NSLog(@"%@", [self.tabBarController.viewControllers description]);
            aps.album = [self.user.albuns objectAtIndex:indexPath.row - 1];
            aps.album.owner = self.user;
            [self.bottomBar.myTabBar setSelectedIndex:2];
            
        }
    }else{
        UINavigationController *albumNavController = [self.tabBarController.viewControllers objectAtIndex:2];
        AlbumPlayerViewController *aps = [albumNavController.viewControllers objectAtIndex:0];
        NSLog(@"%@", [self.tabBarController.viewControllers description]);
        aps.album = [self.user.albuns objectAtIndex:indexPath.row];
        aps.album.owner = self.user;
        [self.bottomBar.myTabBar setSelectedIndex:2];

    }
    
    /*
    NSUInteger auxNumberOfItens = 0;
    
    if (indexPath.row == 0 && [self.generalSingletonReference.currentUser.scId isEqualToString:self.user.scId]) {
        
        UIStoryboard *stBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        NewAlbumViewController *rvc = [stBoard instantiateViewControllerWithIdentifier:@"NewAlbumStoryboard"];
        rvc.user = self.user.referenceOfPFObject;
        
        [self.navigationController pushViewController:rvc animated:YES];
        
        auxNumberOfItens = 1;
        
    }
    else
    {
        
        UINavigationController *albumNavController = [self.tabBarController.viewControllers objectAtIndex:2];
        AlbumPlayerViewController *aps = [albumNavController.viewControllers objectAtIndex:0];
        NSLog(@"%@", [self.tabBarController.viewControllers description]);
        aps.album = [self.user.albuns objectAtIndex:indexPath.row - 1];
        aps.album.owner = self.user;
        [self.bottomBar.myTabBar setSelectedIndex:2];
        
        
        
    }*/
}


/*alteracoes
- metodo reloadfollowbutton
- metodos do delegate e dataSource dos albuns
- metodo viewWillApear
 
 */

@end










