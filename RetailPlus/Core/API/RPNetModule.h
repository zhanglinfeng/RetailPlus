//
//  RPNetModule.h
//  RetailPlus
//
//  Created by lin dong on 13-11-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSDK.h"

#define APP_KEY                 @"21061479"
#define APP_SECRET              @"0c98889261dd151b28996ca5d55bece1"

#define SDK_VERSION             @"1.0"
#define SDK_TIMEOUTINTERVAL     30

@interface RPNetModule : NSObject

+ (NSString *)GetSid;
+ (void)ClearSid;

+ (NSString *)encrypt:(NSString *)plainText;

+(NetworkStatus)GetConnectionStatus;

+(NSString *)genTimeStamp;

+(void)doRequest:(NSString *)strURL isCheckWifi:(BOOL)bCheckWifi withData:(NSMutableDictionary *)dictParam success:(RPSDKSuccess)successBlock failed:(RPSDKFailed)failedBlock;

+(void)doRequest:(NSString *)strURL isCheckWifi:(BOOL)bCheckWifi withData:(NSMutableDictionary *)dictParam success:(RPSDKSuccess)successBlock failed:(RPSDKFailed)failedBlock DownloadProgress:(RPSDKProgress)progressDownload UploadProgress:(RPSDKProgress)progressUpload;

+(id)DoSyncRequest:(NSString *)strURL isCheckWifi:(BOOL)bCheckWifi withData:(NSMutableDictionary *)dictParam timeoutInterval:(NSInteger)nInterval;

+(void)GetWeatherInfo:(NSString *)strCityID success:(RPSDKSuccess)successBlock failed:(RPSDKFailed)failedBlock;
@end
