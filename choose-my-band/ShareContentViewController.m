//
//  ShareContentViewController.m
//  Choose My Band
//
//  Created by Alcivanio on 10/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "ShareContentViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ShareContentViewController ()

@end

@implementation ShareContentViewController

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
    [self startConfigurations];
    [self initElements];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startConfigurations
{
    self.genSingleton = [GeneralSingleton sharedInstance];
    self.topBar = [[CMBTopBar alloc]initWithNavigationController:self.navigationController];
    [self.view addSubview:self.topBar];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)initElements
{
    //The album cover
    CGRect frameCover = CGRectMake(5, 10, self.view.frame.size.width-10, 0);
    frameCover.size.height = frameCover.size.width;
    self.albumCover = [[UIImageView alloc]initWithFrame:frameCover];
    if(self.musicToShare.imageUrl)
        [self.albumCover setImageWithURL:[NSURL URLWithString:self.musicToShare.imageUrl]];
    else
        [self.albumCover setImage:[UIImage imageNamed:@"album-cover"]];
    
    //Status text - user enter
    self.statusText = [[UITextView alloc]initWithFrame:CGRectMake(5, frameCover.size.height + frameCover.origin.y + 5, self.view.frame.size.width-10, 100)];
    [self.statusText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [self.statusText setText:@"Digite aqui o seu status"];
    [self.statusText setTextColor:[UIColor colorWithRed:32/255.0f green:32/255.0f blue:32/255.0f alpha:1]];
    [self.statusText setDelegate:self];
    
    //divisor line
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.statusText.frame.origin.y+self.statusText.frame.size.height+5, self.view.frame.size.width, 1)];
    [line setBackgroundColor:[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1]];
    
    //label with status text count
    self.countTextStatus = [[UILabel alloc]initWithFrame:CGRectMake(5, line.frame.origin.y+11, 100, 30)];
    [self.countTextStatus setText:@"200"];
    [self.countTextStatus setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30]];
    [self.countTextStatus setTextColor:[UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:1]];
    
    //Is better to make the lastbutton first, for we know the x position of facebook
    CGRect frameBTPost = CGRectMake(self.view.frame.size.width-75, line.frame.origin.y+11, 70, 30);
    self.postButton = [[UIButton alloc]initWithFrame:frameBTPost];
    [self.postButton setBackgroundColor:[UIColor colorWithRed:77.0f/255.0f green:205.0f/255.0f blue:242.0f/255.0f alpha:1]];
    [self.postButton.layer setCornerRadius:self.postButton.frame.size.height/2];
    [self.postButton setClipsToBounds:YES];
    [self.postButton setTitle:@"Post" forState:UIControlStateNormal];
    [self.postButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    
    [self.postButton addTarget:self action:@selector(sharePost) forControlEvents:UIControlEventTouchUpInside];
    
    self.facebookShare = [[UIButton alloc]initWithFrame:CGRectMake(frameBTPost.origin.x-50, frameBTPost.origin.y, 30, 30)];
    [self.facebookShare setImage:[UIImage imageNamed:@"fb-share"] forState:UIControlStateNormal];
    [self.facebookShare addTarget:self action:@selector(alterateShareFB) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scroll addSubview:self.albumCover];
    [self.scroll addSubview:self.statusText];
    [self.scroll addSubview:line];
    [self.scroll addSubview:self.countTextStatus];
    [self.scroll addSubview:self.facebookShare];
    [self.scroll addSubview:self.postButton];
}

-(void)sharePost
{
    //Object new post
    PFObject *post = [PFObject objectWithClassName:@"Status"];
    post[@"statusText"] = [self.statusText text];
    post[@"music"] = self.musicToShare.referenceOfPFObject;
    post[@"owner"] = self.genSingleton.currentUser.referenceOfPFObject;
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if(succeeded)
        {
            //The relation to add the object
            PFRelation *relation = [self.genSingleton.currentUser.referenceOfPFObject relationForKey:@"status"];
            [relation addObject:post];
            [self.genSingleton.currentUser.referenceOfPFObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 [self.navigationController popViewControllerAnimated:YES];
                 
                 if (self.shareFB)
                     [self sharePostInFacebook];

             }];
        }
    }];
}

-(void) alterateShareFB
{
    if (!self.shareFB)
        self.shareFB = YES;

    else
        self.shareFB = NO;
}

-(void) sharePostInFacebook
{
    NSString *picture;
    
    if (!self.musicToShare.imageUrl) {
        picture = @"https://scontent-a-gru.xx.fbcdn.net/hphotos-xpa1/v/t1.0-9/10934013_865410226842967_1797907199963228140_n.jpg?oh=b5e002d0eed0fc2ae0f53d599ffd9d49&oe=55300059";
    }
    else
        picture = self.musicToShare.imageUrl;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.musicToShare.title, @"name",
                                   @"Choose My Band", @"caption",
                                   self.statusText.text, @"description",
                                   @"https://choosemyband.com", @"link",
                                   picture, @"picture",
                                   nil];
    
    // Make the request
    [FBRequestConnection startWithGraphPath:@"/me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Link posted successfully to Facebook
                                  NSLog(@"result: %@", result);
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                                  NSLog(@"%@", error.description);
                              }
                          }];
}


#pragma mark textview count
-(void)textViewDidChange:(UITextView *)textView
{
    int maxLength = 200;
    int textLength = textView.text.length;
    [self.countTextStatus setText:[NSString stringWithFormat:@"%d", maxLength-textLength]];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //if the user is erasing the text
    if(range.length == 1)
        return YES;
    
    //the lengths
    int maxLength = 200;
    
    //if the user type the max of text
    if(textView.text.length >= maxLength)
        return NO;
    
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
     
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    [self.statusText setText:@""];
    
    CGRect frameScroll = self.scroll.frame;
    frameScroll.origin.y -=200;
    [self.scroll setFrame:frameScroll];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect frameScroll = self.scroll.frame;
    frameScroll.origin.y +=200;
    [self.scroll setFrame:frameScroll];
}



@end






