//
//  RPRights.h
//  RetailPlus
//
//  Created by lin dong on 14-4-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>

//Rights
typedef enum
{
    RPRightsFuncType_BroadCastMsg = 0,                          //群发消息
    RPRightsFuncType_InviteUser,                                //邀请用户
    RPRightsFuncType_Customer,                                  //客户相关
    
    RPRightsFuncType_CheckAllDomainDoc,                         //查看组织下全部文档
    
    RPRightsFuncType_CheckColleagueCCRecord,                    //查看其他员工回访记录
    
    RPRightsFuncType_SubmitInspectionReport,                    //提交验收报告
    RPRightsFuncType_SubmitRectifyReport,                       //提交整改报告
    RPRightsFuncType_SubmitCVisitReport,                        //提交巡店报告
    RPRightsFuncType_SubmitMaintainReport,                      //提交维修报告
    RPRightsFuncType_SubmitBVisitReport,                        //提交零售巡店报告
    RPRightsFuncType_LiveVideo,                                 //视频直播
    RPRightsFuncType_InputKPITraffic,                           //客流数据录入
    RPRightsFuncType_InputKPISales,                             //销量数据录入
    RPRightsFuncType_LogBook,                                   //交接记录
    RPRightsFuncType_InfoLive,                                  //Info Live查看
    
    RPRightsFuncType_VisualCheck,                               //查看视觉陈列
    RPRightsFuncType_VisualSubmit,                              //提交视觉陈列
    RPRightsFuncType_VisualReply,                               //提交陈列回复
    RPRightsFuncType_VisualModifyStatus,                        //更改陈列状态
    
    RPRightsFuncType_DailyStockMng,                             //点数本管理
    
    //    RPRightsFuncType_GetCustomerList,                           //获取客户列表
    //    RPRightsFuncType_GetUserList,                               //获取通讯录用户列表
    //    RPRightsFuncType_GetStoreList,                              //获取店铺列表
    //    RPRightsFuncType_CheckTrainDoc,                             //获取文档列表
}RPRightsFuncType;

struct RightsStru {
    RPRightsFuncType    type;
    long long           llRightsBit;
    char                * strError;
};


@interface RPRights : NSObject

+(BOOL)hasRightsFunc:(long long)lRightsMap type:(RPRightsFuncType)type;

+(void)ShowRightsError:(RPRightsFuncType)type;

@end
