//
//  RPConfDBMng.h
//  RetailPlus
//
//  Created by lin dong on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPConfDefine.h"

@interface RPConfDBMng : NSObject
{
    PLSqliteDatabase        * _dbPointer;
}

+(RPConfDBMng *)defaultInstance;

//Mng Conf Accounts
-(void)SaveConfAccounts:(NSMutableArray *)arrayAccounts LoginUser:(NSString *)strID;
-(NSMutableArray *)LoadConfAccounts:(NSInteger)nMaxCount LoginUser:(NSString *)strID;

//Call History
-(void)SaveConfHistory:(NSString *)strTheme HostPhone:(NSString *)strHostPhone Guests:(NSMutableArray *)array Date:(NSDate *)date LoginUser:(NSString *)strID;
-(NSMutableArray *)GetConfHistory:(NSString *)strID;
-(void)DeleteConfHistory:(NSString *)strConfId;

@end
