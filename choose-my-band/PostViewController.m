//
//  PostViewController.m
//  Choose My Band
//
//  Created by Bruno Lima on 08/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()

@end

@implementation PostViewController

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
    [self initElementsOfScreen];
    // Do any additional setup after loading the view.
}


-(void)initElementsOfScreen
{
    CGRect frameImage = CGRectMake(5, 10, self.view.frame.size.width-10, self.view.frame.size.width-10);
    self.pictureOfMusic = [[UIImageView alloc] initWithFrame:frameImage];
    [self.pictureOfMusic.layer setCornerRadius:5];
    [self.pictureOfMusic setClipsToBounds:YES];
    [self.pictureOfMusic setImage:[UIImage imageNamed:@"beyonce"]];
    
    frameImage.origin.y += frameImage.size.height + 5;
    frameImage.size.height = 70;
    self.text = [[UITextView alloc] initWithFrame:frameImage];
    [self.text setBackgroundColor:[UIColor grayColor]];
    [self.text setDelegate:self];
    
    CGRect frameLine = CGRectMake(0, frameImage.origin.y+frameImage.size.height + 5, self.view.frame.size.width, 1);
    UIView *line = [[UIView alloc]initWithFrame:frameLine];
    [line setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
    
    CGRect frameLimitCarac = CGRectMake(5, frameLine.origin.y+1+10, 55, 25);
    self.limitCarac = [[UILabel alloc] initWithFrame:frameLimitCarac];
    [self.limitCarac setTextColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
    [self.limitCarac setText:@"200"];
    [self.limitCarac setFont:[UIFont systemFontOfSize:27.0]];
    
    self.postButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.postButton addTarget:self action:@selector(postStatus) forControlEvents:UIControlEventTouchUpInside];
    [self.postButton setTitle:@"Post" forState:UIControlStateNormal];
    [self.postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.postButton setBackgroundColor:[UIColor colorWithRed:77/255.f green:205/255.f blue:251/255.f alpha:1]];
    self.postButton.layer.cornerRadius = 20;
    self.postButton.layer.masksToBounds=YES;
    self.postButton.frame = CGRectMake(self.view.frame.size.width-70, frameLine.origin.y+frameLine.size.height+5, 65, 40);
    [self.postButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    self.shareFacebook = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.shareFacebook addTarget:self action:@selector(postStatus) forControlEvents:UIControlEventTouchUpInside];
    [self.shareFacebook setTitle:@"f" forState:UIControlStateNormal];
    [self.shareFacebook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.shareFacebook setBackgroundColor:[UIColor colorWithRed:77/255.f green:205/255.f blue:251/255.f alpha:1]];
    self.shareFacebook.layer.cornerRadius = 5;
    self.shareFacebook.layer.masksToBounds=YES;
    self.shareFacebook.frame = CGRectMake(self.postButton.frame.origin.x-50, frameLine.origin.y+frameLine.size.height+10, 30, 30);
    [self.shareFacebook.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    [self.postScroll addSubview:self.pictureOfMusic];
    [self.postScroll addSubview:self.text];
    [self.postScroll addSubview:line];
    [self.postScroll addSubview:self.limitCarac];
    [self.postScroll addSubview:self.postButton];
    [self.postScroll addSubview:self.shareFacebook];
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)postStatus
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
