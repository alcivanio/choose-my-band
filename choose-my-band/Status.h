//
//  Status.h
//  choose-my-band
//
//  Created by BEPiD on 27/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"
#import "User.h"
#import "Music.h"
#import <Parse/Parse.h>

@interface Status : NSObject

@property (nonatomic) NSString *objectId;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSDate *updateAt;
@property (nonatomic) NSMutableArray *comments;
@property (nonatomic) NSMutableArray *likes;
@property (nonatomic) Music *music;
@property (nonatomic) User *owner;
@property (nonatomic) NSString *statusText;
@property (nonatomic) PFObject *referenceOfPFObject;

- (id)initWithPFObject:(PFObject *)status;
- (id)initWithPFObject:(PFObject *)status andOwner:(User *)owner;
- (id)initWithPFObjectOnFeed:(PFObject *)status;

@end
