//
//  RPRights.m
//  RetailPlus
//
//  Created by lin dong on 14-4-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPRights.h"
#import "SVProgressHUD.h"

const struct RightsStru rights[] = {
    {RPRightsFuncType_BroadCastMsg, 0x2000000,""},
    {RPRightsFuncType_InviteUser, 0x20000,""},
    {RPRightsFuncType_Customer, 0x400,""},
    {RPRightsFuncType_CheckAllDomainDoc, 0x4000000,""},
    {RPRightsFuncType_InputKPITraffic, 0x800000,""},
    {RPRightsFuncType_InputKPISales, 0x1000000,""},
    {RPRightsFuncType_CheckColleagueCCRecord, 0x200000,""},
    {RPRightsFuncType_SubmitInspectionReport, 0X10,""},
    {RPRightsFuncType_SubmitRectifyReport, 0x8,""},
    {RPRightsFuncType_SubmitCVisitReport, 0x4,""},
    {RPRightsFuncType_SubmitMaintainReport, 0x1,""},
    {RPRightsFuncType_SubmitBVisitReport, 0x100000,""},
    {RPRightsFuncType_LiveVideo, 0x400000,""},
    {RPRightsFuncType_LogBook,0x20000000,""},
    {RPRightsFuncType_InfoLive,0x10000000,""},
    
    {RPRightsFuncType_VisualCheck,0x40000000,""},
    {RPRightsFuncType_VisualSubmit,0x80000000,""},
    {RPRightsFuncType_VisualReply,0x100000000,""},
    {RPRightsFuncType_VisualModifyStatus,0x200000000,""},
    
    {RPRightsFuncType_DailyStockMng,0x400000000,""},
};

#define RIGHTS_COUNT 20

@implementation RPRights
+(BOOL)hasRightsFunc:(long long)lRightsMap type:(RPRightsFuncType)type
{
    if ([RPSDK defaultInstance].bDemoMode) return YES;
    
    for (NSInteger n = 0; n < RIGHTS_COUNT; n ++) {
        if (rights[n].type == type)
        {
            long long lRet = rights[n].llRightsBit & lRightsMap;
            if (lRet > 0)
                return YES;
            return NO ;
        }
    }
    return NO;
}

+(void)ShowRightsError:(RPRightsFuncType)type
{
    for (NSInteger n = 0; n < RIGHTS_COUNT; n++) {
        if (type == rights[n].type) {
            NSString * str = [NSString stringWithCString:rights[n].strError encoding:NSUTF8StringEncoding];
            [SVProgressHUD showErrorWithStatus:str];
            return;
        }
    }
}
@end
