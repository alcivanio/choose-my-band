//
//  SearchViewController.m
//  choose-my-band
//
//  Created by Bruno Lima on 27/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

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
    [self startConfigurations];
    [self initElements];
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(void)startConfigurations
{
    [self.searchScroll setDelegate:self];
    self.pointOfScrollY = 0;
    self.topBar = [[CMBTopBar alloc]initWithNavigationController:self.navigationController];
    [self.view addSubview:self.topBar];
    self.bottomBar = [[CMBBottomBar alloc]initWithY:self.view.frame.size.height width:self.view.frame.size.width navigationController:self.navigationController andScroll:nil];
    self.bottomBar.myTabBar = self.tabBarController;
    [self.view addSubview:self.bottomBar];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.bottomBar.viewControllers = self.viewControllers;
    
    [self.topBar.returnButton setEnabled:NO];
    [self.topBar.returnButton setHidden:YES];

}

-(void)initElements
{
    //SETTING THE BACKGROUNDCOLLOR
    [self.view setBackgroundColor:[UIColor colorWithRed:34/255.f green:34/255.f blue:34/255.f alpha:1]]; //Depois alterar essa cor
    
    //SETTING THE TEXTFIELD
    CGRect frameOfTextField = CGRectMake(10, self.topBar.frame.size.height-30, 255, 20);
    self.searchTextField = [[UITextField alloc] initWithFrame:frameOfTextField];
    //[self.searchTextField setBorderStyle:UITextBorderStyleRoundedRect];
    //[self.searchTextField setFont:[UIFont systemFontOfSize:18]];
    [self.searchTextField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [self.searchTextField setTextColor:[UIColor whiteColor]];
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search for a music or artist" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1]}];
    self.searchTextField.keyboardType = UIKeyboardTypeDefault;
    self.searchTextField.returnKeyType = UIReturnKeyGo;
    [self.searchTextField setDelegate:self];
    
    
    CGRect frameOfButtonSearch = CGRectMake(frameOfTextField.origin.x + frameOfTextField.size.width + 20, frameOfTextField.origin.y, 21, 21);
    self.searchButton = [[UIButton alloc] initWithFrame:frameOfButtonSearch];
    [self.searchButton setBackgroundImage:[UIImage imageNamed:@"tbsearchicon"] forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(goSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //SEGMENTED SEARCH
    
    self.searchSegmented = [[UISegmentedControl alloc] initWithItems:@[@"Musicas",@"Usuarios"]]; //initWithFrame:CGRectMake(10, self.topBar.frame.size.width+10, self.view.frame.size.width - 10, self.topBar.frame.size.height/2)];
    [self.searchSegmented setFrame:CGRectMake(10,self.topBar.frame.size.height + self.searchTextField.frame.size.height,self.view.frame.size.width - 20,30)];
    [self.searchSegmented setTintColor:[UIColor whiteColor]];
    [self.searchSegmented setSelectedSegmentIndex:0];
    [self.searchSegmented addTarget:self action:@selector(searchFor:) forControlEvents:UIControlEventValueChanged];
    
    
    //other scroll
    
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.searchSegmented.frame.size.height + self.searchSegmented.frame.origin.y + 10, self.view.frame.size.width, self.bottomBar.frame.origin.y - (self.searchSegmented.frame.size.height + self.searchSegmented.frame.origin.y + 10))];
    [self.scroll setBackgroundColor:[UIColor whiteColor]];
    
    [self.scroll setContentSize:CGSizeMake(self.view.frame.size.width*2, self.scroll.frame.size.height)];
    [self.scroll setPagingEnabled:YES];
    
    
    //SETTING MUSIC  TABLE VIEW
    CGRect frameOfTableView1 = CGRectMake(0, 0, self.scroll.frame.size.width, self.scroll.frame.size.height);
    self.musicResultsOfSearch = [[UITableView alloc] initWithFrame:frameOfTableView1 style:UITableViewStylePlain];
    [self.musicResultsOfSearch registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.musicResultsOfSearch setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.musicResultsOfSearch setDelegate:self];
    [self.musicResultsOfSearch setDataSource:self];
    [self.musicResultsOfSearch setTag:300];
    
    //SETTING USUARIOS  TABLE VIEW
    CGRect frameOfTableView = CGRectMake(self.view.frame.size.width, 0, self.scroll.frame.size.width, self.scroll.frame.size.height);
    self.usuariosResultsOfSearch = [[UITableView alloc] initWithFrame:frameOfTableView style:UITableViewStylePlain];
    [self.usuariosResultsOfSearch registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.usuariosResultsOfSearch setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.usuariosResultsOfSearch setDelegate:self];
    [self.usuariosResultsOfSearch setDataSource:self];
    [self.usuariosResultsOfSearch setTag:400];

    
    //ADDING TO OTHER SCROLL
    [self.scroll addSubview:self.musicResultsOfSearch];
    [self.scroll addSubview:self.usuariosResultsOfSearch];
    
    
    //ADDING IN THE VIEW
    [self.searchScroll addSubview:self.searchSegmented];
    [self.searchScroll addSubview:self.scroll];

    [self.searchScroll addSubview:self.searchTextField];
    [self.searchScroll addSubview:self.searchButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)goSearch:(UIButton *)sender{
    switch (self.searchSegmented.selectedSegmentIndex) {
        case 0:
            [self searchForMusics];
            break;
        case 1:
            [self searchForUsers];
            break;
        default:
            break;
    }
}

-(IBAction)searchFor:(UISegmentedControl *)sender{
    switch (self.searchSegmented.selectedSegmentIndex) {
        case 0:
            [self.scroll setContentOffset:CGPointMake(0,0)];
            break;
        case 1:
            [self.scroll setContentOffset:CGPointMake(self.view.frame.size.width, 0)];
            break;
        default:
            break;
    }

}

//DO THE SEARCH IN SOUND CLOUD
-(void) searchForMusics {
    
    SCAccount *account = [SCSoundCloud account];
    if (account == nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Not Logged In"
                              message:@"You must login first"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.lastSearch = self.searchTextField.text;
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {

                self.resultsOfSearch = [NSMutableArray new];
            
            
            NSArray *arrayOfResult = (NSArray *) jsonResponse;
            
            for (int i = 0; i < [arrayOfResult count]; i++) {
                if([[arrayOfResult objectAtIndex:i] objectForKey:@"stream_url"] != (NSString *)[NSNull null] && [[arrayOfResult objectAtIndex:i] objectForKey:@"stream_url"])
                    [self.resultsOfSearch addObject:[arrayOfResult objectAtIndex:i]];
            }
            
            [self.musicResultsOfSearch reloadData];
           //[self.resultsOfSearch setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        }
    };
    
    
    NSString *search = [self.searchTextField.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    search = [[NSString alloc]
              initWithData:
              [search dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]
              encoding:NSASCIIStringEncoding];
    NSString *resourceURL = [NSString stringWithFormat:@"https://api.soundcloud.com/me/tracks?q=%@&format=json", search];
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
}
//SEARCH IN PARSE
-(void)searchForUsers{
    [PFCloud callFunctionInBackground:@"findSomeUsers" withParameters:@{@"limit":@"50",@"prefix":self.searchTextField.text} block:^(NSArray *objects, NSError *error) {
        self.resultsOfSearch = [[NSMutableArray alloc] initWithArray:objects];
        [self.usuariosResultsOfSearch reloadData];
    }];

    
}

#pragma mark delegate text field

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (![textField.text isEqualToString:@""]) {
        [self searchForMusics];
    }
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //alterar depois
    return [self.resultsOfSearch count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMBCellTableSearch *cell = [[CMBCellTableSearch alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    if (tableView.tag == 300) {
        NSDictionary *dict = [self.resultsOfSearch objectAtIndex:indexPath.row];
        NSDictionary *user = [dict objectForKey:@"user"];
        
        NSString *urlImage = [[self.resultsOfSearch objectAtIndex:indexPath.row] objectForKey:@"artwork_url"];
        
        //NSLog(@"%@",[[self.tracksOfSearch objectAtIndex:indexPath.row] description]);
        
        NSString *title = [[self.resultsOfSearch objectAtIndex:indexPath.row] objectForKey:@"title"];
        if(urlImage != (NSString *)[NSNull null])
            [cell.albumCover setImageWithURL:[NSURL URLWithString:urlImage]];
        else
            [cell.albumCover setImage:[UIImage imageNamed:@"album-cover"]];
        //[cell.albumCover setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:string]]]];
        
        //Texts visible on search
        if(title.length > 45)
        {
            title = [title substringToIndex:45];
            title = [title stringByAppendingString:@"..."];
        }
        
        [cell.musicTitle setText:title];
        [cell.musicTitle sizeToFit];
        [cell.artistAlbumTitle setText:[user objectForKey:@"username"]];
        [self alterateSizeOfTexts:cell.musicTitle andMoreInfo:cell.artistAlbumTitle];
        
    }
    else{
        User *user = [[User alloc] initWithPFObject:[self.resultsOfSearch objectAtIndex:indexPath.row]];
        
        [cell.musicTitle setText:user.username];
        [cell.musicTitle sizeToFit];
        [cell.artistAlbumTitle setText:user.bio];
        [cell.albumCover setImageWithURL:[NSURL URLWithString:user.profilePictureUrl]];
    }

    return cell;
}

-(void)alterateSizeOfTexts:(UITextView *)title andMoreInfo:(UILabel *)info
{
    CGFloat fixedWidth = title.frame.size.width;
    CGSize newSize = [title sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = title.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    title.frame = newFrame;
    
    CGRect frameNew = info.frame;
    frameNew.origin.y = title.frame.size.height + title.frame.origin.y
    ;
    info.frame = frameNew;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 300) {
        UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:2];
        AlbumPlayerViewController *apvc = [[navController viewControllers] objectAtIndex:0];
        
        
        apvc.album = [[Album alloc] init];
        apvc.album.musics = [[NSMutableArray alloc] init];
        
        
        for (NSDictionary *music in self.resultsOfSearch) {
            Music *newMusic = [[Music alloc] init];
            newMusic.title = [music objectForKey:@"title"];
            newMusic.streamUrl = [music objectForKey:@"stream_url"];
            newMusic.imageUrl = [music objectForKey:@"artwork_url"];
            [apvc.album.musics addObject:newMusic];
        }
        
        self.sharedPlayer = [SingletonPlayer sharedInstance];
        
        NSString *artworkUrl = ((Music *)[apvc.album.musics objectAtIndex:indexPath.row]).imageUrl;
        if (artworkUrl != (NSString *)[NSNull null])
            [apvc.albumCover setImageWithURL:[NSURL URLWithString:artworkUrl]];
        else
            [apvc.albumCover setImage:[UIImage imageNamed:@"album-cover"]];
        
        
        [apvc.tableListMusics reloadData];
        [apvc loadInfosOfAlbum];
        
        if ([self.sharedPlayer.player isPlaying])
            [self.sharedPlayer.player stop];
        [apvc playMusicOfSearchAtIndex:indexPath.row];
        apvc.sharedPlayer.typePlayer = @"player";
        apvc.sharedPlayer.currentController = apvc;
        apvc.album.title = self.lastSearch;

    }
    else{
        //quando clicar no user
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

@end






