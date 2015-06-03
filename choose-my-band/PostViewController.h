//
//  PostViewController.h
//  Choose My Band
//
//  Created by Bruno Lima on 08/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *postScroll;
@property (nonatomic) UIImageView *pictureOfMusic;
@property (nonatomic) UITextView *text;
@property (nonatomic) UILabel *limitCarac;
@property (nonatomic) UIButton *shareFacebook;
@property (nonatomic) UIButton *postButton;

@end
