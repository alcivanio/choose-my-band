//
//  SingleTon.h
//  choose-my-band
//
//  Created by bepid on 02/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Crud.h"
#import "SCUI.h"
#import "DataSaveClass.h"
@interface GeneralSingleton : NSObject


//@property(strong,nonatomic) Crud *crud;
@property(strong, nonatomic) SCAccount *scAccount;
@property(strong, nonatomic) NSString *userID;
@property(strong, nonatomic) NSDictionary *scDictionary;/* the dictionary of the user on sc */
@property(strong, nonatomic) User *currentUser;/* load everytime when the app is */
@property(strong, nonatomic) DataSaveClass *dataClass;/* All the data of the user */
@property(nonatomic) BOOL isLoggin;


/* Metholds */
+(id)sharedInstance;
-(void)initializeGeneralSingleton;
-(DataSaveClass *)loadDataSaveClass;
-(BOOL)deleteDataClass;
-(BOOL)saveDataSaveClass;
-(BOOL)fileExists;


@end
