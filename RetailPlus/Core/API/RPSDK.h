//
//  RPSDK.h
//  RetailPlus
//
//  Created by lin dong on 13-11-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSDKDefine.h"
#import "RPOfflineData.h"
#import "Reachability.h"
#import "ASIDownloadCache.h"

#define kApplicationLogoutNotification @"ApplicationLogout"
#define kApplicationServerStatusNotify @"ServerStatusNotify"

typedef void(^RPSDKSuccess)(id idResult);
typedef void(^RPSDKFailed)(NSInteger nErrorCode,NSString * strDesc);
typedef void(^RPSDKProgress)(NSUInteger bytes, long long totalBytes, long long totalBytesExpected);

@interface RPSDK : NSObject
{
    NSDate *            _dateExpire;
    RPOfflineData *     _dataOffline;
    NSTimer *           _timerCheckSession;
    BOOL                _bKeyBoradShow;
}


@property (nonatomic,retain) NSString *         strToken;
@property (nonatomic,retain) NSString *         strApiBaseUrl;
@property (nonatomic,retain) UserDetailInfo *   userLoginDetail;
@property (nonatomic,retain) NSString *         strLoginPassword;
@property (nonatomic,retain) NSArray *          arrayLoginDevice;
@property (nonatomic,retain) NSArray *          arrayCareerList;
@property (nonatomic,retain) NSMutableArray *   arrayCacheData;
@property (nonatomic) long long                 llRights;
@property (nonatomic) long long                 llOwnedModel;
@property (nonatomic) BOOL                      bVoip;
@property (nonatomic) BOOL                      bDemoMode;
@property (nonatomic) BOOL                      bFirstOpen;

@property (nonatomic,retain) ASIDownloadCache * cacheDocumentLive;
@property (nonatomic,retain) ASIDownloadCache * cacheTraining;
@property (nonatomic,retain) ASIDownloadCache * cacheElearning;

//Static

+(NSString *)GetCacheDir;

+(NSString *)genUUID;

+(UIImage *)CropImage:(UIImage *)image withSize:(CGSize)size;

+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;

+(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;

+(UIImage *) loadImageFromURL:(NSString *)fileURL;

+(RPSDK *)defaultInstance;

+(NetworkStatus)GetConnectionStatus;

+(NSInteger)DateToYear:(NSDate *)date;

+(NSInteger)DateToQuarter:(NSDate *)date;

+(NSInteger)DateToMonth:(NSDate *)date;

+(NSInteger)DateToWeek:(NSDate *)date;

+(NSString *)numberFormatter:(NSNumber*)number;

+(NSString *)noStyleNumber:(NSNumber*)number;

+(NSString *)isValidPassword:(NSString *)strUserName Password:(NSString *)strPassword;

-(void)SetURL:(NSString *)strURL;


//for plus
-(NSString *)genURL:(NSString *)strURL;

-(NSMutableDictionary *)genBodyDataDict:(id)idApi withToken:(BOOL)bHasToken;

-(NSString *)ValidString:(NSDictionary *)dict forKey:(NSString *)strKey;
-(NSNumber *)ValidNumber:(NSDictionary *)dict forKey:(NSString *)strKey defaultValue:(NSInteger)nDefault;
-(NSNumber *)ValidDoubleNumber:(NSDictionary *)dict forKey:(NSString *)strKey defaultValue:(double)dDefault;
-(StoreDetailInfo *)CreateStoreDetailByDict:(NSDictionary *)dict;
-(NSDate *)ValidDate:(NSDictionary *)dict forKey:(NSString *)strKey;
-(UserDetailInfo *)CreateUserDetailByDict:(NSDictionary *)dict;
-(BOOL)SaveUploadCache:(NSDictionary *)dictBody Type:(CacheType)type Desc:(NSString *)strDesc;

//LocalData
-(NSString *)GetSid;

-(NSString *)GetSavedFullName;

-(NSString *)GetSavedLoginUserName;

-(NSString *)GetSavedPassword;

-(BOOL)IsAutoLogin;

-(void)SaveLoginUserName:(NSString *)strUserName FullName:(NSString *)strFullName Password:(NSString *)strPassword autoLogin:(BOOL)bAutoLogin;

-(void)SaveAutoRemindData:(AutoRemaindType)type Data:(NSMutableArray *)array;

-(NSMutableArray *)ReadAutoRemindData:(AutoRemaindType)type;

//System
-(BOOL)SetAvailableServer;

-(void)GetWeatherInfo:(NSString *)strWeatherCode success:(RPSDKSuccess)successBlock failed:(RPSDKFailed)failedBlock;

-(VersionModel *)CheckVersion:(NSString *)strCurrentVersion;

-(void)CheckVersion:(NSString *)strCurrentVersion Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)FeedBack:(NSString *)strContent Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)CheckAuthActionSta:(NSString *)strAuthCode Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)SendMessage:(SendMessageType)type Title:(NSString *)strTitle Detail:(NSString *)strDetail Member:(NSString *)strMembers Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)UpdateDeviceToken:(NSString *)strDeviceToken Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

//User
-(void)Login:(NSString *)strUserName PassWord:(NSString *)strPassWord DeviceID:(NSString *)strDeviceID DeviceName:(NSString *)strDeviceName VerifyCode:(NSString *)strVerifyCode Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)Logout;

-(void)ChangePWD:(NSString *)strOldPWD NewPassWord:(NSString *)strNewPWD Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)InviteUser:(NSString *)strPhone UserName:(NSString *)strUserName PositionID:(NSString *)strPositionID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)UpdateUserProfile:(UserProfileUpdate *)profile Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)SetLoginProtectionStatus:(BOOL)isProtect Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)UpdateDeviceName:(NSString *)strDeviceID DeviceName:(NSString *)strDeviceName Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)Quit:(NSString *)strUserId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)BoundEmail:(NSString *)strEmail SendEmail:(NSString *)strSendEmail Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetLoginDeviceList:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetUserDetailInfo:(NSString *)strUserID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetUserInfoList:(Rank)rank Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetUserRankCount:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetUserListByVendor:(SituationType)sitType VendorID:(NSString *)strVendorID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetReportToUser:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)RequestIdCert:(NSString *)strCertNO CertDevice:(CertDevice)certDeviceType CertType:(CertType)certType withLoginToken:(BOOL)bWithToken  Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)VerifyIdCert:(NSString *)strVerifyCode CertType:(CertType)certType Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetInviteRoleList:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetInvitePositionListByRole:(NSString *)strRoleID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetExistUserTagSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)SetUserTags:(NSString *)strUserId Tag1:(NSString *)strTag1 Tag2:(NSString *)strTag2 Tag3:(NSString *)strTag3 Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)LockUser:(NSString *)strUserId Lock:(BOOL)bLock Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)ResetPsw:(NSString *)strUserId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetPositionList:(NSString *)strUserId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)SetUserPosition:(NSString *)strUserId Position:(NSString *)strPositionId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)RemoveUserPosition:(NSString *)strUserId Position:(NSString *)strPositionId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)SetDefaultPosition:(NSString *)strUserId Position:(NSString *)strPositionId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)SetUserReportTo:(NSString *)strUserId ReportTo:(NSString *)strReportToId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

//Store
-(void)GetDomainListSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetStoreList:(SituationType)sitType Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetVendorList:(NSString *)strStoreID SituationType:(SituationType)sitType Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetAssetCategoryList:(NSString *)strStoreID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)UpdateStoreProfile:(StoreDetailInfo *)info Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

//Customer
-(void)GetCustomerCareerList:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetCustomerList:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)AddCustomer:(Customer *)customer Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)ModifyCustomer:(Customer *)customer Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)LinkageBreakCustomer:(NSString *)strCustomerId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetCustomerPurchaseList:(NSString *)strCustomerId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)DeleteCustomerPurchase:(NSString *)strCustomerId PurchaseId:(NSString *)strPurchaseId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)ModifyCustomerPurchase:(NSString *)strCustomerId Purchase:(CustomerPurchase *)purchase Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)AddCustomerPurchase:(NSString *)strCustomerId Purchase:(CustomerPurchase *)purchase Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

//Documents
-(void)GetDocumentList:(NSString *)strDocmentID GetDocType:(GetDocType)typeGet Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(NSArray *)GetUnfinishedDoc:(CacheType)type;

-(void)HaveLatestDocument:(NSString *)strDocmentID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)ForwardDocument:(NSString *)strDocmentID RecvUserList:(NSArray *)arrayUser RecvMailList:(NSArray *)arrayEmail Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)DeleteDocument:(NSString *)strDocmentID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)SetDocumentRead:(NSString *)strDocmentID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
//Reports
-(void)GetReports:(NSString *)strReportID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

//Infomation Center
-(void)GetICUnreadCountSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetICList:(NSString *)strLastID Type:(ICType)type GetNew:(BOOL)bGetNew GetCount:(NSInteger)nCount Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)PostBroadCastInfo:(NSString *)strInfo Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)PostMessage:(ICMsgFormat)format Content:(id)idSentContent RecvUser:(NSString *)strUserId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

//Task
-(void)AddTask:(NSMutableArray *)arrayTask Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetTaskList:(NSString *)strSearch IsFinished:(BOOL)bFinished IsInitiator:(BOOL)bInitiator IsExecutor:(BOOL)bExecutor Color:(ColorType)color TaskType:(TaskType)type Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)ForwardTask:(NSString *)strTaskId Executor:(NSString *)executorId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)deleteTask:(NSString *)strTaskId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)finishTask:(NSString *)strTaskId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)EditTask:(TaskInfo *)task Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)HasNewTaskSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)SetTaskRead:(TaskInfo *)info Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

//Business Local Cache
-(id)GetTaskCacheDataById:(NSString *)strCacheDataId CacheType:(CacheType)type;

-(id)GetTaskCacheData:(NSString *)strKey CacheType:(CacheType)type;

-(void)SubmitCacheData:(CachData *)data Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)ClearUploadCache:(NSString *)strId;

-(void)ClearCacheData:(NSString *)strStoreID CacheType:(CacheType)type;

-(void)ClearCacheDataById:(NSString *)strId;

-(void)SaveInspCacheData:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(InspData *)data isNormalExit:(BOOL)bNormal;

-(void)SaveVisitCacheData:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(CVisitData *)data isNormalExit:(BOOL)bNormal;

-(void)SaveMaintenCacheData:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(MaintenanceData *)data isNormalExit:(BOOL)bNormal;

-(NSString *)SaveBVisitCacheData:(NSString *)strStoreID Desc:(NSString *)strDesc Data:(BVisitData *)data isNormalExit:(BOOL)bNormal;

-(void)UpdateBVisitCacheData:(NSString *)strCacheDataId StroeId:(NSString *)strStoreID Desc:(NSString *)strDesc Data:(BVisitData *)data isNormalExit:(BOOL)bNormal;

-(void)SaveReportToUser:(ReportToUserSaveType)type Reporters:(NSArray *)arraySection;

-(void)GetReportToUser:(ReportToUserSaveType)type VendorId:(NSString *)strVendorId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

//Inspection
-(void)GetInspHistory:(NSString *)strStoreID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)SubmitInsp:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(InspData *)data Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)SubmitRectification:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(InspData *)data Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

//Store Visit
-(void)SubmitVisit:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(CVisitData *)data Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

//Store Mainten
-(void)SubmitMainten:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(MaintenanceData *)data Reporter:(InspReporters *)reports Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetStoreMntUserList:(NSString *)strStoreID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

//BVisiting
-(void)GetBVisitTemplate:(NSString *)strStoreID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetBVisitTemplateDetail:(NSString *)strTemplateId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)SubmitBVisit:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(BVisitData *)data Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)searchBVisitIssue:(NSString *)strSearch StartDate:(NSString*)startDate EndDate:(NSString*)endDate DomianId:(NSString *)domainId ReportId:(NSString *)reportId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)SubmitBVisitIssue:(BVisitIssueSearchData *)issueData Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetBVisitListSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetBVisitById:(NSString *)reportId  Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetBVisitIssueById:(NSString *)strIssueId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

//Log Book
-(void)GetLogBookList:(NSString *)strStoreId FiltMyPost:(BOOL)bFiltMyPost FiltUnRead:(BOOL)bFiltUnRead FiltFocus:(BOOL)bFiltFocus FiltTag:(NSString *)strTagId LastId:(NSString *)strLastLogBookId GetNew:(BOOL)bGetNew Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetLogBookCommentList:(NSString *)strStoreId LogBookId:(NSString *)strLogBookId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetLogBookDetail:(NSString *)strLogBookId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)PostLogBook:(NSString *)strStoreId Title:(NSString *)strTitle Desc:(NSString *)strDesc Images:(NSMutableArray *)arrayImage Tag:(NSString *)strTagId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)DeleteLogBook:(NSString *)strId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)FocusLogBook:(NSString *)strId Focus:(BOOL)bFocus Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)CommentLogBook:(NSString *)strStoreId LogBookID:(NSString *)strLogBookId Comment:(NSString *)strComment Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)SearchLogBook:(NSString *)strStoreId LastLogBookID:(NSString *)strLastLogBookId Condition:(NSString *)strSearch Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetLogBookTagSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
//KPI
-(void)GetKPISalesDataList:(NSString *)strStoreID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetKPITrafficDataList:(NSString *)strStoreID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)SetKPISalesData:(NSString *)strStoreID SalesData:(NSArray *)arraySale Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)SetKPITrafficData:(NSString *)strStoreID TrafficData:(NSArray *)arrayTraffic Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)DeleteKPISalesData:(NSString *)strStoreID Date:(NSString *)strDate Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)DeleteKPITrafficData:(NSString *)strStoreID Date:(NSString *)strDate Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetSubDomainKPIData:(NSString *)strParentDomainID DateRange:(KPIDateRange *)range Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

//CourtesyCall
-(void)GetCourtesyCallTypeSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)AddCourtesyCallInfo:(CourtesyCallInfo *)info Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)EditCourtesyCallInfo:(CourtesyCallInfo *)info Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)DeleteCourtesyCallInfo:(NSString *)strCoutesyCallInfoId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetCourtesyCallInfoList:(NSString *)strUserID isCompleted:(BOOL)bComplete Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetCourtesyCallInfoList:(NSString *)strStoreID Date:(NSDate *)date Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetCCPSubAccount:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)CompleteVoipCall:(CCPVoipCall *)call Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(void)GetCcInfoByStoreId:(NSString *)strStoreID Date:(NSDate *)date Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

//Training
-(void)GetTraningFolderDocsSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

//Live Video
-(void)GetLiveCameraList:(NSString *)strStoreID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

//Goods Tracking
-(void)GetGoodsTrackingInfo:(NSString *)strCode Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;

-(BOOL)InsertGoodsTrackingInfo:(GoodsTrackingInfo *)info;

-(BOOL)DeleteGoodsTrackingInfo:(NSString *)strTrackingID;

-(NSArray *)GetGoodsTrackingList:(NSString *)strFilter;

//Retail Consulting
-(void)UploadRetailConsult:(NSString *)strDetail Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
@end
