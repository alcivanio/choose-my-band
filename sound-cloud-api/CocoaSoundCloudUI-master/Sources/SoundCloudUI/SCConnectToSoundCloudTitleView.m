/*
 * Copyright 2010, 2011 nxtbgthng for SoundCloud Ltd.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 *
 * For more information and documentation refer to
 * http://soundcloud.com/api
 * 
 */

#import "SCBundle.h"

#import "SCConnectToSoundCloudTitleView.h"
#import "SCGradientButton.h"
#import "SCLoginViewController.h"

@implementation SCConnectToSoundCloudTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.55;
        self.layer.shadowOffset = CGSizeMake(0, 0);

        // Cancel Button
        SCGradientButton *cancelButton = [[SCGradientButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 80.0,
                                                                                            6.0,
                                                                                            72.0,
                                                                                            32.0)
                                                                          colors:nil];
        cancelButton.backgroundColor = [UIColor colorWithPatternImage:[SCBundle imageWithName:@"cancel"]];
        cancelButton.layer.borderColor = [UIColor blackColor].CGColor;
        [cancelButton setTitle:SCLocalizedString(@"cancel", @"Cancel")
                      forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        cancelButton.titleLabel.textColor = [UIColor colorWithRed:0.8
                                                            green:0.8
                                                             blue:0.8
                                                            alpha:1.0];
        [cancelButton setTitleShadowColor:[UIColor blackColor]
                                 forState:UIControlStateNormal];
        cancelButton.titleLabel.shadowOffset = CGSizeMake(0, -1.0);
        [cancelButton addTarget:(SCLoginViewController *)self.superview
                         action:@selector(cancel)
               forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        [cancelButton release];
        
        // The Cloud
        UIImageView *cloudImageView = [[UIImageView alloc] init];
        cloudImageView.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin);
        cloudImageView.image = [SCBundle imageWithName:@"orange_header_logo"];
        [cloudImageView sizeToFit];
        cloudImageView.frame = CGRectMake(0,
                                          -0.6,
                                          CGRectGetWidth(cloudImageView.frame),
                                          CGRectGetHeight(cloudImageView.frame));
        [self addSubview:cloudImageView];
        [cloudImageView release];

    }
    return self;
}

- (void)drawRect:(CGRect)rect;
{
    CGRect topLineRect;
    CGRect gradientRect;
    CGRect bottomLineRect;
    CGRectDivide(self.bounds, &topLineRect, &gradientRect, 0.0, CGRectMinYEdge);
    CGRectDivide(gradientRect, &bottomLineRect, &gradientRect, 1.0, CGRectMaxYEdge);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                                 (CGFloat[]){0.22, 0.22, 0.22, 1.0,  0.137, 0.137, 0.137, 1.0},
                                                                 (CGFloat[]){0, 1.0},
                                                                 2);
    CGContextDrawLinearGradient(context, gradient, gradientRect.origin, CGPointMake(gradientRect.origin.x, CGRectGetMaxY(gradientRect)), 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    CGContextSetFillColor(context, (CGFloat[]){0, 0, 0, 1.0});
    CGContextFillRect(context, topLineRect);
}

@end
