//
//  DataSaveClass.m
//  Choose My Band
//
//  Created by Alcivanio on 1/15/15.
//  Copyright (c) 2015 Siara. All rights reserved.
//

#import "DataSaveClass.h"

@implementation DataSaveClass

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if(!self)
        return nil;
    
    /* The properties of the object */
    self.userID = [aDecoder decodeObjectForKey:@"userID"];
    self.scID = [aDecoder decodeObjectForKey:@"scID"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.scID forKey:@"scID"];
}

@end
