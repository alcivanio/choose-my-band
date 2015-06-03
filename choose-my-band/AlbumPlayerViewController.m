//
//  AlbumPlayerViewController.m
//  choose-my-band
//
//  Created by Alcivanio on 02/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "AlbumPlayerViewController.h"

@interface AlbumPlayerViewController ()

@end

@implementation AlbumPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self instantiateElements];
    [self initializeElements];
    [self loadTracksOfAlbum];
    [self loadInfosOfAlbum];
    self.sharedPlayer = [SingletonPlayer sharedInstance];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self instantiateElements];
    [self initializeElements];
    [self loadTracksOfAlbum];
    [self loadInfosOfAlbum];
    self.sharedPlayer = [SingletonPlayer sharedInstance];
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadInfosOfAlbum];
    [self loadTracksOfAlbum];
    [self.view addSubview:self.bottomBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadTracksOfAlbum
{
    PFRelation *relationTracks = [self.album.pfObjectReference relationForKey:@"musics"];
    [[relationTracks query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        //If is not inited
        if(!self.album.musics)
        {
            self.album.musics = [[NSMutableArray alloc]init];
        
        //Adding the tracks
        for (PFObject *obj in objects)
            [self.album.musics addObject:[[Music alloc]initWithPFObject:obj]];
        }
        
        //reload the table
        [self.tableListMusics reloadData];
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(void)instantiateElements
{
    self.topBar = [[CMBTopBar alloc]initWithNavigationController:self.navigationController];
    [self.view addSubview:self.topBar];
    self.bottomBar = [[CMBBottomBar alloc]initWithY:self.view.frame.size.height width:self.view.frame.size.width navigationController:self.navigationController andScroll:nil];
    self.bottomBar.myTabBar = self.tabBarController;
    [self.view addSubview:self.bottomBar];
    self.bottomBar.viewControllers = self.viewControllers;
    
    [self.topBar.returnButton setEnabled:NO];
    [self.topBar.returnButton setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)loadInfosOfAlbum
{
    //Informations about the album
    //fazer isso aquiiiii
    if (self.album.coverUrl != (NSString *)[NSNull null])
        [self.albumCover setImageWithURL:[NSURL URLWithString:self.album.coverUrl]];
    else
        [self.albumCover setImage:[UIImage imageNamed:@"album-cover"]];

        [self.albumTitle setText:self.album.title];
    NSString *albumBand = [self.album.owner.username stringByAppendingString: [self generateYear:self.album.createdAt]];
    [self.albumBandAndYear setText:albumBand];
}

-(void)initializeElements
{
    CGRect frameScroll = CGRectMake(0, self.topBar.frame.size.height, self.view.frame.size.width, (self.view.frame.size.height-self.topBar.frame.size.height)-self.bottomBar.frame.size.height);
    self.scroll = [[UIScrollView alloc]initWithFrame:frameScroll];
    [self.scroll setBackgroundColor:[UIColor blackColor]];
    
    CGRect framePrincipalInfo = CGRectMake(0, 0, self.view.frame.size.width, 100);
    UIView *topInformations = [[UIView alloc]initWithFrame:framePrincipalInfo];
    [topInformations setBackgroundColor:[UIColor whiteColor]];
    
    CGRect frameAlbumCover = CGRectMake(5, framePrincipalInfo.origin.y +10, framePrincipalInfo.size.height-20, framePrincipalInfo.size.height-20);
    self.albumCover = [[UIImageView alloc]initWithFrame:frameAlbumCover];
    [self.albumCover setImage:[UIImage imageNamed:@"album-cover"]];
    [self.albumCover setClipsToBounds:YES];
    [self.albumCover.layer setCornerRadius:5];
    
    CGRect frameAlbumTitle = CGRectMake(frameAlbumCover.size.width +frameAlbumCover.origin.x + 5, frameAlbumCover.origin.y, 0, 22);
    frameAlbumTitle.size.width = self.view.frame.size.width - frameAlbumTitle.origin.x - 5;
    self.albumTitle = [[UITextView alloc]initWithFrame:frameAlbumTitle];
    [self.albumTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    self.albumTitle.textContainer.lineFragmentPadding = 0;//Removing the borders
    self.albumTitle.textContainerInset = UIEdgeInsetsZero;
    [self.albumTitle setText:@"Never mind"];
    [self.albumTitle setTextColor:[UIColor colorWithRed:77.0f/255.0f green:205.0f/255.0f blue:242.0f/255.0f alpha:1]];
    [self.albumTitle setScrollEnabled:NO];
    [self.albumTitle setSelectable:NO];
    
    CGRect frameAlbumBand = CGRectMake(frameAlbumTitle.origin.x, frameAlbumTitle.origin.y + frameAlbumTitle.size.height +1,self.view.frame.size.width - frameAlbumTitle.origin.x - 5, 15);
    self.albumBandAndYear = [[UILabel alloc]initWithFrame:frameAlbumBand];
    [self.albumBandAndYear setText:@"Nirvana, 1997"];
    [self.albumBandAndYear setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1]];
    [self.albumBandAndYear setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    
    CGRect frameAlbumDuration = frameAlbumBand;
    frameAlbumDuration.origin.y = frameAlbumBand.origin.y + frameAlbumBand.size.height +1;
    self.albumDuration = [[UILabel alloc]initWithFrame:frameAlbumDuration];
    [self.albumDuration setText:[self generateAlbumDuration:self.album.duration]];
    [self.albumDuration setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [self.albumDuration setTextColor:[UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1]];
    
    CGRect frameShare = CGRectMake(self.view.frame.size.width-80, frameAlbumCover.size.height+frameAlbumCover.origin.y-20, 75, 20);
    self.shareButton = [[UIButton alloc]initWithFrame:frameShare];
    [self.shareButton setBackgroundColor:[UIColor colorWithRed:77.0f/255.0f green:205.0f/255.0f blue:242.0f/255.0f alpha:1]];
    [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [self.shareButton.layer setCornerRadius:self.shareButton.frame.size.height/2];
    [self.shareButton setClipsToBounds:YES];
    [self.shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [self.shareButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    //Adding elements on top informations
    [topInformations addSubview:self.albumCover];
    [topInformations addSubview:self.albumTitle];
    [topInformations addSubview:self.albumBandAndYear];
    [topInformations addSubview:self.albumDuration];
    [topInformations addSubview:self.shareButton];
    
    CGRect frameOfFirstLine = CGRectMake(0, topInformations.frame.size.height, self.view.frame.size.width, 1);
    UIView *firstLine = [[UIView alloc]initWithFrame:frameOfFirstLine];
    [firstLine setBackgroundColor:[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1]];
    
    CGRect framePlayerControls = CGRectMake(0, self.view.frame.size.height-100-self.bottomBar.frame.size.height-self.topBar.frame.size.height, self.view.frame.size.width, 100);
    UIView *playerControllers = [[UIView alloc]initWithFrame:framePlayerControls];
    [playerControllers setBackgroundColor:[UIColor whiteColor]];
    
    CGRect frameOfTableView = CGRectMake(0, frameOfFirstLine.origin.y+1, self.view.frame.size.width, self.view.frame.size.height-framePlayerControls.size.height-100-self.bottomBar.frame.size.height-self.topBar.frame.size.height);
    self.tableListMusics = [[UITableView alloc]initWithFrame:frameOfTableView];
    [self.tableListMusics setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableListMusics setDelegate:self];
    [self.tableListMusics setDataSource:self];
    
    CGRect frameOfSecondLine = frameOfFirstLine;
    frameOfSecondLine.origin.y=framePlayerControls.origin.y-1;
    UIView *secondLine = [[UIView alloc]initWithFrame:frameOfSecondLine];
    [secondLine setBackgroundColor:[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1]];
    
    CGRect framePlay = CGRectMake((self.view.frame.size.width/2)-40, 5, 80, 80);
    self.play = [[UIButton alloc]initWithFrame:framePlay];
    [self.play setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
    [self.play.layer setCornerRadius:40];
    [self.play setClipsToBounds:YES];
    [self.play addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
    if ([self.sharedPlayer.typePlayer isEqualToString:@"player"])
        [self.play setTag:1];
    
    
    
    CGRect framePrev = CGRectMake(framePlay.origin.x-10-40, 30, 40, 40);
    self.prev = [[UIButton alloc]initWithFrame:framePrev];
    [self.prev setBackgroundColor:[UIColor colorWithRed:238/255.f green:238/255.f blue:238/255.f alpha:1]];
    [self.prev.layer setCornerRadius:20];
    [self.prev setClipsToBounds:YES];
    [self.prev addTarget:self action:@selector(prevButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frameNext = framePrev;
    frameNext.origin.x = framePlay.size.width + framePlay.origin.x + 10;
    self.next = [[UIButton alloc]initWithFrame:frameNext];
    [self.next setBackgroundColor:[UIColor colorWithRed:238/255.f green:238/255.f blue:238/255.f alpha:1]];
    [self.next.layer setCornerRadius:20];
    [self.next setClipsToBounds:YES];
    [self.next addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];


//    CGRect frameSlider = CGRectMake(50, 5, self.view.frame.size.width-100, 5);
//    self.progressOfMusic = [[UISlider alloc] initWithFrame:frameSlider];
//    [self.progressOfMusic setThumbImage:[UIImage new] forState:UIControlStateNormal];
//    [self.progressOfMusic addTarget:self action:@selector(changeValue) forControlEvents:UIControlEventValueChanged];
//    [self.progressOfMusic setEnabled:NO];
//    
//    frameSlider.origin.x -= 30;
//    frameSlider.size.height = 10;
//    frameSlider.origin.y -= 2;
//    self.currentTime = [[UILabel alloc] initWithFrame:frameSlider];
//    [self.currentTime setFont:[UIFont systemFontOfSize:11.0]];
//    [self.currentTime setText:@"00:00"];
//    
//    frameSlider.origin.x = self.progressOfMusic.frame.origin.x + self.progressOfMusic.frame.size.width + 5;
//    self.totalTime = [[UILabel alloc] initWithFrame:frameSlider];
//    [self.totalTime setFont:[UIFont systemFontOfSize:11.0]];
//    [self.totalTime setText:@"00:00"];
    
    [playerControllers addSubview:self.play];
    [playerControllers addSubview:self.prev];
    [playerControllers addSubview:self.next];
//    [playerControllers addSubview:self.progressOfMusic];
//    [playerControllers addSubview:self.currentTime];
//    [playerControllers addSubview:self.totalTime];
    
    [self.view addSubview:self.scroll];
    [self.scroll addSubview:topInformations];
    [self.scroll addSubview:firstLine];
    [self.scroll addSubview:self.tableListMusics];
    [self.scroll addSubview:playerControllers];
    [self.scroll addSubview:secondLine];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.album.musics count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.sharedPlayer.currentController = self;
    self.sharedPlayer.typePlayer = @"player";
    [self.sharedPlayer.player stop];
    self.sharedPlayer.playList = self.album.musics;
    self.sharedPlayer.nextMusic = [NSNumber numberWithInt:indexPath.row];
    [self.sharedPlayer playMusicOfPlayListAtIndex:indexPath.row];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CMBAlbumTableCell *cell = [[CMBAlbumTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [cell.titleMusic setText:[[self.album.musics objectAtIndex:indexPath.row] title]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

-(void)nextButtonAction
{
    if(self.album)
        [self.sharedPlayer playNextMusic];
    
}


-(void)prevButtonAction
{
    if(self.album)
        [self.sharedPlayer playPrevMusic];
}

-(void) playButtonAction
{
    if(self.album){
       if (self.play.tag == 0) {
           self.sharedPlayer.currentController = self;
           self.sharedPlayer.typePlayer = @"player";
           self.sharedPlayer.playList = self.album.musics;
           [self.sharedPlayer playMusicOfPlayListAtIndex:0];
           [self.play setTag:1];
       }
       else if([self.sharedPlayer.player isPlaying] && self.play.tag == 1) {
           [self.sharedPlayer.player pause];
           [self.play setTag:2];
       }
       else if (![self.sharedPlayer.player isPlaying] && self.play.tag == 2)
       {
           [self.sharedPlayer.player play];
           [self.play setTag:1];
       }
    }
}

-(void) playMusicOfSearchAtIndex:(int)index
{
    self.sharedPlayer = [SingletonPlayer sharedInstance];
    self.sharedPlayer.playList = self.album.musics;
    [self.sharedPlayer playMusicOfPlayListAtIndex:index];
}

-(void)shareAction
{
    NSIndexPath *index = [self.tableListMusics indexPathForSelectedRow];
    NSLog(@"%d",index.row);
    
    UIStoryboard *stBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShareContentViewController *shareView = (ShareContentViewController *)[stBoard instantiateViewControllerWithIdentifier:@"ShareContentStoryboard"];
    shareView.musicToShare = [self.album.musics objectAtIndex:[self.tableListMusics indexPathForSelectedRow].row];
    [self.navigationController pushViewController:shareView animated:YES];
    
}

-(NSString *)generateAlbumDuration:(NSNumber *)floatDuration{
    NSString *duration;
    
    int hora = 0;
    int min = 0;
    int sec = 0;
    int aux2 = [floatDuration intValue];
    int aux = 100*([floatDuration floatValue] - aux2);
    if(aux > 59){
        sec = aux - 60;
        aux2+=aux/60;
    }
    else{
        sec = aux;
    }
    
    if(aux2 > 59){
        min = aux2 - 60;
        hora+=aux2/60;
    }
    else{
        min = aux2;
    }
    
    if(hora == 0){
        if (min < 10) {
            if(sec < 10){
                duration = [NSString stringWithFormat:@"0%i:0%i",min,sec];
            }
            else{
                duration = [NSString stringWithFormat:@"0%i:%i",min,sec];
            }
        }
        else{
            if(sec < 10){
                duration = [NSString stringWithFormat:@"%i:0%i",min,sec];
            }
            else{
                duration = [NSString stringWithFormat:@"%i:%i",min,sec];
            }
        }
    }
    else{
        if (min < 10) {
            if(sec < 10){
                duration = [NSString stringWithFormat:@"%i:0%i:0%i",hora,min,sec];
            }
            else{
                duration = [NSString stringWithFormat:@"%i:0%i:%i",hora,min,sec];
            }
        }
        else{
            if(sec < 10){
                duration = [NSString stringWithFormat:@"%i:%i:0%i",hora,min,sec];
            }
            else{
                duration = [NSString stringWithFormat:@"%i:%i:%i",hora,min,sec];
            }
        }

        
    }
    
    return duration;
}


-(NSString *)generateYear:(NSDate *) date{

    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"YYYY"];
    NSString *year = [formatter stringFromDate:date];
    return [NSString stringWithFormat:@", %@",year];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl)
    {
        if (event.subtype == UIEventSubtypeRemoteControlPlay)
        {
            [[[SingletonPlayer sharedInstance] player] play];
        }
        else if (event.subtype == UIEventSubtypeRemoteControlPause)
        {
            [[[SingletonPlayer sharedInstance] player] pause];
        }
        else if (event.subtype == UIEventSubtypeRemoteControlNextTrack)
        {
            [[SingletonPlayer sharedInstance] playNextMusic];
            
        }
        else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack)
        {
            [[SingletonPlayer sharedInstance] playPrevMusic];
        }
    }
}
@end





















