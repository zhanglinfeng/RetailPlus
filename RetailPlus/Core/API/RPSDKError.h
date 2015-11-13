//
//  RPSDKError.h
//  RetailPlus
//
//  Created by lin dong on 13-11-27.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    RPSDKError_Unknown              = -1,
    RPSDKError_Success              = 0,
    
//LocalError
    RPSDKError_Param                = 1,
    RPSDKError_NoConnection,
    RPSDKError_NoWifiConnection,
    RPSDKError_SubmitAddToCache,
    RPSDKError_SubmitAddToCacheFailed,
    RPSDKError_NoData,
//ServerError
    RPSDKError_Server               = 100,
    
//API Error
//System
    RPSDKError_AccountFrozen         = 10002,
    RPSDKError_AccountLoginOtherPlace= 10019,
    RPSDKError_AccountExpire         = 10038,
//User
//Login
    RPSDKError_Login_RequireVCode   = 10004,
}RPSDKErrorCode;

@interface RPSDKError : NSObject

+(NSString *)GetErrorDesc:(RPSDKErrorCode)code;

@end
