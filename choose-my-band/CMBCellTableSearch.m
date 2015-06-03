//
//  CMBCellTableSearch.m
//  choose-my-band
//
//  Created by Bruno Lima on 27/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "CMBCellTableSearch.h"

@implementation CMBCellTableSearch

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initElements];
    }
    
    return self;
}

-(void) initElements{
    
    
    //SETTING COVER
    CGRect frameOfCover = CGRectMake(5, 5, 80, 80);
    self.albumCover = [[UIImageView alloc] initWithFrame:frameOfCover];
    [self.albumCover.layer setCornerRadius:5];
    [self.albumCover setClipsToBounds:YES];
    [self.albumCover setContentMode:UIViewContentModeScaleAspectFill];
    
    //SETTING TITLE LABEL
    int widthLabelMusic = self.frame.size.width - (frameOfCover.origin.x + frameOfCover.size.width + 10);
    CGRect frameTitleMusic = CGRectMake(frameOfCover.origin.x + frameOfCover.size.width+5, 5, widthLabelMusic, 20);
    self.musicTitle = [[UITextView alloc] initWithFrame:frameTitleMusic];
    [self.musicTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]];
    //[self.musicTitle setFont:[UIFont systemFontOfSize:17.0]];
    //[self.musicTitle setBackgroundColor:[UIColor blackColor]];
    [self.musicTitle setScrollEnabled:NO];
    [self.musicTitle setEditable:NO];
    [self.musicTitle setSelectable:NO];
    self.musicTitle.textContainer.lineFragmentPadding = 0;//Removing the borders
    self.musicTitle.textContainerInset = UIEdgeInsetsZero;
    
    [self.musicTitle setTextColor:[UIColor colorWithRed:77.0f/255.0f green:205.0f/255.0f blue:242.0f/255.0f alpha:1]];
    [self.musicTitle setText:@"Music title"];
    
    //SETTING TITLE ALBUM
    frameTitleMusic.origin.y +=20;
    self.artistAlbumTitle = [[UILabel alloc] initWithFrame:frameTitleMusic];
    [self.artistAlbumTitle setFont:[UIFont systemFontOfSize:14.0]];
    [self.artistAlbumTitle setTextColor:[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1]];
    [self.artistAlbumTitle setText:@"Music band and album"];
    
    
    //ADDING IN THE CELL
    [self.contentView addSubview:self.albumCover];
    [self.contentView addSubview:self.musicTitle];
    [self.contentView addSubview:self.artistAlbumTitle];
}

@end
