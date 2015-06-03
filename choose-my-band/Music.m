//
//  Music.m
//  choose-my-band
//
//  Created by BEPiD on 27/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "Music.h"

@implementation Music

- (id)initWithPFObject:(PFObject *)music
{
    self = [super init];
    if (self)
    {
        self.objectId = music.objectId;
        self.createdAt = music.createdAt;
        self.updateAt = music.updatedAt;
        self.category = music[@"category"];
        self.imageUrl = music[@"imageUrl"];
        self.streamUrl = music[@"streamUrl"];
        self.title = music[@"title"];
        self.duration = music[@"duration"];
        self.referenceOfPFObject = music;
    }
    return self;
}

@end
