//
//  User.m
//  choose-my-band
//
//  Created by BEPiD on 27/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "User.h"
#import <Parse/Parse.h>

@implementation User
//
//@property (nonatomic) NSString *objectId;
//@property (nonatomic) NSDate *createdAt;
//@property (nonatomic) NSString *scId;
//@property (nonatomic) NSDate *updateAt;
//@property (nonatomic) NSString *username;
//@property (nonatomic) NSString *email;
//@property (nonatomic) BOOL emailVerified;
//@property (nonatomic) NSMutableArray *albuns;
//@property (nonatomic) NSMutableArray *followers;
//@property (nonatomic) NSString *name;
//@property (nonatomic) NSString *profilePictureUrl;
//@property (nonatomic) NSString *profileCoverUrl;

- (id)initWithPFObject:(PFObject *)pfObj
{
    self = [super init];
    if (self)
    {
        self.objectId = pfObj.objectId;
        self.updateAt = pfObj.updatedAt;
        self.createdAt = pfObj.createdAt;
        self.profilePictureUrl = pfObj[@"profilePictureUrl"];
        self.profileCoverUrl = pfObj[@"profileCoverUrl"];
        self.bio = pfObj[@"bio"];
        self.username = pfObj[@"username"];
        self.name = pfObj[@"name"];
        self.email = pfObj[@"email"];
        self.scId = pfObj[@"scId"];
        self.referenceOfPFObject = pfObj;
        self.followers = [[NSMutableArray alloc]init];
        self.albuns = [[NSMutableArray alloc]init];
        self.statusList = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
