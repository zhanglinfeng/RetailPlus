//
//  RPSDKDSDefine.h
//  RetailPlus
//
//  Created by lin dong on 14-7-10.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "RPSDKDSDefine.h"

typedef enum
{
    RPDSIOType_In = 1,
    RPDSIOType_Out=-1,
}RPDSIOType;

@interface RPDSTag : NSObject
@property (nonatomic,retain) NSString * strTagName;
@end

@interface RPDSCurrentStock : NSObject
@property (nonatomic,retain) NSString       * strCountId;
@property (nonatomic,retain) NSDate         * dateAdd;
@property (nonatomic,retain) UserDetailInfo * userInfo;
@property (nonatomic) NSInteger               nCount;
@end

@interface RPDSIOStock : NSObject
@property (nonatomic,retain) NSString       * strCountId;
@property (nonatomic,retain) NSDate         * dateAdd;
@property (nonatomic,retain) UserDetailInfo * userInfo;
@property (nonatomic,retain) NSString       * strComment;
@property (nonatomic) NSInteger               nCount;
@property (nonatomic) RPDSIOType              typeIO;
@end

@interface RPDSDetail : NSObject
@property (nonatomic,retain) NSString       * strStockDetailId;
@property (nonatomic,retain) NSString       * strStoreId;
@property (nonatomic,retain) NSString       * SN;
@property (nonatomic,retain) NSMutableArray * arrayTags; //RPDSTag队列
@property (nonatomic,retain) NSMutableArray * arrayIO; //RPDSIOStock队列
@property (nonatomic,retain) NSMutableArray * arrayCurrent; //RPDSCurrentStock队列
@property (nonatomic,retain) NSMutableArray * arrayLast; //RPDSCurrentStock队列
@property (nonatomic) NSInteger             nLastAmount;
@property (nonatomic) NSInteger             nInAmount;
@property (nonatomic) NSInteger             nOutAmount;
@property (nonatomic) NSInteger             nCurrentAmount;
@end

@interface StoreStockList : NSObject
@property (nonatomic,assign) NSInteger              SN;//点数账期
@property (nonatomic,retain) NSDate         * openTime;
@property (nonatomic,retain) NSDate         * closeTime;
@property (nonatomic,retain) NSString       * strCloseUserId;
@property (nonatomic,retain) NSString       * strComments;
@property (nonatomic,assign) NSInteger              countAmount;//点数数量
@property (nonatomic,assign) NSInteger              lastAmount;
@property (nonatomic,assign) NSInteger              inAmount;
@property (nonatomic,assign) NSInteger              outAmount;
@property (nonatomic,assign) NSInteger              balanceAmount;//应得期末数量
@property (nonatomic,retain)UserDetailInfo         * userInfo;
@end

@interface FavTagList : NSObject
@property (nonatomic,retain) NSMutableArray * arrayTag;
@property (nonatomic)BOOL                     isLast;

@end