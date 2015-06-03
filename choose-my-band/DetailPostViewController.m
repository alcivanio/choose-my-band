//
//  DetailPostViewController.m
//  Choose My Band
//
//  Created by BEPiD on 05/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "DetailPostViewController.h"

@interface DetailPostViewController ()

@end

@implementation DetailPostViewController

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
    // Do any additional setup after loading the view.
    self.genSingleton = [GeneralSingleton sharedInstance];
    [self startConfigurations];
    [self initElements];
}

-(void)startConfigurations
{
    self.pointOfScrollY = 0;
    self.topBar = [[CMBTopBar alloc]initWithNavigationController:self.navigationController];
    [self.view addSubview:self.topBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initElements{
    
    //SET THE IMAGE FOR ALBUM COVER
    CGRect frameOfAlbumCover = CGRectMake(5, 10, self.view.frame.size.width - 10, self.view.frame.size.width - 10);
    self.coverAlbum = [[UIImageView alloc] initWithFrame:frameOfAlbumCover];
    if (self.statusPost.music.imageUrl)
        [self.coverAlbum setImageWithURL:[NSURL URLWithString:self.statusPost.music.imageUrl]];
    else
        [self.coverAlbum setImage:[UIImage imageNamed:@"album-cover"]];
    [self.coverAlbum.layer setCornerRadius:5];
    [self.coverAlbum setClipsToBounds:YES];
    [self.coverAlbum setContentMode:UIViewContentModeScaleAspectFill];
    
    UITapGestureRecognizer *oneTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPostClick:)];
    //  [oneTouch setNumberOfTapsRequired:1];
    [self.coverAlbum addGestureRecognizer:oneTouch];
    [self.coverAlbum setUserInteractionEnabled:YES];
    
    //SET THE LIKES LABEL
    CGRect frameLikes = CGRectMake(self.view.frame.size.width - 75, frameOfAlbumCover.origin.y + frameOfAlbumCover.size.height + 11, 70, 30);
    self.likeLabel = [[UILabel alloc] initWithFrame:frameLikes];
    [self.likeLabel setText:@"- likes"];
    [self.likeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [self.likeLabel setTextColor:[UIColor grayColor]];
    [self reformatLike];
    
    CGRect frameOfLike = CGRectMake(frameLikes.origin.x - 25, frameOfAlbumCover.origin.y + frameOfAlbumCover.size.height + 10, 20, 20);
    self.likeIcon = [[UIButton alloc] initWithFrame:frameOfLike];
    [self.likeIcon setBackgroundImage:[UIImage imageNamed:@"like-icon"] forState:UIControlStateNormal];
    [self.likeIcon addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.likeIcon.layer setCornerRadius:10];
    [self.likeIcon setClipsToBounds:YES];
    
    CGRect frameLineLike = CGRectMake(50, frameOfLike.origin.y + frameOfLike.size.height+10, self.view.frame.size.width, 1);
    UIView *lineOfLike = [[UIView alloc]initWithFrame:frameLineLike];
    [lineOfLike setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
    
    /* PROFILE PICTURE ALBUM IMAGE */
    //Frame used in the all view
    CGRect frameProfilePicture = CGRectMake(5, frameLineLike.origin.y + 11, 50, 50);
    
    //init profile picture
    self.profilePicture = [[UIImageView alloc]initWithFrame:frameProfilePicture];
    [self.profilePicture setImageWithURL:[NSURL URLWithString:[self.statusPost.owner.profilePictureUrl stringByReplacingOccurrencesOfString:@"large.jpg" withString:@"t500x500.jpg"]]];
    
    //border radius of the image
    [self.profilePicture.layer setCornerRadius:5];
    [self.profilePicture setClipsToBounds:YES];
    
    /* TEXT STATUS*/
    CGRect frameStatusText;
    frameStatusText.origin.x = frameProfilePicture.origin.x + frameProfilePicture.size.width + 5;
    frameStatusText.origin.y = frameProfilePicture.origin.y;
    frameStatusText.size.width = 256;
    frameStatusText.size.height = 133;
    
    self.textStatus = [[UITextView alloc]initWithFrame:frameStatusText];
    [self.textStatus setAttributedText:[self formatedTextStatus]];
    [self.textStatus setEditable:NO];
    [self.textStatus setScrollEnabled:NO];
    //Styles of the text status
    self.textStatus.textContainer.lineFragmentPadding = 0;//Removing the borders
    self.textStatus.textContainerInset = UIEdgeInsetsZero;
    
    //ADDING IN THE SCROOL
    [self.postScroll addSubview:self.coverAlbum];
    [self.postScroll addSubview:self.likeLabel];
    [self.postScroll addSubview:self.likeIcon];
    [self.postScroll addSubview:self.profilePicture];
    [self.postScroll addSubview:self.textStatus];
    [self.postScroll addSubview:lineOfLike];
    [self.postScroll addSubview:self.profilePicture];
    [self.postScroll addSubview:self.textStatus];
    
    [self reformatHeader];
    [self reloadLike];
}

-(void)reformatHeader
{
    //Remonting the text view of status
    CGFloat fixedWidth = self.textStatus.frame.size.width;
    CGSize sizeFits = [self.textStatus sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.textStatus.frame;
    newFrame.size = CGSizeMake(fmaxf(sizeFits.width, fixedWidth), sizeFits.height);
    self.textStatus.frame = newFrame;
    
    //Now, about the line y position
    float lastYPosition = self.textStatus.frame.origin.y + self.textStatus.frame.size.height;
    if((self.textStatus.frame.origin.y + self.textStatus.frame.size.height) < (self.profilePicture.frame.origin.y + self.profilePicture.frame.size.height))
        lastYPosition = self.profilePicture.frame.origin.y + self.profilePicture.frame.size.height;
    
    self.linePostToComments = [[UIView alloc]initWithFrame:CGRectMake(0, lastYPosition+10, self.view.frame.size.width, 1)];
    [self.linePostToComments setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
    [self.postScroll addSubview:self.linePostToComments];
    [self.postScroll setContentSize:CGSizeMake(self.view.frame.size.width,lastYPosition+20)];
}

-(void)reformatLike
{
    NSLog(@"%f",self.likeLabel.frame.size.width);
    [self.likeLabel sizeToFit];
    NSLog(@"%f",self.likeLabel.frame.size.width);
    CGRect frame = self.likeLabel.frame;
    frame.origin.x = self.view.frame.size.width-frame.size.width-5;
    self.likeLabel.frame = frame;
    frame = self.likeIcon.frame;
    frame.origin.x = self.likeLabel.frame.origin.x-frame.size.width-5;
    self.likeIcon.frame = frame;
}

-(NSMutableAttributedString *)formatedTextStatus
{
    NSString *aux = [[self.statusPost.owner.username stringByAppendingString:@": "] stringByAppendingString:self.statusPost.statusText];
    
    NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc]initWithString:aux];
    
    /* RANGES IN THE STRINGS */
    NSRange rgUserName = [aux rangeOfString:[aux componentsSeparatedByString:@":"][0]];//Range of the username
    rgUserName.length++;//Add +1 of the ":"
    NSRange rgAllText = [aux rangeOfString:aux];//All text range
    
    //The color of the all text and the font size
    [statusString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] range:rgAllText];
    //modifying the color of all text
    [statusString addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithRed:32/255 green:32/255 blue:32/255 alpha:1]
                         range:rgAllText];
    
    //the color of the user name will be in blue color, the range is the user name
    [statusString addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithRed:77.0f/255.0f green:205.0f/255.0f blue:242.0f/255.0f alpha:1]
                         range:rgUserName];
    
    return statusString;//Return the mutable atributted string
}

-(void)likeAction
{
    PFRelation *likes = [self.statusPost.referenceOfPFObject relationForKey:@"likes"];
    PFQuery  *queryLikes = [likes query];
    
    
    
    [queryLikes whereKey:@"objectId" equalTo:self.genSingleton.currentUser.objectId];
    
    [queryLikes getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error)
            [likes removeObject:object];
        else
            [likes addObject: self.genSingleton.currentUser.referenceOfPFObject];
        
        [self.statusPost.referenceOfPFObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if(succeeded)
                 [self reloadLike];
         }];
    }];
}

-(void)reloadLike
{
    [PFCloud callFunctionInBackground:@"getNumberOfLikes" withParameters:@{@"objectId":self.statusPost.objectId,@"objectClass":@"Status"} block:^(NSNumber *count, NSError *error)
     {
         if(!error)
         {
             if([count intValue] == 1)
                 [self.likeLabel setText:[[count stringValue] stringByAppendingString:@" Like"]];
             else
                 [self.likeLabel setText:[[count stringValue] stringByAppendingString:@" Likes"]];
             
             [self reformatLike];
         }
     }];
    
    //Check to know if the image have to be selected
    PFRelation *likes = [self.statusPost.referenceOfPFObject relationForKey:@"likes"];
    PFQuery  *queryLikes = [likes query];
    [queryLikes whereKey:@"objectId" equalTo:self.genSingleton.currentUser.objectId];
    [queryLikes getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
    {
        if(!error)
            [self.likeIcon setImage:[UIImage imageNamed:@"like-icon-setted"] forState:UIControlStateNormal];
        else
            [self.likeIcon setImage:[UIImage imageNamed:@"like-icon"] forState:UIControlStateNormal];
    }];
}

-(void)onPostClick:(UITapGestureRecognizer *)sender
{
    if ([self.sharedPlayer.player isPlaying])
        [self.sharedPlayer.player stop];
    
    UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:2];
    AlbumPlayerViewController *apvc = [[nav viewControllers] objectAtIndex:0];
    
    
    apvc.album = [[Album alloc] init];
    apvc.album.musics = [[NSMutableArray alloc] init];
    
    [apvc.album.musics addObject:self.statusPost.music];
    
    self.sharedPlayer = [SingletonPlayer sharedInstance];
    
    NSString *artworkUrl = ((Music *)[apvc.album.musics objectAtIndex:0]).imageUrl;
    if (artworkUrl != (NSString *)[NSNull null])
        [apvc.albumCover setImageWithURL:[NSURL URLWithString:artworkUrl]];
    else
        [apvc.albumCover setImage:[UIImage imageNamed:@"album-cover"]];
    
    
    [apvc.tableListMusics reloadData];
    [apvc loadInfosOfAlbum];
    
    if ([self.sharedPlayer.player isPlaying])
        [self.sharedPlayer.player stop];
    [apvc playMusicOfSearchAtIndex:0];
    apvc.sharedPlayer.typePlayer = @"player";
    apvc.sharedPlayer.currentController = apvc;
}


@end
