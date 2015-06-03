//
//  SCGradientButton.h
//  SoundCloudUI
//
//  Created by r/o/b on 12/18/12.
//  Copyright (c) 2012 SoundCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SCGradientButton : UIButton

@property (nonatomic, strong) NSArray *colors;

- (id)initWithFrame:(CGRect)frame colors:(NSArray *)colors;

@end
