//
//  SCDrawing.m
//  SoundCloudUI
//
//  Created by r/o/b on 12/20/12.
//  Copyright (c) 2012 SoundCloud. All rights reserved.
//

#import "SCDrawing.h"

@implementation SCDrawing

void drawLine(CGContextRef context,
              CGPoint startPoint,
              CGPoint endPoint,
              CGColorRef color,
              CGFloat width)
{

    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, width);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
