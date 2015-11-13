//
//  RPBLogic.h
//  RetailPlus
//
//  Created by lin dong on 13-8-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPBData.h"
#import "RPOfflineData.h"

typedef void(^RPRuntimeSuccess)(id dictResult);
typedef void(^RPRuntimeFailed)(NSInteger nErrorCode,NSString * strDesc);

#define API_VERSION             @"1.0"
#define API_TIMEOUTINTERVAL     60
#define API_APPKEY              @"87654321"
#define API_SECRET              @"12345678901234567890123456789012"

@interface RPBLogic : NSObject
{
    NSString        * _strSession;
    RPOfflineData   * _dataOffline;
}

@property (nonatomic,retain) NSString       * strApiBaseUrl;
@property (nonatomic,retain) RPColleague    * colleagueLoginUser;
@property (nonatomic,retain) RPLoginUserProfile * loginProfile;
@property (nonatomic,retain) RPSimUserInfo  * simUserInfo;
@property (nonatomic,retain) NSString       * strLoginUserName;
@property (nonatomic,retain) NSMutableArray * arrayCacheData;
@property (nonatomic)        BOOL           bDemoMode;
@property (nonatomic)        BOOL           bLoginProtection;
@property (nonatomic,retain) NSMutableArray * arrayLoginDevice;

+(NSString *) genUUID;
+(NSString *) GetCacheDir;

+ (UIImage *)CropImage:(UIImage *)image withSize:(CGSize)size;
+(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;
+(UIImage *) loadImageFromURL:(NSString *)fileURL;
+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;

+(RPBLogic *)defaultInstance;

-(NSString *)GetSavedLoginUserName;

-(NSString *)GetSavedPassword;

-(void)Login:(NSString *)strUserName PassWord:(NSString *)strPassWord success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)Logout;

-(void)SetUrl:(NSString *)strUrl;

-(void)SaveLoginUserName:(NSString *)strUserName Password:(NSString *)strPassword autoLogin:(BOOL)bAutoLogin;

-(void)GetLoginDeviceSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)SubmitFeedback:(NSString *)strFeedBack Success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)QuitEnterpriseSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)GetLoginUserProfileSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)ChangePsw:(NSString *)strUserName OldPassWord:(NSString *)strPassWordOld PassWord:(NSString *)strPassWord success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)RequestIdCert:(NSString *)strCertNo DeviceType:(CERTDEVICETYPE)deviceType CertType:(CERTTYPE)certType success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)VerifyIdCert:(NSString *)strVerifyCode CertType:(CERTTYPE)certType success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)SignUpGetVerifyCode:(NSString *)strPhoneNo success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)SignUpVerifyCode:(NSString *)strPhoneNo VerifyCode:(NSString *)strVerifyCode success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)SignUpSetPsw:(NSString *)strPhoneNo PassWord:(NSString *)strPassWord success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)GetSimUserInfoSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)BoundEmail:(NSString *)strEmail SendEmail:(NSString *)strEmailSend Success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)ModifyUserProfile:(NSString *)strFirstName Email:(NSString *)strEmail Image:(UIImage *)image Sex:(RPSex)sex success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)GetUserInfo:(NSString *)strUserID success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)GetStoreListSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)GetMCReports:(NSString *)strReportID success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)GetInspCatagory:(NSString *)strStoreID success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)GetInspReports:(NSString *)strStoreID success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)SubmitRectification:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(RPInspData *)data success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)SubmitInsp:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(RPInspData *)data success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)SubmitVisit:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(RPCVisitData *)data success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)SubmitMainten:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(RPMaintenanceData *)data Reporter:(RPInspReporters *)reports success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)GetColleagueByVendor:(NSString *)strVendorId success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)GetColleagueCountSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)GetUsableRoleListSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)GetRoleUsableContent:(NSString *)strRoleID success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)GetColleague:(NSInteger)nRoleLevel success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)GetCustomerSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)InviteUser:(NSString *)strPhone RoleID:(NSString *)strRoleID RangeID:(NSString *)strRangeId
        RoleRange:(RPRoleLevel)level success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)AddCustomer:(RPCustomer *)customer success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)GetAllStoreListSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;


-(void)GetMaintenVendor:(NSString *)strStoreID success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)GetMaintenStoreColleague:(NSString *)strStoreID success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

-(void)SubmitCacheData:(RPCachData *)data success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock;

//cache task function
-(void)SaveInspCacheData:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(RPInspData *)data isNormalExit:(BOOL)bNormal;

-(void)SaveVisitCacheData:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(RPCVisitData *)data isNormalExit:(BOOL)bNormal;

-(void)SaveMaintenCacheData:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(RPMaintenanceData *)data isNormalExit:(BOOL)bNormal;

-(id)GetTaskCacheData:(NSString *)strStoreID CacheType:(CacheType)type;

-(void)ClearCacheData:(NSString *)strStoreID CacheType:(CacheType)type;
@end
