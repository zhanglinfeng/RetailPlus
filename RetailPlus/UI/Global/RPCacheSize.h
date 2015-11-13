//
//  RPCacheSize.h
//  RetailPlus
//
//  Created by lin dong on 14-4-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPCacheSize : NSObject

+(unsigned long long)GetSystemCacheSize;
+(unsigned long long)GetDocumentLiveCacheSize;
+(unsigned long long)GetTrainingCacheSize;
+(NSString *)GetCacheSizeString:(unsigned long long)nSize;

+(void)ClearSystemCache;
+(void)ClearDocumentLiveCache;
+(void)ClearTrainingCache;

@end
