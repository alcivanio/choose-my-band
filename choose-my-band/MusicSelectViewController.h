//
//  MusicSelectViewController.h
//  Choose-My-Band
//
//  Created by bepid on 10/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "Music.h"
#import "SCUI.h"


@interface MusicSelectViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView *table;
@property (nonatomic) UIButton *buttonDone;

@property (nonatomic) NSMutableArray *selectedMusics;
@property (nonatomic) NSMutableDictionary *scMusics;

//http://ios-blog.co.uk/tutorials/check-if-active-internet-connection-exists-on-ios-device/

-(NSArray *) ordenaMusicasWithArray:(NSMutableArray *)array;
@end
