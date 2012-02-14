//
//  SNSBinder.h
//  TaTa
//
//  Created by it on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBShareKit.h"

typedef enum {
    kSNSTypeSina = 0,
    kSNSTypeTx
} SNSType ;

@interface SNSBinder : NSObject


+ (SNSBinder *)sharedBinder;

- (void)startSinaOauthWithNavigationController:(UINavigationController *)navigationController;

- (void)startTxOauthWithNavigationController:(UINavigationController *)navigationController;

- (void)sinaLogout;
- (void)txLogout;

- (void)shareToSns:(SNSType)type withStatus:(NSString *)status;

- (void)shareToSns:(SNSType)type 
         withPhoto:(UIImage *)image 
         andStatus:(NSString *)status;

- (BOOL)isSinaLogin;
- (BOOL)isTxLogin;

@end
