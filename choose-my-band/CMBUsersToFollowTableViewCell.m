//
//  UsersToFollowTableViewCell.m
//  Choose My Band
//
//  Created by Bruno Lima on 08/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "CMBUsersToFollowTableViewCell.h"

@implementation CMBUsersToFollowTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initCell
{
    CGRect frameOfPicture = CGRectMake(5, 10, 80, 80);
    self.profilePicture = [[UIImageView alloc] initWithFrame:frameOfPicture];
    [self.profilePicture.layer setCornerRadius:5];
    [self.profilePicture setClipsToBounds:YES];
    [self.profilePicture setContentMode:UIViewContentModeScaleAspectFill];
    
    self.selectedImage = [[UIImageView alloc]initWithFrame:frameOfPicture];
    [self.selectedImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.selectedImage.layer setCornerRadius:5];
    [self.selectedImage setClipsToBounds:YES];
    [self.selectedImage setImage:[UIImage imageNamed:@"selected-image"]];
    [self.selectedImage setHidden:YES];
    
    int xOfLabelName = frameOfPicture.origin.x+frameOfPicture.size.width+5;
    CGRect frameName = CGRectMake(xOfLabelName, frameOfPicture.origin.y+2, self.frame.size.width-xOfLabelName, 20);
    self.userName = [[UILabel alloc] initWithFrame:frameName];
    [self.userName setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.0]];
    [self.userName setTextColor:[UIColor colorWithRed:77/255.f green:205/255.f blue:251/255.f alpha:1]];
    [self.userName setText:@"Cabrito Rocha"];
    
    frameName.origin.y = frameName.origin.y+3;
    frameName.size.height = 50;
    frameName.size.width = self.frame.size.width - frameName.origin.x-5;
    self.userBio = [[UILabel alloc] initWithFrame:frameName];
    [self.userBio setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
    [self.userBio setTextColor:[UIColor colorWithRed:101/255.f green:101/255.f blue:101/255.f alpha:1]];
    [self.userBio setText:@"An David Guetta fake bio image"];
    [self.userBio setNumberOfLines:4];
    
    CGRect frameLine = CGRectMake(0, 101, self.frame.size.width, 1);
    UIView *line = [[UIView alloc]initWithFrame:frameLine];
    [line setBackgroundColor:[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1]];
    
    [self.contentView addSubview:self.profilePicture];
    [self.contentView addSubview:self.selectedImage];
    [self.contentView addSubview:self.userName];
    [self.contentView addSubview:self.userBio];
    [self.contentView addSubview:line];
}

@end
