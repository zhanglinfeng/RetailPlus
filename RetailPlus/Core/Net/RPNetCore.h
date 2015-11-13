//
//  RPNetCore.h
//  RetailPlus
//
//  Created by lin dong on 13-8-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPBLogic.h"

//用户登录
#define kAPIUserLogin               @"User/Login"

//获取用户验证信息
#define kAPIGetSimUserInfo          @"Common/GetSimUserInfo"

//获取登陆用户信息
#define kAPIGetProfile              @"UserProfile/GetProfile"

//提交反馈
#define kAPISubmitFeedback          @"FeedBack/SendMessage"

//获取登陆设备
#define kAPIGetLoginDevice          @"Common/GetLoginDevice"

//退出公司
#define kAPIQuitOwner               @"User/QuitOwner"

//绑定邮箱
#define kAPIBoundEmail              @"Common/BoundEmail"

//获取通用验证码
#define kAPIRequestIdcert           @"Common/RequestIdcert"

//验证通用验证码
#define kAPIVerifyIdcert            @"Common/VerifyIdcert"

//获取验证码
#define kAPIGetCheckCode            @"User/GetCheckCode"

//验证验证码
#define kAPICheckCode               @"User/CheckCode"

//验证设置密码
#define kAPISetPassword             @"User/SetPassword"

//修改用户信息
#define kAPIModifyUserProfile       @"User/Update"

//获取邀请用户可用角色
#define kAPIGetUsableRoleList       @"Contacts/GetUsableRoleList"

//邀请用户
#define kAPIInviteUser              @"Contacts/InviteUser"

//邀请用户
#define kAPIAddCustomer             @"Contacts/AddCustomer"

//获取角色可选内容列表
#define kAPIGetRoleUsableContent    @"Contacts/GetRoleUsableContent"

//获取用户根据角色等级统计信息
#define kAPIGetUserLevelCount       @"/Contacts/UserLevelCount"

//获取用户列表
#define kAPIGetUserList             @"Contacts/GetUserList"

//获取用户信息
#define kAPIGetUserInfo             @"Common/GetUserById"

//修改密码
#define kAPIUpdatePwd               @"User/UpdatePwd"

//获取客户列表
#define kAPIGetCustomerList         @"/Contacts/GetCustomerList"

//获取店铺列表
#define kAPIGetAllStoreList         @"Common/GetStoreList"

//获取店铺列表
#define kAPIGetStoreListByUser      @"Store/GetStoreListByUserId"

//获取通知中心文档
#define kAPIGetMCReports            @"Message/GetMessage"

//获取验收类目
#define kAPIGetInspCatagory         @"Store/GetCategoryList"

//获取验收报告列表
#define kAPIGetInspReports          @"Store/GetInspection"

//提交验收报告列表
#define kAPIUploadInspection        @"Store/UploadInspection"

//提交整改报告列表
#define kAPIUploadRectification     @"Store/UploadRectification"

//提交巡检报告
#define kAPIUploadStoreVisit        @"Store/UploadStoreVisit"

//根据供应商获取用户
#define kAPIGetColleagueByVendor    @"Store/GetUserByVendorId"


//获取维修供应商
#define kAPIGetMaintenVendor        @"Store/GetVendorByStoreId"

//获取维修联系人列表
#define kAPIGetStoreColleague       @"Store/GetStoreAllUser"

//提交维修报告列表
#define kAPIUploadMainten           @"Store/UploadStoreMnt"



@interface RPNetCore : NSObject

+(void)doRequestBySimple:(NSString *)strMethod withHead:(NSDictionary *)dictHead withBody:(NSArray *)arrayBody success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

+(void)doRequest:(NSString *)strMethod withHead:(NSDictionary *)dictHead withBody:(NSDictionary *)dictBody success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

+(void)doRequest:(NSString *)strMethod withHead:(NSDictionary *)dictHead withBodyString:(NSString *)strBody success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

@end
