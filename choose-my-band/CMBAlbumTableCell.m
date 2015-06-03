//
//  CMBAlbumTableCell.m
//  choose-my-band
//
//  Created by Alcivanio on 03/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "CMBAlbumTableCell.h"

@implementation CMBAlbumTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initElements];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initElements
{
    //Adding element circle
    CGRect frameCircle = CGRectMake(5, 10, 40, 40);
    self.circleSelected = [[UIButton alloc]initWithFrame:frameCircle];
    [self.circleSelected setBackgroundColor:[UIColor colorWithRed:238/255.f green:238/255.f blue:238/255.f alpha:1]];
    [self.circleSelected.layer setCornerRadius:20];
    [self.circleSelected setClipsToBounds:YES];
    
    
    //The title of the music
    CGRect frameTitleMusic = CGRectMake(frameCircle.origin.x + frameCircle.size.width + 10, 13, self.contentView.frame.size.width - (frameCircle.origin.x + frameCircle.size.width + 15), 20);
    self.titleMusic = [[UILabel alloc]initWithFrame:frameTitleMusic];
    [self.titleMusic setTextColor:[UIColor colorWithRed:77/255.f green:205/255.f blue:251/255.f alpha:1]];
    [self.titleMusic setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
    
    CGRect frameLine = CGRectMake(0, 60, self.frame.size.width, 1);
    UIView *line = [[UIView alloc]initWithFrame:frameLine];
    [line setBackgroundColor:[UIColor colorWithRed:238/255.f green:238/255.f blue:238/255.f alpha:1]];
    
    [self.contentView addSubview:self.circleSelected];
    [self.contentView addSubview:self.titleMusic];
    [self.contentView addSubview:line];
    
    
    
    
    
    
}

@end









