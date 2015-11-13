//
//  RPSDKDefine.h
//  RetailPlus
//
//  Created by lin dong on 13-11-27.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    DeviceType_IOS  = 0,
    DeviceType_Android,
}DeviceType;

typedef enum
{
    VersionStatus_Latest = 0,
    VersionStatus_recommend,
    VersionStatus_Force,
}VersionStatus;

typedef enum
{
    SituationType_NotAssign = 0,
    SituationType_Inspection,
    SituationType_Visit,
    SituationType_Maintenance,
    SituationType_Rectification,
    SituationType_BVisit,
    SituationType_LiveVideo,
    SituationType_CourtesyCall,
    SituationType_KPIInput,
    SituationType_LogBook,
    SituationType_ModifyCustomer,
}SituationType;

typedef enum
{
    CertDevice_Phone = 0,
    CertDevice_Email,
}CertDevice;

typedef enum
{
    CertType_SignUp = 1,
    CertType_ChangePWD,
    CertType_ChangeBoundMail,
    CertType_LoginProtect,
}CertType;

typedef enum
{
    Sex_NotAssign = 1,
    Sex_Male,
    Sex_Female,
}Sex;

typedef enum
{
  Rights_Insp = 1,
  Rights_CVisit = 2,
  Rights_Mainten = 4,
  Rights_Rectification = 8,
}Rights;

typedef enum
{
    Rand_All = 0,
    Rank_Manager = 1,
    Rank_StoreManager,
    Rank_Assistant,
    Rank_Vendor,
}Rank;

typedef enum
{
    SendMessageType_SMS = 0,
    SendMessageType_Mail,
}SendMessageType;

typedef enum
{
    ReportToUserSaveType_Insp = 0,
    ReportToUserSaveType_Rectification,
    ReportToUserSaveType_Maintenance,
    ReportToUserSaveType_Visit,
    ReportToUserSaveType_BVisit
}ReportToUserSaveType;

@interface VersionModel : NSObject
@property (nonatomic,retain) NSString * strDownloadURL;
@property (nonatomic,retain) NSString * strVersionDesc;
@property (nonatomic,retain) NSString * strVersionNum;
@property (nonatomic) VersionStatus status;
@end

@interface LoginDevice : NSObject
@property (nonatomic,retain) NSString * strDeviceName;
@property (nonatomic,retain) NSString * strDeviceType;
@property (nonatomic,retain) NSString * strDeviceUUID;
@property (nonatomic,retain) NSString * strLastLoginDate;
@property (nonatomic,retain) NSString * strLoginDeviceId;
@end

typedef enum
{
    AutoRemaindType_SubmitEmail = 0,
    AutoRemaindType_CountTag,
    AutoRemaindType_EditUserTag,
}AutoRemaindType;

//User
typedef enum
{
    UserStatus_Locked = 0,
    UserStatus_Normal,
}UserStatusType;

@interface UserRankCount : NSObject
@property (nonatomic) NSInteger nCountManager;
@property (nonatomic) NSInteger nCountStoreManager;
@property (nonatomic) NSInteger nCountAssistant;
@property (nonatomic) NSInteger nCountVendor;
@end

@interface RPPosition : NSObject
@property (nonatomic,retain) NSString * strPositionId;
@property (nonatomic,retain) NSString * strPositionName;
@property (nonatomic,retain) NSString * strRoleId;
@property (nonatomic,retain) NSString * strRoleName;
@property (nonatomic)Rank rank;
@end

@interface UserDetailInfo : NSObject
@property (nonatomic,retain) NSString * strUserId;
@property (nonatomic,retain) NSString * strUserCode;
@property (nonatomic,retain) NSString * strUserAcount;
@property (nonatomic,retain) NSString * strUserEmail;
@property (nonatomic,retain) NSString * strFirstName;
//@property (nonatomic,retain) NSString * strSurName;
@property (nonatomic,retain) NSString * strPortraitImg;
@property (nonatomic,retain) NSString * strPortraitImgBig;
@property (nonatomic,retain) NSString * strAlternatePhone;
@property (nonatomic,retain) NSString * strInterest;
@property (nonatomic,retain) NSString * strBirthDate;
@property (nonatomic) NSInteger nBirthYear;
@property (nonatomic) Sex sex;
@property (nonatomic) BOOL IsPublicAge;
@property (nonatomic) BOOL IsLoginProtection;

@property (nonatomic,retain) NSString * strPositionID;
@property (nonatomic,retain) NSString * strRoleName;
@property (nonatomic,retain) NSString * strDomainName;
@property (nonatomic,retain) NSString * strReportToUserId;
@property (nonatomic,retain) NSString * strReportTo;
@property (nonatomic) Rank rank;

@property (nonatomic,retain) NSString * strEnterpise;
@property (nonatomic,retain) NSString * strOfficePhoneNumber;
@property (nonatomic,retain) NSString * strOfficeAddress;
@property (nonatomic,retain) NSString * strWorkEmail;

@property (nonatomic,retain) NSString * strTag1;
@property (nonatomic,retain) NSString * strTag2;
@property (nonatomic,retain) NSString * strTag3;

@property (nonatomic,retain) NSString * strJoinedDate;

@property (nonatomic) UserStatusType    status;
@property (nonatomic) BOOL              bCanModify;
@property (nonatomic) BOOL              bCanDelete;

@property (nonatomic,retain) NSString  * strDefaultPosId;
@property (nonatomic,retain) NSMutableArray * arrayPosition;

@property (nonatomic,retain) NSString  * strCompare;//用来排序的字符串，第一字符为中文的话为首字母
@property (nonatomic)        BOOL        bFirstAlph;//第一个字符是否为符号(数字)
@property (nonatomic,retain) NSString  * strSectionLetter;
@end

@interface UserProfileUpdate : NSObject
@property (nonatomic,retain) NSString  * strUserId;
@property (nonatomic,retain) NSString  * strFirstName;
//@property (nonatomic,retain) NSString  * strSurName;
@property (nonatomic,retain) NSString  * strWorkEmail;
@property (nonatomic,retain) NSString  * strInterest;
@property (nonatomic,retain) NSString  * strAlternatePhone;
@property (nonatomic,retain) NSString  * strBirthDate;
@property (nonatomic) NSInteger nBirthYear;

@property (nonatomic,retain) UIImage   * imgUser;
@property (nonatomic) Sex sex;
@property (nonatomic) BOOL IsPublicAge;

@property (nonatomic,retain) NSString  * strUserAccount;
@property (nonatomic,retain) NSString  * strOnBoard;
@property (nonatomic,retain) NSString  * strOfficePhone;
@property (nonatomic,retain) NSString  * strOfficeAddress;
@end

//Customer
@interface Customer : NSObject
@property (nonatomic,retain) NSString * strCustomerId;
@property (nonatomic,retain) NSString * strFirstName;
//@property (nonatomic,retain) NSString * strSurName;
@property (nonatomic,retain) NSString * strPhone1;
@property (nonatomic,retain) NSString * strPhone2;
@property (nonatomic) BOOL isVip;
@property (nonatomic) BOOL isRelate;
@property (nonatomic,retain) NSString * strCustImg;
@property (nonatomic,retain) NSString * strCustImgBig;
@property (nonatomic,retain) UIImage  * imgCust;

@property (nonatomic) Sex Sex;
@property (nonatomic,retain) NSString * strBirthDate;
@property (nonatomic) NSInteger  nBirthYear;

@property (nonatomic,retain) NSString * strAddress;
@property (nonatomic,retain) NSString * strEmail;
@property (nonatomic,retain) NSString * strDistrict;

@property (nonatomic,retain) NSString * strRelationUserId;
@property (nonatomic,retain) NSString * strRelationUserName;
@property (nonatomic)        Rank     rankRelationUser;
@property (nonatomic,retain) NSString * strChildrenDesc;
@property (nonatomic,retain) NSString * strMemorialDaysDesc;
@property (nonatomic,retain) NSString * strInterest;
@property (nonatomic,retain) NSString * strTitle;
@property (nonatomic,retain) NSString * strCareerId;
@property (nonatomic,retain) NSString * strStoreDesc;
@property (nonatomic,retain) NSString * strStoreId;

@property (nonatomic,retain) NSString  * strCompare;        //用来排序的字符串，第一字符为中文的话为首字母
@property (nonatomic) BOOL bFirstAlph;                      //第一个字符是否为符号(数字)
@property (nonatomic,retain) NSString  * strSectionLetter;  //用来快速定位的字母，符号(数字)显示为#
@end

@interface CustomerCareer : NSObject
@property (nonatomic, retain) NSString * strCustomerCareerId;
@property (nonatomic, retain) NSString * strCustomerCareerDesc;
@end

@interface CustomerPurchase : NSObject
@property (nonatomic, retain) NSString * strPurchaseId;
@property (nonatomic, retain) NSString * strProductName;
@property (nonatomic, retain) NSNumber * numProductPrice;
@property (nonatomic, retain) NSNumber * numProductQty;
@property (nonatomic, retain) NSNumber * numProductAmount;
@property (nonatomic, retain) NSString * strPurchaseDate;
@property (nonatomic, retain) NSString * strStoreId;
@end

//Invite
@interface InviteRole : NSObject
@property (nonatomic,retain) NSString * strRoleID;
@property (nonatomic,retain) NSString * strRoleName;
@property (nonatomic,retain) NSString * strDomainTypeName;
@property (nonatomic) Rank         rankRole;
@end

@interface InvitePosition : NSObject
@property (nonatomic,retain) NSString * strPositionID;
@property (nonatomic,retain) NSString * strDomainName;
@end

//Store
@interface DomainInfo : NSObject
@property (nonatomic,retain) NSString * strDomainID;
@property (nonatomic,retain) NSString * strParentDomainID;
@property (nonatomic,retain) NSString * strDomainCode;
@property (nonatomic,retain) NSString * strDomainName;
@property (nonatomic,retain) UIView   * viewDomainNav;
@end

@interface StoreDetailInfo : NSObject
@property (nonatomic,retain) NSString * strStoreId;
@property (nonatomic,retain) NSString * strDomainID;
@property (nonatomic,retain) NSString * strStoreThumb;
@property (nonatomic,retain) NSString * strStoreThumbBig;
@property (nonatomic,retain) NSString * strBrandName;
@property (nonatomic,retain) NSString * strStoreName;
@property (nonatomic,retain) NSString * strStoreType;
@property (nonatomic,retain) NSString * strStoreOrganize;
@property (nonatomic,retain) NSString * strStoreAddress;
@property (nonatomic,retain) NSString * strStorePostCode;
@property (nonatomic) BOOL isOwn;
@property (nonatomic) BOOL isPerfect;

@property (nonatomic,retain) NSString * strStoreCode;
@property (nonatomic,retain) NSString * strCityName;
@property (nonatomic,retain) NSString * strCity;
@property (nonatomic,retain) NSString * strDealerName;
@property (nonatomic,retain) NSString * strMarket;
@property (nonatomic,retain) NSString * strShopMap;
@property (nonatomic,retain) NSString * strArea;
@property (nonatomic,retain) NSString * strDecorationDate;
@property (nonatomic,retain) NSString * strEmail;
@property (nonatomic,retain) NSString * strFax;
//@property (nonatomic) NSInteger nStartTime;
//@property (nonatomic) NSInteger nEndTime;
@property (nonatomic,retain) NSString * strStartTime;
@property (nonatomic,retain) NSString * strEndTime;
@property (nonatomic,retain) NSString * strAreaSquare;
@property (nonatomic,retain) NSString * strWeatherCode;
@property (nonatomic,retain) NSString * strPhone;
@property (nonatomic,retain) NSString * strDomainNo;
@property (nonatomic,retain) NSString * strParentDomainId;


@property (nonatomic) long long         llRights;
@property (nonatomic,retain) UIImage  * imgStore;

@property (nonatomic,retain) NSMutableArray * arrayShopMap;
@end


@interface StoreShopMap : NSObject
@property (nonatomic,retain) NSString * strId;
@property (nonatomic,retain) NSString * strTitle;
@property (nonatomic,retain) NSString * strUrl;
@end

//MessageCenter
typedef enum
{
    ICType_Message = 0,
    ICType_Report,
    ICType_Task,
}ICType;

typedef enum
{
    ICMsgType_BroadCast = 0,        //管理员广播
    ICMsgType_GroupMsg,             //群发消息
    ICMsgType_SystemNotify,         //系统通知
    ICMsgType_PrivateMsg,           //私信
}ICMsgType;

typedef enum
{
    ICMsgFormat_Text = 0,
    ICMsgFormat_Voice,
    ICMsgFormat_Picture,
}ICMsgFormat;

@interface ICUnread : NSObject
@property (nonatomic) ICType        type;
@property (nonatomic) NSInteger     nCount;
@end

@interface ICDetailInfo : NSObject
@property (nonatomic,retain) NSString           * strID;
@property (nonatomic)ICMsgType                  typeMsg;
@property (nonatomic)ICMsgFormat                format;
@property (nonatomic,retain) UserDetailInfo     * userPost;
@property (nonatomic,retain) NSDate             * dtTime;
@property (nonatomic,retain) NSString           * strSubject;
@property (nonatomic,retain) NSString           * strParam;
@property (nonatomic,retain) NSString           * strFileSize;

@property (nonatomic) NSInteger                 nCellHeight;
@end



//Report
@interface MCReport : NSObject
@property (nonatomic,retain) NSString   * strReportID;
@property (nonatomic,retain) NSString   * strSenderID;
@property (nonatomic,retain) NSString   * strSenderName;
@property (nonatomic) Rank              rank;
@property (nonatomic,retain) NSString   * strImgPic;
@property (nonatomic,retain) NSString   * strReportName;
@property (nonatomic,retain) NSString   * strReportType;
@property (nonatomic,retain) NSString   * strReportUrl;
@property (nonatomic,retain) NSDate     * dateReport;
@end

//Businiss
typedef enum
{
    CACHETYPE_INSPECTION = 0,
    CACHETYPE_RECTIFICITION,
    CACHETYPE_VISITING,
    CACHETYPE_MAINTEN,
    CACHETYPE_BVISITING,
    CACHETYPE_ELEARNINGEXAM,
}CacheType;

@interface CachData : NSObject
@property (nonatomic,retain) NSString   * strID;
@property (nonatomic,retain) NSString   * strDesc;
@property (nonatomic,retain) NSString   * strData;
@property (nonatomic,retain) NSDate     * date;
@property (nonatomic) CacheType         type;
@property (nonatomic) BOOL              bSubmited;
@end

@interface TaskCachData : NSObject
@property (nonatomic,retain) NSString   * strID;
@property (nonatomic,retain) NSString   * strDesc;
@property (nonatomic,retain) NSString   * strData;
@property (nonatomic,retain) NSString   * strKey;
@property (nonatomic,retain) NSDate     * date;
@property (nonatomic) CacheType         type;
@property (nonatomic) BOOL              bNormalExit;
@end

typedef enum
{
    MARK_NONE = 0,
    MARK_1,
    MARK_2,
    MARK_3,
    MARK_4,
    MARK_5,
}MARK;

@interface Vendor : NSObject
@property (nonatomic,retain) NSString           * strVendorID;
@property (nonatomic,retain) NSString           * strVendorName;
@property (nonatomic,retain) NSString           * strAssetType;
@end

//Documents Live
typedef enum
{
    GetDocType_All = 0,
    GetDocType_Sent,
    GetDocType_UnSent,
    GetDocType_UnFinished,
} GetDocType;

@interface Document : NSObject
@property (nonatomic,retain) NSString * strDocumentID;
@property (nonatomic,retain) NSString * strDocumentCode;
@property (nonatomic,retain) NSString * strDocumentURL;
@property (nonatomic,retain) NSString * strFileName;
@property (nonatomic,retain) NSString * strDescEx;          //零售巡店 显示零售巡店模版
@property (nonatomic,retain) NSString * strStoreName;
@property (nonatomic,retain) NSString * strBrandName;

@property (nonatomic,retain) NSString * strDomainNo;

@property (nonatomic) Rank rankAuthor;
@property (nonatomic,retain) NSString * strAuthor;
@property (nonatomic,retain) NSString * strCreateTime;
@property (nonatomic,retain) NSString * strDocType;
@property (nonatomic) BOOL              isReceived;
@property (nonatomic) BOOL              isSendBySelf;
@property (nonatomic) BOOL              isEdit;
@property (nonatomic) BOOL              isFinish;
@property (nonatomic) float             fileSize;
//for All
@property (nonatomic) BOOL              isNew;

//for unsent
//@property (nonatomic,retain) NSString * strUnSentID;
//@property (nonatomic,retain) NSString * strUnsentDesc;
//@property (nonatomic,retain) NSString * strUnSentData;
@property (nonatomic,retain) CachData * dataUnSent;
@property (nonatomic) BOOL isUnSentUploading;

//for unfinish
@property (nonatomic,retain) NSString * strUnfinishStoreId;
@property (nonatomic,retain) NSString * strUnfinishDesc;
@property (nonatomic)CacheType UnfinishDocType;
@end

//Inspection
@interface InspReporterUser : NSObject
@property (nonatomic)        BOOL           bUserCollegue;
@property (nonatomic,retain) UserDetailInfo * collegue;
@property (nonatomic,retain) NSString       * strEmail;
@property (nonatomic)        BOOL           bSelected;
@end

@interface InspReporterSection : NSObject
@property (nonatomic,retain) NSString * strTitle1;
@property (nonatomic,retain) NSString * strTitle2;
@property (nonatomic,retain) NSString * strVendorID;
@property (nonatomic,retain) NSMutableArray * arrayUser;
@end

@interface InspReporters : NSObject
@property (nonatomic,retain) NSMutableArray * arraySection;
@end


@interface InspData : NSObject
@property (nonatomic,retain) NSMutableArray     * arrayInsp;       //RPInspVendor数组
@property (nonatomic,retain) NSString           * strImgShopUrl;
@property (nonatomic) MARK                      mark;
@property (nonatomic,retain) NSString           * strDesc;
@property (nonatomic,retain) InspReporters    * reporters;
@end

@interface InspVendor : NSObject
@property (nonatomic,retain) NSString           * strVendorID;
@property (nonatomic,retain) NSString           * strVendorName;
@property (nonatomic,retain) NSString           * strAssetType;
@property (nonatomic,retain) NSMutableArray     * arrayCatagory;
@end

@interface InspCatagory : NSObject
@property (nonatomic,retain) NSString           * strCatagoryID;
@property (nonatomic,retain) NSString           * strCatagoryName;
@property (nonatomic,retain) NSString           * strCatagoryDesc;
@property (nonatomic) MARK                      markCatagory;
@property (nonatomic,retain) NSMutableArray     * arrayIssue;
@end

@interface InspIssue : NSObject
@property (nonatomic,retain) NSString           * strIssueID;
@property (nonatomic,retain) NSString           * strIssueTitle;
@property (nonatomic,retain) NSString           * strIssueDesc;
@property (nonatomic,retain) NSString           * strVendorName;
@property (nonatomic,retain) NSString           * strVendorType;
@property (nonatomic,retain) NSString           * strVendorID;
@property (nonatomic) BOOL                      bHasLocation;
@property (nonatomic) CGPoint                   ptLocation;
@property (nonatomic,retain) NSString           * strMapId;
@property (nonatomic,retain) NSMutableArray     * arrayIssueImg;
@end

@interface InspIssueImage : NSObject
@property (nonatomic,retain) NSString           * strUrl;
@property (nonatomic,retain) NSString           * strLocalFileName;
@property (nonatomic,retain) UIImage            * imgIssue;
@property (nonatomic)        CGRect             rcIssue;
@end

@interface InspReportResult : NSObject
@property (nonatomic,retain) NSString           * strResultID;
@property (nonatomic,retain) NSString           * strStoreName;
@property (nonatomic,retain) NSString           * strBrandName;
@property (nonatomic,retain) NSString           * strInspectionDate;
@property (nonatomic,retain) NSString           * strInspctor;
@property (nonatomic,retain) NSMutableArray     * arrayDetail;
@property (nonatomic)        BOOL               bSelected;
@end

@interface InspReportResultDetail : NSObject
@property (nonatomic,retain) NSString           * strCatagoryID;
@property (nonatomic)        MARK               mark;
@property (nonatomic,retain) NSMutableArray     * arrayIssue;
@end

//Construction Visiting
@interface CVisitData : NSObject
@property (nonatomic,retain) NSMutableArray     * arrayIssue;
@property (nonatomic,retain) NSString           * strImgShopUrl;
@property (nonatomic) MARK                      mark;
@property (nonatomic,retain) NSString           * strDesc;
@property (nonatomic,retain) InspReporters      * reporters;
@end

//Store Maintenance
@interface MaintenVendor : NSObject
@property (nonatomic,retain) NSString           * strVendorID;
@property (nonatomic,retain) NSString           * strVendorName;
@property (nonatomic,retain) NSString           * strVendorType;
@end

@interface MaintenContact : NSObject
@property (nonatomic,retain) NSString           * strUserName;
@property (nonatomic,retain) NSString           * strPhone;
@property (nonatomic) BOOL                      bColleague;
@end

@interface MaintenanceData : NSObject
@property (nonatomic,retain) NSMutableArray     * arrayIssue;
@property (nonatomic,retain) NSMutableArray     * arrayContacts;
@property (nonatomic,retain) NSString           * strContactsRemark;
@property (nonatomic,retain) NSString           * strImgShopUrl;
@property (nonatomic,retain) InspReporters      * reporters;
@end

//Boutique Visiting
typedef enum
{
    BVisitMark_EMPTY = -2,
    BVisitMark_NONE = -1,
    BVisitMark_NO,
    BVisitMark_YES,
}BVisitMark;

@interface BVisitTemplate : NSObject
@property (nonatomic,retain) NSString          * strTemplateId;
@property (nonatomic,retain) NSString          * strTemplateName;
@property (nonatomic,retain) NSString          * strTemplateDesc;
@property (nonatomic,retain) NSString          * strCategoryTag;
@property (nonatomic) NSInteger                nCatagoryCount;
@end

@interface BVisitData : NSObject
@property (nonatomic,retain) NSString           * strSourceReportId;
@property (nonatomic,retain) NSString           * strTemplateId;
@property (nonatomic,retain) NSString           * strTemplateName;
@property (nonatomic,retain) NSString           * strTemplateDesc;
@property (nonatomic,retain) NSString           * strCategoryTag;
@property (nonatomic,retain) NSMutableArray     * arrayCatagory;       //BVisitCategory数组
//@property (nonatomic,retain) NSString           * strImgShopUrl;
@property (nonatomic,retain) NSArray            * arrayMap;
@property (nonatomic,retain) NSString           * strComment;
@property (nonatomic,retain) NSString           * strTitle;
@property (nonatomic,retain) InspReporters      * reporters;
@property (nonatomic) float                     fPoint;
@property (nonatomic,assign)NSInteger           nStatus;//0 未完成 ，1 已完成
@end

@interface BVisitCategory : NSObject
@property (nonatomic,retain) NSString           * strCategoryName;
@property (nonatomic,retain) NSMutableArray     * arrayItem;            //BVisitItem数组
@property (nonatomic) float                     fPoint;
@end

@interface BVisitItem : NSObject
@property (nonatomic,retain) NSString           * strItemId;
@property (nonatomic,retain) NSString           * strItemTitle;
@property (nonatomic,retain) NSString           * strItemDesc;
@property (nonatomic) float                     fWeight;
@property (nonatomic) BVisitMark                mark;
@property (nonatomic,retain) NSMutableArray     * arrayIssue;
@property (nonatomic)  BOOL                           bMark;
@end

@interface BVisitIssueSearchRet : NSObject
//@property (nonatomic,retain) UserDetailInfo     * userInfo;//⽤用户详情
@property (nonatomic,retain) NSString           * strBoutiqueVisitId;
@property (nonatomic,retain) NSString           * strIssueId;
@property (nonatomic,retain) NSString           * strStoreId;
@property (nonatomic,retain) NSString           * strStoreName;
@property (nonatomic,retain) NSString           * strUserId;
@property (nonatomic,retain) NSString           * strUserName;
@property (nonatomic) Rank                        rank;
@property (nonatomic,retain) NSString           * strModelName;//模版名称
@property (nonatomic,retain) NSString           * strCatagoryName;//分组名称
@property (nonatomic,retain) NSString           * strItemName;//打分项名称
@property (nonatomic,retain) NSString           * strPostTime;//提交时间
@property (nonatomic,retain) InspIssue          * issue;//零售巡店问题 (与提交时的对象格式相同)
@property (nonatomic,retain) NSMutableArray     * arrayTask;//放TaskInfo
@property (nonatomic)BOOL                         bSelected;

@end

@interface BVisitSearchRetCatagory : NSObject
@property (nonatomic,retain) StoreDetailInfo    * storeInfo;
@property (nonatomic,retain) NSMutableArray     * arrayIssueSearchRet;//问题列表
@property (nonatomic)BOOL                         bExpend;
@property (nonatomic)BOOL                         bSelected;
@end

@interface BVisitIssueSearchData : NSObject

@property (nonatomic,retain) NSMutableArray     * arrayIssue;
@property (nonatomic,retain) InspReporters      * reporters;

@end
//继续巡店列表结构
//@interface BVisitIssueData : NSObject
//@property (nonatomic,retain) NSString           * strBVDetailId;
//@property (nonatomic,retain) NSString           * strItemId;
//@property (nonatomic,retain) NSString           * strItemTitle;
//@property (nonatomic,retain) NSString           * strItemDesc;
//@property (nonatomic) float                      fWeight;
//@property (nonatomic,retain) NSString           * strCategoryName;
//@property (nonatomic,assign) NSInteger            nScore;
//@property (nonatomic,retain) NSMutableArray     * arrayIssue;
//@end
//
//@interface BVisitSubmitItem : NSObject
//@property (nonatomic,retain) NSArray      * arrayIssuesData;
//@end

@interface BVisitListModel : NSObject//继续巡店列表结构
@property (nonatomic,retain) NSString           * strReportId;
//@property (nonatomic,retain) NSString           * strTemplateId;
//@property (nonatomic,retain) NSString           * strTemplateName;
//@property (nonatomic,retain) NSString           * strTemplateDesc;
//@property (nonatomic,retain) NSString           * strCategoryTag;
@property (nonatomic,retain) NSString           * strReportTitle;
@property (nonatomic,retain) NSString           * strDate;
//@property (nonatomic) float                       fPoint;
@property (nonatomic,retain) NSString           * strStoreId;
@property (nonatomic,retain) NSString           * strStoreName;
//@property (nonatomic,retain) NSString           * strRemark;
@property (nonatomic) Rank                        rank;
@property (nonatomic,retain) NSString           * strUserName;
@property (nonatomic,retain) BVisitData         * bVisitData;
@end

//Task
typedef enum
{
    TASK_BVisit=4,
//    TASK_two,
//    TASK_three,
}TaskType;

typedef enum
{
    COLOR_ALL = -1,
    COLOR_gray=0,
    COLOR_purple,//紫色
    COLOR_red,
    COLOR_yellow,
    COLOR_green,
    COLOR_bluegreen,
}ColorType;

typedef enum
{
    TASKSTATE_unfinished = 1,
    TASKSTATE_running,
    TASKSTATE_finished,
}TaskState;

@interface TaskInfo : NSObject
@property (nonatomic,retain) NSString           * strCode;
@property (nonatomic,retain) NSString           * strTaskId;
@property (nonatomic)TaskType                     typeTask;
@property (nonatomic,retain) NSString           * strOther;//根据任务类型区分 零售巡店:零售巡店IssueID!
@property (nonatomic,retain) NSString           * strTitle;
@property (nonatomic,retain) NSString           * strDesc;
@property (nonatomic,retain) UserDetailInfo     * userExecutor;
@property (nonatomic,retain) UserDetailInfo     * userInitiator;//发起人
@property (nonatomic)BOOL                         bAllDay;
@property (nonatomic)BOOL                         isNew;
@property (nonatomic,retain) NSDate             * dateEnd;
@property (nonatomic,retain) NSDate             * dateCreate;
@property (nonatomic,retain) NSDate             * dateFinish;
@property (nonatomic)ColorType                    typeColor;
@property (nonatomic)TaskState                    state;
@end

//@interface TaskModel : NSObject
//@property (nonatomic,retain) InspIssue          * issue;
//@property (nonatomic,retain) NSMutableArray           * arrayTask;
//@end





//HandOver LogBook
@interface LogBookDetail : NSObject
@property (nonatomic,retain) NSString           * strID;                //交接本ID
@property (nonatomic,retain) NSString           * strTitle;             //交接本标题
@property (nonatomic,retain) NSString           * strDesc;              //交接本描述
@property (nonatomic,retain) NSMutableArray     * arrayImageSmall;      //交接本包含的缩略图片（最多3涨）
@property (nonatomic,retain) NSMutableArray     * arrayImageBig;        //交接本包含的全图（最多3涨）
@property (nonatomic,retain) NSDate             * dtPostTime;           //发布时间
@property (nonatomic,retain) NSString           * strTagId;
@property (nonatomic,retain) NSString           * strTagDesc;

@property (nonatomic,retain) UserDetailInfo     * userPost;                 //发布用户信息
//
//@property (nonatomic,retain) NSString           * strPostUserID;        //发布人ID
//@property (nonatomic,retain) NSString           * strPostUserName;      //发布人名字
//@property (nonatomic) Rank                      rankPostUser;           //发布人等级
//@property (nonatomic,retain) NSString           * strPostUserImageUrl;  //发布人头像URL
@property (nonatomic) BOOL                      bFocus;                 //是否收藏
@property (nonatomic) BOOL                      bMyPost;                //是否自己发布
@property (nonatomic) BOOL                      bRead;                  //是否自己已读
@property (nonatomic) NSInteger                 nCommentCount;          //Comment个数
@property (nonatomic,retain) NSMutableArray     * arrayComment;         //LogBookDetail array

@property (nonatomic,retain) StoreDetailInfo    * store;                //店铺信息

@property (nonatomic) BOOL                      bExpand;                //当前是否打开评论
@end

@interface LogBookTag : NSObject
@property (nonatomic,retain) NSString           * strTagId;
@property (nonatomic,retain) NSString           * strDesc;
@end

//KPI
typedef enum
{
    KPIMode_Hour = 0,
    KPIMode_Day,
}KPIMode;

@interface KPISalesData : NSObject
@property (nonatomic) NSInteger                 nYear;
@property (nonatomic) NSInteger                 nMonth;
@property (nonatomic) NSInteger                 nDay;
@property (nonatomic) NSInteger                 nHour;
@property (nonatomic) KPIMode                   mode;
@property (nonatomic) NSInteger                 nTraQty;
@property (nonatomic) NSInteger                 nProQty;
@property (nonatomic) NSInteger                 nAmount;
@end

@interface KPITrafficData : NSObject
@property (nonatomic) NSInteger                 nYear;
@property (nonatomic) NSInteger                 nMonth;
@property (nonatomic) NSInteger                 nDay;
@property (nonatomic) NSInteger                 nHour;
@property (nonatomic) KPIMode                   mode;
@property (nonatomic) NSInteger                 nTraffic;
@end

@interface KPIDomainData : NSObject
@property (nonatomic,retain) NSString           * strDomainID;
@property (nonatomic,retain) NSString           * strDomainName;
@property (nonatomic) long long                  nTraffic;
@property (nonatomic) long long                  nTraQty;
@property (nonatomic) long long                  nProQty;
@property (nonatomic) long long                  nAmount;
@property (nonatomic) NSInteger                 nConvPercent;
@property (nonatomic) BOOL                      bHasChild;
@property (nonatomic) BOOL                      bFav;
@end

typedef enum
{
    KPIDateRangeType_Year = 0,
    KPIDateRangeType_Quarter,
    KPIDateRangeType_Month,
    KPIDateRangeType_Week,
    KPIDateRangeType_Day,
}KPIDateRangeType;

@interface KPIDateRange:NSObject
@property (nonatomic) KPIDateRangeType         type;
@property (nonatomic,retain) NSDate            * date;
@property (nonatomic)NSInteger                 nYear;
@property (nonatomic)NSInteger                 nIndex;
@end

//Courtesy Call
typedef enum
{
    CourtesyCallThroughType_PSTN = 0,
    CourtesyCallThroughType_CCPVOIP,
}CourtesyCallThroughType;

@interface CourtesyCallType: NSObject
@property (nonatomic,retain) NSString           * strCourtesyCallTypeId;
@property (nonatomic,retain) NSString           * strCourtesyCallTips;
@property (nonatomic,retain) NSString           * strDescription;
@property (nonatomic,retain) NSString           * strTypeName;
@end

@interface CourtesyCallInfo: NSObject
@property (nonatomic,retain) NSString           * strID;
@property (nonatomic,retain) Customer           * customer;
@property (nonatomic,retain) UserDetailInfo     * userCaller;
@property (nonatomic,retain) NSString           * strCourtesyCallTypeId;
@property (nonatomic,retain) NSString           * strTelephoneNo;
@property (nonatomic,retain) NSString           * strComment;
@property (nonatomic,retain) NSDate             * dateCC;
@property (nonatomic,retain) NSDate             * datePlan;
@property (nonatomic,retain) NSDate             * dateRemind;
@property (nonatomic) BOOL                      bRemind;
@property (nonatomic) BOOL                      isCompleted;
@property (nonatomic) BOOL                      isSatisfied;

//2.0 add
@property (nonatomic,retain) NSString           * strRecordUrl;
@property (nonatomic) BOOL                      bSuccess;
@property (nonatomic) CourtesyCallThroughType   typeThrough;
@property (nonatomic) NSInteger                 nDuration;
@end

@interface CCPSubAccount : NSObject
@property (nonatomic,retain) NSString           * strVoipAccount;
@property (nonatomic,retain) NSString           * strSubToken;
@property (nonatomic,retain) NSString           * strSubAccountSid;
@property (nonatomic,retain) NSString           * strVoipPwd;
@property (nonatomic,retain) NSString           * strVoipToken;
@end

@interface CCPVoipCall : NSObject
@property (nonatomic,retain) NSString           * strVoipToken;
@property (nonatomic,retain) NSString           * strCourtesyCallId;
@property (nonatomic,retain) NSString           * strCourtesyCallTypeId;
@property (nonatomic,retain) NSString           * strCustomerId;
@property (nonatomic,retain) NSString           * strTelephoneNo;
@property (nonatomic,retain) NSString           * strRemark;
@property (nonatomic) NSInteger                 nDuration;
@property (nonatomic) CourtesyCallThroughType   typeThrough;
@property (nonatomic) BOOL                      bSuccess;
@end

//Training Doc
@interface TrainingFolder : NSObject
@property (nonatomic,retain) NSString          * strFolderName;
@property (nonatomic,retain) NSMutableArray    * arrayDoc;
@end

@interface TrainingDoc : NSObject
@property (nonatomic,retain) NSString          * strID;
@property (nonatomic,retain) NSString          * strCreator;
@property (nonatomic,retain) NSString          * strFileName;
@property (nonatomic,retain) NSString          * strUrl;
@property (nonatomic,retain) NSString          * strDate;
@property (nonatomic)double                    dbSize;
@end

//Live Video
@interface LiveCamera : NSObject
@property (nonatomic,retain) NSString          * strID;
@property (nonatomic,retain) NSString          * strCameraName;
@property (nonatomic,retain) NSString          * strLiveURL;
@end

//Goods Tracking
@interface GoodsTrackingInfo : NSObject
@property (nonatomic,retain) NSString          * strID;
@property (nonatomic,retain) NSString          * strDate;
@property (nonatomic,retain) NSString          * strCode;
@property (nonatomic,retain) NSString          * strDetail;
@end