//
//  ShareContentViewController.h
//  Choose My Band
//
//  Created by Alcivanio on 10/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "CMBTopBar.h"
#import "CMBBottomBar.h"
#import "Music.h"
#import "GeneralSingleton.h"

@interface ShareContentViewController : UIViewController<UITextViewDelegate>
//Default
@property (nonatomic) GeneralSingleton *genSingleton;
@property (nonatomic) CMBTopBar *topBar;
@property (nonatomic) CMBBottomBar *bottomBar;
@property (nonatomic) Music *musicToShare;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (nonatomic) UIImageView *albumCover;
@property (nonatomic) UITextView *statusText;
@property (nonatomic) UILabel *countTextStatus;
@property (nonatomic) UIButton *facebookShare;
@property (nonatomic) UIButton *postButton;
@property (nonatomic) BOOL shareFB;


@end
