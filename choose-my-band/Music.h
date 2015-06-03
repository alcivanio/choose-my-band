//
//  Music.h
//  choose-my-band
//
//  Created by BEPiD on 27/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Music : NSObject

@property (nonatomic) NSString *objectId;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSDate *updateAt;
@property (nonatomic) NSString *category;
@property (nonatomic) NSString *imageUrl;
@property (nonatomic) NSString *streamUrl;
@property (nonatomic) NSString *title;
@property (nonatomic) NSNumber *duration;
@property (nonatomic) PFObject *referenceOfPFObject;


- (id)initWithPFObject:(PFObject *)music;

@end
