//
//  RPSDK+VisualMerchandising.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

//#import "RPSDK.h"
#import "RPSDKVMDefine.h"

@interface RPSDK (VisualMerchandising)

-(void)GetVisualDisplayAttachmentsSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)getVisualStoreList:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(float)ValidFloatNumber:(NSDictionary *)dict forKey:(NSString *)strKey defaultValue:(float)dDefault;
-(void)AddFollowStore:(NSArray *)arrayStore Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)DelFollowStore:(NSArray *)arrayStore Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)GetVisualDisplayList:(NSString *)FollowStoreId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)AddVisualDisplayModel:(NSString *)storeId Title:(NSString *)title Comment:(NSString*)comment X:(float)x Y:(float)y Images:(NSMutableArray *)arrayImg Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)GetStoreInfo:(NSString *)storeId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)AddReplyModel:(NSString *)visualDisplayId StoreId:(NSString *)storeId Type:(int)type Comments:(NSString *)comments ImageArray:(NSMutableArray *)arrayImg Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)GetReplyList:(NSString *)visualDisplayId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)AddReference:(NSString *)visualDisplayId StoreId:(NSString *)storeId Type:(int)type Comments:(NSString *)comments ImageArray:(NSMutableArray *)arrayImg Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)UpdateVisualDisplayStatus:(NSString *)visualDisplayId Status:(int)states Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)DelReply:(NSString *)visualDisplayDetailId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
@end
