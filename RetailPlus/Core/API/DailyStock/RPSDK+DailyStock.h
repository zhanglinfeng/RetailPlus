//
//  RPSDK+DailyStock.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-14.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPSDK.h"
#import "RPSDKDSDefine.h"
@interface RPSDK (DailyStock)
-(void)GetStoreStock:(NSString *)strStoreID SN:(NSInteger)sn IsLatest:(BOOL)isLatest IsQuery:(BOOL)isQuery Query:(NSString *)query Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)PostStoreStockCount:(NSString *)strStoreID SN:(NSInteger)sn Count:(NSInteger)count Tag1:(NSString *)tag1 Tag2:(NSString *)tag2 Tag3:(NSString *)tag3 Comments:(NSString *)comments Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)GetTagList:(NSString *)strStoreID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)GetStoreStockDetail:(NSString *)strStoreID SN:(NSInteger)sn Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)PostStoreStockIOCount:(NSString *)strStoreID Type:(RPDSIOType)type SN:(NSInteger)sn Count:(NSInteger)count Tag1:(NSString *)tag1 Tag2:(NSString *)tag2 Tag3:(NSString *)tag3 Comments:(NSString *)comments Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)FinishStockTaking:(NSString *)strStoreID SN:(NSInteger)sn Comments:(NSString *)comments Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)DeleteStockDetail:(NSString *)strCountID Type:(NSString *)type Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
@end
