//
//  AppDelegate.m
//  choose-my-band
//
//  Created by Alcivanio on 16/09/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "AppDelegate.h"
#import "SCUI.h"
#import <FacebookSDK/FacebookSDK.h>

//#import "SingletonPlayer.h"


@implementation AppDelegate

+(void)initialize
{
    [SCSoundCloud setClientID:@"ded8fdd7b43d206029535151750a01f2"
                       secret:@"bc577ef24b981334f63a2e34c751946c"
                  redirectURL:[NSURL URLWithString:@"choosemyband://oauth2"]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"VNKpVYQRlb14jt93FcRFyxbPqt3WtzTIAJ486fbt"
                  clientKey:@"qABSffl9VCXa6z0I9bbRko7UYArWB56NHUDLffeM"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [FBLoginView class];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"publish_actions"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          //                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    UIApplication* thisApp = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier __block task = [thisApp beginBackgroundTaskWithExpirationHandler:^{
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        [self printTimeRemaining];
        //        while(YES) {
        //            [NSThread sleepForTimeInterval:1.0];
        //            [self printTimeRemaining];
        //        }
        //[thisApp endBackgroundTask:task];
    });
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Retrieve the app delegate
         //AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         //[appDelegate sessionStateChanged:session state:state error:error];
     }];
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
