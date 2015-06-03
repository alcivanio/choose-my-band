//
//  CMBCellTableSearch.h
//  choose-my-band
//
//  Created by Bruno Lima on 27/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMBCellTableSearch : UITableViewCell

@property (nonatomic) UIImageView *albumCover;
@property (nonatomic) UITextView *musicTitle;
@property (nonatomic) UILabel *artistAlbumTitle;

-(void) initElements;


@end
