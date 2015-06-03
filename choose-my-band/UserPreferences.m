//
//  UserPreferences.m
//  Choose My Band
//
//  Created by Jose Lucas Souza das Chagas on 16/01/15.
//  Copyright (c) 2015 Siara. All rights reserved.
//

#import "UserPreferences.h"

@implementation UserPreferences


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if(!self)
        return nil;
    
    /* The properties of the object */
    self.isAutoShare = [aDecoder decodeBoolForKey:@"isAutoShare"];
    self.enableNotification = [aDecoder decodeBoolForKey:@"enableNotification"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.isAutoShare forKey:@"isAutoShare"];
    [aCoder encodeBool:self.enableNotification forKey:@"enableNotification"];
}
@end
