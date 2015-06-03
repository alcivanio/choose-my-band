//
//  UserPreferences.h
//  Choose My Band
//
//  Created by Jose Lucas Souza das Chagas on 16/01/15.
//  Copyright (c) 2015 Siara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPreferences : NSObject <NSCoding>


//variable for logged user preferences 
@property(nonatomic) BOOL isAutoShare;
@property(nonatomic) BOOL enableNotification;
@end
