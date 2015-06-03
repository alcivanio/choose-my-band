//
//  SCAlertView.m
//  SoundCloudUI
//
//  Created by r/o/b on 12/20/12.
//  Copyright (c) 2012 SoundCloud. All rights reserved.
//

#import "SCAlertView.h"

@interface SCAlertView ()
@property (nonatomic, copy) SCAlertViewDismissBlock block;
@end


@implementation SCAlertView

@synthesize block = _block;
@synthesize context, userInfo;

#pragma mark Lifecycle

+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSArray *)otherButtonTitles
                         block:(SCAlertViewDismissBlock)block;
{

    SCAlertView *alert = [[SCAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    alert.delegate = alert;
    alert.block = block;

    for (NSString *buttonTitle in otherButtonTitles) {
        [alert addButtonWithTitle:buttonTitle];
    }
    [alert show];
}


#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    if (self.block) {
        self.block(buttonIndex, self.cancelButtonIndex == buttonIndex);
    }
}


@end
