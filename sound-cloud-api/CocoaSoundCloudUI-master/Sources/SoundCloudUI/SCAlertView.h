//
//  SCAlertView.h
//  SoundCloudUI
//
//  Created by r/o/b on 12/20/12.
//  Copyright (c) 2012 SoundCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SCAlertViewDismissBlock)(NSInteger buttonIndex, BOOL didCancel);

@interface SCAlertView : UIAlertView <UIAlertViewDelegate>

@property (nonatomic, strong) id context;
@property (nonatomic, strong) id userInfo;

+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSArray *)otherButtonTitles
                         block:(SCAlertViewDismissBlock)block;

@end
