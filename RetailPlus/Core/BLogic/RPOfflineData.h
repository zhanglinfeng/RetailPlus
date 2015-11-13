//
//  RPOfflineData.h
//  RetailPlus
//
//  Created by lin dong on 13-10-25.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PlausibleDatabase/PlausibleDatabase.h>

typedef void(^RPRuntimeOfflineSuccess)(id idResult);
typedef void(^RPRuntimeOfflineFailed)(NSInteger nErrorCode,NSString * strDesc);

@interface RPOfflineData : NSObject
{
    PLSqliteDatabase        * _dbPointer;
}

+(RPOfflineData *)defaultInstance;

-(void)Login:(NSString *)strUserName PassWord:(NSString *)strPassWord success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock;

-(void)GetUserInfo:(NSString *)strUserID success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock;

-(void)GetColleagueCountSuccess:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock;

-(void)GetCustomerSuccess:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock;

-(void)GetColleague:(NSInteger)nRoleLevel success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock;

-(void)GetStoreList:(BOOL)bOwn Success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock;

-(void)GetMCReports:(NSString *)strReportID success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock;

-(void)GetInspCatagory:(NSString *)strStoreID success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock;

-(void)GetInspReports:(NSString *)strStoreID success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock;

-(void)GetVendors:(NSString *)strStoreID success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock;

-(void)GetUserListByVendor:(NSString *)strVendorID success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock;

-(void)GetMaintenStoreColleague:(NSString *)strStoreID success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock;

@end
