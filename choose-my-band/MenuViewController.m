//
//  LogoutViewController.m
//  choose-my-band
//
//  Created by BEPiD on 02/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
    
    /* General Singleton load informations */
    self.genSingle = [GeneralSingleton sharedInstance];
    
    self.optionsMenu = [[NSMutableArray alloc] initWithArray:@[@[@"Change personal data", @"Change profile cover"], @[@"Enable notifications", @"Facebook auto-share"], @[@"Facebook login", @"CMB logout"]]];
    self.sectionsTitle = @[@"Personal data and customization", @"Application control", @"Account control"];
    
    self.sharedPlayer = [SingletonPlayer sharedInstance];
    [self startElementsOnScreen];
    [self startConfigurations];
}

-(void)startConfigurations
{
    self.topBar = [[CMBTopBar alloc]initWithNavigationController:self.navController];
    self.topBar.isAtMenu = YES;
    [self.topBar.returnButton setEnabled:NO];
    [self.topBar.returnButton setHidden:YES];
    [self.view addSubview:self.topBar];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startElementsOnScreen
{
    CGRect frameOfTable = CGRectMake(0, 58, self.view.frame.size.width, self.view.frame.size.height);
    self.tableMenu = [[UITableView alloc] initWithFrame:frameOfTable style:UITableViewStylePlain];
    //[self.tableMenu setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableMenu registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableMenu setDelegate:self];
    [self.tableMenu setDataSource:self];
    
    self.switchFacebook = [[UISwitch alloc] init];
    self.switchNotification = [[UISwitch alloc] init];
    [self.view addSubview:self.tableMenu];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell.textLabel setText:[[self.optionsMenu objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    
    
    //continuar aqui
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.accessoryView = self.switchNotification;
                [self.switchNotification setOn:self.sharedPlayer.preferences.enableNotification];
                [self.switchNotification addTarget:self action:@selector(switchNotif) forControlEvents:UIControlEventValueChanged];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                break;
            case 1:
                [self.switchFacebook setOn:self.sharedPlayer.preferences.isAutoShare];
                cell.accessoryView = self.switchFacebook;
                [self.switchFacebook addTarget:self action:@selector(switchFace) forControlEvents:UIControlEventValueChanged];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                break;
        }
    }
    
    else if (indexPath.section == 2 && indexPath.row == 0)
        if ((FBSession.activeSession.state == FBSessionStateOpen
             || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)) {
            [cell.textLabel setText:@"Facebook logout"];
        }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                [self loginFacebook];
                break;
            case 1:
                [self logoutSoundCloud];
                
                break;
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionsTitle objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = [@"   " stringByAppendingString: [self.sectionsTitle objectAtIndex:section]];
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, self.view.frame.size.width, 23);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    label.text = sectionTitle;
    label.backgroundColor = [UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1];
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [view addSubview:label];
    
    return view;
}

-(void)logoutSoundCloud
{
    /* When the user click to logout, delete the informations saved previously */
    [self.genSingle deleteDataClass];
    
    /* Stopping the player */
    if ([self.sharedPlayer.player isPlaying])
        [self.sharedPlayer.player stop];
    
    [SCSoundCloud removeAccess];
    [self dismissViewControllerAnimated:YES completion:nil];
    UIViewController *uvc = [self.navController.viewControllers objectAtIndex:self.navController.viewControllers.count-1];
    [uvc.tabBarController setSelectedIndex:0];
    
}

-(void)loginFacebook
{
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
        [self.tableMenu reloadData];
    } else {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"publish_actions"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
         }];
    }
}

-(void)switchNotif
{
    if (self.sharedPlayer.preferences.enableNotification != self.switchNotification.isOn) {
        self.sharedPlayer.preferences.enableNotification = self.switchNotification.isOn;
        [self.sharedPlayer saveDataSaveClass];
    }
}

-(void)switchFace
{
    if (self.sharedPlayer.preferences.isAutoShare != self.switchFacebook.isOn) {
        self.sharedPlayer.preferences.isAutoShare = self.switchFacebook.isOn;
        [self.sharedPlayer saveDataSaveClass];
    }
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
