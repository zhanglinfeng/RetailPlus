//
//  RPOwnedModel.h
//  RetailPlus
//
//  Created by lin dong on 14-5-21.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    OwnedModelType_Inspection = 0,          //    1     项目验收
    OwnedModelType_Training,                //    2     培训课件管理
    OwnedModelType_Visiting,                //    4     店铺巡检
    OwnedModelType_Maintenance,             //    8     店铺报修
    OwnedModelType_Logbook,                 //    16	交接记录
    OwnedModelType_BVisiting,               //    32	零售巡店
    OwnedModelType_CCall,                   //    64	问候回访
    OwnedModelType_LiveVideo,               //    128	视频直播
    OwnedModelType_KPI,                     //    256	KPI管理
    OwnedModelType_Construction,            //    512	工程管理
    OwnedModelType_CodeQuery,               //    1024	货品追踪
    OwnedModelType_CCPVoid,                 //    2048  容联平台问候回访
    OwnedModelType_Visual,                  //    4096  视觉陈列
    OwnedModelType_DailyStock,              //    8192  点数本
    OwnedModelType_ELearning                //    16384 在线培训
}RPOwnedModelType;

struct OwnedModelStru {
    RPOwnedModelType    type;
    long long           llModelBit;
};

@interface RPOwnedModel : NSObject

+(BOOL)hasModelFunc:(long long)lModelMap type:(RPOwnedModelType)type;

@end
