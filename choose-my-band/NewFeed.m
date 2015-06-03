//
//  NewFeed.m
//  choose-my-band
//
//  Created by Alcivanio on 16/09/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "NewFeed.h"


@implementation NewFeed

- (id)initProfileImage:(NSString *)urlProfileImage andAlbumImage:(NSString *)urlAlbumImage userName:(NSString *)userName statusText:(NSString *)statusText frame:(CGRect)frame
{
    self = [super initWithFrame:frame];//default
    
    if (self)
    {
        //Init the parts of the content of the post
        _urlAlbumImage = urlAlbumImage;
        _urlProfileImage = urlProfileImage;
        _userName = userName;
        _statusText = statusText;
    }
    
    [self createObjectsOfView];
    return self;
}

- (id)initProfileImage:(NSString *)urlProfileImage andAlbumImage:(NSString *)urlAlbumImage userName:(NSString *)userName statusText:(NSString *)statusText frame:(CGRect)frame andStatus:(Status *)status
{
    self = [self initProfileImage:urlProfileImage andAlbumImage:urlAlbumImage userName:userName statusText:statusText frame:frame];
    if(self)
        self.statusReference = status;
    return self;
}



-(void)createObjectsOfView
{
    /* FEEDs ALBUM IMAGE */
    //Frame of the album status image
    CGRect frameStatusAlbumImage;
    frameStatusAlbumImage.origin.x = 5;
    frameStatusAlbumImage.origin.y = 5;
    frameStatusAlbumImage.size.width = 310;
    frameStatusAlbumImage.size.height = 190;
    
    //init image of the album
    self.albumImageView = [[UIImageView alloc]init];
    if (self.urlAlbumImage)
        [self.albumImageView setImageWithURL:[NSURL URLWithString:self.urlAlbumImage]];
    else
        [self.albumImageView setImage:[UIImage imageNamed:@"album-cover"]];
    [self.albumImageView setFrame:frameStatusAlbumImage];
    [self.albumImageView setContentMode:UIViewContentModeScaleAspectFill];//no images stretching
    [self.albumImageView setBackgroundColor:[UIColor grayColor]];
    
    //border radius of the image
    [self.albumImageView.layer setCornerRadius:5];
    [self.albumImageView setClipsToBounds:YES];
    
    
    /* PROFILE PICTURE ALBUM IMAGE */
    //Frame used in the all view
    CGRect frameProfilePicture;
    frameProfilePicture.origin.x = frameStatusAlbumImage.origin.x;
    frameProfilePicture.origin.y = frameStatusAlbumImage.size.height + 10;
    frameProfilePicture.size.width = 50;
    frameProfilePicture.size.height = 50;
    
    //init profile picture
    self.profilePictureView = [[UIImageView alloc]init];
    [self.profilePictureView setImageWithURL:[NSURL URLWithString:self.urlProfileImage]];
    [self.profilePictureView setFrame:frameProfilePicture];
    
    //border radius of the image
    [self.profilePictureView.layer setCornerRadius:5];
    [self.profilePictureView setClipsToBounds:YES];
    
    /* TEXT STATUS*/
    CGRect frameStatusText;
    frameStatusText.origin.x = frameProfilePicture.origin.x + frameProfilePicture.size.width + 5;
    frameStatusText.origin.y = frameProfilePicture.origin.y;
    frameStatusText.size.width = 256;
    frameStatusText.size.height = 133;
    
    self.statusTextView = [[UITextView alloc]initWithFrame:frameStatusText];
    [self.statusTextView setAttributedText:[self formatedTextStatus]];
    [self.statusTextView setEditable:NO];
    [self.statusTextView setSelectable:NO];
    [self.statusTextView setScrollEnabled:NO];
    
    //Styles of the text status
    self.statusTextView.textContainer.lineFragmentPadding = 0;//Removing the borders
    self.statusTextView.textContainerInset = UIEdgeInsetsZero;
    
    //[statusTextView setTextColor:[UIColor colorWithRed:1 green:0.6 blue:1 alpha:1]];
    //[statusTextView setFont:[UIFont fontWithName:@"ArialMT" size:14]];
    
    UITapGestureRecognizer *doubleTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playMusicInPost)];
    [doubleTouch setNumberOfTapsRequired:2];
    [doubleTouch setDelegate:self];
    [self addGestureRecognizer:doubleTouch];
    [self setUserInteractionEnabled:YES];
    
    //Adicionando todas as sub-views
    [self addSubview:self.albumImageView];//The album image
    [self addSubview:self.profilePictureView];
    [self addSubview:self.statusTextView];
    
    [self remontFrameNewFeed];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 2) {
        [self playMusicInPost];
    }
}

-(void)remontFrameNewFeed
{
    //Remonting the text view of status
    CGFloat fixedWidth = self.statusTextView.frame.size.width;
    CGSize sizeFits = [self.statusTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.statusTextView.frame;
    newFrame.size = CGSizeMake(fmaxf(sizeFits.width, fixedWidth), sizeFits.height);
    self.statusTextView.frame = newFrame;
    
    //Last size of the text and image
    float lastYTextStatus = self.statusTextView.frame.origin.y + self.statusTextView.frame.size.height;
    float lastYPictureImage = self.profilePictureView.frame.origin.y + self.profilePictureView.frame.size.height;
    float usedYToLine = lastYTextStatus+20;
    
    //Adding the last line
    if(lastYTextStatus < lastYPictureImage)
        usedYToLine = lastYPictureImage+20;
    
    CGRect frameLastLine = CGRectMake(self.profilePictureView.frame.size.width + self.profilePictureView.frame.origin.x, usedYToLine, self.frame.size.width, 1);
    UIView *line = [[UIView alloc]initWithFrame:frameLastLine];
    [line setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
    [self addSubview:line];
    
    newFrame = self.frame;
    newFrame.size.height = self.albumImageView.frame.origin.y + usedYToLine + 20;
    self.frame = newFrame;
}

-(NSMutableAttributedString *)formatedTextStatus
{
    //self.statusText = [[self.userName stringByAppendingString:@": "] stringByAppendingString:self.statusText];
    NSString *strStatus = [[self.userName stringByAppendingString:@": "] stringByAppendingString:self.statusText];
    NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc]initWithString:strStatus];
    

    NSRange rgUserName = [strStatus rangeOfString:[strStatus componentsSeparatedByString:@":"][0]];//Range of the username
    rgUserName.length++;//Add +1 of the ":"
    NSRange rgAllText = [strStatus rangeOfString:strStatus];//All text range
    
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


-(void)playMusicInPost
{
    if ([self.sharedPlayer.player isPlaying])
        [self.sharedPlayer.player stop];
    
    
    AlbumPlayerViewController *apvc = [self.tabBarReference.viewControllers objectAtIndex:2];
    
    
    apvc.album = [[Album alloc] init];
    apvc.album.musics = [[NSMutableArray alloc] init];
    
    [apvc.album.musics addObject:self.statusReference.music];
    
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
















