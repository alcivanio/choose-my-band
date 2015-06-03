//
//  DataSaveClass.h
//  Choose My Band
//
//  Created by Alcivanio on 1/15/15.
//  Copyright (c) 2015 Siara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface DataSaveClass : NSObject<NSCoding>

/* The properties to save */
@property(nonatomic) NSString *userID;//Here is the id of SoundCloud.com
@property(nonatomic) NSString *scID;//SoundCloud ID, to user configurations

@end
