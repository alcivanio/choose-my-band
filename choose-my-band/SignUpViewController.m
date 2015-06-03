//
//  SignUpViewController.m
//  Choose My Band
//
//  Created by bepid on 08/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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
    
    /*UITapGestureRecognizer *oneTouch = [[UITapGestureRecognizer alloc]initWithTarget:self.view action:@selector(onWindowClick:)];
     [oneTouch setNumberOfTapsRequired:1];
     [self.view addGestureRecognizer:oneTouch];*/
    [self initDefaultColors];
    _user = [PFObject objectWithClassName:@"CustomUser"];
    [self initFirstView];
    // Do any additional setup after loading the view.
    [self loadSuggestedUsers];
}

-(void)initDefaultColors
{
    self.fontTextViewAndField = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    self.fontHeaderFields = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    self.textColorHead = [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1];
    self.textFieldsTextColor = [UIColor colorWithRed:50/255.f green:50/255.f blue:50/255.f alpha:1];
    self.textFieldsBgColor = [UIColor colorWithRed:236/255.f green:236/255.f blue:236/255.f alpha:1];
}

-(UIView *)topBarInformationsWithFrame:(CGRect)frame Title:(NSString *)title andInfo:(NSString *)info
{
    //the principal view
    UIView *view = [[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:[UIColor colorWithRed:78/255.f green:203/255.f blue:252/255.f alpha:1]];
    //lb with the title
    UILabel *lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 18, frame.size.width, 32)];
    [lbTitle setText:title];
    [lbTitle setTextColor:[UIColor whiteColor]];
    [lbTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:25.0]];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    //lb with the description info
    UILabel *lbInfo = [[UILabel alloc]initWithFrame:CGRectMake(0, lbTitle.frame.origin.y+lbTitle.frame.size.height, frame.size.width, 18)];
    [lbInfo setText:info];
    [lbInfo setTextColor:[UIColor whiteColor]];
    [lbInfo setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
    [lbInfo setTextAlignment:NSTextAlignmentCenter];
    
    [view addSubview:lbTitle];
    [view addSubview:lbInfo];
    return view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark user first informations
-(void) initFirstView{
    self.coverUrls = [[NSMutableArray alloc] initWithArray:@[@"https://scontent-a-gru.xx.fbcdn.net/hphotos-xpa1/v/t1.0-9/1513686_767665796602509_5147905455972812805_n.jpg?oh=5b008056552e12cd711a27438066fb98&oe=5514E342",
                                                         @"https://scontent-a-gru.xx.fbcdn.net/hphotos-xpa1/v/t1.0-9/10857968_767665799935842_6619280259965938541_n.jpg?oh=b07bc9bd294a813707e4caab402bc27b&oe=550AC2FD",
                                                         @"https://scontent-a-gru.xx.fbcdn.net/hphotos-xaf1/l/t31.0-8/10862692_767665806602508_6371797180840689649_o.jpg",@"https://scontent-b-gru.xx.fbcdn.net/hphotos-xpa1/t31.0-8/10687524_767665863269169_5035298072788673475_o.jpg",@"https://scontent-b-gru.xx.fbcdn.net/hphotos-xap1/t31.0-8/10848633_767665833269172_6440482072865602723_o.jpg"]];
    
    //label type your name
    CGRect frameName = CGRectMake(5, 0, 150, 20);
    self.typeYourName = [[UILabel alloc] initWithFrame:frameName];
    [self.typeYourName setFont:self.fontHeaderFields];
    [self.typeYourName setText:@"Type your name"];
    [self.typeYourName setTextColor:self.textColorHead];
    
    //The input
    frameName.origin.y += frameName.size.height;
    frameName.size.height += 20;
    frameName.size.width = self.view.frame.size.width - 2*frameName.origin.x;
    self.yourName = [[UITextField alloc] initWithFrame:frameName];
    [self.yourName setTextAlignment:NSTextAlignmentCenter];
    [self.yourName setTextColor:self.textFieldsTextColor];
    [self.yourName setBackgroundColor:self.textFieldsBgColor];
    [self.yourName setFont:self.fontTextViewAndField];
    self.yourName.layer.cornerRadius=20;
    [self.yourName setClipsToBounds:YES];
    self.yourName.delegate = self;
    
    //The Bio
    CGRect frameBio = CGRectMake(5, frameName.origin.y+frameName.size.height + 20, 150, 20);
    self.typeYourBio = [[UILabel alloc] initWithFrame:frameBio];
    [self.typeYourBio setText:@"Type your bio"];
    [self.typeYourBio setFont:self.fontHeaderFields];
    [self.typeYourBio setTextColor:self.textColorHead];
    
    //The input
    frameBio.origin.y += frameBio.size.height;
    frameBio.size.height += 20;
    frameBio.size.width = self.view.frame.size.width - 2*frameBio.origin.x;
    self.yourBio = [[UITextField alloc] initWithFrame:frameBio];
    [self.yourBio setTextAlignment:NSTextAlignmentCenter];
    [self.yourBio setBackgroundColor:self.textFieldsBgColor];
    [self.yourBio setTextColor:self.textFieldsTextColor];
    [self.yourBio setFont:self.fontTextViewAndField];
    self.yourBio.layer.cornerRadius=20;
    [self.yourBio setClipsToBounds:YES];
    self.yourBio.delegate = self;
    
    //The e-mail
    CGRect frameEmail = CGRectMake(5, frameBio.origin.y+frameBio.size.height + 20, 150, 20);
    self.typeYourEmail = [[UILabel alloc] initWithFrame:frameEmail];
    [self.typeYourEmail setText:@"Type your email"];
    [self.typeYourEmail setFont:self.fontHeaderFields];
    [self.typeYourEmail setTextColor:self.textColorHead];
    
    //the input
    frameEmail.origin.y += frameEmail.size.height;
    frameEmail.size.height += 20;
    frameEmail.size.width = self.view.frame.size.width - 2*frameEmail.origin.x;
    self.yourEmail = [[UITextField alloc] initWithFrame:frameEmail];
    [self.yourEmail setTextAlignment:NSTextAlignmentCenter];
    [self.yourEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.yourEmail setTextColor:self.textFieldsTextColor];
    [self.yourEmail setBackgroundColor:self.textFieldsBgColor];
    [self.yourEmail setFont:self.fontTextViewAndField];
    [self.yourEmail.layer setCornerRadius:20];
    [self.yourEmail setClipsToBounds:YES];
    self.yourEmail.delegate = self;
    
    //The cover
    CGRect frameCover = CGRectMake(5, frameEmail.origin.y+frameEmail.size.height + 20, 250, 20);
    self.selectYourCover = [[UILabel alloc] initWithFrame:frameCover];
    [self.selectYourCover setFont:self.fontHeaderFields];
    [self.selectYourCover setTextColor:self.textColorHead];
    [self.selectYourCover setText:@"Select your profile cover"];
    
    
    /* THE COLLECTION OF COVERS */
    frameCover.origin.y += frameCover.size.height;
    frameCover.origin.x = 0;
    frameCover.size.width =self.view.frame.size.width;
    frameCover.size.height = 110;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumLineSpacing:19]; //espaçamento
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.itemSize = CGSizeMake(100, 100);
    [layout setMinimumLineSpacing:5];
    self.collectionCover = [[UICollectionView alloc] initWithFrame:frameCover collectionViewLayout:layout];
    [self.collectionCover registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionCover setBackgroundColor:[UIColor whiteColor]];
    [self.collectionCover setShowsHorizontalScrollIndicator:NO];
    [self.collectionCover setDataSource:self];
    [self.collectionCover setDelegate:self];
    self.collectionCover.allowsSelection = YES;
    [self.collectionCover setUserInteractionEnabled:YES];
    
    //Lines
    CGRect frameLineOne = CGRectMake(0, frameCover.origin.y+3, self.view.frame.size.width, 1);
    UIView *lineOne = [[UIView alloc]initWithFrame:frameLineOne];
    [lineOne setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
    
    frameLineOne.origin.y += frameCover.size.height-2;
    UIView *lineTwo = [[UIView alloc]initWithFrame:frameLineOne];
    [lineTwo setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
    
    self.toView2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.toView2 addTarget:self action:@selector(showNextView) forControlEvents:UIControlEventTouchUpInside];
    [self.toView2 setTitle:@"Continue" forState:UIControlStateNormal];
    [self.toView2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.toView2 setBackgroundColor:[UIColor colorWithRed:77/255.f green:205/255.f blue:251/255.f alpha:1]];
    self.toView2.layer.cornerRadius = 20;
    self.toView2.layer.masksToBounds=YES;
    self.toView2.frame = CGRectMake(self.view.frame.size.width-109, frameCover.origin.y + frameCover.size.height + 20, 104, 40.0);
    
    
    [self.view addSubview:[self topBarInformationsWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 78) Title:@"Welcome" andInfo:@"Editing your personal information"]];
    [self.signUpScroll addSubview:self.typeYourName];
    [self.signUpScroll addSubview:self.yourName];
    [self.signUpScroll addSubview:self.typeYourBio];
    [self.signUpScroll addSubview:self.yourBio];
    [self.signUpScroll addSubview:self.typeYourEmail];
    [self.signUpScroll addSubview:self.yourEmail];
    [self.signUpScroll addSubview:self.selectYourCover];
    [self.signUpScroll addSubview:self.collectionCover];
    [self.signUpScroll addSubview:lineOne];
    [self.signUpScroll addSubview:lineTwo];
    [self.signUpScroll addSubview:self.toView2];
    [self.signUpScroll setTag:1];
    [self loadFirstInfromations];
    
    
    
}
#pragma mark view with users to follow
//view with some followers
-(void) initSecondView{
    
    CGRect frameOfList = CGRectMake(0, -20, self.view.frame.size.width, 430);
    self.listOfFollowers = [[UITableView alloc] initWithFrame:frameOfList];
    [self.listOfFollowers registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellFollowers"];
    [self.listOfFollowers setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.listOfFollowers setDelegate:self];
    [self.listOfFollowers setDataSource:self];
    [self.listOfFollowers setShowsVerticalScrollIndicator:NO];
    
    UIView *finalLine = [[UIView alloc]initWithFrame:CGRectMake(0, frameOfList.origin.y+frameOfList.size.height, self.view.frame.size.width, 1)];
    [finalLine setBackgroundColor:[UIColor colorWithRed:153/255.f green:153/255.f blue:153/255.f alpha:1]];
    
    CGRect frameNAlbum = CGRectMake(self.view.frame.size.width-170, frameOfList.origin.y + frameOfList.size.height + 10, 165, 40.0);
    self.createNewAlbum = [[UIButton alloc]initWithFrame:frameNAlbum];
    [self.createNewAlbum addTarget:self action:@selector(loadCreateNewAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.createNewAlbum setTitle:@"Create new album" forState:UIControlStateNormal];
    [self.createNewAlbum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.createNewAlbum setBackgroundColor:[UIColor colorWithRed:77/255.f green:205/255.f blue:251/255.f alpha:1]];
    [self.createNewAlbum.layer setCornerRadius:20];
    [self.createNewAlbum setClipsToBounds:YES];
    [self.createNewAlbum.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
    
    CGRect framecmbS = CGRectMake(frameNAlbum.origin.x-120, frameOfList.origin.y + frameOfList.size.height + 10, 115, 40.0);
    self.startCMB = [[UIButton alloc]initWithFrame:framecmbS];
    [self.startCMB addTarget:self action:@selector(loadStartCMB) forControlEvents:UIControlEventTouchUpInside];
    [self.startCMB setTitle:@"Start CMB" forState:UIControlStateNormal];
    [self.startCMB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startCMB.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
    [self.startCMB setBackgroundColor:[UIColor colorWithRed:153/255.f green:153/255.f blue:153/255.f alpha:1]];
    [self.startCMB.layer setCornerRadius:20];
    [self.startCMB setClipsToBounds:YES];
    
    
    [self.signUpScroll addSubview:self.listOfFollowers];
    [self.signUpScroll addSubview:finalLine];
    [self.signUpScroll addSubview:self.createNewAlbum];
    [self.signUpScroll addSubview:self.startCMB];
    [self.signUpScroll setTag:2];
    
}

#pragma mark view to create some album
-(void) initCreatAlbum{
    
    self.selectedMusics = [NSMutableArray new];
    
    /*The album informations on top*/
    CGRect frameOfCover = CGRectMake(5, -10, 100, 100);
    self.coverAlbum = [[UIImageView alloc] initWithFrame:frameOfCover];
    [self.coverAlbum.layer setCornerRadius:5];
    [self.coverAlbum.layer setMasksToBounds:YES];
    [self.coverAlbum setImage:[UIImage imageNamed:@"album-cover"]];
    
    //Label with the album title
    CGRect frameLabel = CGRectMake(frameOfCover.origin.x+frameOfCover.size.width+7, frameOfCover.origin.y, self.view.frame.size.width-frameOfCover.size.width-10, 15);
    self.albumTitle = [[UILabel alloc] initWithFrame:frameLabel];
    [self.albumTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
    [self.albumTitle setTextColor:[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1]];
    [self.albumTitle setText:@"Set album title"];
    
    //Label with the album date of post
    frameLabel.origin.y += frameLabel.size.height + 5;
    self.dateOfAlbum = [[UILabel alloc] initWithFrame:frameLabel];
    [self.dateOfAlbum setText:@"Select the tracks below"];
    [self.dateOfAlbum setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
    [self.dateOfAlbum setTextColor:[UIColor colorWithRed:101/255.f green:101/255.f blue:101/255.f alpha:1]];
    
    //Line separate
    UIView *lineTopToMiddle = [[UIView alloc]initWithFrame:CGRectMake(0, frameOfCover.origin.y+frameOfCover.size.height+10, self.view.frame.size.width, 1)];
    [lineTopToMiddle setBackgroundColor:[UIColor colorWithRed:203/255.f green:203/255.f blue:203/255.f alpha:1]];
    
    //The part to add album
    frameLabel = CGRectMake(5, frameLabel.origin.y + frameLabel.size.height +90, 80, 20);
    self.labelTitle = [[UILabel alloc] initWithFrame:frameLabel];
    [self.labelTitle setFont:self.fontHeaderFields];
    [self.labelTitle setTextColor:[UIColor colorWithRed:101/255.f green:101/255.f blue:101/255.f alpha:1]];
    [self.labelTitle setText:@"Album title"];
    
    //TextField - album title
    frameLabel.origin.y += frameLabel.size.height;
    frameLabel.size.height += 20;
    frameLabel.size.width = self.view.frame.size.width - 2*frameLabel.origin.x;
    
    self.fieldTitle = [[UITextField alloc] initWithFrame:frameLabel];
    [self.fieldTitle setTextAlignment:NSTextAlignmentCenter];
    [self.fieldTitle setBackgroundColor:self.textFieldsBgColor];
    [self.fieldTitle setTextColor:self.textFieldsTextColor];
    [self.fieldTitle setFont:self.fontTextViewAndField];
    [self.fieldTitle.layer setCornerRadius:20];
    [self.fieldTitle setClipsToBounds:YES];
    [self.fieldTitle setDelegate:self];
    
    //The label with the album post
    CGRect framePost = CGRectMake(5, frameLabel.origin.y + frameLabel.size.height + 25, 100, 20);
    self.post = [[UILabel alloc] initWithFrame:framePost];
    [self.post setFont:self.fontHeaderFields];
    [self.post setTextColor:self.textColorHead];
    [self.post setText:@"Album post"];
    
    framePost.origin.y += framePost.size.height;
    framePost.size.height += 60;
    framePost.size.width = self.view.frame.size.width - 2*framePost.origin.x;
    self.fieldPost = [[UITextField alloc] initWithFrame:framePost];
    [self.fieldPost setTextAlignment:NSTextAlignmentCenter];
    [self.fieldPost setBackgroundColor:self.textFieldsBgColor];
    [self.fieldPost setFont:self.fontTextViewAndField];
    [self.fieldPost setTextColor:self.textFieldsTextColor];
    [self.fieldPost.layer setCornerRadius:20];
    [self.fieldPost setClipsToBounds:YES];
    [self.fieldPost setDelegate:self];
    
    self.selectSounds = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-225, framePost.origin.y+framePost.size.height+20, 220, 40)];
    [self.selectSounds addTarget:self action:@selector(selectSCSounds) forControlEvents:UIControlEventTouchUpInside];
    [self.selectSounds setTitle:@"Select SoundCloud tracks" forState:UIControlStateNormal];
    [self.selectSounds setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.selectSounds setBackgroundColor:[UIColor colorWithRed:251/255.f green:155/255.f blue:0.0 alpha:1]];
    [self.selectSounds setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
    [self.selectSounds.layer setCornerRadius:20];
    [self.selectSounds setClipsToBounds:YES];
    
    CGRect frameLine = CGRectMake(0, self.selectSounds.frame.origin.y+self.selectSounds.frame.size.height+20, self.view.frame.size.width, 1);
    UIView *line = [[UIView alloc]initWithFrame:frameLine];
    [line setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
    
    CGRect frameButton = self.startCMB.frame;
    frameButton.origin.y = frameLine.origin.y + frameLine.size.height + 10;
    frameButton.origin.x = self.view.frame.size.width - self.startCMB.frame.size.width - 5;
    self.startCMB.frame = frameButton;
    [self.startCMB removeTarget:self action:@selector(loadCreateNewAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.startCMB addTarget:self action:@selector(createAlbumAction) forControlEvents:UIControlEventTouchUpInside];
    [self.startCMB setBackgroundColor:[UIColor colorWithRed:78/255.f green:203/255.f blue:252/255.f alpha:1]];
    
    [self.signUpScroll addSubview:self.coverAlbum];
    [self.signUpScroll addSubview:self.albumTitle];
    [self.signUpScroll addSubview:self.dateOfAlbum];
    [self.signUpScroll addSubview:lineTopToMiddle];
    [self.signUpScroll addSubview:self.labelTitle];
    [self.signUpScroll addSubview:self.fieldTitle];
    [self.signUpScroll addSubview:self.post];
    [self.signUpScroll addSubview:self.fieldPost];
    [self.signUpScroll addSubview:self.selectSounds];
    [self.signUpScroll addSubview:line];
    [self.signUpScroll addSubview:self.startCMB];
    [self.signUpScroll setTag:3];
    
}

#pragma mark other methods

-(void)loadSuggestedUsers
{
    [PFCloud callFunctionInBackground:@"sortSomeUsers" withParameters:@{@"limit":@"8"}block:^(NSArray *result, NSError *error)
    {
        if(!error)
        {
            //if suggestuser is not instatiaded
            if(!self.suggestedUsers)
                self.suggestedUsers = [[NSMutableArray alloc]init];
            
            //Thats is about the selected or not the user
            if(!self.suggestedUsersSelected)
                self.suggestedUsersSelected = [[NSMutableArray alloc]init];
            
            //for with the users adding on suggested
            for (PFObject *obj in result)
                [self.suggestedUsers addObject:[[User alloc]initWithPFObject:obj]];
            
            //And now, the no on the selected values
            for (int i=0; i<self.suggestedUsers.count; i++)
                 [self.suggestedUsersSelected addObject:@"YES"];
        }
    }];
}

-(void)showNextView{
    
    
    
    if([self.yourEmail.text isEqualToString:@""] || [self.yourName.text isEqualToString:@""] || [self.yourBio.text isEqualToString:@""]){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Atention!" message:@"You have to complete all informations to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        
        
        [av show];
        
    }
    
    else
    {
        

        self.user[@"name"] = self.yourName.text;
        self.user[@"username"] = [self.soundCloudData objectForKey:@"username"];
        //self.user[@"name"] = @"Alcivanio";
        self.user[@"bio"] = self.yourBio.text;
        self.user[@"email"] = self.yourEmail.text;
        self.user[@"scId"] = [[self.soundCloudData objectForKey:@"id"] stringValue];
        //self.user[@"scId"] = @"123123123";
        self.user[@"profilePictureUrl"] = [self.soundCloudData objectForKey:@"avatar_url"];
        //self.user[@"profilePictureUrl"] = @"";
        
        
        for(UIView *subview in [self.signUpScroll subviews])
            [subview removeFromSuperview];
        [self initSecondView];
        [self.listOfFollowers reloadData];
    }
    
}

-(void)loadCreateNewAlbum
{
    PFRelation *followersRelation = [self.user relationForKey:@"followers"];
    for (int i = 0; i < self.suggestedUsersSelected.count; i++) {
        if(!([[self.suggestedUsersSelected objectAtIndex:i] boolValue])){
            User *user = [self.suggestedUsers objectAtIndex:i];
            [followersRelation addObject:user.referenceOfPFObject];

        }
    }
    
    for(UIView *subview in [self.signUpScroll subviews])
        [subview removeFromSuperview];
    
    [self initCreatAlbum];
    
    //fazer a parte de adicionar as musicas
    
}
//metodo para o botao start cmb que deve iniciar o aplicativo

-(void)loadStartCMB
{
    PFRelation *followersRelation = [self.user relationForKey:@"followers"];
    for (int i = 0; i < self.suggestedUsersSelected.count; i++) {
        if(!([[self.suggestedUsersSelected objectAtIndex:i] boolValue])){
            User *user = [self.suggestedUsers objectAtIndex:i];
            [followersRelation addObject:user.referenceOfPFObject];
            
        }
    }
    
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.tabBarController setSelectedIndex:1];
    }];
}


/* Metholds created after */
-(void)loadFirstInfromations
{
    //                PFObject *newUser = [PFObject objectWithClassName:@"CustomUser"];
    //                newUser[@"scId"] = [[userInformations objectForKey:@"id"] stringValue];
    //                newUser[@"username"] = [userInformations objectForKey:@"username"];
    //                newUser[@"name"] = [userInformations objectForKey:@"full_name"];
    //                newUser[@"bio"] = [userInformations objectForKey:@"description"];
    //                newUser[@"profilePictureUrl"] = [userInformations objectForKey:@"avatar_url"];
    //                [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    //                [self getTracksInSC:newUser];
    
    [self.yourName setText:[self.soundCloudData objectForKey:@"username"]];
    
    
    // [self.yourBio setText:[self.soundCloudData objectForKey:@"description"] ?@"":[self.soundCloudData ///objectForKey:@"description"] ];
}

//fazer a parte de adicionar as musicas
-(void)selectSCSounds
{
    UIStoryboard *stBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MusicSelectViewController *rvc = (MusicSelectViewController *)[stBoard instantiateViewControllerWithIdentifier:@"MusicSelectStoryboard"];
    //UIViewController *rvc = [stBoard instantiateViewControllerWithIdentifier:@"RegistrationStoryboard"];
    rvc.selectedMusics = self.selectedMusics;
    [self.navigationController presentViewController:rvc animated:YES completion:nil];
    
    
    
}

-(void)createAlbumAction{
    if([self.fieldTitle.text isEqualToString:@""] || [self.fieldPost.text isEqualToString:@""] || self.selectedMusics.count == 0)
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"ALERT" message:@"complete all" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
    }
    else
    {
        __block PFObject *pfObjectMusicAux ;//= [PFObject objectWithClassName:@"Music"];
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                PFObject *newAlbum = [PFObject objectWithClassName:@"Album"];
                newAlbum[@"title"] = self.fieldTitle.text;
                newAlbum[@"owner"] = self.user;
                newAlbum[@"coverUrl"] = [[self.selectedMusics objectAtIndex:0] imageUrl];
                
                PFRelation *musics = [newAlbum relationForKey:@"musics"];
                for (int i = 0 ; i < [self.selectedMusics count] ; i++) {
                    Music *music = [self.selectedMusics objectAtIndex:i];
                    newAlbum[@"duration"] = [NSNumber numberWithFloat:[newAlbum[@"duration"] floatValue] + [music.duration floatValue] ];
                    
                    
                    PFObject *pfObjectMusic = [PFObject objectWithClassName:@"Music"];
                    pfObjectMusic[@"title"] = music.title;
                    pfObjectMusic[@"streamUrl"] = music.streamUrl;
                    pfObjectMusic[@"duration"] = music.duration;
                    pfObjectMusic[@"streamUrl"] = music.streamUrl;
                    pfObjectMusic[@"category"] = music.category;
                    pfObjectMusic[@"owner"] = self.user;
                    
                    
                    [pfObjectMusic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(succeeded){
                            pfObjectMusicAux = pfObjectMusic;
                            
                            [musics addObject:pfObjectMusic];
                            [newAlbum saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if(succeeded){
                                    PFRelation *albuns = [self.user relationForKey:@"albuns"];
                                    [albuns addObject:newAlbum];
                                    
                                    /*PFObject *status = [PFObject objectWithClassName:@"Status"];
                                     status[@"owner"] = self.user;
                                     status[@"statusText"] = self.fieldPost.text;
                                     status[@"music"] = pfObjectMusicAux;
                                     */
                                    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        if (succeeded) {
                                            
                                            if(i == 0){
                                                
                                                PFObject *status = [PFObject objectWithClassName:@"Status"];
                                                status[@"owner"] = self.user;
                                                status[@"statusText"] = self.fieldPost.text;
                                                status[@"music"] = pfObjectMusicAux;
                                                [status saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                    if (succeeded) {
                                                        PFRelation *statusRelation = [self.user relationForKey:@"status"];
                                                        [statusRelation addObject:status];
                                                        
                                                        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                            
                                                            if(succeeded){
                                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                                                [self.tabBarController setSelectedIndex:1];
                                                            }
                                                        }];
                                                    }
                                                }];
                                            }
                                            
                                            NSLog(@"sdas");
                                            
                                            
                                            //aqui ele vai iniciar o app
                                            //for(UIView *subview in [self.signUpScroll subviews])
                                            //   [subview removeFromSuperview];
                                            
                                        }
                                    }];
                                    
                                    
                                    
                                    
                                }
                            }];
                        }
                    }];
                }
                
                
            }
            else{
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"ALERT" message:@"A problem happend" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                
                [av show];
                
            }
        }];
        
        
        
    }
    
}


#pragma mark - TextFieldDelegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(self.signUpScroll.frame.origin.y == 78){
        if([textField isEqual:self.fieldTitle] || [textField isEqual:self.fieldPost]){
            [self.signUpScroll setFrame:CGRectMake(self.signUpScroll.frame.origin.x,self.signUpScroll.frame.origin.y -50, self.signUpScroll.frame.size.width, self.signUpScroll.frame.size.height)];
        
        }
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if([textField isEqual:self.fieldTitle] || [textField isEqual:self.fieldPost])
    {
        [self.signUpScroll setFrame:CGRectMake(self.signUpScroll.frame.origin.x, self.signUpScroll.frame.origin.y +50,
        self.signUpScroll.frame.size.width, self.signUpScroll.frame.size.height)];
    }
    
    return YES;
}





-(void)onWindowClick:(UITapGestureRecognizer *)sender
{
    if(self.signUpScroll.tag == 3 && ([self.fieldPost isEditing] || [self.fieldTitle isEditing]))
    {
        [self.signUpScroll setFrame:CGRectMake(self.signUpScroll.frame.origin.x, self.signUpScroll.frame.origin.y + 5,
        self.signUpScroll.frame.size.width, self.signUpScroll.frame.size.height)];
    }
    
    [self.yourName resignFirstResponder];
    [self.yourBio resignFirstResponder];
    [self.yourEmail resignFirstResponder];
    [self.fieldTitle resignFirstResponder];
    [self.fieldPost resignFirstResponder];
    [self.yourName resignFirstResponder];
}

#pragma mark TableView users to follow
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.suggestedUsers.count; //numbers of followers
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMBUsersToFollowTableViewCell *cell = [[CMBUsersToFollowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFollowers"];
    
    //User aux
    User *aux = [self.suggestedUsers objectAtIndex:indexPath.row];
    
    [cell.profilePicture setImageWithURL:[NSURL URLWithString:aux.profilePictureUrl]];
    [cell.userName setText:aux.username];
    [cell.userBio setText:aux.bio];
    
    [cell.selectedImage setHidden:[[self.suggestedUsersSelected objectAtIndex:indexPath.row] boolValue]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //changing in the screen
    CMBUsersToFollowTableViewCell *cell = (CMBUsersToFollowTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.selectedImage setHidden:!cell.selectedImage.isHidden];

    [self.suggestedUsersSelected replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%@",(cell.selectedImage.isHidden)?@"YES":@"NO"]];
}


#pragma mark - UICollection delegate and datasource methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    
    
    [selectedCell setAlpha:0.2];
    
    self.user[@"profileCoverUrl"] = [self.coverUrls objectAtIndex:indexPath.row];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [selectedCell setAlpha:1];
    
    
    self.user[@"profileCoverUrl"] = @"";

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5; //number of covers
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    //[cell setBackgroundColor:[UIColor grayColor]];
    UIImageView *cover = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, cell.frame.size.width, cell.frame.size.height)];
    [cover setContentMode:UIViewContentModeScaleAspectFill];
    [cover setImage:[UIImage imageNamed:@"user"]];
    [cover setImageWithURL:[NSURL URLWithString:[self.coverUrls objectAtIndex:indexPath.row]]];
    [cover setBackgroundColor:[UIColor redColor]];
    [cell.contentView.layer setCornerRadius:5];
    [cell.contentView setClipsToBounds:YES];
    [cell.contentView addSubview:cover];
    cell.layer.cornerRadius = 5;
    [cell setClipsToBounds:YES];
    [cell.selectedBackgroundView setBackgroundColor:[UIColor whiteColor]];
    
    return cell;
}
@end
