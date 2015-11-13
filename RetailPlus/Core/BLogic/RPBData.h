//
//  RPBData.h
//  RetailPlus
//
//  Created by lin dong on 13-8-20.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    CERTDEVICETYPE_PHONE = 1,
    CERTDEVICETYPE_EMAIL,
}CERTDEVICETYPE;

typedef enum
{
    CERTTYPE_SIGNUP = 1,
    CERTTYPE_CHGPSW,
    CERTTYPE_CHGBOUNDMAIL,
    CERTTYPE_LOGINPROTECT,
}CERTTYPE;

typedef enum
{
  RPSex_Female = 0,
  RPSex_Male,
  RPSex_UnSpec,
}RPSex;


//Role
typedef enum
{
    RPRoleLevel_Brand = 1,
    RPRoleLevel_Area,
    RPRoleLevel_City,
    RPRoleLevel_Store,
}RPRoleLevel;

@interface RPRole : NSObject
@property (nonatomic,retain) NSString * strRoleID;
@property (nonatomic,retain) NSString * strRoleName;
@property (nonatomic) NSInteger         nRoleClass;
@property (nonatomic) RPRoleLevel       nRoleLevel;
@end

@interface RPUnit : NSObject
@property (nonatomic,retain) NSString * strUnitID;
@property (nonatomic,retain) NSString * strUnitName;
@end

//Account Sec Binding UserInfo
@interface RPSimUserInfo : NSObject
@property (nonatomic,retain) NSString * strBoundEmail;
@property (nonatomic,retain) NSString * strPhoneNo;
@property (nonatomic,retain) NSString * strRpNo;
@end

//Login Device
@interface RPLoginDevice : NSObject
@property (nonatomic,retain) NSString * strDeviceName;
@property (nonatomic,retain) NSString * strDeviceType;
@property (nonatomic,retain) NSString * strDeviceUUID;
@property (nonatomic,retain) NSString * strLastLoginDate;
@property (nonatomic,retain) NSString * strLoginDeviceId;
@end

//Login User Profile
@interface RPLoginUserProfile : NSObject
@property (nonatomic,retain) NSString * strAlternatePhone;
@property (nonatomic,retain) NSDate * dateBirthday;
@property (nonatomic,retain) NSString * strEmail;
@property (nonatomic,retain) NSString * strEnterprise;
@property (nonatomic,retain) NSString * strFirstName;
@property (nonatomic,retain) NSString * strImgPic;
@property (nonatomic,retain) NSString * strImgPicBig;
@property (nonatomic,retain) NSString * strInterest;
@property (nonatomic,retain) NSString * strJoinedAt;
@property (nonatomic,retain) NSString * strOfficeAddress;
@property (nonatomic,retain) NSString * strOfficePhone;
@property (nonatomic,retain) NSString * strPhone;
@property (nonatomic,retain) NSString * strPosition;
@property (nonatomic,retain) NSString * strJobTitle;
@property (nonatomic) NSInteger nRoleLevel;
@property (nonatomic,retain) NSString * strReportToId;
@property (nonatomic) BOOL bSexMale;
@property (nonatomic) BOOL bPublicAge;
//@property (nonatomic,retain) NSString * strSurName;
@property (nonatomic,retain) NSString * struserId;
@end

//Colleague
@interface RPColleague : NSObject
@property (nonatomic,retain) NSString  * strID;
@property (nonatomic,retain) NSString  * strFirstName;
//@property (nonatomic,retain) NSString  * strSurName;
@property (nonatomic,retain) NSString  * strPhone;
@property (nonatomic,retain) NSString  * strEmail;
@property (nonatomic,retain) NSString  * strBirthday;

@property (nonatomic,retain) NSString   * strImgPic;
@property (nonatomic,retain) NSString   * strImgPicBig;
@property (nonatomic) RPSex              sex;

@property (nonatomic) BOOL               bRegist;
@property (nonatomic,retain) NSString  * strRoleDesc;
@property (nonatomic) NSInteger          nRoleLevel;

@property (nonatomic,retain) NSString  * strReportToName;
@property (nonatomic,retain) NSString  * strReportToID;

@property (nonatomic,retain) NSString  * strCompare;//用来排序的字符串，第一字符为中文的话为首字母
@property (nonatomic)        BOOL        bFirstAlph;//第一个字符是否为符号(数字)
@property (nonatomic,retain) NSString  * strSectionLetter;
@end

@interface RPColleagueState : NSObject
@property (nonatomic) NSInteger nCountLev1;
@property (nonatomic) NSInteger nCountLev2;
@property (nonatomic) NSInteger nCountLev3;
@property (nonatomic) NSInteger nCountLev4;
@end

//Customer
@interface RPCustomer : NSObject
@property (nonatomic,retain) NSString  * strID;
@property (nonatomic,retain) NSString  * strPhone1;
@property (nonatomic,retain) NSString  * strPhone2;
@property (nonatomic,retain) NSString  * strFirstName;
//@property (nonatomic,retain) NSString  * strSurName;
@property (nonatomic,retain) NSString  * strAddress;
@property (nonatomic,retain) NSString  * strBirthday;
@property (nonatomic,retain) NSString  * strDistrict;
@property (nonatomic,retain) NSString  * strEmail;

@property (nonatomic,retain) UIImage   * imgPic;
@property (nonatomic,retain) NSString  * strImgPicUrl;
@property (nonatomic,retain) NSString  * strImgPicUrlBig;

@property (nonatomic) RPSex              sex;
@property (nonatomic) BOOL               isVip;
@property (nonatomic) BOOL               isLink;

@property (nonatomic,retain) NSString  * strCompare;//用来排序的字符串，第一字符为中文的话为首字母
@property (nonatomic)        BOOL        bFirstAlph;//第一个字符是否为符号(数字)
@property (nonatomic,retain) NSString  * strSectionLetter;
@end

//Store
@interface RPStore : NSObject
@property (nonatomic,retain) NSString  * strStoreName;
@property (nonatomic,retain) NSString  * strStoreThumb;
@property (nonatomic,retain) NSString  * strImageThumb;
@property (nonatomic,retain) NSString  * strImageThumbBig;
@property (nonatomic,retain) NSString  * strBrandName;
@property (nonatomic,retain) NSString  * strCityName;
@property (nonatomic,retain) NSString  * strDealerName;
@property (nonatomic,retain) NSString  * strStoreAddress;
@property (nonatomic,retain) NSString  * strStorePhone;
@property (nonatomic,retain) NSString  * strStoreCode;
@property (nonatomic,retain) NSString  * strDistrictCode;
@property (nonatomic,retain) NSString  * strInspDate;
@property (nonatomic,retain) NSString  * strInspUser;
@property (nonatomic,retain) NSString  * strWeatherCode;
@property (nonatomic,retain) NSString  * strFax;
@property (nonatomic,retain) NSString  * strEmail;


@property (nonatomic)        NSInteger   nStartTime;
@property (nonatomic)        NSInteger   nEndTime;
@property (nonatomic)        NSInteger   nWeatherCode;

@property (nonatomic)        BOOL      bFavorite;
@property (nonatomic)        BOOL      isStoreUser;
@property (nonatomic)        BOOL      isInfoComplete;

@property (nonatomic)        BOOL      bHasInspection;
@property (nonatomic,retain) NSString  * strMarket;
@property (nonatomic,retain) NSString  * strShopMap;
@property (nonatomic,retain) NSString  * strStoreID;
@property (nonatomic,retain) NSString  * strAreaSquare;

@property (nonatomic,retain) NSString  * strArea;
@property (nonatomic,retain) NSString  * strDecorationDate;

@property (nonatomic)        BOOL      bHasReview;


@end

//MessageCenter
@interface RPMCReport : NSObject
@property (nonatomic,retain) NSString   * strReportID;
@property (nonatomic,retain) NSString   * strSenderID;
@property (nonatomic,retain) NSString   * strSenderName;
@property (nonatomic) NSInteger           nRoleLevel;
//@property (nonatomic,retain) UIImage    * imgPic;
@property (nonatomic,retain) NSString   * strImgPic;
@property (nonatomic,retain) NSString   * strReportName;
@property (nonatomic,retain) NSString   * strReportType;
@property (nonatomic,retain) NSString   * strReportUrl;
@property (nonatomic,retain) NSDate     * dateReport;
@end

//Cache
//typedef enum
//{
//    CACHETYPE_INSPECTION = 0,
//    CACHETYPE_RECTIFICITION,
//    CACHETYPE_VISITING,
//    CACHETYPE_MAINTEN,
//}CacheType;

@interface RPCachData : NSObject
@property (nonatomic,retain) NSString   * strID;
@property (nonatomic,retain) NSString   * strDesc;
@property (nonatomic,retain) NSString   * strData;
@property (nonatomic,retain) NSDate     * date;
@property (nonatomic) CacheType         type;
@property (nonatomic) BOOL              bSubmited;
@end

@interface RPTaskCachData : NSObject
@property (nonatomic,retain) NSString   * strID;
@property (nonatomic,retain) NSString   * strDesc;
@property (nonatomic,retain) NSString   * strData;
@property (nonatomic,retain) NSString   * strKey;
@property (nonatomic,retain) NSDate     * date;
@property (nonatomic) CacheType         type;
@property (nonatomic) BOOL              bNormalExit;
@end


//Inspection
typedef enum
{
    InspMark_NONE = 0,
    InspMark_1,
    InspMark_2,
    InspMark_3,
    InspMark_4,
    InspMark_5,
}InspMark;

//@interface RPInspReport : NSObject
//@property (nonatomic,retain) NSString           * strStoreName;
//@property (nonatomic,retain) NSString           * strStoreBrand;
//@property (nonatomic,retain) NSString           * strInspDate;
//@property (nonatomic,retain) NSString           * strInspUser;
//@property (nonatomic)        BOOL               bSelected;
//
//@end

@interface RPInspReporterUser : NSObject
@property (nonatomic)        BOOL        bUserCollegue;
@property (nonatomic,retain) RPColleague * collegue;
@property (nonatomic,retain) NSString    * strEmail;
@property (nonatomic)        BOOL        bSelected;
@end

@interface RPInspReporterSection : NSObject
@property (nonatomic,retain) NSString * strTitle1;
@property (nonatomic,retain) NSString * strTitle2;
@property (nonatomic,retain) NSString * strVendorID;
@property (nonatomic,retain) NSMutableArray * arrayUser;
@end

@interface RPInspReporters : NSObject
@property (nonatomic,retain) NSMutableArray * arraySection;
@end


@interface RPInspData : NSObject
@property (nonatomic,retain) NSMutableArray     * arrayInsp;       //RPInspVendor数组
@property (nonatomic,retain) NSString           * strImgShopUrl;
@property (nonatomic,retain) RPInspReporters    * reporters;
@end

@interface RPInspVendor : NSObject
@property (nonatomic,retain) NSString           * strVendorID;
@property (nonatomic,retain) NSString           * strVendorName;
@property (nonatomic,retain) NSString           * strVendorType;
@property (nonatomic,retain) NSMutableArray     * arrayCatagory;
@end

@interface RPInspCatagory : NSObject
@property (nonatomic,retain) NSString           * strCatagoryID;
@property (nonatomic,retain) NSString           * strCatagoryName;
@property (nonatomic,retain) NSString           * strCatagoryDesc;
@property (nonatomic) InspMark                  markCatagory;
@property (nonatomic,retain) NSMutableArray     * arrayIssue;
@end


@interface RPInspIssue : NSObject
@property (nonatomic,retain) NSString           * strIssueID;
@property (nonatomic,retain) NSString           * strIssueTitle;
@property (nonatomic,retain) NSString           * strIssueDesc;
@property (nonatomic,retain) NSString           * strVendorName;
@property (nonatomic,retain) NSString           * strVendorType;
@property (nonatomic,retain) NSString           * strVendorID;
@property (nonatomic) BOOL                      bHasLocation;
@property (nonatomic) CGPoint                   ptLocation;
@property (nonatomic,retain) NSMutableArray     * arrayIssueImg;
@end

@interface RPInspIssueImage : NSObject
@property (nonatomic,retain) NSString           * strUrl;
@property (nonatomic,retain) NSString           * strLocalFileName;
@property (nonatomic,retain) UIImage            * imgIssue;
@property (nonatomic)        CGRect             rcIssue;
@end

@interface RPInspReportResult : NSObject
@property (nonatomic,retain) NSString           * strResultID;
@property (nonatomic,retain) NSString           * strStoreName;
@property (nonatomic,retain) NSString           * strBrandName;
@property (nonatomic,retain) NSString           * strInspectionDate;
@property (nonatomic,retain) NSString           * strInspctor;
@property (nonatomic,retain) NSMutableArray     * arrayDetail;
@property (nonatomic)        BOOL               bSelected;
@end

@interface RPInspReportResultDetail : NSObject
@property (nonatomic,retain) NSString           * strCatagoryID;
@property (nonatomic)        InspMark           mark;
@property (nonatomic,retain) NSMutableArray     * arrayIssue;
@end

//Construction Visiting
@interface RPCVisitData : NSObject
@property (nonatomic,retain) NSMutableArray     * arrayIssue;
@property (nonatomic,retain) NSString           * strImgShopUrl;
@property (nonatomic) InspMark                  mark;
@property (nonatomic,retain) NSString           * strDesc;
@property (nonatomic,retain) RPInspReporters    * reporters;
@end

//Store Maintenance
@interface RPMaintenVendor : NSObject
@property (nonatomic,retain) NSString           * strVendorID;
@property (nonatomic,retain) NSString           * strVendorName;
@property (nonatomic,retain) NSString           * strVendorType;
@end

@interface RPContact : NSObject
@property (nonatomic,retain) NSString           * strUserName;
@property (nonatomic,retain) NSString           * strPhone;
@property (nonatomic) BOOL                      bColleague;
@end

@interface RPMaintenanceData : NSObject
@property (nonatomic,retain) NSMutableArray     * arrayIssue;
@property (nonatomic,retain) NSMutableArray     * arrayContacts;
@property (nonatomic,retain) NSString           * strContactsRemark;
@property (nonatomic,retain) NSString           * strImgShopUrl;
@property (nonatomic,retain) RPInspReporters    * reporters;
@end

