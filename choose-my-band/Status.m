//
//  Status.m
//  choose-my-band
//
//  Created by BEPiD on 27/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "Status.h"

@implementation Status
- (id)initWithPFObject:(PFObject *)status
{
    self = [super init];
    if (self)
    {
        self.objectId = status.objectId;
        self.createdAt = status.createdAt;
        self.updateAt = status.updatedAt;
        self.statusText = status[@"statusText"];
        self.referenceOfPFObject = status;
    }
    return self;
}

- (id)initWithPFObject:(PFObject *)status andOwner:(User *)owner
{
    self = [self initWithPFObject:status];
    if (self)
    {
        self.music = [[Music alloc]initWithPFObject:status[@"music"]];
        self.owner = owner;
    }
    return self;
}

- (id)initWithPFObjectOnFeed:(PFObject *)status
{
    self = [self initWithPFObject:status];
    if (self)
    {
        self.music = [[Music alloc]initWithPFObject:status[@"music"]];
        self.owner = [[User alloc]initWithPFObject:status[@"owner"]];
    }
    return self;
}


@end
