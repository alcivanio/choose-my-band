//
//  InitViewController.h
//  choose-my-band
//
//  Created by Alcivanio on 30/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUI.h"
#import "CMBBottomBar.h"
#import "SignUpViewController.h"
#import "GeneralSingleton.h"
#import "DataSaveClass.h"

@interface InitViewController : UIViewController<NSXMLParserDelegate>

@property (nonatomic) UIButton *loginSC;

@property (nonatomic) NSMutableArray *infoMusic;
@property (nonatomic) NSString *element;
@property (nonatomic) NSNumber *item;
@property (nonatomic) NSMutableArray *tracks;
@property (nonatomic) BOOL added;
@property (nonatomic) CMBBottomBar *bottomBar;
@property (nonatomic) NSMutableArray *viewControllers;
@property (nonatomic) GeneralSingleton *genSingleton;

@end
