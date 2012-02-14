//
//  SettingController.h
//  SNS
//
//  Created by  on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

extern NSString *const kNotificationClearMsgHistory;

@interface SettingController : UITableViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@end
