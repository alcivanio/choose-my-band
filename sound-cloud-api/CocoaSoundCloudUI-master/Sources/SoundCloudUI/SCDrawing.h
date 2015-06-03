//
//  SCDrawing.h
//  SoundCloudUI
//
//  Created by r/o/b on 12/20/12.
//  Copyright (c) 2012 SoundCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDrawing : NSObject

void drawLine(CGContextRef context,
              CGPoint startPoint,
              CGPoint endPoint,
              CGColorRef color,
              CGFloat width);

@end
