//
//  Comment.h
//  choose-my-band
//
//  Created by BEPiD on 27/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Comment : NSObject

@property (nonatomic) NSString *objectId;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSDate *updateAt;
@property (nonatomic) NSString *content;
@property (nonatomic) User *owner;
@property (nonatomic) NSMutableArray *likes;


@end
