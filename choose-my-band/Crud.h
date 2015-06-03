//
//  Crud.h
//  choose-my-band
//
//  Created by Bruno Lima on 01/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "SCUI.h"
#import "Status.h"
#import "Music.h"
#import "User.h"

@interface Crud : NSObject

@property PFObject *currentUser;
@property BOOL isLogged;

- (instancetype)initCRUDWithScId:(NSString *)scId;



-(BOOL)existNewVersion;

-(void)addAlbumWithTitle:(NSString *)nomeAlbum type:(NSString *)albumType coverUrl:(NSString *)cover;

-(void)updateRelationUserAtColumnNamed:(NSString *)name withObject:(PFObject *)object;

-(void) addFollowerWithscId:(NSString *)scId;

-(void)addStatusWithStatusText:(NSString *)text music:(PFObject *)musicObject;

-(void)addMusicWithImageUrl:(NSString *)imageUrl StreamUrl:(NSString *)streamUrl Title:(NSString *)title andAlbum:(PFObject *)album;

-(void)addCommentAtObject:(PFObject *)object andContent:(NSString *) content;

-(int)numberOfStatusForFollower;

-(NSMutableArray *)getAllStatus;

-(NSMutableArray *)getStatusFromUserWithObject:(PFObject *)object amount:(int)amount  andSkip: (int)skip;

-(void)addLikeAtObject:(PFObject *)object;

-(NSArray *)searchMusicsForTitle:(NSString *)title;
@end
