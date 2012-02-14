//
//  SinaWebViewController.h
//  TaTa
//
//  Created by it on 12-2-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNSWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;

- (id)initWithUrl:(NSString *)aUrl;

@end
