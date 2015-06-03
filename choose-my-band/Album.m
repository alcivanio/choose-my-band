//
//  Album.m
//  choose-my-band
//
//  Created by BEPiD on 27/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "Album.h"
#import "User.h"

@implementation Album

//@property (nonatomic) NSString *objectId;
//@property (nonatomic) NSDate *createdAt;
//@property (nonatomic) NSDate *updateAt;
//@property (nonatomic) NSString *albumType;
//@property (nonatomic) NSString *coverUrl;
//@property (nonatomic) NSMutableArray *musics;
//@property (nonatomic) NSString *title;

- (id)initWithPFObject:(PFObject *)pfObj
{
    self = [super init];
    if (self)
    {
        self.objectId = pfObj.objectId;
        self.createdAt = pfObj.createdAt;
        self.updateAt = pfObj.updatedAt;
        self.albumType = pfObj[@"albumType"];
        self.coverUrl = pfObj[@"coverUrl"];
        self.title = pfObj[@"title"];
        self.duration = pfObj[@"duration"];
        self.pfObjectReference = pfObj;
    }
    return self;
}

@end
