//
//  InitViewController.m
//  choose-my-band
//
//  Created by Alcivanio on 30/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "InitViewController.h"
#import "ProfileViewController.h"
#import "FeedViewController.h"
#import "AlbumPlayerViewController.h"
#import "RadioViewController.h"
#import "SearchViewController.h"
#import "GeneralSingleton.h"
#import "SingletonPlayer.h"
@interface InitViewController ()

@end

@implementation InitViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //The elements of the screen
    [self startElementsOnScreen];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.tabBarController setHidesBottomBarWhenPushed:NO];
    
    //Thread to update the list of top 100
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{/*[self checkIfUpdated];*/});

    //The soundCloud account
    SCAccount *account =[SCSoundCloud account];
    if(account)
    {
        [self goToStartScreen];
    }
}

-(void)goToStartScreen
{
//    UIStoryboard *stBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//   ProfileViewController *rvc = (ProfileViewController *)[stBoard instantiateViewControllerWithIdentifier:@"ProfileStoryboard"];
//    rvc.returnButtonIsHidden = YES;
    //UIViewController *rvc = [stBoard instantiateViewControllerWithIdentifier:@"SignUpStoryboard"];
    //UIViewController *rvc = [stBoard instantiateViewControllerWithIdentifier:@"PostStoryboard"];
//    [self.navigationController pushViewController:rvc animated:YES];
    [self.tabBarController setSelectedIndex:1];
    
    
    //[self.navigationController pushViewController:[self.viewControllers objectAtIndex:0] animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startElementsOnScreen
{
    UIImageView *imageBackground = [[UIImageView alloc]initWithFrame:self.view.frame];
    [imageBackground setContentMode:UIViewContentModeScaleAspectFill];
    [imageBackground setImage:[UIImage imageNamed:@"init-background"]];
    
    UIView *viewColor = [[UIView alloc]initWithFrame:self.view.frame];
    [viewColor setBackgroundColor:[UIColor colorWithRed:1.f green:86/255.f blue:76/255.f alpha:0.5]];
    
    CGRect frameLogo = CGRectMake(0, 0, 186, 98);
    frameLogo.origin.x = (self.view.frame.size.width-frameLogo.size.width)/2;
    frameLogo.origin.y = (self.view.frame.size.height-frameLogo.size.height)-80;
    
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:frameLogo];
    [logoImage setImage:[UIImage imageNamed:@"full-logo"]];
    
    CGRect loadSCFrame = CGRectMake(0, frameLogo.origin.y + frameLogo.size.height + 20 , 217, 39);
    loadSCFrame.origin.x = (self.view.frame.size.width-loadSCFrame.size.width)/2;
    self.loginSC = [[UIButton alloc]initWithFrame:loadSCFrame];
    [self.loginSC setBackgroundColor:[UIColor whiteColor]];
    [self.loginSC.layer setCornerRadius:loadSCFrame.size.height/2];
    [self.loginSC setClipsToBounds:YES];
    [self.loginSC setTitle:@"Login with SoundCloud" forState:UIControlStateNormal];
    [self.loginSC.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [self.loginSC setTitleColor:[UIColor colorWithRed:33/255.f green:33/255.f blue:33/255.f alpha:1] forState:UIControlStateNormal];
    [self.loginSC addTarget:self action:@selector(callSoundCloudLogin) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomBar = [[CMBBottomBar alloc]initWithY:self.view.frame.size.height width:self.view.frame.size.width navigationController:self.navigationController andScroll:nil];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    
    [self.view addSubview:imageBackground];
    [self.view addSubview:viewColor];
    [self.view addSubview:logoImage];
    [self.view addSubview:self.loginSC];
    
    /* Atributting the General Singleton -> all data users */
    self.genSingleton = [GeneralSingleton sharedInstance];
}

-(void)callSoundCloudLogin
{
    SCLoginViewControllerCompletionHandler handler = ^(NSError *error)
    {
        if (SC_CANCELED(error))
        {
            NSLog(@"Usuario cancelou o login - fazer nada");
        } else if (error)
        {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else
        {
            [self getInfomationsInSC];
        }
    };
    
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
        SCLoginViewController *loginViewController;
        
        loginViewController = [SCLoginViewController
                               loginViewControllerWithPreparedURL:preparedURL
                               completionHandler:handler];
        CGRect frameLogin = loginViewController.view.frame;
        [loginViewController.view setFrame:frameLogin];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }];
}

-(void) getInfomationsInSC{
    
    
    //JSON - First, we get the json with the data of the user account
    SCAccount *account = [SCSoundCloud account];
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error)
    {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (!(jsonError) || [jsonResponse isKindOfClass:[NSArray class]])
        {
            [self checkIfNewUser:(NSDictionary *) jsonResponse];
            
        }
    };
    
    [SCRequest performMethod:SCRequestMethodGET onResource:[NSURL URLWithString:@"https://api.soundcloud.com/me.json"]usingParameters:nil withAccount:account sendingProgressHandler:nil responseHandler:handler];
    
}

-(void) checkIfNewUser:(NSDictionary *)userInformations{
    
    PFQuery *query = [PFQuery queryWithClassName:@"CustomUser"];
    [query whereKey:@"scId" equalTo:[[userInformations objectForKey:@"id"] stringValue]];
    [query selectKeys:@[@"scId"]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            if ([objects count] == 0)
            {
                UIStoryboard *stBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SignUpViewController *suvc = (SignUpViewController *)[stBoard instantiateViewControllerWithIdentifier:@"SignUpStoryboard"];
                suvc.soundCloudData = userInformations;
                [self.navigationController pushViewController:suvc animated:YES];
            }
            
            else
            {
                [self savingDataOfDataClass:userInformations andPFUser:[objects objectAtIndex:0]];
                [self goToStartScreen];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
}

-(void)savingDataOfDataClass:(NSDictionary *)userInformations andPFUser:(PFUser *)user
{
    /* Atributting the variables of user 'save data class' */
    self.genSingleton.dataClass.userID = user.objectId;
    self.genSingleton.dataClass.scID = [NSString stringWithFormat:@"%@",[userInformations objectForKey:@"id"]];
    
    /* Saving the data on 'disk' and reloading the 'save class' */
    [self.genSingleton saveDataSaveClass];
    [self.genSingleton initializeGeneralSingleton];
    
    /* To know when the last user loggout in the same app session */
    self.genSingleton.isLoggin = YES;
}

-(void) getTracksInSC:(PFObject *) user{
    
    
    //JSON - First, we get the json with the data of the user account
    SCAccount *account = [SCSoundCloud account];
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error)
    {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (!(jsonError) || [jsonResponse isKindOfClass:[NSArray class]])
        {
            
            [self addAlbunsForNewUser:(NSArray *)jsonResponse user:user];
        }
    };
    
    [SCRequest performMethod:SCRequestMethodGET onResource:[NSURL URLWithString:@"https://api.soundcloud.com/me/playlists.json"]usingParameters:nil withAccount:account sendingProgressHandler:nil responseHandler:handler];
    
}


-(void)addAlbunsForNewUser:(NSArray *) albunsInformations user:(PFObject *) user{
    
    for (NSDictionary *album in albunsInformations) {
        NSLog(@"%@", [album description]);
        
        PFObject *newAlbum = [PFObject objectWithClassName:@"Album"];
        if ([album objectForKey:@"genre"])
            newAlbum[@"albumType"] = [album objectForKey:@"genre"];
        if ([album objectForKey:@"artwork_url"])
            newAlbum[@"coverUrl"] = [album objectForKey:@"artwork_url"];
        newAlbum[@"owner2"] = user;
        newAlbum[@"title"] = [album objectForKey:@"title"];
        
        for (NSDictionary *music in [album objectForKey:@"tracks"]) {
            
            PFObject *newMusic = [PFObject objectWithClassName:@"Music"];
            newMusic[@"album"] = newAlbum;
            if ([music objectForKey:@"artwork_url"])
                newMusic[@"imageUrl"] = [music objectForKey:@"artwork_url"];
            if ([music objectForKey:@"stream_url"])
                newMusic[@"streamUrl"] = [music objectForKey:@"stream_url"];
            if ([music objectForKey:@"genre"])
                newMusic[@"category"] = [music objectForKey:@"genre"];
            newMusic[@"title"] = [music objectForKey:@"title"];
            newMusic[@"duration"] = [music objectForKey:@"duration"];
            newMusic[@"scId"] = [[music objectForKey:@"id"] stringValue];
            
            [newMusic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                PFRelation *relationMusic = [newAlbum relationForKey:@"musics"];
                [relationMusic addObject:newMusic];
                [newAlbum saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    PFRelation *relationAlbumUser = [user relationForKey:@"albuns"];
                    [relationAlbumUser addObject:newAlbum];
                    [user saveInBackground];
                }];
            }];
            
            
        }
        
    }
}

#pragma update top100

-(void) getMusics:(int) index{
    
    
    SCAccount *account = [SCSoundCloud account];
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            
            
            NSArray *array = (NSArray *) jsonResponse;
            while (!self.added) {
                
                if (![[array objectAtIndex:[self.item intValue]] count] == 0) {
                    
                    BOOL bool1 = ([[array objectAtIndex:[self.item intValue]] objectForKey:@"stream_url"] != [NSNull null]);
                    BOOL bool2 = (BOOL) [[array objectAtIndex:[self.item intValue]] objectForKey:@"stream_url"];
                    BOOL bool3 = ([[array objectAtIndex:[self.item intValue]] objectForKey:@"artwork_url"] != [NSNull null]);
                    
                    if (bool1 && bool2 && bool3)
                    {
                        self.added = YES;
                        [self addInParseAt:index WithData:[array objectAtIndex:[self.item intValue]]];
                    }
                    else
                        self.item = @([self.item intValue]+1);
                }
                else
                    self.item = @([self.item intValue]+1);
            }
            
            self.added = NO;
            self.item = @0;
        }
    };
    
    
    NSString *search = [[[self.infoMusic objectAtIndex:index] objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *resourceURL = [NSString stringWithFormat:@"https://api.soundcloud.com/me/tracks?q=%@&format=json", search];
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
    
}

-(void) addInParseAt:(int)index WithData:(PFObject *) music{
    
    PFQuery *query = [PFQuery queryWithClassName:@"MusicTop100"];
    [query selectKeys:@[@"coverPictureUrl", @"title", @"streamUrl", @"scId"]];
    query.limit = 1;
    query.skip = index;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *oldObject, NSError *error) {
        if (!error) {
            oldObject[@"imageUrl"] = [music objectForKey:@"artwork_url"];
            oldObject[@"title"] = [[self.infoMusic objectAtIndex:index] objectAtIndex:0];
            oldObject[@"artist"] = [[self.infoMusic objectAtIndex:index] objectAtIndex:1];
            oldObject[@"streamUrl"] = [music objectForKey:@"stream_url"];
            oldObject[@"scId"] = [[music objectForKey:@"id"] stringValue];
            [oldObject saveInBackground];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}


-(void)checkIfUpdated{
    
    NSDate *date = [NSDate date];
    SCAccount *account = [SCSoundCloud account];
    
    PFQuery *query = [PFQuery queryWithClassName:@"MusicTop100"];
    [query whereKey:@"updatedAt" lessThan:date];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"dd MM YYYY"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [formatter setDateStyle:NSDateFormatterFullStyle];
            
            
            NSDate *dateOne = [[NSDate alloc] init];
            NSDate *dateTwo = [[NSDate alloc] init];
            
            NSString *date1 = [formatter stringFromDate:date];
            dateOne = [formatter dateFromString:date1];
            
            NSString *date2 = [formatter stringFromDate:object.updatedAt];
            dateTwo = [formatter dateFromString:date2];
            
            if (![dateOne isEqualToDate:dateTwo] && account != nil) {
                //[self initReader];
                [PFCloud callFunctionInBackground:@"atualizaTop100" withParameters:@{} block:^(NSArray *object, NSError *error) {
                    self.infoMusic = [[NSMutableArray alloc] initWithArray:object];
                    self.tracks = [NSMutableArray new];
                    self.item = @0;
                    
                    for (int i = 0; i < 100; i++) {
                        
                        [self getMusics:i];
                    }
                    
                }];
                
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}


@end
