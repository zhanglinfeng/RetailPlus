//
//  RPELWebCache.h
//  RetailPlus
//
//  Created by lin dong on 14-7-21.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

#if NS_BLOCKS_AVAILABLE
typedef void (^RPELWebCacheSuccessBlock)(NSString *strFilePath);
typedef void (^RPELWebCacheFailedBlock)();
typedef void (^RPELWebCacheProgressBlock)(unsigned long long size, unsigned long long total);
#endif

@interface RPELWebCache : NSObject
{

}

@property (nonatomic,retain) ASIHTTPRequest          * httpRequest;
@property (nonatomic,retain) NSString                * strFileType;             //下载文件类型
@property (nonatomic,strong) RPELWebCacheFailedBlock failBlock;
@property (nonatomic,retain) NSString                * strPathSave;             //保存缓存文件的路径
@property (nonatomic,retain) NSString                * strFileNameTemp;         //临时文件名＋路径
@property (nonatomic) BOOL                    bBeginDownload;

+(NSString *)GetCacheURL:(NSString *)strUrl PathSave:(NSString *)strPathSave;//判断缓存是否存在，存在返回缓存文件＋路径，不存在返回空

-(id)init:(NSString *)strUrl PathSave:(NSString *)strPathSave;
-(void)SetCompleteBlock:(RPELWebCacheSuccessBlock)aCompletionBlock;
-(void)SetFailedBlock:(RPELWebCacheFailedBlock)aFailedBlock;
-(void)SetProgressBlock:(RPELWebCacheProgressBlock)aProgressBlock;
-(void)StartAsynchronous;
-(void)CancelDownload;
@end
