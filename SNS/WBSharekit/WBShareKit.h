//
//  WBShareKit.h
//  WBShareKit
//
//  Created by Gao Semaus on 11-8-8.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAAsynchronousDataFetcher.h"
#import "OAToken.h"
#import "OAServiceTicket.h"
#import "WBShareKey.h"
#import "WBRequest.h"

@interface WBShareKit : NSObject
{
    SEL _successSEL;
    SEL _failSEL;
}

@property (nonatomic, assign) UINavigationController *navigationController;
@property (nonatomic, assign) id delegate;

+ (WBShareKit *)mainShare;
- (void)handleOpenURL:(NSURL *)url;

#pragma mark sina
- (void)startSinaOauthWithSelector:(SEL)_sSel 
                withFailedSelector:(SEL)_eSel
          withNavigationController:(UINavigationController *)navigationController 
                      withDelegate:(id)delegate;

- (void)sinaLogout;
- (BOOL)isSinaLogin;

- (void)sendSinaRecordWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel;
- (void)sendSinaPhotoWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng path:(NSString *)_path delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel;

#pragma mark tx
- (void)startTxOauthWithSelector:(SEL)_sSel 
              withFailedSelector:(SEL)_eSel
        withNavigationController:(UINavigationController *)navigationController 
                    withDelegate:(id)delegate;

- (void)txLogout;
- (BOOL)isTxLogin;

- (void)sendTxRecordWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng format:(NSString *)_format delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel;
- (void)sendTxRecordWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng format:(NSString *)_format path:(NSString *)_path delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel;


#pragma mark douban
- (void)startDoubanOauthWithSelector:(SEL)_sSel withFailedSelector:(SEL)_eSel;
//- (void)startDoubanAccess;
- (void)sendDoubanShuoWithStatus:(NSString *)_status delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel;


#pragma mark twitter
- (void)startTwitterOauthWithSelector:(SEL)_sSel withFailedSelector:(SEL)_eSel;
- (void)sendTwitterWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel;

#pragma mark 163
- (void)startWyOauthWithSelector:(SEL)_sSel withFailedSelector:(SEL)_eSel;
- (void)sendWyRecordWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel;
- (void)sendWyPhotoWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng path:(NSString *)_path delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel;
@end
