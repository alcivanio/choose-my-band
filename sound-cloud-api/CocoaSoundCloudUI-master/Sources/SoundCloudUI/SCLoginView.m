/*
 * Copyright 2010, 2011 nxtbgthng for SoundCloud Ltd.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 *
 * For more information and documentation refer to
 * http://soundcloud.com/api
 * 
 */

#if TARGET_OS_IPHONE
#import "NXOAuth2.h"
#else
#import <OAuth2Client/NXOAuth2.h>
#endif
#import <QuartzCore/QuartzCore.h>

#import "SCSoundCloud.h"
#import "SCSoundCloud+Private.h"
#import "UIColor+SoundCloudUI.h"
#import "UIDevice+SoundCloudUI.h"
#import "UIView+SoundCloudUI.h"
#import "SCConstants.h"
#import "SCBundle.h"
#import "SCLoginView.h"
#import "SCGradientButton.h"
#import "SCAlertView.h"
#import "SCDrawing.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"

@interface SCLoginView () <OHAttributedLabelDelegate, UIWebViewDelegate>
@property (nonatomic, readwrite, assign) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) UILabel *titleLabel;
@property (nonatomic, assign) SCGradientButton *fbButton;
@property (nonatomic, assign) SCGradientButton *loginButton;
@property (nonatomic, readwrite, assign) UIWebView *webView;
@property (nonatomic, assign) OHAttributedLabel *tosLabel;
- (void)commonAwake;
@end

@implementation SCLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonAwake];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Separator Line
    CGFloat lineWidth = 1.3;
    CGFloat topLineY = 133.0;
    CGFloat bottomLineY = topLineY + lineWidth;

    // Top part
    CGColorRef topLineColor = [UIColor soundCloudSuperLightGrey].CGColor;

    CGPoint topLineStartPoint = CGPointMake(0, topLineY);
    CGPoint topLineEndPoint   = CGPointMake(CGRectGetWidth(self.bounds), topLineY);
    drawLine(context, topLineStartPoint, topLineEndPoint, topLineColor, lineWidth);

    // Bottom part
    CGColorRef bottomLineColor = [UIColor colorWithRed:1.0
                                                 green:1.0
                                                  blue:1.0
                                                 alpha:1.0].CGColor;

    CGPoint bottomLineStartPoint = CGPointMake(0, bottomLineY);
    CGPoint bottomLineEndPoint   = CGPointMake(CGRectGetWidth(self.bounds), bottomLineY);
    drawLine(context, bottomLineStartPoint, bottomLineEndPoint, bottomLineColor, lineWidth);

}

- (void)commonAwake;
{
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	self.activityIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin);
	self.activityIndicator.hidesWhenStopped = YES;
	[self addSubview:self.activityIndicator];
    
    self.webView = [[[UIWebView alloc] initWithFrame:self.bounds] autorelease];
    self.webView.delegate = self;
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.alpha = 0.0;
    self.webView.opaque = NO;
    [self addSubview:self.webView];

    self.backgroundColor = [UIColor soundCloudBackgroundGrey];

    [self layoutTitleLabel];
    [self layoutFbButton];
    [self layoutCredentialsView];
    [self layoutLoginButton];
    [self layoutTermsAndPrivacy];
}

- (void)dealloc;
{
    [super dealloc];
}

#pragma mark -
#pragma mark Layout all of the things

- (void)layoutTitleLabel
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textAlignment = UITextAlignmentLeft;
    self.titleLabel.text = [NSString stringWithFormat:SCLocalizedString(@"credential_title", @"Title"),
                            [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
    self.titleLabel.textColor = [UIColor soundCloudGrey];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    self.titleLabel.shadowColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
}

- (void)layoutFbButton
{
    NSArray *fbButtonColors = [NSArray arrayWithObjects:
                                [UIColor colorWithRed:0
                                                green:0.4
                                                 blue:0.8
                                                alpha:1.0],
                                [UIColor colorWithRed:0.043
                                                green:0.314
                                                 blue:0.588
                                                alpha:1.0],
                                nil];

    self.fbButton = [[SCGradientButton alloc] initWithFrame:CGRectZero
                                                     colors:fbButtonColors];
    self.fbButton.backgroundColor = [UIColor whiteColor];
    [self.fbButton setTitle:SCLocalizedString(@"fb_sign_in",@"Facebook")
                   forState:UIControlStateNormal];
    self.fbButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.fbButton.titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
    self.fbButton.titleLabel.shadowOffset = CGSizeMake(0.0, -0.9);
    self.fbButton.titleLabel.shadowColor = [UIColor blackColor];
    [self.fbButton setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
    self.fbButton.layer.borderColor = [UIColor colorWithRed:0
                                                      green:0.286
                                                       blue:0.569
                                                      alpha:1.0].CGColor;
    self.fbButton.layer.borderWidth = 1.0;

    [self.fbButton addTarget:self
                      action:@selector(signInWithFacebook:)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.fbButton];

    // Facebook logo
    UIImageView *fbLogo = [[UIImageView alloc] init];
    fbLogo.image = [SCBundle imageWithName:@"facebook"];
    [fbLogo sizeToFit];
    fbLogo.frame = CGRectMake(7.0,
                              6.0,
                              CGRectGetWidth(fbLogo.frame),
                              CGRectGetHeight(fbLogo.frame));
    [self.fbButton addSubview:fbLogo];
}

- (void)layoutCredentialsView
{
    self.credentialsView = [[SCCredentialsView alloc] init];
    self.credentialsView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    [self addSubview:self.credentialsView];
}

- (void)layoutLoginButton
{
    self.loginButton = [[SCGradientButton alloc] initWithFrame:CGRectZero
                                                        colors:nil];
    self.loginButton.backgroundColor = [UIColor colorWithPatternImage:[SCBundle imageWithName:@"continue"]];

    [self.loginButton setTitle:SCLocalizedString(@"connect_to_sc",@"Connect")
                      forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self.loginButton setTitleColor:[UIColor soundCloudGrey]
                           forState:UIControlStateNormal];

    [self.loginButton setTitleShadowColor:[UIColor whiteColor]
                                 forState:UIControlStateNormal];

    self.loginButton.titleLabel.shadowOffset  = CGSizeMake(0.0, 1.0);
    self.loginButton.layer.borderColor        = [UIColor soundCloudSuperLightGrey].CGColor;
    [self.loginButton addTarget:self
                         action:@selector(login:)
               forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.loginButton];
}

- (void)layoutTermsAndPrivacy
{
    NSMutableAttributedString *text = [NSMutableAttributedString attributedStringWithString:SCLocalizedString(@"sign_in_tos_pp_body", nil)];
    [text setFont:[UIFont systemFontOfSize:13.0]];

    self.tosLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
    self.tosLabel.attributedText = text;
    self.tosLabel.centerVertically = NO;
    self.tosLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.tosLabel.textAlignment = UITextAlignmentCenter;
    self.tosLabel.textColor = [UIColor soundCloudLightGrey];
    self.tosLabel.backgroundColor = [UIColor clearColor];
    self.tosLabel.delegate = self;
    [self.tosLabel setLinkColor:[UIColor soundCloudGrey]];

    NSRange touLinkRange = [text.string rangeOfString:SCLocalizedString(@"terms_of_use_substring", nil)];
    NSAssert((touLinkRange.location != NSNotFound), @"Localisation of sign_in_tos_pp_body needs to contain substring");
    [self.tosLabel addCustomLink:[NSURL URLWithString:kTermsOfServiceURL]
                         inRange:touLinkRange];

    NSRange ppLinkRange = [text.string rangeOfString:SCLocalizedString(@"privatcy_policy_substring", nil)];
    NSAssert((ppLinkRange.location != NSNotFound), @"Localisation of sign_in_tos_pp_body needs to contain substring");
    [self.tosLabel addCustomLink:[NSURL URLWithString:kPrivacyPolicyURL]
                         inRange:ppLinkRange];

    [self addSubview:self.tosLabel];
}

- (UIEdgeInsets)updateEdgeInsets
{
    UIEdgeInsets edgeInsets;
    if ([UIDevice isIPad]) {
        edgeInsets = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ?
        UIEdgeInsetsMake(0, -CGRectGetWidth(self.bounds)/3, 0, 0) : UIEdgeInsetsMake(0, -230.0, 0, 0);

    } else {
       edgeInsets = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ?
        UIEdgeInsetsMake(0, -CGRectGetWidth(self.bounds)/3, 0, 0) : UIEdgeInsetsMake(0, -30.0, 0, 0);
    }
    return edgeInsets;
}

#pragma mark View

- (void)layoutSubviews;
{
    CGFloat titleLabelX = 18.0;
    CGFloat titleLabelY = 13.0;
    CGFloat titleLabelHeight = 40.0;
    CGFloat buttonHeight = 43.0;

    self.webView.frame = self.bounds;

    self.titleLabel.frame = CGRectMake(titleLabelX,
                                       titleLabelY,
                                       self.bounds.size.width - self.frame.origin.x,
                                       titleLabelHeight);

    self.credentialsView.frame = CGRectMake(13.0,
                                            155.0,
                                            self.bounds.size.width - 27.0,
                                            97.0);

    self.fbButton.frame = CGRectMake(self.credentialsView.frame.origin.x,
                                     69.0,
                                     self.credentialsView.frame.size.width,
                                     buttonHeight);

    self.loginButton.frame = CGRectMake(self.credentialsView.frame.origin.x,
                                        self.credentialsView.frame.origin.y + self.credentialsView.frame.size.height + 21.0,
                                        self.credentialsView.frame.size.width,
                                        buttonHeight);

    self.fbButton.titleEdgeInsets = [self updateEdgeInsets];

    self.activityIndicator.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    self.tosLabel.frame = CGRectMake(self.loginButton.frame.origin.x,
                                     self.loginButton.frame.origin.y + self.loginButton.frame.size.height + 17.0,
                                     CGRectGetWidth(self.bounds) - 20.0,
                                     80.0);
    [self setNeedsDisplay];
}

- (void)askForOpeningURL:(NSURL*)URL
{
    [SCAlertView showAlertViewWithTitle:SCLocalizedString(@"open_in_safari_title", nil)
                                message:SCLocalizedString(@"open_in_safari_message", nil)
                      cancelButtonTitle:SCLocalizedString(@"alert_cancel", nil)
                      otherButtonTitles:[NSArray arrayWithObject:SCLocalizedString(@"alert_ok", nil)]
                                  block:^(NSInteger buttonIndex, BOOL didCancel) {
                                      if (!didCancel) {
                                          [[UIApplication sharedApplication] openURL:URL];
                                      }
                                  }];
}

#pragma mark Accessors

@synthesize loginDelegate;
@synthesize activityIndicator;
@synthesize credentialsView;
@synthesize fbButton;
@synthesize loginButton;
@synthesize titleLabel;
@synthesize tosLabel;

- (void)removeAllCookies;
{
    // WORKAROUND: Remove all Cookies to enable the use of facebook user accounts
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

#pragma mark Button Actions

- (void)login:(id)sender
{
    [[self firstResponderFromSubviews] resignFirstResponder];

   if ((self.credentialsView.username.length != 0) &&
       (self.credentialsView.password.length != 0)) {
        [[SCSoundCloud shared] requestAccessWithUsername:self.credentialsView.username
                                                password:self.credentialsView.password];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SCLocalizedString(@"credentials_error", @"Credentials Error")
                                                        message:SCLocalizedString(@"credentials_error_message", @"Credentials Message Error")
                                                       delegate:nil
                                              cancelButtonTitle:SCLocalizedString(@"alert_ok", @"OK")
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)signInWithFacebook:(id)sender
{
    NSDictionary *accountConfig = [[NXOAuth2AccountStore sharedStore] configurationForAccountType:kSCAccountType];
    NSURL *URLToOpen = [NSURL URLWithString:[NSString stringWithFormat:@"%@/via/facebook?client_id=%@&redirect_uri=%@&display=popup&response_type=code",
                                                accountConfig[kNXOAuth2AccountStoreConfigurationAuthorizeURL],
                                                accountConfig[kNXOAuth2AccountStoreConfigurationClientID],
                                                accountConfig[kNXOAuth2AccountStoreConfigurationRedirectURL]]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:URLToOpen]];
    // Dismiss Keyboard if it is still shown
    [[self firstResponderFromSubviews] resignFirstResponder];
}

- (void)cancel:(id)sender
{
    [(UIViewController *)self.loginDelegate dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark OHAttributedLabel delegate

- (BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo;
{
    if ([linkInfo.URL.absoluteString isEqualToString:kTermsOfServiceURL]) {
        [self askForOpeningURL:[NSURL URLWithString:kTermsOfServiceURL]];
    } else if ([linkInfo.URL.absoluteString isEqualToString:kPrivacyPolicyURL]) {
        [self askForOpeningURL:[NSURL URLWithString:kPrivacyPolicyURL]];
    }
    return NO;
}

- (UIColor*)colorForLink:(NSTextCheckingResult*)linkInfo underlineStyle:(int32_t*)underlineStyle;
{
    *underlineStyle = kCTUnderlineStyleSingle;
    return [UIColor soundCloudGrey];
}

#pragma mark WebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    [self.activityIndicator startAnimating];
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self bringSubviewToFront:self.webView];
                         self.webView.alpha = 1.0;
                         self.webView.backgroundColor = [UIColor colorWithRed:0.3
                                                                        green:0.3
                                                                         blue:0.3
                                                                        alpha:1.0];
                         self.bounds = self.webView.frame;
                         [self bringSubviewToFront:self.activityIndicator];
                     }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [self.activityIndicator stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    [SCSoundCloud handleRedirectURL:request.URL];
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    if ([[error domain] isEqualToString:NSURLErrorDomain]) {

        if ([error code] == NSURLErrorCancelled)
            return;

    } else if ([[error domain] isEqualToString:@"WebKitErrorDomain"]) {

        if ([error code] == 101)
            return;

        if ([error code] == 102)
            return;
    }

    if ([self.loginDelegate respondsToSelector:@selector(loginView:didFailWithError:)]) {
        [self.loginDelegate loginView:self
                     didFailWithError:error];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self firstResponderFromSubviews] resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}

@end
