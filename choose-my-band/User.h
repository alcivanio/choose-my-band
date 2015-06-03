//
//  User.h
//  choose-my-band
//
//  Created by BEPiD on 27/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"
#import <Parse/Parse.h>

@interface User : NSObject

@property (nonatomic) NSString *objectId;
@property (nonatomic) NSString *scId;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSDate *updateAt;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *bio;
@property (nonatomic) NSString *email;
@property (nonatomic) BOOL emailVerified;
@property (nonatomic) NSMutableArray *albuns;
@property (nonatomic) NSMutableArray *followers;
@property (nonatomic) NSMutableArray *statusList;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *profilePictureUrl;
@property (nonatomic) NSString *profileCoverUrl;
@property (nonatomic) PFObject *referenceOfPFObject;



- (id)initWithPFObject:(PFObject *)pfObj;


@end
