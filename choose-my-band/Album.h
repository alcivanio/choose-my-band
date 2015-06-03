//
//  Album.h
//  choose-my-band
//
//  Created by BEPiD on 27/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Music.h"
#import <Parse/Parse.h>
@class User;

@interface Album : NSObject

@property (nonatomic) NSString *objectId;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSDate *updateAt;
@property (nonatomic) NSString *albumType;
@property (nonatomic) NSString *coverUrl;
@property (nonatomic) NSMutableArray *musics;
@property (nonatomic) NSString *title;
@property (nonatomic) User *owner;
@property (nonatomic) PFObject *pfObjectReference;
@property (nonatomic) NSNumber *duration;
- (id)initWithPFObject:pfObj;


@end
