//
//  RPOwnedModel.m
//  RetailPlus
//
//  Created by lin dong on 14-5-21.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPOwnedModel.h"

@implementation RPOwnedModel

const struct OwnedModelStru models[] = {
    {OwnedModelType_Inspection,0x00000001},
    {OwnedModelType_Training,0x00000002},
    {OwnedModelType_Visiting,0x00000004},
    {OwnedModelType_Maintenance,0x00000008},
    {OwnedModelType_Logbook,0x00000010},
    {OwnedModelType_BVisiting,0x00000020},
    {OwnedModelType_CCall,0x00000040},
    {OwnedModelType_LiveVideo,0x00000080},
    {OwnedModelType_KPI,0x00000100},
    {OwnedModelType_Construction,0x00000200},
    {OwnedModelType_CodeQuery,0x00000400},
    {OwnedModelType_CCPVoid,0x00000800},
    {OwnedModelType_Visual,0x00001000},
    {OwnedModelType_DailyStock,0x00002000},
    {OwnedModelType_ELearning,0x00004000},
};

#define OWNEDMODELS_COUNT 15

+(BOOL)hasModelFunc:(long long)lModelMap type:(RPOwnedModelType)type
{
    if ([RPSDK defaultInstance].bDemoMode) return YES;
    
    for (NSInteger n = 0; n < OWNEDMODELS_COUNT; n ++) {
        if (models[n].type == type)
        {
            long long lRet = models[n].llModelBit & lModelMap;
            if (lRet > 0)
                return YES;
            return NO ;
        }
    }
    return NO;
}
@end
