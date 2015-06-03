//
//  SearchViewController.h
//  choose-my-band
//
//  Created by Bruno Lima on 27/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBBottomBar.h"
#import "CMBTopBar.h"
#import "CMBCellTableSearch.h"
#import "SCUI.h"
#import "UIImageView+AFNetworking.h"
#import "AlbumPlayerViewController.h"
#import "SingletonPlayer.h"

@interface SearchViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property(nonatomic)UIImageView *albumCover;
@property (nonatomic) CMBTopBar *topBar;
@property (nonatomic) CMBBottomBar *bottomBar;
@property (nonatomic) NSInteger pointOfScrollY;
@property (nonatomic) NSInteger contentOffSetOnScroll;//to know if the bottom bar have to be hidden
@property (weak, nonatomic) IBOutlet UIScrollView *searchScroll;
@property (nonatomic) UITableView *musicResultsOfSearch;
@property (nonatomic) UITableView *usuariosResultsOfSearch;
@property (nonatomic) UITextField *searchTextField;
@property (nonatomic) UIButton *searchButton;

@property (nonatomic) NSMutableArray *resultsOfSearch;

@property (nonatomic) NSString *lastSearch;
@property (nonatomic) SingletonPlayer *sharedPlayer;
@property (nonatomic) NSMutableArray *viewControllers;

//new properties

@property (nonatomic) UISegmentedControl *searchSegmented;
@property (nonatomic) UIScrollView *scroll;

-(IBAction)goSearch:(UIButton *)sender;


@end
