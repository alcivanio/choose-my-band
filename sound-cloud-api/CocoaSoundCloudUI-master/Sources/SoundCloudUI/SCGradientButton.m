//
//  SCGradientButton.m
//  SoundCloudUI
//
//  Created by r/o/b on 12/18/12.
//  Copyright (c) 2012 SoundCloud. All rights reserved.
//

#import "SCGradientButton.h"
#import "SCConstants.h"

@implementation SCGradientButton

#pragma mark Class Methods

+ (Class)layerClass;
{
	return [CAGradientLayer class];
}

#pragma mark Accessors

@synthesize colors;

- (void)setColors:(NSArray *)value
{
	if (value == colors) {
		return;
	}

    colors = value;

	NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
	for (UIColor *color in colors) {
		[cgColors addObject:(id)color.CGColor];
	}
	CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
	[gradientLayer setColors:cgColors];
	gradientLayer.startPoint = CGPointMake(0.5, 0.0);
	gradientLayer.endPoint = CGPointMake(0.5, 1.0);

	NSInteger numberOfColors = gradientLayer.colors.count;
	if (numberOfColors > 1) {
		NSMutableArray *locations = [NSMutableArray arrayWithCapacity:numberOfColors];
		for (NSInteger locationIndex = 0; locationIndex < numberOfColors; locationIndex++) {
			CGFloat location = (1.0f / (numberOfColors - 1)) * locationIndex;
			[locations addObject:[NSNumber numberWithFloat:location]];
		}
		gradientLayer.locations = locations;
	}

	[self setNeedsDisplay];
}

#pragma mark Lifecycle

- (id)initWithFrame:(CGRect)frame colors:(NSArray *)theColors
{
    self = [super initWithFrame:frame];
	if (self) {
		self.colors = theColors;
        self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = kSCBorderRadius;
    }
	return self;
}

- (void)setSelected:(BOOL)selected;
{
    [super setSelected:selected];
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.alpha = highlighted ?:0.6;
    [self setNeedsDisplay];
}

@end
