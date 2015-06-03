//
//  SignUpViewController.m
//  Choose My Band
//
//  Created by bepid on 08/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "NewAlbumViewController.h"

@interface NewAlbumViewController ()

@end

@implementation NewAlbumViewController

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
    //self.bottomBar.myTabBar = self.tabBarController;

    /*UITapGestureRecognizer *oneTouch = [[UITapGestureRecognizer alloc]initWithTarget:self.view action:@selector(onWindowClick:)];
    [oneTouch setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:oneTouch];*/
    self.genSingleton = [GeneralSingleton sharedInstance];
    self.user = self.genSingleton.currentUser.referenceOfPFObject;
    [self initDefaultColors];
    [self initCreatAlbum];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(void) initCreatAlbum{
    ///////////
    self.topBar = [[CMBTopBar alloc]initWithNavigationController:self.navigationController];
    [self.view addSubview:self.topBar];
    
    //////////////
    self.selectedMusics = [NSMutableArray new];
    
    CGRect frameOfCover = CGRectMake(5, 10, 100, 100);
    self.coverAlbum = [[UIImageView alloc] initWithFrame:frameOfCover];
    [self.coverAlbum.layer setCornerRadius:5];
    [self.coverAlbum.layer setMasksToBounds:YES];
    [self.coverAlbum setImage:[UIImage imageNamed:@"album-cover"]];
    
    CGRect frameLabel = CGRectMake(frameOfCover.origin.x+frameOfCover.size.width+7, frameOfCover.origin.y+5, 120, 15);
    self.albumTitle = [[UILabel alloc] initWithFrame:frameLabel];
    [self.albumTitle setFont:[UIFont systemFontOfSize:16.0]];
    [self.albumTitle setText:@"Set album title"];
    
    frameLabel.origin.y += frameLabel.size.height + 5;
    self.dateOfAlbum = [[UILabel alloc] initWithFrame:frameLabel];
    [self.dateOfAlbum setFont:[UIFont systemFontOfSize:16.0]];
    [self.dateOfAlbum setText:@"13/10/2020"];
    
    frameLabel = CGRectMake(5, frameLabel.origin.y + frameLabel.size.height +90, 80, 20);
    self.labelTitle = [[UILabel alloc] initWithFrame:frameLabel];
    [self.labelTitle setFont:[UIFont systemFontOfSize:16.0]];
    [self.labelTitle setText:@"Album title"];
    
    frameLabel.origin.y += frameLabel.size.height;
    //frameName.origin.x -= 5;
    frameLabel.size.height += 20;
    frameLabel.size.width = self.view.frame.size.width - 2*frameLabel.origin.x;
    self.fieldTitle = [[UITextField alloc] initWithFrame:frameLabel];
    [self.fieldTitle setTextAlignment:NSTextAlignmentCenter];
    [self.fieldTitle setBackgroundColor:[UIColor grayColor]];
    self.fieldTitle.layer.cornerRadius=20;
    self.fieldTitle.layer.masksToBounds=YES;
    [self.fieldTitle setDelegate:self];
    
    CGRect framePost = CGRectMake(5, frameLabel.origin.y + frameLabel.size.height + 25, 100, 20);
    self.post = [[UILabel alloc] initWithFrame:framePost];
    [self.post setFont:[UIFont systemFontOfSize:16.0]];
    [self.post setText:@"Album post"];
    
    framePost.origin.y += framePost.size.height;
    //frameName.origin.x -= 5;
    framePost.size.height += 60;
    framePost.size.width = self.view.frame.size.width - 2*framePost.origin.x;
    self.fieldPost = [[UITextField alloc] initWithFrame:framePost];
    [self.fieldPost setTextAlignment:NSTextAlignmentCenter];
    [self.fieldPost setBackgroundColor:[UIColor grayColor]];
    self.fieldPost.layer.cornerRadius=20;
    self.fieldPost.layer.masksToBounds=YES;
    [self.fieldPost setDelegate:self];
    
    self.selectSounds = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.selectSounds addTarget:self action:@selector(selectSCSounds) forControlEvents:UIControlEventTouchUpInside];
    [self.selectSounds setTitle:@"Select SoundCloud tracks" forState:UIControlStateNormal];
    [self.selectSounds setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.selectSounds setBackgroundColor:[UIColor orangeColor]];
    self.selectSounds.layer.cornerRadius = 20;
    self.selectSounds.layer.masksToBounds=YES;
    self.selectSounds.frame = CGRectMake(self.view.frame.size.width-205, framePost.origin.y+framePost.size.height+20, 200, 40);
    
    CGRect frameLine = CGRectMake(0, self.selectSounds.frame.origin.y+self.selectSounds.frame.size.height+20, self.view.frame.size.width, 1);
    UIView *line = [[UIView alloc]initWithFrame:frameLine];
    [line setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];

    
    
    self.startCMB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.startCMB addTarget:self action:@selector(createAlbumAction) forControlEvents:UIControlEventTouchUpInside];
    [self.startCMB setTitle:@"Start CMB" forState:UIControlStateNormal];
    [self.startCMB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startCMB setBackgroundColor:[UIColor colorWithRed:77/255.f green:205/255.f blue:251/255.f alpha:1]];
    self.startCMB.layer.cornerRadius = 20;
    self.startCMB.layer.masksToBounds=YES;
    self.startCMB.frame = CGRectMake(self.view.frame.size.width - 85, frameLine.origin.y + frameLine.size.height + 10, 80, 40.0);
//    
//    CGRect frameButton = self.startCMB.frame;
//    frameButton.origin.y = frameLine.origin.y + frameLine.size.height + 10;
//    frameButton.origin.x = self.view.frame.size.width - self.startCMB.frame.size.width - 5;
//    self.startCMB.frame = frameButton;
//    [self.startCMB addTarget:self action:@selector(createAlbumAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.signUpScroll addSubview:self.coverAlbum];
    [self.signUpScroll addSubview:self.albumTitle];
    [self.signUpScroll addSubview:self.dateOfAlbum];
    [self.signUpScroll addSubview:self.labelTitle];
    [self.signUpScroll addSubview:self.fieldTitle];
    [self.signUpScroll addSubview:self.post];
    [self.signUpScroll addSubview:self.fieldPost];
    [self.signUpScroll addSubview:self.selectSounds];
    [self.signUpScroll addSubview:line];
    [self.signUpScroll addSubview:self.startCMB];
    [self.signUpScroll setTag:3];
    
}*/

-(void)initDefaultColors
{
    self.fontTextViewAndField = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    self.fontHeaderFields = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    self.textColorHead = [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1];
    self.textFieldsTextColor = [UIColor colorWithRed:50/255.f green:50/255.f blue:50/255.f alpha:1];
    self.textFieldsBgColor = [UIColor colorWithRed:236/255.f green:236/255.f blue:236/255.f alpha:1];
}

-(void) initCreatAlbum{
    
    self.topBar = [[CMBTopBar alloc]initWithNavigationController:self.navigationController];
    [self.view addSubview:self.topBar];
    
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
    
    CGRect frameButton = CGRectMake(self.view.frame.size.width - 120, frameLine.origin.y + frameLine.size.height + 10, 115, 40);
    self.startCMB = [[UIButton alloc]initWithFrame:frameButton];
    [self.startCMB addTarget:self action:@selector(createAlbumAction) forControlEvents:UIControlEventTouchUpInside];
    [self.startCMB setTitle:@"Create Album" forState:UIControlStateNormal];
    [self.startCMB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startCMB.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
    [self.startCMB setBackgroundColor:[UIColor colorWithRed:77/255.f green:205/255.f blue:251/255.f alpha:1]];
    [self.startCMB.layer setCornerRadius:20];
    [self.startCMB setClipsToBounds:YES];
    
 
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5; //numbers of followers
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}


//show a view to select musics in soundcloud
-(void)selectSCSounds
{
    UIStoryboard *stBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     MusicSelectViewController *rvc = (MusicSelectViewController *)[stBoard instantiateViewControllerWithIdentifier:@"MusicSelectStoryboard"];
    //UIViewController *rvc = [stBoard instantiateViewControllerWithIdentifier:@"RegistrationStoryboard"];
    rvc.selectedMusics = self.selectedMusics;
    [self.navigationController presentViewController:rvc animated:YES completion:nil];


    
}

//create new album and new status

-(void)createAlbumAction{
    if([self.fieldTitle.text isEqualToString:@""] || [self.fieldPost.text isEqualToString:@""] || self.selectedMusics.count == 0){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"ALERT" message:@"complete all" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        
        
        [av show];
        
    }
    else{
        __block PFObject *pfObjectMusicAux ;//= [PFObject objectWithClassName:@"Music"];
                
        
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
                                                                //[self.navigationController popToRootViewControllerAnimated:YES];
                                                                //UINavigationController *profileNavController = [self.tabBarController.viewControllers objectAtIndex:1];
                                                                //ProfileViewController *aps = [profileNavController.viewControllers objectAtIndex:0];
                                                                //NSLog(@"%@", [self.tabBarController.viewControllers description]);
                                                                [self.bottomBar.myTabBar setSelectedIndex:1];

                                                                [self.navigationController popViewControllerAnimated:YES];
                                                                //[self.bottomBar.myTabBar setSelectedIndex:2];
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


@end
