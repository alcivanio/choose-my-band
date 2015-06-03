//
//  SingleTon.m
//  choose-my-band
//
//  Created by bepid on 02/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "GeneralSingleton.h"
#import "ProfileViewController.h"
#import "AlbumPlayerViewController.h"
#import "FeedViewController.h"
#import "RadioViewController.h"
#import "SearchViewController.h"

@implementation GeneralSingleton


+(id)sharedInstance
{
    static dispatch_once_t obj = 0;
    __strong static id _sharedObject = nil; //pode ser qualquer nome
    
    dispatch_once(&obj, ^{
        _sharedObject = [[self alloc]init];
    });
    
    // Retorna o objeto para o método de classe
    return _sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self instantiateObjects];
        [self initializeGeneralSingleton];
    }
    return self;
}

-(void)initializeGeneralSingleton
{
    //Getting the sound cloud accout
    self.scAccount = [SCSoundCloud account];
    
    /* Load the data if file exists. We need make it, just one time */
    if([self fileExists])
        [self loadDataSaveClass];
    
    [self loadBasicsInformations];
}

-(void)instantiateObjects
{
    self.dataClass = [[DataSaveClass alloc]init];
}

-(void)loadBasicsInformations
{
    //JSON - First, we get the json with the data of the user account
    SCAccount *account = [SCSoundCloud account];
    
    if(!account)
        return;
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error)
    {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (!(jsonError) || [jsonResponse isKindOfClass:[NSArray class]])
        {
            self.scDictionary = (NSDictionary *)jsonResponse;
            [self loadCurrentoUser];
        }
    };
    
    [SCRequest performMethod:SCRequestMethodGET onResource:[NSURL URLWithString:@"https://api.soundcloud.com/me.json"]
             usingParameters:nil withAccount:account sendingProgressHandler:nil responseHandler:handler];
}

-(void)loadCurrentoUser
{
    //NSString *oi = (NSString *)[NSString stringWithFormat:@"%@",[self.scDictionary objectForKey:@"id"]];
    PFQuery *query = [PFQuery queryWithClassName:@"CustomUser"];
    [query whereKey:@"scId" equalTo:[NSString stringWithFormat:@"%@",[self.scDictionary objectForKey:@"id"]]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            self.currentUser = [[User alloc]initWithPFObject:[objects objectAtIndex:0]];
        }
    }];
}

-(NSString *)pathOfSavedClassDirectory
{
    /* The path where the archives are (may be) saved */
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [pathDocuments stringByAppendingPathComponent:@"cmbData.cmb"];
}

-(BOOL)saveDataSaveClass
{
    /* Save the data of the self.dataClass, with basic infos of the user */
    [NSKeyedArchiver archiveRootObject:self.dataClass toFile:[self pathOfSavedClassDirectory]];
    
    NSFileManager *mng = [NSFileManager defaultManager];
    NSLog(@"%@", [self pathOfSavedClassDirectory]);
    BOOL breakDois = [mng fileExistsAtPath:[self pathOfSavedClassDirectory]];
    
    return YES;
}

-(DataSaveClass *)loadDataSaveClass
{
    /* Load the data saved */
    self.dataClass = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathOfSavedClassDirectory]];
    
    NSFileManager *mng = [NSFileManager defaultManager];
    NSLog(@"%@", [self pathOfSavedClassDirectory]);
    [mng fileExistsAtPath:[self pathOfSavedClassDirectory]];
    
    /* return, if the user wants to user the data */
    return self.dataClass;
}

/* Remove the data class of the system. Return YES if it is finished with sucess */
-(BOOL)deleteDataClass
{
    NSFileManager *fManager = [NSFileManager defaultManager];
    return [fManager removeItemAtPath:[self pathOfSavedClassDirectory] error:nil];
}

/* If the archive exists, return YES */
-(BOOL)fileExists
{
    NSFileManager *mng = [NSFileManager defaultManager];
    return [mng fileExistsAtPath:[self pathOfSavedClassDirectory]];
}

@end
