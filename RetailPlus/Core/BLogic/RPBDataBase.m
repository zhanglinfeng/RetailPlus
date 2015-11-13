//
//  RPBDataBase.m
//  RetailPlus
//
//  Created by lin dong on 13-9-18.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPBDataBase.h"

#define kDBFileName  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"RetailPlus.sqlite"]

@implementation RPBDataBase

static RPBDataBase *defaultObject;

+(RPBDataBase *)defaultInstance
{
    @synchronized(self){
        if (!defaultObject)
        {
            defaultObject = [[self alloc] init];
        }
    }
    return defaultObject;
}

-(id)init
{
    self = [super init];
    if (self) {
        _dbPointer = [[PLSqliteDatabase alloc] initWithPath:kDBFileName];
        if (_dbPointer) {
            if ([_dbPointer open]) {
                [_dbPointer executeUpdate:@"CREATE TABLE UploadCache (\"id\" TEXT PRIMARY KEY,\"Data\" TEXT,\"Date\" TEXT,\"Desc\" TEXT,\"type\" INTEGER,\"LoginUserName\" TEXT)"];
                
                [_dbPointer executeUpdate:@"CREATE TABLE TaskCache (\"id\" TEXT PRIMARY KEY,\"Data\" TEXT,\"Date\" TEXT,\"Desc\" TEXT, \"Key\" TEXT, \"type\" INTEGER,\"userid\" TEXT,\"isNormalExit\" INTEGER)"];
                
                 [_dbPointer executeUpdate:@"CREATE TABLE AutoRemindCache (\"id\" TEXT PRIMARY KEY,\"Data\" TEXT,\"type\" INTEGER,\"userid\" TEXT)"];
                
                [_dbPointer executeUpdate:@"CREATE TABLE GoodsTracking (\"id\" TEXT PRIMARY KEY,\"Date\" TEXT,\"Code\" TEXT,\"Detail\" TEXT,\"userid\" TEXT)"];
                
                [_dbPointer executeUpdate:@"CREATE TABLE ReportToUser (\"id\" TEXT PRIMARY KEY,\"Date\" TEXT,\"Key1\" TEXT,\"Key2\" TEXT,\"Value1\" TEXT,\"Value2\" TEXT,\"type\" INTEGER,\"userid\" TEXT)"];
                return self;
            }
        }
    }
    return nil;
}

+(NSString *)genUUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef str_ref = CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)str_ref];
    
    CFRelease(str_ref);
    return uuid;
}

-(BOOL)SaveUploadCache:(NSString *)strLoginName CacheType:(CacheType)type Data:(NSDictionary *)dictData Date:(NSString *)strDate Desc:(NSString *)strDesc ToArray:(NSMutableArray *)array
{
    NSError *error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictData options:NSJSONWritingPrettyPrinted error:&error];
    NSString * strBody = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * strID = [RPBDataBase genUUID];
  //  NSString * str = [NSString stringWithFormat:@"insert into UploadCache (id,Data,Date,Desc,type,loginusername) values ('%@','%@','%@','%@',%d,'%@')",strID,strBody,strDate,strDesc,type,strLoginName];
    
    if ([_dbPointer executeUpdate:@"insert into UploadCache (id,Data,Date,Desc,type,loginusername) values (?,?,?,?,?,?)",strID,strBody,strDate,strDesc,[NSNumber numberWithInteger:type],strLoginName])
    {
        CachData * data = [[CachData alloc] init];
        data.strID = strID;
        data.strData = strBody;
        data.strDesc = strDesc;
        data.type = type;
        data.bSubmited = NO;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        data.date = [[NSDate alloc] init];
        data.date = [dateFormatter dateFromString:strDate];
        [array addObject:data];
        return YES;
    }
    return NO;
}

-(NSMutableArray *)GetCacheDataArray:(NSString *)strLoginName
{
    NSMutableArray  * array = [[NSMutableArray alloc] init];
    
    NSString * str = [NSString stringWithFormat:@"select * from uploadcache where loginusername = '%@'",strLoginName];
    
    id<PLResultSet> ds = [_dbPointer executeQuery:str];
    while ([ds next]) {
        CachData * data = [CachData alloc];
        data.strDesc = [ds objectForColumn:@"desc"];
        data.strData = [ds objectForColumn:@"Data"];
        data.strID = [ds objectForColumn:@"id"];
        NSNumber * num = [ds objectForColumn:@"type"];
        data.type = num.integerValue;
        NSString * strDate = [ds objectForColumn:@"Date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        data.date = [[NSDate alloc] init];
        data.date = [dateFormatter dateFromString:strDate];
        
        data.bSubmited = NO;
        [array addObject:data];
    }
    return array;
}

-(void)SetCacheDataSubmitted:(NSString *)strID
{
    NSString * str = [NSString stringWithFormat:@"delete from uploadcache where id = '%@'",strID];
    [_dbPointer executeUpdate:str];
}

-(NSString *)SaveTaskCacheData:(NSString *)strUserID Key:(NSString *)strKey CacheType:(CacheType)type Data:(NSDictionary *)dictData Date:(NSString *)strDate Desc:(NSString *)strDesc isNormalExit:(BOOL)bNormal
{
    if (type != CACHETYPE_BVISITING) {
        [self ClearTaskCacheData:strUserID Key:strKey CacheType:type];
    }
    
    
    NSError *error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictData options:NSJSONWritingPrettyPrinted error:&error];
    NSString * strBody = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * strID = [RPBDataBase genUUID];
//    NSString * str = [NSString stringWithFormat:@"insert into TaskCache (id,Data,Date,Desc,key,type,userid,isNormalExit) values ('%@','%@','%@','%@','%@',%d,'%@',%d)",strID,strBody,strDate,strDesc,strKey,type,strUserID,bNormal];
    
    if ([_dbPointer executeUpdate:@"insert into TaskCache (id,Data,Date,Desc,key,type,userid,isNormalExit) values (?,?,?,?,?,?,?,?)",strID,strBody,strDate,strDesc,strKey,[NSNumber numberWithInt:type],strUserID,[NSNumber numberWithBool:bNormal]])
        return strID;
    return nil;
}

-(BOOL)UpdateTaskCacheData:(NSString *)strUserID CacheDataId:(NSString *)strCacheDataId CacheType:(CacheType)type Data:(NSDictionary *)dictData Date:(NSString *)strDate Desc:(NSString *)strDesc isNormalExit:(BOOL)bNormal
{
    NSError *error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictData options:NSJSONWritingPrettyPrinted error:&error];
    NSString * strBody = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
 //   NSString * str = [NSString stringWithFormat:@"update TaskCache set Data = '%@',Date = '%@',Desc = '%@',type = %d,isNormalExit = %d where id = '%@' and userid = '%@'",strBody,strDate,strDesc,type,bNormal,strCacheDataId,strUserID];
    
    return [_dbPointer executeUpdate:@"update TaskCache set Data = ?,Date = ?,Desc = ?,type = ?,isNormalExit = ? where id = ? and userid = ?",strBody,strDate,strDesc,[NSNumber numberWithInteger:type],[NSNumber numberWithBool:bNormal],strCacheDataId,strUserID];
}

-(void)ClearTaskCacheData:(NSString *)strUserID Key:(NSString *)strKey CacheType:(CacheType)type
{
    NSString * str = [NSString stringWithFormat:@"delete from TaskCache where key = '%@' and userid = '%@' and type = %d",strKey,strUserID,type];
    [_dbPointer executeUpdate:str];
}

-(void)ClearCacheDataById:(NSString *)strId
{
    NSString * str = [NSString stringWithFormat:@"delete from TaskCache where id = '%@'",strId];
    [_dbPointer executeUpdate:str];
}

-(TaskCachData *)GetTaskCacheData:(NSString *)strUserID ByCacheDataId:(NSString *)strCacheDataId CacheType:(CacheType)type
{
    NSString * str = [NSString stringWithFormat:@"select * from TaskCache where id = '%@' and userid = '%@' and type = %d",strCacheDataId,strUserID,type];
    id<PLResultSet> ds = [_dbPointer executeQuery:str];
    while ([ds next]) {
        TaskCachData * data = [TaskCachData alloc];
        data.strDesc = [ds objectForColumn:@"desc"];
        data.strData = [ds objectForColumn:@"Data"];
        data.strID = [ds objectForColumn:@"id"];
        data.strKey = [ds objectForColumn:@"key"];
        
        NSNumber * num = [ds objectForColumn:@"type"];
        data.type = num.integerValue;
        NSString * strDate = [ds objectForColumn:@"Date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        data.date = [[NSDate alloc] init];
        data.date = [dateFormatter dateFromString:strDate];
        data.bNormalExit = ((NSNumber *)[ds objectForColumn:@"isNormalExit"]).boolValue;
        
        return data;
    }
    return nil;
}

-(TaskCachData *)GetTaskCacheData:(NSString *)strUserID Key:(NSString *)strKey CacheType:(CacheType)type
{
    NSString * str = [NSString stringWithFormat:@"select * from TaskCache where key = '%@' and userid = '%@' and type = %d",strKey,strUserID,type];
    
    id<PLResultSet> ds = [_dbPointer executeQuery:str];
    while ([ds next]) {
        TaskCachData * data = [TaskCachData alloc];
        data.strDesc = [ds objectForColumn:@"desc"];
        data.strData = [ds objectForColumn:@"Data"];
        data.strID = [ds objectForColumn:@"id"];
        data.strKey = [ds objectForColumn:@"key"];
        
        NSNumber * num = [ds objectForColumn:@"type"];
        data.type = num.integerValue;
        NSString * strDate = [ds objectForColumn:@"Date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        data.date = [[NSDate alloc] init];
        data.date = [dateFormatter dateFromString:strDate];
        data.bNormalExit = ((NSNumber *)[ds objectForColumn:@"isNormalExit"]).boolValue;
        
        return data;
    }
    return nil;
}

-(NSArray *)GetAllTaskCacheData:(NSString *)strUserID
{
    NSString * str = [NSString stringWithFormat:@"select * from TaskCache where userid = '%@' ORDER  BY Date desc",strUserID];
    
    NSMutableArray * arrayData = [[NSMutableArray alloc] init];
    
    id<PLResultSet> ds = [_dbPointer executeQuery:str];
    while ([ds next]) {
        TaskCachData * data = [TaskCachData alloc];
        data.strDesc = [ds objectForColumn:@"desc"];
        data.strData = [ds objectForColumn:@"Data"];
        data.strID = [ds objectForColumn:@"id"];
        data.strKey = [ds objectForColumn:@"key"];
        
        NSNumber * num = [ds objectForColumn:@"type"];
        data.type = num.integerValue;
        NSString * strDate = [ds objectForColumn:@"Date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        data.date = [[NSDate alloc] init];
        data.date = [dateFormatter dateFromString:strDate];
        data.bNormalExit = ((NSNumber *)[ds objectForColumn:@"isNormalExit"]).boolValue;
        
        [arrayData addObject:data];
    }
    return arrayData;
}

-(void)SaveAutoRemindData:(NSString *)strUserID Type:(AutoRemaindType)type Data:(NSMutableArray *)array
{
    [_dbPointer beginTransaction];
    
    NSString * str = [NSString stringWithFormat:@"delete from AutoRemindCache where userid = '%@' and type = %d",strUserID,type];
    [_dbPointer executeUpdate:str];
    
    for (NSString * strBody in array) {
        NSString * strID = [RPBDataBase genUUID];
       // NSString * str = [NSString stringWithFormat:@"insert into AutoRemindCache (id,Data,type,userid) values ('%@','%@',%d,'%@')",strID,strBody,type,strUserID];
        
        [_dbPointer executeUpdate:@"insert into AutoRemindCache (id,Data,type,userid) values (?,?,?,?)",strID,strBody,[NSNumber numberWithInteger:type],strUserID];
    }
    
    [_dbPointer commitTransaction];
}

-(NSMutableArray *)ReadAutoRemindData:(NSString *)strUserID Type:(AutoRemaindType)type
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSString * str = [NSString stringWithFormat:@"select * from AutoRemindCache where userid = '%@' and type = %d",strUserID,type];
    id<PLResultSet> ds = [_dbPointer executeQuery:str];
    while ([ds next]) {
        [array addObject:[ds objectForColumn:@"Data"]];
    }
    return array;
}

-(BOOL)InsertGoodsTracking:(NSString *)strUserID Tracking:(GoodsTrackingInfo *)info
{
//    NSString * str = [NSString stringWithFormat:@"insert into GoodsTracking (id,Date,Code,Detail,userid) values ('%@','%@','%@','%@','%@')",info.strID,info.strDate,info.strCode,info.strDetail,strUserID];
    return [_dbPointer executeUpdate:@"insert into GoodsTracking (id,Date,Code,Detail,userid) values (?,?,?,?,?)",info.strID,info.strDate,info.strCode,info.strDetail,strUserID];
}

-(BOOL)DeleteGoodTracking:(NSString *)strUserID TrackingID:(NSString *)strID
{
    NSString * str = [NSString stringWithFormat:@"delete from GoodsTracking where userid = '%@' and id = '%@'",strUserID,strID];
   return [_dbPointer executeUpdate:str];
}

-(NSArray *)GetGoodsTrackingList:(NSString *)strUserID Filter:(NSString *)strFilter
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSMutableArray * arrayCurrent = [[NSMutableArray alloc] init];
    
    NSString * str = [NSString stringWithFormat:@"select * from GoodsTracking where userid = '%@' ORDER BY Date",strUserID];
    if (strFilter && strFilter.length > 0) {
        str = [NSString stringWithFormat:@"select * from GoodsTracking where userid = '%@' AND (Code like '%%%@%%' OR Detail like '%%%@%%') ORDER BY Date",strUserID,strFilter,strFilter];
    }
    
    id<PLResultSet> ds = [_dbPointer executeQuery:str];
    while ([ds next]) {
        GoodsTrackingInfo * info = [[GoodsTrackingInfo alloc] init];
        info.strID = [ds objectForColumn:@"id"];
        info.strDate = [ds objectForColumn:@"Date"];
        info.strCode = [ds objectForColumn:@"Code"];
        info.strDetail = [ds objectForColumn:@"Detail"];
        BOOL bAddCurrent = NO;
        if (arrayCurrent.count == 0)
            bAddCurrent = YES;
        else
        {
            GoodsTrackingInfo * info2 = [arrayCurrent objectAtIndex:(arrayCurrent.count - 1)];
            if ([info2.strDate isEqualToString:info.strDate]) bAddCurrent = YES;
        }
        if (bAddCurrent)
            [arrayCurrent addObject:info];
        else
        {
            [array addObject:arrayCurrent];
            arrayCurrent = [[NSMutableArray alloc] init];
            [arrayCurrent addObject:info];
        }
    }
    if (arrayCurrent.count > 0) {
        [array addObject:arrayCurrent];
    }
    
    return array;
}

-(void)SaveReportToUser:(NSString *)strUserID ReportType:(ReportToUserSaveType)type Date:(NSString *)strDate Reporters:(NSArray *)arraySection
{
    for (InspReporterSection * sec in arraySection) {
        NSString * str = nil;
        if (sec.strVendorID && sec.strVendorID.length > 0)
        {
            str = [NSString stringWithFormat:@"delete from ReportToUser where userid = '%@' and type = %d and key1 = '%@'",strUserID,type,sec.strVendorID];
        }
        else
        {
            str = [NSString stringWithFormat:@"delete from ReportToUser where userid = '%@' and type = %d",strUserID,type];
        }
        [_dbPointer executeUpdate:str];
    }
    
    for (InspReporterSection * sec in arraySection) {
       // NSString * str = nil;
        NSString * strVendorId = @"";
        if (sec.strVendorID && sec.strVendorID.length > 0) {
            strVendorId = sec.strVendorID;
        }
        
        for (InspReporterUser * user in sec.arrayUser) {
            if (user.bSelected) {
                if (user.bUserCollegue)
                {
                    //  str = [NSString stringWithFormat:@"insert into ReportToUser (id,Date,key1,key2,value1,value2,type,userid) values ('%@','%@','%@','%@','%@','%@','%d','%@')",[RPBDataBase genUUID],strDate,strVendorId,@"",user.collegue.strUserId,@"YES",type,strUserID];
                    
                    [_dbPointer executeUpdate:@"insert into ReportToUser (id,Date,key1,key2,value1,value2,type,userid) values (?,?,?,?,?,?,?,?)",[RPBDataBase genUUID],strDate,strVendorId,@"",user.collegue.strUserId,@"YES",[NSNumber numberWithInteger:type],strUserID];
                }
                else
                {
                    //  str = [NSString stringWithFormat:@"insert into ReportToUser (id,Date,key1,key2,value1,value2,type,userid) values ('%@','%@','%@','%@','%@','%@','%d','%@')",[RPBDataBase genUUID],strDate,strVendorId,@"",user.strEmail,@"NO",type,strUserID];
                    [_dbPointer executeUpdate:@"insert into ReportToUser (id,Date,key1,key2,value1,value2,type,userid) values (?,?,?,?,?,?,?,?)",[RPBDataBase genUUID],strDate,strVendorId,@"",user.strEmail,@"NO",[NSNumber numberWithInteger:type],strUserID];
                }
            }
        }
    }
}

-(NSArray *)GetReportToUser:(NSString *)strUserID ReportType:(ReportToUserSaveType)type VendorId:(NSString *)strVendorId
{
    NSString * str = nil;
    if (strVendorId && strVendorId.length > 0)
         str = [NSString stringWithFormat:@"select * from ReportToUser where userid = '%@' and type = %d and key1 = '%@'",strUserID,type,strVendorId];
    else
         str = [NSString stringWithFormat:@"select * from ReportToUser where userid = '%@' and type = %d",strUserID,type];
   
    NSMutableArray * array = [[NSMutableArray alloc] init];
    id<PLResultSet> ds = [_dbPointer executeQuery:str];
    while ([ds next]) {
        InspReporterUser * user = [[InspReporterUser alloc] init];
        NSString * strBool = [ds objectForColumn:@"value2"];
        if ([strBool isEqualToString:@"YES"]) {
            user.bUserCollegue = YES;
            user.strEmail = [ds objectForColumn:@"value1"];
        }
        else
        {
            user.bUserCollegue = NO;
            user.strEmail = [ds objectForColumn:@"value1"];
        }
        [array addObject:user];
    }
    return array;
}

@end
