//
//  RPConfDBMng.m
//  RetailPlus
//
//  Created by lin dong on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPConfDBMng.h"

#define kDBConfCallFileName  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"RPConfCall.sqlite"]

@implementation RPConfDBMng

static RPConfDBMng *defaultObject;

+(RPConfDBMng *)defaultInstance
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
        _dbPointer = [[PLSqliteDatabase alloc] initWithPath:kDBConfCallFileName];
        if (_dbPointer) {
            if ([_dbPointer open]) {
                [_dbPointer executeUpdate:@"CREATE TABLE \"ConfCallAccount\" (\"ID\" TEXT PRIMARY KEY, \"UserName\" TEXT, \"PassWord\" TEXT, \"IsChecked\" BOOLEAN,\"IsInited\" BOOLEAN,\"UserId\" TEXT)"];
                
                [_dbPointer executeUpdate:@"CREATE TABLE \"ConfCallHistory\" (\"ID\" TEXT PRIMARY KEY, \"Theme\" TEXT, \"HostPhone\" TEXT, \"CallDate\" TEXT,\"UserId\" TEXT)"];
                
                [_dbPointer executeUpdate:@"CREATE TABLE \"ConfCallHistoryGuest\" (\"ID\" TEXT PRIMARY KEY, \"CallHistoryID\" TEXT, \"Phone\" TEXT,\"Name\" TEXT, \"mail\" TEXT,\"UserId\" TEXT)"];
                
                return self;
            }
        }
    }
    return nil;
}

-(void)SaveConfAccounts:(NSMutableArray *)arrayAccounts LoginUser:(NSString *)strID
{
    [_dbPointer beginTransaction];
    NSString * str = @"delete from ConfCallAccount";
    if ([_dbPointer executeUpdate:str])
    {
        for (RPConfAccount * account in arrayAccounts) {
         //   NSString * str = [NSString stringWithFormat:@"insert into ConfCallAccount (ID,UserName,PassWord,IsChecked,IsInited,UserId) values ('%@','%@','%@',%d,%d,'%@')",account.strID,account.strUserName,account.strPassWord,account.bChecked,account.bInited,strID];
            [_dbPointer executeUpdate:@"insert into ConfCallAccount (ID,UserName,PassWord,IsChecked,IsInited,UserId) values (?,?,?,?,?,?)",account.strID,account.strUserName,account.strPassWord,[NSNumber numberWithBool:account.bChecked],[NSNumber numberWithBool:account.bInited],strID];
        }
    }
    [_dbPointer commitTransaction];
}

-(NSMutableArray *)LoadConfAccounts:(NSInteger)nMaxCount LoginUser:(NSString *)strID
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    for (NSInteger n = 1; n < (nMaxCount + 1); n ++) {
        NSString * str = [NSString stringWithFormat:@"select * from ConfCallAccount where id = %d and UserId = '%@'",n,strID];
        RPConfAccount * account = [[RPConfAccount alloc] init];
        account.strID = [NSString stringWithFormat:@"%d",n];
        
        id<PLResultSet> ds = [_dbPointer executeQuery:str];
        if ([ds next]) {
            account.strUserName = [ds objectForColumn:@"UserName"];
            account.strPassWord = [ds objectForColumn:@"PassWord"];
            account.bChecked = [ds boolForColumn:@"IsChecked"];
            account.bInited = [ds boolForColumn:@"IsInited"];
        }
        else
        {
            account.strUserName = @"";
            account.strPassWord = @"";
            account.bChecked = NO;
            account.bInited = NO;
        }
        
        [array addObject:account];
    }
    return array;
}

- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString ;
}


-(void)SaveConfHistory:(NSString *)strTheme HostPhone:(NSString *)strHostPhone Guests:(NSMutableArray *)array Date:(NSDate *)date LoginUser:(NSString *)strID
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString * strGuid = [self getUniqueStrByUUID];
    
    [_dbPointer beginTransaction];
  //  NSString * str = [NSString stringWithFormat:@"insert into ConfCallHistory (ID,Theme,HostPhone,CallDate,UserId) values ('%@','%@','%@','%@','%@')",strGuid,strTheme,strHostPhone,[formatter stringFromDate:date],strID];
    [_dbPointer executeUpdate:@"insert into ConfCallHistory (ID,Theme,HostPhone,CallDate,UserId) values (?,?,?,?,?)",strGuid,strTheme,strHostPhone,[formatter stringFromDate:date],strID];
    
    for (RPConfGuest * guest in array) {
   //     NSString * str = [NSString stringWithFormat:@"insert into ConfCallHistoryGuest (ID,CallHistoryID,Phone,mail,Name,UserId) values ('%@','%@','%@','%@','%@','%@')",[self getUniqueStrByUUID],strGuid,guest.strPhone,guest.strEmail,guest.strGuestName,strID];
        [_dbPointer executeUpdate:@"insert into ConfCallHistoryGuest (ID,CallHistoryID,Phone,mail,Name,UserId) values (?,?,?,?,?,?)",[self getUniqueStrByUUID],strGuid,guest.strPhone,guest.strEmail,guest.strGuestName,strID];
    }
    
    [_dbPointer commitTransaction];
}

-(NSMutableArray *)GetConfHistory:(NSString *)strID
{
    NSMutableArray * arrayRet = [[NSMutableArray alloc] init];
    
    NSString * str = [NSString stringWithFormat:@"select * from ConfCallHistory where UserId = '%@'",strID];
    id<PLResultSet> ds = [_dbPointer executeQuery:str];
    while ([ds next]) {
        RPConf * conf = [[RPConf alloc] init];
        conf.strID = [ds objectForColumn:@"ID"];
        conf.strCallTheme = [ds objectForColumn:@"Theme"];
        if (conf.strCallTheme == (id)[NSNull null]) {
            conf.strCallTheme = @"";
        }
        
        conf.strHostPhone = [ds objectForColumn:@"HostPhone"];
        NSString * strDate = [ds objectForColumn:@"CallDate"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        conf.dateCallHistory = [formatter dateFromString:strDate];
        
        conf.arrayGuest = [[NSMutableArray alloc] init];
        
        RPConfGuest * guest = [[RPConfGuest alloc] init];
        guest.strPhone = conf.strHostPhone;
        guest.strEmail = @"";
        [conf.arrayGuest addObject:guest];
        
        NSString * str = [NSString stringWithFormat:@"select * from ConfCallHistoryGuest where UserId = '%@' and CallHistoryID = '%@'",strID,conf.strID];
        id<PLResultSet> ds2 = [_dbPointer executeQuery:str];
        while ([ds2 next]) {
            RPConfGuest * guest = [[RPConfGuest alloc] init];
            guest.strPhone = [ds2 objectForColumn:@"Phone"];
            if (guest.strPhone == (id)[NSNull null]) {
                guest.strPhone = @"";
            }
            guest.strEmail = [ds2 objectForColumn:@"mail"];
            if (guest.strEmail == (id)[NSNull null]) {
                guest.strEmail = @"";
            }
            guest.strGuestName = [ds2 objectForColumn:@"Name"];
            if (guest.strGuestName == (id)[NSNull null]) {
                guest.strGuestName = @"";
            }
            
            [conf.arrayGuest addObject:guest];
        }
        [arrayRet addObject:conf];
    }
    return arrayRet;
}

-(void)DeleteConfHistory:(NSString *)strConfId
{
    NSString * str1 = [NSString stringWithFormat:@"delete from ConfCallHistory where ID = '%@'",strConfId];
    NSString * str2 = [NSString stringWithFormat:@"delete from ConfCallHistoryGuest where CallHistoryID = '%@'",strConfId];
    [_dbPointer executeUpdate:str1];
    [_dbPointer executeUpdate:str2];
}
@end
