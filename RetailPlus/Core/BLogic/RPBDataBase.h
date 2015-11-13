//
//  RPBDataBase.h
//  RetailPlus
//
//  Created by lin dong on 13-9-18.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PlausibleDatabase/PlausibleDatabase.h>

@interface RPBDataBase : NSObject
{
    PLSqliteDatabase        * _dbPointer;
}

+(RPBDataBase *)defaultInstance;

-(BOOL)SaveUploadCache:(NSString *)strLoginName CacheType:(CacheType)type Data:(NSDictionary *)dictData Date:(NSString *)strDate Desc:(NSString *)strDesc ToArray:(NSMutableArray *)array;

-(NSMutableArray *)GetCacheDataArray:(NSString *)strLoginName;

-(void)SetCacheDataSubmitted:(NSString *)strID;

//每项功能的客户端缓存功能
-(NSString *)SaveTaskCacheData:(NSString *)strUserID Key:(NSString *)strKey CacheType:(CacheType)type Data:(NSDictionary *)dictData Date:(NSString *)strDate Desc:(NSString *)strDesc isNormalExit:(BOOL)bNormal;

-(BOOL)UpdateTaskCacheData:(NSString *)strUserID CacheDataId:(NSString *)strCacheDataId CacheType:(CacheType)type Data:(NSDictionary *)dictData Date:(NSString *)strDate Desc:(NSString *)strDesc isNormalExit:(BOOL)bNormal;

-(void)ClearTaskCacheData:(NSString *)strUserID Key:(NSString *)strKey CacheType:(CacheType)type;

-(void)ClearCacheDataById:(NSString *)strId;

-(TaskCachData *)GetTaskCacheData:(NSString *)strUserID ByCacheDataId:(NSString *)strCacheDataId CacheType:(CacheType)type;
-(TaskCachData *)GetTaskCacheData:(NSString *)strUserID Key:(NSString *)strKey CacheType:(CacheType)type;

-(NSArray *)GetAllTaskCacheData:(NSString *)strUserID;

//自动提示缓存
-(void)SaveAutoRemindData:(NSString *)strUserID Type:(AutoRemaindType)type Data:(NSMutableArray *)array;

-(NSMutableArray *)ReadAutoRemindData:(NSString *)strUserID Type:(AutoRemaindType)type;

//货品追踪历史记录
-(BOOL)InsertGoodsTracking:(NSString *)strUserID Tracking:(GoodsTrackingInfo *)info;
-(BOOL)DeleteGoodTracking:(NSString *)strUserID TrackingID:(NSString *)strID;
-(NSArray *)GetGoodsTrackingList:(NSString *)strUserID Filter:(NSString *)strFilter;

//保存发送报告的用户
-(void)SaveReportToUser:(NSString *)strUserID ReportType:(ReportToUserSaveType)type Date:(NSString *)strDate Reporters:(NSArray *)arraySection;

-(NSArray *)GetReportToUser:(NSString *)strUserID ReportType:(ReportToUserSaveType)type VendorId:(NSString *)strVendorId;

@end
