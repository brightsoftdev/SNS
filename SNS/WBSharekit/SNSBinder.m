//
//  SNSBinder.m
//  TaTa
//
//  Created by it on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SNSBinder.h"
#import "MTStatusBarOverlay.h"
#import "TKAlertCenter.h"

@implementation SNSBinder


+ (SNSBinder *)sharedBinder {
    static SNSBinder *binderSingleton = nil;
    if (!binderSingleton) {
        binderSingleton = [[SNSBinder alloc] init];
    }
    return binderSingleton;
}

- (void)dealloc {
    
    [super dealloc];
}

- (void)shareToSinaWithPhoto:(NSString *)imagePath 
                   andStatus:(NSString *)status 
                    delegate:(id)delagate 
             successSelector:(SEL)_sSel 
                failSelector:(SEL)_eSel {
    
    [[MTStatusBarOverlay sharedInstance] postMessage:@"正在同步到新浪微博..."];
    
    [[WBShareKit mainShare] sendSinaPhotoWithStatus:status
                                                lat:0.0
                                                lng:0.0
                                               path:imagePath
                                           delegate:delagate
                                    successSelector:_sSel
                                       failSelector:_eSel];
}

- (void)shareToTxWithPhoto:(NSString *)imagePath 
                 andStatus:(NSString *)status 
                  delegate:(id)delagate 
           successSelector:(SEL)_sSel 
              failSelector:(SEL)_eSel {
    [[MTStatusBarOverlay sharedInstance] postMessage:@"正在同步到腾讯微博..."];
    
    [[WBShareKit mainShare] sendTxRecordWithStatus:status
                                               lat:0.0
                                               lng:0.0
                                            format:@"json"
                                              path:imagePath
                                          delegate:delagate
                                   successSelector:_sSel
                                      failSelector:_eSel];
}

- (void)shareToSns:(SNSType)type withStatus:(NSString *)status {   
    
    switch (type) {
        case kSNSTypeSina: {
            [[MTStatusBarOverlay sharedInstance] postMessage:@"正在同步到新浪微博..."];
            [[WBShareKit mainShare] sendSinaRecordWithStatus:status
                                                         lat:0
                                                         lng:0
                                                    delegate:self
                                             successSelector:@selector(shareToSinaFinish:)
                                                failSelector:@selector(shareToSinaError:)];
        }
            break;
            
        case kSNSTypeTx: {
            [[MTStatusBarOverlay sharedInstance] postMessage:@"正在同步到腾讯微博..."];
            [[WBShareKit mainShare] sendTxRecordWithStatus:status
                                                       lat:0
                                                       lng:0
                                                    format:@"json"
                                                  delegate:self
                                           successSelector:@selector(shareToTxFinish:)
                                              failSelector:@selector(shareToTxError:)];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)shareToSns:(SNSType)type 
         withPhoto:(UIImage *)image 
         andStatus:(NSString *)status  {
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths lastObject];
    NSMutableString *imagePath = [NSMutableString stringWithString:documentPath];
    [imagePath appendString:@"/tempImageForUploadSns.png"];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    [imageData writeToFile:imagePath
                atomically:YES];
    
    switch (type) {
        case kSNSTypeSina: {
            [self shareToSinaWithPhoto:imagePath
                             andStatus:status
                              delegate:self
                       successSelector:@selector(shareToSinaFinish:)
                          failSelector:@selector(shareToSinaError:)];
        }
            break;
            
        case kSNSTypeTx: {
            [self shareToTxWithPhoto:imagePath
                           andStatus:status
                            delegate:self
                     successSelector:@selector(shareToTxFinish:)
                        failSelector:@selector(shareToTxError:)];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)isSinaLogin {
    return [[WBShareKit mainShare] isSinaLogin];
}

- (BOOL)isTxLogin {
    return [[WBShareKit mainShare] isTxLogin];
}

- (void)startSinaOauthWithNavigationController:(UINavigationController *)navigationController {
    [[WBShareKit mainShare] startSinaOauthWithSelector:@selector(sinaLoginFinish)
                                    withFailedSelector:@selector(sinaLoginError)
                              withNavigationController:navigationController 
                                          withDelegate:self];
}

- (void)startTxOauthWithNavigationController:(UINavigationController *)navigationController {
    [[WBShareKit mainShare] startTxOauthWithSelector:@selector(txLoginFinish)
                                  withFailedSelector:@selector(txLoginError)
                            withNavigationController:navigationController 
                                        withDelegate:self];
}

- (void)sinaLogout {
    [[WBShareKit mainShare] sinaLogout];
}
                    
- (void)txLogout {
    [[WBShareKit mainShare] txLogout];
}

#pragma mark - delegate 

- (void)sinaLoginFinish {
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"绑定成功！"
                                                  image:[UIImage imageNamed:@"sinaIcon.png"]];
}

- (void)sinaLoginError {
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"绑定失败！"
                                                  image:[UIImage imageNamed:@"sinaIcon.png"]];
}

- (void)txLoginFinish {
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"绑定成功！"
                                                  image:[UIImage imageNamed:@"tengxunIcon.png"]];
}

- (void)txLoginError {
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"绑定失败！"
                                                  image:[UIImage imageNamed:@"tengxunIcon.png"]];
}

- (void)shareToSinaFinish:(NSData *)data {
    DLog(@"%@", data);
    
    [[MTStatusBarOverlay sharedInstance] postFinishMessage:@"同步到新浪微博成功！"
                                                  duration:2];
}


- (void)shareToSinaError:(NSError *)error {
    DLog(@"%@", [error description]);
    
    [[MTStatusBarOverlay sharedInstance] postErrorMessage:@"同步到新浪微博失败！"
                                                 duration:2];
}

- (void)shareToTxFinish:(NSData *)data {
    DLog(@"%@", data);
    
    [[MTStatusBarOverlay sharedInstance] postFinishMessage:@"同步到腾讯微博成功！"
                                                  duration:2];
    
}

- (void)shareToTxError:(NSError *)error {
    DLog(@"%@", [error description]);
    
    [[MTStatusBarOverlay sharedInstance] postErrorMessage:@"同步到腾讯微博失败！"
                                                 duration:2];
}


@end
