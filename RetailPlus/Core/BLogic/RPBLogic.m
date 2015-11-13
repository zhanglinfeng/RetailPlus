//
//  RPBLogic.m
//  RetailPlus
//
//  Created by lin dong on 13-8-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPBLogic.h"
#import "RPNetCore.h"
#import "GTMBase64.h"
#import "pinyin.h"
#import "RPBDataBase.h"
#import "RPOfflineData.h"

@implementation RPBLogic

static RPBLogic *defaultObject;

+(RPBLogic *)defaultInstance
{
    @synchronized(self){
        if (!defaultObject)
        {
            defaultObject = [[self alloc] init];
        }
    }
    return defaultObject;
}

+(NSString *)GetCacheDir
{
    NSString *imageDir = [NSString stringWithFormat:@"%@/Caches", NSTemporaryDirectory()];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return imageDir;
}

+(NSString *)genUUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef str_ref = CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)str_ref];
    
    CFRelease(str_ref);
    return uuid;
}

+ (UIImage *)CropImage:(UIImage *)image withSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColor(context, CGColorGetComponents([UIColor whiteColor].CGColor));
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    [image drawInRect:CGRectMake((size.width - image.size.width) / 2,(size.height - image.size.height) / 2,image.size.width,image.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
}

+(UIImage *) loadImageFromURL:(NSString *)fileURL
{
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[fileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    result = [UIImage imageWithData:data];
    return result;
}


+(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

-(id)init
{
    id ret = [super init];
    if (ret) {
        NSString *versionStr = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"ServerUrl"];
        self.strApiBaseUrl = versionStr;
        
        self.bDemoMode = NO;
        NSNumber *numDemoMode = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"DemoMode"];
        if(numDemoMode)
            self.bDemoMode = numDemoMode.boolValue;
        
        _dataOffline = [[RPOfflineData alloc] init];
    }
    return ret;
}

-(NSString *)GenTimeStamp
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateformatter stringFromDate:[NSDate date]];
}

-(NSDictionary *)GenRequestHead:(BOOL)bWithSession
{
    NSDictionary * dict = nil;
    NSString * strSession = _strSession;
    if (!bWithSession)
        strSession = @"";
    
    dict = @{@"sessionid":@"12345",@"timestamp":[self GenTimeStamp],@"v":API_VERSION,@"appkey":API_APPKEY,@"appsercet":API_SECRET};
    
    return dict;
}

-(NSString *)ValidateString:(NSString *)str
{
    NSString * strRet = [[NSString alloc] init];
    strRet = @"";
    
    if (str == nil || (id)str == [NSNull null]) {
        return strRet;
    }
    return str;
}

-(NSString *)GetSavedLoginUserName
{
    NSString *filename=[NSTemporaryDirectory() stringByAppendingPathComponent:@"system.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    return [data objectForKey:@"LoginUserName"];
}

-(NSString *)GetSavedPassword
{
    NSString *filename=[NSTemporaryDirectory() stringByAppendingPathComponent:@"system.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSNumber * numAuto = [data objectForKey:@"AutoLogin"];
    if (numAuto.boolValue) {
        return [data objectForKey:@"LoginPsw"];
    }
    return nil;
}

-(void)SaveLoginUserName:(NSString *)strUserName Password:(NSString *)strPassword autoLogin:(BOOL)bAutoLogin
{
    NSString *filename=[NSTemporaryDirectory() stringByAppendingPathComponent:@"system.plist"];
    //输入写入
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:strUserName forKey:@"LoginUserName"];
    if (bAutoLogin) {
        [dict setObject:strPassword forKey:@"LoginPsw"];
        [dict setObject:[NSNumber numberWithBool:bAutoLogin] forKey:@"AutoLogin"];
    }
    else
    {
        [dict setObject:@"" forKey:@"LoginPsw"];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"AutoLogin"];
    }
    [dict writeToFile:filename atomically:YES];
}

-(void)Login:(NSString *)strUserName PassWord:(NSString *)strPassWord success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (self.bDemoMode) {
        [[RPOfflineData defaultInstance] Login:strUserName PassWord:strPassWord success:^(id dictResult) {
            _strLoginUserName = strUserName;
            _strSession = @"demosession";
            
            NSString *filename=[NSTemporaryDirectory() stringByAppendingPathComponent:@"system.plist"];
            //输入写入
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:_strLoginUserName forKey:@"LoginUserName"];
            [dict writeToFile:filename atomically:YES];
            
            successBlock(dictResult);
        } failed:^(NSInteger nErrorCode, NSString *strDesc) {
            failedBlock(nErrorCode,strDesc);
        }];
    }
    else
    {
        if (strUserName && strPassWord) {
            [RPNetCore doRequestBySimple:kAPIUserLogin withHead:[self GenRequestHead:NO] withBody:[NSArray arrayWithObjects:strUserName,strPassWord,nil]
            success:^(NSDictionary * dictResult)
            {
                _strLoginUserName = strUserName;
                _strSession = [dictResult objectForKey:@"AuthToken"];
                self.arrayCacheData = [[RPBDataBase defaultInstance] GetCacheDataArray:_strLoginUserName];
                
                NSString *filename=[NSTemporaryDirectory() stringByAppendingPathComponent:@"system.plist"];
                //输入写入
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                [dict setObject:_strLoginUserName forKey:@"LoginUserName"];
                [dict writeToFile:filename atomically:YES];
                
                successBlock(dictResult);
            }
            failed:^(NSInteger nErrorCode,NSString * strDesc)
            {
                 failedBlock(nErrorCode,strDesc);
            }];
        }
    }
}

-(void)SetUrl:(NSString *)strUrl
{
    self.strApiBaseUrl = strUrl;
}

-(void)ChangePsw:(NSString *)strUserName OldPassWord:(NSString *)strPassWordOld PassWord:(NSString *)strPassWord success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (strUserName && strPassWord && strPassWordOld) {
        [RPNetCore doRequestBySimple:kAPIUpdatePwd withHead:[self GenRequestHead:YES] withBody:[NSArray arrayWithObjects:strUserName,strPassWordOld,strPassWord,nil]
         success:^(NSDictionary * dictResult)
         {
             successBlock(dictResult);
         }
         failed:^(NSInteger nErrorCode,NSString * strDesc)
         {
             failedBlock(nErrorCode,strDesc);
         }];
    }
}

-(void)Logout
{
    NSString * strLoginUserName = [self GetSavedLoginUserName];
    
    NSString *filename=[NSTemporaryDirectory() stringByAppendingPathComponent:@"system.plist"];
    //输入写入
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:strLoginUserName forKey:@"LoginUserName"];
    [dict setObject:@"" forKey:@"LoginPsw"];
    [dict setObject:[NSNumber numberWithBool:NO] forKey:@"AutoLogin"];
    [dict writeToFile:filename atomically:YES];
    
   _colleagueLoginUser = nil;
   _strLoginUserName = nil;
   _arrayCacheData = nil;
}

-(void)GetLoginDeviceSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    [RPNetCore doRequestBySimple:kAPIGetLoginDevice withHead:[self GenRequestHead:YES] withBody:[NSArray arrayWithObjects:nil]
                         success:^(NSDictionary * dictResult)
     {
         _bLoginProtection = ((NSNumber *)[dictResult objectForKey:@"IsLoginProtection"]).boolValue;
         _arrayLoginDevice = [[NSMutableArray alloc] init];
         
         NSArray * arrayDeviceGet = [dictResult objectForKey:@"LoginDeviceList"];
         for (NSDictionary * dictDeviceGet in arrayDeviceGet) {
             RPLoginDevice * device = [[RPLoginDevice alloc] init];
             device.strDeviceName = [dictDeviceGet objectForKey:@"DeviceName"];
             device.strDeviceType = [dictDeviceGet objectForKey:@"DeviceType"];
             device.strDeviceUUID = [dictDeviceGet objectForKey:@"DeviceUUID"];
             device.strLastLoginDate = [dictDeviceGet objectForKey:@"LastLoginDate"];
             device.strLoginDeviceId = [dictDeviceGet objectForKey:@"LoginDeviceId"];
             [_arrayLoginDevice addObject:device];
         }
         successBlock(dictResult);
     }
                          failed:^(NSInteger nErrorCode,NSString * strDesc)
     {
         failedBlock(nErrorCode,strDesc);
     }];
    
}

-(void)SubmitFeedback:(NSString *)strFeedBack Success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    [RPNetCore doRequestBySimple:kAPISubmitFeedback withHead:[self GenRequestHead:YES] withBody:[NSArray arrayWithObjects:strFeedBack,nil]
                         success:^(NSDictionary * dictResult)
     {
         successBlock(dictResult);
     }
                          failed:^(NSInteger nErrorCode,NSString * strDesc)
     {
         failedBlock(nErrorCode,strDesc);
     }];
}

-(void)GetLoginUserProfileSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    _loginProfile = [[RPLoginUserProfile alloc] init];
    _loginProfile.strAlternatePhone = @"123456";
    _loginProfile.dateBirthday = [NSDate date];
    _loginProfile.bPublicAge = YES;
    _loginProfile.bSexMale = YES;
    _loginProfile.nRoleLevel = 1;
//    _loginProfile.strSurName = @"Dong";
    _loginProfile.strFirstName = @"Popeye";
    _loginProfile.strPhone = @"13888888888";
    _loginProfile.strAlternatePhone = @"1333333333";
    _loginProfile.strInterest = @"Music";
    _loginProfile.strJobTitle = @"Store Manager";
    _loginProfile.strEmail = @"popeyedong@163.com";
    _loginProfile.strJoinedAt = @"2012-11-11";
    _loginProfile.strOfficePhone = @"123456";
    _loginProfile.strOfficeAddress = @"shanghai";
    _loginProfile.strPosition = @"风尚";
    _loginProfile.strEnterprise = @"swatch";
    _loginProfile.strReportToId = @"zhao";
    successBlock(_loginProfile);
    
//    [RPNetCore doRequestBySimple:kAPIGetProfile withHead:[self GenRequestHead:YES] withBody:nil
//                         success:^(NSDictionary * dictResult)
//     {
//         _loginProfile = [[RPLoginUserProfile alloc] init];
//         
//         successBlock(_loginProfile);
//     }
//                          failed:^(NSInteger nErrorCode,NSString * strDesc)
//     {
//         failedBlock(nErrorCode,strDesc);
//     }];
}

-(void)QuitEnterpriseSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    [RPNetCore doRequestBySimple:kAPIQuitOwner withHead:[self GenRequestHead:YES] withBody:nil
                         success:^(NSDictionary * dictResult)
     {
         successBlock(nil);
     }
                          failed:^(NSInteger nErrorCode,NSString * strDesc)
     {
         failedBlock(nErrorCode,strDesc);
     }];
}

-(void)GetSimUserInfoSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    [RPNetCore doRequestBySimple:kAPIGetSimUserInfo withHead:[self GenRequestHead:YES] withBody:nil
    success:^(NSDictionary * dictResult)
    {
        _simUserInfo = [[RPSimUserInfo alloc] init];
        _simUserInfo.strBoundEmail = [self ValidateString:[dictResult objectForKey:@"BoundEmail"]];
        _simUserInfo.strPhoneNo = [self ValidateString:[dictResult objectForKey:@"PhoneNo"]];
        _simUserInfo.strRpNo = [self ValidateString:[dictResult objectForKey:@"RpNo"]];
        successBlock(_simUserInfo);
    }
    failed:^(NSInteger nErrorCode,NSString * strDesc)
    {
        failedBlock(nErrorCode,strDesc);
    }];
}

-(void)BoundEmail:(NSString *)strEmail SendEmail:(NSString *)strEmailSend Success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    [RPNetCore doRequest:kAPIBoundEmail withHead:[self GenRequestHead:YES] withBody:@{@"NewEmail":strEmail,@"EmailAddress":strEmailSend}
    success:^(NSDictionary * dictResult)
    {
         successBlock(dictResult);
    }
    failed:^(NSInteger nErrorCode,NSString * strDesc)
    {
        failedBlock(nErrorCode,strDesc);
    }];
}

-(void)RequestIdCert:(NSString *)strCertNo DeviceType:(CERTDEVICETYPE)deviceType CertType:(CERTTYPE)certType success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    [RPNetCore doRequestBySimple:kAPIRequestIdcert withHead:[self GenRequestHead:NO] withBody:[NSArray arrayWithObjects:strCertNo,[NSString stringWithFormat:@"%d",deviceType],[NSString stringWithFormat:@"%d",certType],nil]
     success:^(NSDictionary * dictResult)
     {
         _strSession = [dictResult objectForKey:@"AuthToken"];
         successBlock(dictResult);
     }
     failed:^(NSInteger nErrorCode,NSString * strDesc)
     {
         failedBlock(nErrorCode,strDesc);
     }];
}

-(void)VerifyIdCert:(NSString *)strVerifyCode CertType:(CERTTYPE)certType success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (_strSession) {
        [RPNetCore doRequestBySimple:kAPIVerifyIdcert withHead:[self GenRequestHead:YES] withBody:[NSArray arrayWithObjects:strVerifyCode,[NSString stringWithFormat:@"%d",certType],nil]
                             success:^(NSDictionary * dictResult)
         {
             successBlock(dictResult);
         }
                              failed:^(NSInteger nErrorCode,NSString * strDesc)
         {
             failedBlock(nErrorCode,strDesc);
         }];
    }
    else
        failedBlock(-1,nil);
}

-(void)SignUpGetVerifyCode:(NSString *)strPhoneNo success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (strPhoneNo) {
        [RPNetCore doRequestBySimple:kAPIGetCheckCode withHead:[self GenRequestHead:NO] withBody:[NSArray arrayWithObjects:strPhoneNo,nil]
        success:^(NSDictionary * dictResult)
        {
             successBlock(dictResult);
        }
        failed:^(NSInteger nErrorCode,NSString * strDesc)
        {
             failedBlock(nErrorCode,strDesc);
        }];
    }
}

-(void)SignUpVerifyCode:(NSString *)strPhoneNo VerifyCode:(NSString *)strVerifyCode success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (strPhoneNo && strVerifyCode) {
        [RPNetCore doRequestBySimple:kAPICheckCode withHead:[self GenRequestHead:NO] withBody:[NSArray arrayWithObjects:strPhoneNo,strVerifyCode,nil]
        success:^(NSDictionary * dictResult)
         {
             successBlock(dictResult);
         }
        failed:^(NSInteger nErrorCode,NSString * strDesc)
         {
             failedBlock(nErrorCode,strDesc);
         }];
    }
}

-(void)SignUpSetPsw:(NSString *)strPhoneNo PassWord:(NSString *)strPassWord success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (strPhoneNo && strPassWord) {
        self.arrayCacheData = [[NSMutableArray alloc] init];
        
        [RPNetCore doRequestBySimple:kAPISetPassword withHead:[self GenRequestHead:NO] withBody:[NSArray arrayWithObjects:strPhoneNo,strPassWord,nil]
        success:^(NSDictionary * dictResult)
         {
             _strLoginUserName = strPhoneNo;
             _strSession = [dictResult objectForKey:@"AuthToken"];
             successBlock(dictResult);
             
             NSString *filename=[NSTemporaryDirectory() stringByAppendingPathComponent:@"system.plist"];
             //输入写入
             NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
             [dict setObject:_strLoginUserName forKey:@"LoginUserName"];
             [dict writeToFile:filename atomically:YES];
         }
        failed:^(NSInteger nErrorCode,NSString * strDesc)
         {
             failedBlock(nErrorCode,strDesc);
         }];
    }
}


-(void)ModifyUserProfile:(NSString *)strFirstName Email:(NSString *)strEmail Image:(UIImage *)image Sex:(RPSex)sex success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    NSString * strImage =  [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(image, 0.5)];
    if (strImage == nil) {
        strImage = @"";
    }
    
    [RPNetCore doRequest:kAPIModifyUserProfile withHead:[self GenRequestHead:YES] withBody:@{@"FirstName":strFirstName,@"Email":strEmail,@"UserImg":strImage,@"Sex":[NSNumber numberWithInteger:sex]}
    success:^(NSDictionary * dictResult) {
        successBlock(dictResult);
    }
    failed:^(NSInteger nErrorCode, NSString *strDesc) {
        failedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetStoreListSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (self.bDemoMode) {
        [[RPOfflineData defaultInstance] GetStoreList:YES Success:^(id dictResult) {
            successBlock(dictResult);
        } failed:^(NSInteger nErrorCode, NSString *strDesc) {
            failedBlock(nErrorCode,strDesc);
        }];
    }
    else
    {
        [RPNetCore doRequestBySimple:kAPIGetStoreListByUser withHead:[self GenRequestHead:YES] withBody:nil
        success:^(NSArray * arrayResult)
         {
             
             NSMutableArray * arrayStore = [[NSMutableArray alloc] init];
             
             for (NSDictionary * dict in arrayResult) {
                 RPStore * store = [[RPStore alloc] init];
                 store.strStoreName = [dict objectForKey:@"StoreName"];
                 NSString * strThumb = [dict objectForKey:@"StoreThumb"];
                 if (strThumb && strThumb.length > 0) {
                     store.strImageThumb = strThumb;
                     store.strImageThumbBig = [store.strImageThumb stringByReplacingCharactersInRange:NSMakeRange(store.strImageThumb.length - 6,2) withString:@"_2"];
                 }
                 
                 //store.strStoreThumb = [dict objectForKey:@""];
                 store.strBrandName = [self ValidateString:[dict objectForKey:@"BrandName"]];
                 store.strCityName = [self ValidateString:[dict objectForKey:@"CityName"]];
                 store.strDealerName = [self ValidateString:[dict objectForKey:@"DealerName"]];
                 store.strStoreAddress = [self ValidateString:[dict objectForKey:@"StoreAddress"]];
                 store.strStoreCode = [self ValidateString:[dict objectForKey:@"StoreCode"]];
                 store.strDistrictCode = [self ValidateString:[dict objectForKey:@"DistrictCode"]];
                 store.strStorePhone = [self ValidateString:[dict objectForKey:@"Phone"]];
                 
                 store.strFax = [self ValidateString:[dict objectForKey:@"Fax"]];
                 store.strEmail = [self ValidateString:[dict objectForKey:@"Email"]];
                 store.nStartTime = ((NSNumber *)[dict objectForKey:@"StartTime"]).integerValue;
                 store.nEndTime = ((NSNumber *)[dict objectForKey:@"EndTime"]).integerValue;
                 store.nWeatherCode = ((NSNumber *)[dict objectForKey:@"WeatherCode"]).integerValue;
                 
                 BOOL bFav = ((NSNumber *)[dict objectForKey:@"IsFavorite"]).boolValue;
                 store.bFavorite = bFav;
                 
                 // store.bHasInspection = [dict objectForKey:@""];
                 store.strMarket = [self ValidateString:[dict objectForKey:@"Market"]];
                 store.strShopMap = [self ValidateString:[dict objectForKey:@"ShopMap"]];
                 store.strStoreID = [self ValidateString:[dict objectForKey:@"StoreId"]];
                 store.strAreaSquare = [self ValidateString:[dict objectForKey:@"AreaSquare"]];
                 store.strDecorationDate = [self ValidateString:[dict objectForKey:@"DecorationDate"]];
                 
                 NSNumber * num = [dict objectForKey:@"IsOwn"];
                 if (num && (id)num != [NSNull null]) {
                     store.isStoreUser = num.boolValue;
                 }
                 
                 num = [dict objectForKey:@"IsPerfect"];
                 if (num && (id)num != [NSNull null]) {
                     store.isInfoComplete = num.boolValue;
                 }
                 
                 // store.bHasReview = [dict objectForKey:@""];
                 
                 [arrayStore addObject:store];
             }
             successBlock(arrayStore);
         }
        failed:^(NSInteger nErrorCode,NSString * strDesc)
         {
             failedBlock(nErrorCode,strDesc);
         }];
    }
}

-(void)GetMCReports:(NSString *)strReportID success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (self.bDemoMode) {
        [[RPOfflineData defaultInstance] GetMCReports:strReportID success:^(id dictResult) {
            successBlock(dictResult);
        } failed:^(NSInteger nErrorCode, NSString *strDesc) {
            failedBlock(nErrorCode,strDesc);
        }];
    }
    else
    {
        if (_strSession == nil) {
            return;
        }
        
         [RPNetCore doRequestBySimple:kAPIGetMCReports withHead:[self GenRequestHead:YES] withBody:[NSArray arrayWithObjects:strReportID,nil]
         success:^(NSArray * arrayResult)
         {
             NSMutableArray * array = [[NSMutableArray alloc] init];
             for (NSDictionary * dictResult in  arrayResult) {
                  RPMCReport * report = [[RPMCReport alloc] init];
                 
                 report.strReportID = [self ValidateString:[dictResult objectForKey:@"MegId"]];
                 report.strReportName = [self ValidateString:[dictResult objectForKey:@"DocName"]];
                 report.strReportType = [self ValidateString:[dictResult objectForKey:@"DocType"]];
                 report.strReportUrl = [self ValidateString:[dictResult objectForKey:@"DocUrl"]];
                 NSString * strDate = [dictResult objectForKey:@"DeliveryDate"];
                 if (strDate && (id)strDate != [NSNull null]) {
                     NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                     [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                     report.dateReport = [[NSDate alloc] init];
                     report.dateReport = [formatter dateFromString:strDate];
                 }
                 
                 
                 NSDictionary * dictSender = [dictResult objectForKey:@"DeliveryBy"];
                 report.strSenderID = [self ValidateString:[dictSender objectForKey:@"UserId"]];
                 report.strSenderName = [self ValidateString:[dictSender objectForKey:@"UserName"]];
                 
                 NSNumber * num = [dictSender objectForKey:@"RoleLevel"];
                 if (num && (id)num != [NSNull null]) {
                     report.nRoleLevel = num.integerValue;
                 }
                 
                 NSString * strPic = [dictSender objectForKey:@"UserImg"];
                 if (strPic && strPic.length > 0) {
                     report.strImgPic = strPic;
                 }

                 [array addObject:report];
             }
             successBlock(array);
         }
         failed:^(NSInteger nErrorCode,NSString * strDesc)
         {
             failedBlock(nErrorCode,strDesc);
         }];
    }
}

-(void)GetInspCatagory:(NSString *)strStoreID success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock

{
    if (_bDemoMode) {
        [[RPOfflineData defaultInstance] GetInspCatagory:strStoreID success:^(id dictResult) {
            successBlock(dictResult);
        } failed:^(NSInteger nErrorCode, NSString *strDesc) {
            failedBlock(nErrorCode,strDesc);
        }];
    }
    else
    {
        [RPNetCore doRequestBySimple:kAPIGetInspCatagory withHead:[self GenRequestHead:YES] withBody:[NSArray arrayWithObjects:strStoreID,nil]
         success:^(NSDictionary * dictResult) {
             
             RPInspData * data = [[RPInspData alloc] init];
             data.arrayInsp = [[NSMutableArray alloc] init];
             
             NSArray * vendors = [dictResult objectForKey:@"Vedors"];
             for (NSDictionary * vendor in vendors) {
                 RPInspVendor * vendorAdd = [[RPInspVendor alloc] init];
                 vendorAdd.strVendorID = [vendor objectForKey:@"VendorId"];
                 vendorAdd.strVendorType = [vendor objectForKey:@"VendorType"];
                 vendorAdd.strVendorName = [vendor objectForKey:@"VendorName"];
                 vendorAdd.arrayCatagory = [[NSMutableArray alloc] init];
                 
                 NSArray * catagories = [vendor objectForKey:@"Categorys"];
                 for (NSDictionary * catagory in catagories) {
                     RPInspCatagory * catagoryAdd = [[RPInspCatagory alloc] init];
                     catagoryAdd.strCatagoryDesc = [catagory objectForKey:@"CategoryDesc"];
                     catagoryAdd.strCatagoryID = [catagory objectForKey:@"CategoryId"];
                     catagoryAdd.strCatagoryName = [catagory objectForKey:@"CategoryName"];
                     
                     NSString * strUnit = [catagory objectForKey:@"Unit"];
                     NSNumber * num = [catagory objectForKey:@"Quantity"];
                     if (num && (id)num != [NSNull null]) {
                         catagoryAdd.strCatagoryDesc = [NSString stringWithFormat:@"%@(%d %@)",catagoryAdd.strCatagoryDesc,num.integerValue,strUnit];
                     }
                     
                     [vendorAdd.arrayCatagory addObject:catagoryAdd];
                 }
                 
                 [data.arrayInsp addObject:vendorAdd];
             }
             
             successBlock(data);
         }
         failed:^(NSInteger nErrorCode, NSString *strDesc) {
              failedBlock(nErrorCode,strDesc);
         }];
    }
}

-(void)GetInspReports:(NSString *)strStoreID success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (self.bDemoMode) {
        [[RPOfflineData defaultInstance] GetInspReports:strStoreID success:^(id dictResult) {
            successBlock(dictResult);
        } failed:^(NSInteger nErrorCode, NSString *strDesc) {
            failedBlock(nErrorCode,strDesc);
        }];
    }
    else
    {
        [RPNetCore doRequestBySimple:kAPIGetInspReports withHead:[self GenRequestHead:YES] withBody:[NSArray arrayWithObjects:strStoreID,nil]
        success:^(NSMutableArray * arrayResult) {
            NSMutableArray * array = [[NSMutableArray alloc] init];
            for (NSDictionary * dict in arrayResult) {
                RPInspReportResult * data = [[RPInspReportResult alloc] init];
                data.arrayDetail = [[NSMutableArray alloc] init];
                data.strResultID = [self ValidateString:[dict objectForKey:@"InspId"]];
                data.strStoreName = [self ValidateString:[dict objectForKey:@"StoreName"]];
                data.strBrandName = [self ValidateString:[dict objectForKey:@"BrandName"]];
                data.strInspctor = [self ValidateString:[dict objectForKey:@"Inspector"]];
                data.strInspectionDate = [self ValidateString:[dict objectForKey:@"InspectionDate"]];
                data.arrayDetail = [[NSMutableArray alloc] init];
                data.bSelected = NO;
                
                NSArray * details = [dict objectForKey:@"IssuesData"];
                for (NSDictionary * dictDetail in details) {
                    RPInspReportResultDetail * rsDetail = [[RPInspReportResultDetail alloc] init];
                    
                    rsDetail.strCatagoryID = [self ValidateString:[dictDetail objectForKey:@"ItemId"]];
                    NSNumber * number = [dictDetail objectForKey:@"Score"];
                    if (number && (id)number != [NSNull null]) {
                        rsDetail.mark = number.intValue;
                    }
                    
                    rsDetail.arrayIssue = [[NSMutableArray alloc] init];
                    
                    NSArray * issues = [dictDetail objectForKey:@"Issues"];
                    for (NSDictionary * dictIssue in issues){
                        RPInspIssue * issue = [[RPInspIssue alloc] init];
                        issue.strIssueDesc = [self ValidateString:[dictIssue objectForKey:@"IssueDesc"]];
                        issue.strIssueID = [self ValidateString:[dictIssue objectForKey:@"IssueGid"]];
                        issue.strIssueTitle = [self ValidateString:[dictIssue objectForKey:@"Title"]];
                        issue.arrayIssueImg = [[NSMutableArray alloc] init];
                        
                        NSNumber * numberX = [dictIssue objectForKey:@"X"];
                        NSNumber * numberY = [dictIssue objectForKey:@"Y"];
                        if (numberX && (id)numberX != [NSNull null] && numberY && (id)numberY != [NSNull null]) {
                            issue.bHasLocation = YES;
                            issue.ptLocation = CGPointMake(numberX.intValue, numberY.intValue);
                        }
                        
    //                    for (NSDictionary * location in locations) {
    //                        NSNumber * numberX = [location objectForKey:@"X"];
    //                        NSNumber * numberY = [location objectForKey:@"Y"];
    //                        if (numberX && (id)numberX != [NSNull null] && numberY && (id)numberY != [NSNull null]) {
    //                            issue.bHasLocation = YES;
    //                            issue.ptLocation = CGPointMake(numberX.intValue, numberY.intValue);
    //                        }
    //                    }
                        
                        NSArray * images = [dictIssue objectForKey:@"IssueImgs"];
                        
                        issue.arrayIssueImg = [NSMutableArray arrayWithArray:@[[[RPInspIssueImage alloc] init],[[RPInspIssueImage alloc] init], [[RPInspIssueImage alloc] init]]];
                        NSInteger n = 0;
                        for (NSDictionary * image in images) {
                            RPInspIssueImage * issueImage = [[RPInspIssueImage alloc] init];
                            NSString * strPic = [image objectForKey:@"ImgData"];
                            if (strPic && ((id)strPic != [NSNull null])) {
                                issueImage.strUrl = strPic;
                                
                                NSNumber * numHeight = [image objectForKey:@"RegHeight"];
                                NSNumber * numWidth = [image objectForKey:@"RegWidth"];
                                NSNumber * numX = [image objectForKey:@"RegX"];
                                NSNumber * numY = [image objectForKey:@"RegY"];
                                
                                if ((numHeight && ((id)numHeight != [NSNull null])) &&
                                    (numWidth && ((id)numWidth != [NSNull null])) &&
                                    (numX && ((id)numX != [NSNull null])) &&
                                    (numY && ((id)numY != [NSNull null]))) {
                                    issueImage.rcIssue = CGRectMake(numX.integerValue, numY.integerValue, numWidth.integerValue, numHeight.integerValue);
                                }
                                [issue.arrayIssueImg replaceObjectAtIndex:n withObject:issueImage];
                                n++;
                            }
                        }

                        [rsDetail.arrayIssue addObject:issue];
                    }
                    [data.arrayDetail addObject:rsDetail];
                }
                [array addObject:data];
            }
             
             successBlock(array);
         }
        failed:^(NSInteger nErrorCode, NSString *strDesc) {
              failedBlock(nErrorCode,strDesc);
        }];
    }
}


-(void)GetColleagueByVendor:(NSString *)strVendorId success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (_bDemoMode) {
        successBlock(nil);
    }
    else
    {
        [RPNetCore doRequestBySimple:kAPIGetColleagueByVendor withHead:[self GenRequestHead:YES] withBody:[NSArray arrayWithObjects:strVendorId,nil]
         success:^(NSArray * arrayResult) {
             NSMutableArray * arrayRet = [[NSMutableArray alloc] init];
             for (NSDictionary * dict in arrayResult) {
                 RPColleague  * colleague = [[RPColleague alloc] init];
                 colleague.strFirstName = [self ValidateString:[dict objectForKey:@"FirstName"]];
//                 colleague.strSurName = [self ValidateString:[dict objectForKey:@"SurName"]];
                 colleague.strBirthday = [self ValidateString:[dict objectForKey:@"Birthday"]];
                 colleague.strEmail = [self ValidateString:[dict objectForKey:@"Email"]];
                 colleague.strID = [self ValidateString:[dict objectForKey:@"UserId"]];
                 
                 NSNumber * num = [dict objectForKey:@"IsRegist"];
                 if (num && (id)num != [NSNull null]) colleague.bRegist = num.boolValue;
                 
                 colleague.strPhone = [self ValidateString:[dict objectForKey:@"Phone"]];
                 colleague.strRoleDesc = [self ValidateString:[dict objectForKey:@"RoleDesc"]];
                 
                 num = [dict objectForKey:@"RoleLevel"];
                 if (num && (id)num != [NSNull null]) colleague.nRoleLevel = num.intValue;
                 
                 num = [dict objectForKey:@"Sex"];
                 if (num && (id)num != [NSNull null]) colleague.sex = num.intValue;
                 else colleague.sex = RPSex_UnSpec;
                 
                 NSString * strPic = [dict objectForKey:@"UserImg"];
                 if (strPic && strPic.length > 0) {
                     colleague.strImgPic = strPic;
                     colleague.strImgPicBig = [colleague.strImgPic stringByReplacingCharactersInRange:NSMakeRange(colleague.strImgPic.length - 6,2) withString:@"_2"];
                 }
                 
                 NSDictionary * dictReportTo = [dict objectForKey:@"UserReport"];
                 if (dictReportTo && ((id)dictReportTo != [NSNull null])) {
                     colleague.strReportToName = [self ValidateString:[dictReportTo objectForKey:@"UserName"]];
                     colleague.strReportToID = [self ValidateString:[dictReportTo objectForKey:@"UserID"]];
                 }
                 
                 if (colleague.bRegist == NO)
                     colleague.strFirstName = colleague.strPhone;
                 
                 if (colleague.strFirstName.length > 0) {
                     NSString *subString = [colleague.strFirstName substringToIndex:1];
                     int a = [subString characterAtIndex:0];
                     if( a > 0x4e00 && a < 0x9fff)
                     {
                         char c = pinyinFirstLetter([subString characterAtIndex:0]);
                         colleague.strCompare = [[NSString alloc] initWithBytes:&c length:1 encoding:NSUTF8StringEncoding];
                         colleague.strSectionLetter = colleague.strCompare;
                     }
                     else if (a < 65)
                     {
                         colleague.bFirstAlph = YES;
                         colleague.strCompare = colleague.strFirstName;
                         colleague.strSectionLetter = @"#";
                     }
                     else
                     {
                         colleague.strCompare = colleague.strFirstName;
                         colleague.strSectionLetter = [colleague.strFirstName substringToIndex:1];
                     }
                     
                     [arrayRet addObject:colleague];
                 }
             }
             successBlock(arrayRet);
         }
         failed:^(NSInteger nErrorCode, NSString *strDesc) {
              failedBlock(nErrorCode,strDesc);
         }];
    }
}

-(BOOL)SaveUploadCache:(NSDictionary *)dictBody Type:(CacheType)type Desc:(NSString *)strDesc
{
    return [[RPBDataBase defaultInstance] SaveUploadCache:_strLoginUserName CacheType:type Data:dictBody Date:[self GenTimeStamp] Desc:strDesc ToArray:_arrayCacheData];
}

-(NSDictionary *)GenRectificationData:(NSString *)strStoreID Data:(RPInspData *)data
{
    NSMutableDictionary * dictBody = [[NSMutableDictionary alloc] init];
    [dictBody setObject:strStoreID forKey:@"storeId"];
    
    NSMutableArray * arrayEmail = [[NSMutableArray alloc] init];
    NSMutableArray * arrayColleague = [[NSMutableArray alloc] init];
    
    for (RPInspReporterSection * section in data.reporters.arraySection) {
        for (RPInspReporterUser * user in section.arrayUser) {
            if (user.bSelected) {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                if (user.bUserCollegue)
                {
                    [dict setObject:user.collegue.strID forKey:@"UserId"];
                    if (section.strVendorID) {
                        [dict setObject:section.strVendorID forKey:@"DataId"];
                    }
                    
                    [arrayColleague addObject:dict];
                }
                else
                {
                    [dict setObject:user.strEmail forKey:@"Email"];
                    if (section.strVendorID) {
                        [dict setObject:section.strVendorID forKey:@"DataId"];
                    }
                    
                    [arrayEmail addObject:dict];
                }
            }
        }
    }
    [dictBody setObject:arrayEmail forKey:@"EmailList"];
    [dictBody setObject:arrayColleague forKey:@"UserList"];
    
    NSMutableDictionary * dictInspData = [[NSMutableDictionary alloc] init];
    [dictInspData setObject:@"" forKey:@"InspId"];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString * strDate = [dateformatter stringFromDate:[NSDate date]];
    [dictInspData setObject:strDate forKey:@"InspectionDate"];
    
    NSMutableArray * arrayCatagory = [[NSMutableArray alloc] init];
    for (RPInspVendor * vendor in data.arrayInsp)
    {
        for (RPInspCatagory * catagory in vendor.arrayCatagory) {
            NSMutableDictionary * dictCatagory = [[NSMutableDictionary alloc] init];
            [dictCatagory setObject:catagory.strCatagoryID forKey:@"ItemId"];
            [dictCatagory setObject:[NSNumber numberWithInteger:catagory.markCatagory] forKey:@"Score"];
            
            NSMutableArray * arrayIssues = [[NSMutableArray alloc] init];
            for (RPInspIssue * issue in catagory.arrayIssue) {
                NSMutableDictionary * dictIssue = [[NSMutableDictionary alloc] init];
                [dictIssue setObject:issue.strIssueDesc forKey:@"IssueDesc"];
                [dictIssue setObject:@"" forKey:@"IssueGid"];
                [dictIssue setObject:issue.strIssueTitle forKey:@"Title"];
                
                [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.x] forKey:@"X"];
                [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.y] forKey:@"Y"];
                
                NSMutableArray * arrayImage = [[NSMutableArray alloc] init];
                for (RPInspIssueImage * image in issue.arrayIssueImg) {
                    if (image.imgIssue == nil && image.strUrl.length > 0) {
                        image.imgIssue = [RPBLogic loadImageFromURL:image.strUrl];
                    }
                    
                    if (image.imgIssue) {
                        NSMutableDictionary * dictImage = [[NSMutableDictionary alloc] init];
                        NSString * strImage =  [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(image.imgIssue, 0.5)];
                        
                        [dictImage setObject:strImage forKey:@"ImgData"];
                        
                        [dictImage setObject:[NSNumber numberWithInteger:image.rcIssue.size.height] forKey:@"RegHeight"];
                        [dictImage setObject:[NSNumber numberWithInteger:image.rcIssue.size.width] forKey:@"RegWidth"];
                        [dictImage setObject:[NSNumber numberWithInteger:image.rcIssue.origin.x] forKey:@"RegX"];
                        [dictImage setObject:[NSNumber numberWithInteger:image.rcIssue.origin.y] forKey:@"RegY"];
                        
                        [arrayImage addObject:dictImage];
                    }
                }
                [dictIssue setObject:arrayImage forKey:@"IssueImgs"];
                
                [arrayIssues addObject:dictIssue];
            }
            [dictCatagory setObject:arrayIssues forKey:@"Issues"];
            
            [arrayCatagory addObject:dictCatagory];
        }
    }
    
    [dictInspData setObject:arrayCatagory forKey:@"IssuesData"];
    [dictBody setObject:dictInspData forKey:@"Inspdata"];
    return dictBody;
}

-(void)SubmitRectification:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(RPInspData *)data success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (self.bDemoMode) {
        successBlock(nil);
    }
    else
    {
        NSDictionary * dictBody = [self GenRectificationData:strStoreID Data:data];
        [RPNetCore doRequest:kAPIUploadRectification withHead:[self GenRequestHead:YES] withBody:dictBody
        success:^(id dictResult) {
            successBlock(dictResult);
        }
        failed:^(NSInteger nErrorCode, NSString *strDesc) {
            if ([self SaveUploadCache:dictBody Type:CACHETYPE_RECTIFICITION Desc:strStoreName]) {
                failedBlock(1000,@"Add to local submit array success");
            }
            else
            {
                failedBlock(1001,@"Add to local submit array failed");
            }
        }];
    }
}

-(NSDictionary *)GenInspData:(NSString *)strStoreID Data:(RPInspData *)data
{
    NSMutableDictionary * dictBody = [[NSMutableDictionary alloc] init];
    [dictBody setObject:strStoreID forKey:@"storeId"];
    
    NSMutableArray * arrayEmail = [[NSMutableArray alloc] init];
    NSMutableArray * arrayColleague = [[NSMutableArray alloc] init];
    
    for (RPInspReporterSection * section in data.reporters.arraySection) {
        for (RPInspReporterUser * user in section.arrayUser) {
            if (user.bSelected) {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                if (user.bUserCollegue)
                {
                    [dict setObject:user.collegue.strID forKey:@"UserId"];
                    [dict setObject:@"" forKey:@"DataId"];
                    [arrayColleague addObject:dict];
                }
                else
                {
                    [dict setObject:user.strEmail forKey:@"Email"];
                    [dict setObject:@"" forKey:@"DataId"];
                    [arrayEmail addObject:dict];
                }
            }
        }
    }
    [dictBody setObject:arrayEmail forKey:@"EmailList"];
    [dictBody setObject:arrayColleague forKey:@"UserList"];
    
    NSMutableDictionary * dictInspData = [[NSMutableDictionary alloc] init];
    [dictInspData setObject:@"" forKey:@"InspId"];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString * strDate = [dateformatter stringFromDate:[NSDate date]];
    [dictInspData setObject:strDate forKey:@"InspectionDate"];
    
    NSMutableArray * arrayCatagory = [[NSMutableArray alloc] init];
    for (RPInspVendor * vendor in data.arrayInsp)
    {
        for (RPInspCatagory * catagory in vendor.arrayCatagory) {
            NSMutableDictionary * dictCatagory = [[NSMutableDictionary alloc] init];
            [dictCatagory setObject:catagory.strCatagoryID forKey:@"ItemId"];
            [dictCatagory setObject:[NSNumber numberWithInteger:catagory.markCatagory] forKey:@"Score"];
            
            NSMutableArray * arrayIssues = [[NSMutableArray alloc] init];
            for (RPInspIssue * issue in catagory.arrayIssue) {
                NSMutableDictionary * dictIssue = [[NSMutableDictionary alloc] init];
                [dictIssue setObject:issue.strIssueDesc forKey:@"IssueDesc"];
                [dictIssue setObject:@"" forKey:@"IssueGid"];
                [dictIssue setObject:issue.strIssueTitle forKey:@"Title"];
                [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.x] forKey:@"X"];
                [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.y] forKey:@"Y"];
                
                NSMutableArray * arrayImage = [[NSMutableArray alloc] init];
                for (RPInspIssueImage * image in issue.arrayIssueImg) {
                    if (image.imgIssue) {
                        NSMutableDictionary * dictImage = [[NSMutableDictionary alloc] init];
                        NSString * strImage =  [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(image.imgIssue, 0.5)];
                        
                        [dictImage setObject:strImage forKey:@"ImgData"];
                        
                        [dictImage setObject:[NSNumber numberWithInteger:image.rcIssue.size.height] forKey:@"RegHeight"];
                        [dictImage setObject:[NSNumber numberWithInteger:image.rcIssue.size.width] forKey:@"RegWidth"];
                        [dictImage setObject:[NSNumber numberWithInteger:image.rcIssue.origin.x] forKey:@"RegX"];
                        [dictImage setObject:[NSNumber numberWithInteger:image.rcIssue.origin.y] forKey:@"RegY"];
                        
                        [arrayImage addObject:dictImage];
                    }
                }
                [dictIssue setObject:arrayImage forKey:@"IssueImgs"];
                
                [arrayIssues addObject:dictIssue];
            }
            [dictCatagory setObject:arrayIssues forKey:@"Issues"];
            
            [arrayCatagory addObject:dictCatagory];
        }
    }
    
    [dictInspData setObject:arrayCatagory forKey:@"IssuesData"];
    [dictBody setObject:dictInspData forKey:@"Inspdata"];
    return dictBody;
}

-(void)SubmitInsp:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(RPInspData *)data success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (self.bDemoMode) {
        successBlock(nil);
    }
    else
    {
        NSDictionary * dictBody = [self GenInspData:strStoreID Data:data];
        [RPNetCore doRequest:kAPIUploadInspection withHead:[self GenRequestHead:YES] withBody:dictBody
        success:^(id dictResult) {
            successBlock(dictResult);
        }
        failed:^(NSInteger nErrorCode, NSString *strDesc) {
            if ([self SaveUploadCache:dictBody Type:CACHETYPE_INSPECTION Desc:strStoreName]) {
                failedBlock(1000,@"Add to local submit array success");
            }
            else
            {
                failedBlock(1001,@"Add to local submit array failed");
            }
        }];
    }
}

-(NSDictionary *)GenVisitData:(NSString *)strStoreID Data:(RPCVisitData *)data
{
    NSMutableDictionary * dictBody = [[NSMutableDictionary alloc] init];
    [dictBody setObject:strStoreID forKey:@"storeId"];
    
    if (!data.strDesc) data.strDesc = @"";
    [dictBody setObject:data.strDesc forKey:@"Overall"];
    [dictBody setObject:[NSNumber numberWithInteger:data.mark] forKey:@"Score"];
    
    NSMutableArray * arrayEmail = [[NSMutableArray alloc] init];
    NSMutableArray * arrayColleague = [[NSMutableArray alloc] init];
    
    if (data.reporters != nil) {
        for (RPInspReporterSection * section in data.reporters.arraySection) {
            for (RPInspReporterUser * user in section.arrayUser) {
                if (user.bSelected) {
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                    if (user.bUserCollegue)
                    {
                        [dict setObject:user.collegue.strID forKey:@"UserId"];
                        [dict setObject:@"" forKey:@"DataId"];
                        [arrayColleague addObject:dict];
                    }
                    else
                    {
                        [dict setObject:user.strEmail forKey:@"Email"];
                        [dict setObject:@"" forKey:@"DataId"];
                        [arrayEmail addObject:dict];
                    }
                }
            }
        }
        [dictBody setObject:arrayEmail forKey:@"EmailList"];
        [dictBody setObject:arrayColleague forKey:@"UserList"];
    }
    
    NSMutableArray * arrayIssues = [[NSMutableArray alloc] init];
    for (RPInspIssue * issue in data.arrayIssue) {
        NSMutableDictionary * dictIssue = [[NSMutableDictionary alloc] init];
        [dictIssue setObject:issue.strIssueDesc forKey:@"Desc"];
        [dictIssue setObject:@"" forKey:@"IssueId"];
        [dictIssue setObject:issue.strIssueTitle forKey:@"Title"];
        [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.x] forKey:@"X"];
        [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.y] forKey:@"Y"];
        
        
        NSMutableArray * arrayImage = [[NSMutableArray alloc] init];
        for (RPInspIssueImage * image in issue.arrayIssueImg) {
            if (image.imgIssue) {
                NSMutableDictionary * dictImage = [[NSMutableDictionary alloc] init];
                NSString * strImage =  [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(image.imgIssue, 0.5)];
                
                [dictImage setObject:strImage forKey:@"ImgData"];
                
                [dictImage setObject:[NSNumber numberWithInteger:image.rcIssue.size.height] forKey:@"RegHeight"];
                [dictImage setObject:[NSNumber numberWithInteger:image.rcIssue.size.width] forKey:@"RegWidth"];
                [dictImage setObject:[NSNumber numberWithInteger:image.rcIssue.origin.x] forKey:@"RegX"];
                [dictImage setObject:[NSNumber numberWithInteger:image.rcIssue.origin.y] forKey:@"RegY"];
                
                [arrayImage addObject:dictImage];
            }
        }
        [dictIssue setObject:arrayImage forKey:@"IssueImgs"];
        
        [arrayIssues addObject:dictIssue];
    }
    
    [dictBody setObject:arrayIssues forKey:@"InspIssues"];
    return dictBody;
}

-(void)SubmitVisit:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(RPCVisitData *)data success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (self.bDemoMode) {
        successBlock(nil);
    }
    else
    {
        NSDictionary * dictBody = [self GenVisitData:strStoreID Data:data];
        [RPNetCore doRequest:kAPIUploadStoreVisit withHead:[self GenRequestHead:YES] withBody:dictBody
        success:^(id dictResult) {
            successBlock(dictResult);
        }
        failed:^(NSInteger nErrorCode, NSString *strDesc) {
            if ([self SaveUploadCache:dictBody Type:CACHETYPE_VISITING Desc:strStoreName]) {
                failedBlock(1000,@"Add to local submit array success");
            }
            else
            {
                failedBlock(1001,@"Add to local submit array failed");
            }
        }];
    }
}

-(NSDictionary *)GenMaintenData:(NSString *)strStoreID Data:(RPMaintenanceData *)data Reporter:(RPInspReporters *)reports
{
    NSMutableDictionary * dictBody = [[NSMutableDictionary alloc] init];
    [dictBody setObject:strStoreID forKey:@"storeId"];
    
    NSMutableArray * arrayEmail = [[NSMutableArray alloc] init];
    NSMutableArray * arrayColleague = [[NSMutableArray alloc] init];
    
    if (reports != nil) {
        for (RPInspReporterSection * section in reports.arraySection) {
            for (RPInspReporterUser * user in section.arrayUser) {
                if (user.bSelected) {
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                    if (user.bUserCollegue)
                    {
                        [dict setObject:user.collegue.strID forKey:@"UserId"];
                        if (section.strVendorID) {
                            [dict setObject:section.strVendorID forKey:@"DataId"];
                        }
                        
                        [arrayColleague addObject:dict];
                    }
                    else
                    {
                        [dict setObject:user.strEmail forKey:@"Email"];
                        if (section.strVendorID) {
                            [dict setObject:section.strVendorID forKey:@"DataId"];
                        }
                        
                        [arrayEmail addObject:dict];
                    }
                }
            }
        }
    }
    
    [dictBody setObject:arrayEmail forKey:@"EmailList"];
    [dictBody setObject:arrayColleague forKey:@"UserList"];
    
    if (data.strContactsRemark == nil) {
        data.strContactsRemark = @"";
    }
    
    [dictBody setObject:data.strContactsRemark forKey:@"Remark"];
    
    if (data.arrayContacts) {
        RPContact * contact = [data.arrayContacts objectAtIndex:0];
        if (contact.strUserName && contact.strPhone) {
            [dictBody setObject:contact.strUserName forKey:@"ContactName1"];
            [dictBody setObject:contact.strPhone forKey:@"ContactPhone1"];
        }
        
        
        contact = [data.arrayContacts objectAtIndex:1];
        if (contact.strUserName && contact.strPhone)
        {
            [dictBody setObject:contact.strUserName forKey:@"ContactName2"];
            [dictBody setObject:contact.strPhone forKey:@"ContactPhone2"];
        }
    }
    
    NSMutableArray * arrayIssues = [[NSMutableArray alloc] init];
    for (RPInspIssue * issue in data.arrayIssue) {
        NSMutableDictionary * dictIssue = [[NSMutableDictionary alloc] init];
        [dictIssue setObject:issue.strIssueDesc forKey:@"Desc"];
        [dictIssue setObject:issue.strIssueTitle forKey:@"Title"];
        [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.x] forKey:@"X"];
        [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.y] forKey:@"Y"];
        [dictIssue setObject:issue.strVendorID forKey:@"Category"];
        
        NSMutableArray * arrayImage = [[NSMutableArray alloc] init];
        for (RPInspIssueImage * image in issue.arrayIssueImg) {
            if (image.imgIssue) {
                NSMutableDictionary * dictImage = [[NSMutableDictionary alloc] init];
                NSString * strImage =  [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(image.imgIssue, 0.5)];
                
                [dictImage setObject:strImage forKey:@"ImgData"];
                
                [dictImage setObject:[NSNumber numberWithInteger:image.rcIssue.size.height] forKey:@"RegHeight"];
                [dictImage setObject:[NSNumber numberWithInteger:image.rcIssue.size.width] forKey:@"RegWidth"];
                [dictImage setObject:[NSNumber numberWithInteger:image.rcIssue.origin.x] forKey:@"RegX"];
                [dictImage setObject:[NSNumber numberWithInteger:image.rcIssue.origin.y] forKey:@"RegY"];
                
                [arrayImage addObject:dictImage];
            }
        }
        [dictIssue setObject:arrayImage forKey:@"IssueImgs"];
        
        [arrayIssues addObject:dictIssue];
    }
    
    [dictBody setObject:arrayIssues forKey:@"InspIssues"];
    return dictBody;
}

-(void)SubmitMainten:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(RPMaintenanceData *)data Reporter:(RPInspReporters *)reports success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (self.bDemoMode) {
        successBlock(nil);
    }
    else
    {
        NSDictionary * dictBody = [self GenMaintenData:strStoreID Data:data Reporter:reports];
        
        [RPNetCore doRequest:kAPIUploadMainten withHead:[self GenRequestHead:YES] withBody:dictBody
        success:^(id dictResult) {
             successBlock(dictResult);
        }
        failed:^(NSInteger nErrorCode, NSString *strDesc) {
            if ([self SaveUploadCache:dictBody Type:CACHETYPE_MAINTEN Desc:strStoreName]) {
                failedBlock(1000,@"Add to local submit array success");
            }
            else
            {
                failedBlock(1001,@"Add to local submit array failed");
            }
        }];
    }
}

-(void)GetColleagueCountSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (_bDemoMode) {
        [[RPOfflineData defaultInstance] GetColleagueCountSuccess:^(id dictResult) {
            successBlock(dictResult);
        } failed:^(NSInteger nErrorCode, NSString *strDesc) {
            failedBlock(nErrorCode,strDesc);
        }];
    }
    else
    {
        [RPNetCore doRequestBySimple:kAPIGetUserLevelCount withHead:[self GenRequestHead:YES] withBody:nil success:^(NSArray * arrayResult) {
            RPColleagueState * state = [[RPColleagueState alloc] init];
            for (NSDictionary * dict in arrayResult) {
                NSNumber * numLev = [dict objectForKey:@"Level"];
                NSNumber * numCount = [dict objectForKey:@"Count"];
                if (numLev && numCount) {
                    switch (numLev.intValue) {
                        case 1:
                            state.nCountLev1 = numCount.intValue;
                            break;
                        case 2:
                            state.nCountLev2 = numCount.intValue;
                            break;
                        case 3:
                            state.nCountLev3 = numCount.intValue;
                            break;
                        case 4:
                            state.nCountLev4 = numCount.intValue;
                            break;
                        default:
                            break;
                    }
                }
            }
            successBlock(state);
        } failed:^(NSInteger nErrorCode, NSString *strDesc) {
            failedBlock(nErrorCode,strDesc);
        }];
    }
}

-(void)GetUserInfo:(NSString *)strUserID success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (self.bDemoMode)
    {
        if  (strUserID == nil)
            strUserID = self.strLoginUserName;
        
        [[RPOfflineData defaultInstance] GetUserInfo:strUserID success:^(id dictResult) {
            successBlock(dictResult);
        } failed:^(NSInteger nErrorCode, NSString *strDesc) {
            failedBlock(nErrorCode,strDesc);
        }];
    }
    else
    {
        NSArray * arrayBody = nil;
        if (strUserID != nil) {
            arrayBody = [NSArray arrayWithObjects:strUserID,nil];
        }
        [RPNetCore doRequestBySimple:kAPIGetUserInfo withHead:[self GenRequestHead:YES] withBody:arrayBody
        success:^(NSDictionary * dict) {
            RPColleague * colleague = [[RPColleague alloc] init];
            
            colleague.strFirstName = [self ValidateString:[dict objectForKey:@"FirstName"]];
//            colleague.strSurName = [self ValidateString:[dict objectForKey:@"SurName"]];
            colleague.strBirthday = [self ValidateString:[dict objectForKey:@"Birthday"]];
            colleague.strEmail = [self ValidateString:[dict objectForKey:@"Email"]];
            colleague.strID = [self ValidateString:[dict objectForKey:@"UserId"]];
            
            NSNumber * num = [dict objectForKey:@"IsRegist"];
            if (num && (id)num != [NSNull null]) colleague.bRegist = num.boolValue;
            
            colleague.strPhone = [self ValidateString:[dict objectForKey:@"Phone"]];
            colleague.strRoleDesc = [self ValidateString:[dict objectForKey:@"RoleDesc"]];
            
            num = [dict objectForKey:@"RoleLevel"];
            if (num && (id)num != [NSNull null]) colleague.nRoleLevel = num.intValue;
            
            num = [dict objectForKey:@"Sex"];
            if (num && (id)num != [NSNull null]) colleague.sex = num.intValue;
            else colleague.sex = RPSex_UnSpec;
            
            NSString * strPic = [dict objectForKey:@"UserImg"];
            if (strPic && strPic.length > 0) {
                colleague.strImgPic = strPic;
                colleague.strImgPicBig = [colleague.strImgPic stringByReplacingCharactersInRange:NSMakeRange(colleague.strImgPic.length - 6,2) withString:@"_2"];
            }
            
            NSDictionary * dictReportTo = [dict objectForKey:@"UserReport"];
            if (dictReportTo && ((id)dictReportTo != [NSNull null])) {
                colleague.strReportToName = [self ValidateString:[dictReportTo objectForKey:@"UserName"]];
                colleague.strReportToID = [self ValidateString:[dictReportTo objectForKey:@"UserID"]];
            }
            
            successBlock(colleague);
        }
        failed:^(NSInteger nErrorCode, NSString *strDesc) {
            failedBlock(nErrorCode,strDesc);
        }];
    }
}

-(void)GetColleague:(NSInteger)nRoleLevel success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (_bDemoMode) {
        [[RPOfflineData defaultInstance] GetColleague:nRoleLevel success:^(id dictResult) {
            successBlock(dictResult);
        } failed:^(NSInteger nErrorCode, NSString *strDesc) {
            failedBlock(nErrorCode,strDesc);
        }];
    }
    else
    {
        [RPNetCore doRequestBySimple:kAPIGetUserList withHead:[self GenRequestHead:YES] withBody:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",nRoleLevel],nil]
        success:^(NSArray * arrayResult) {
            NSMutableArray * arrayRet = [[NSMutableArray alloc] init];
            for (NSDictionary * dict in arrayResult) {
                RPColleague  * colleague = [[RPColleague alloc] init];
                colleague.strFirstName = [self ValidateString:[dict objectForKey:@"FirstName"]];
//                colleague.strSurName = [self ValidateString:[dict objectForKey:@"SurName"]];
                colleague.strBirthday = [self ValidateString:[dict objectForKey:@"Birthday"]];
                colleague.strEmail = [self ValidateString:[dict objectForKey:@"Email"]];
                colleague.strID = [self ValidateString:[dict objectForKey:@"UserId"]];
                
                NSNumber * num = [dict objectForKey:@"IsRegist"];
                if (num && (id)num != [NSNull null]) colleague.bRegist = num.boolValue;
                
                colleague.strPhone = [self ValidateString:[dict objectForKey:@"Phone"]];
                colleague.strRoleDesc = [self ValidateString:[dict objectForKey:@"RoleDesc"]];
                
                num = [dict objectForKey:@"RoleLevel"];
                if (num && (id)num != [NSNull null]) colleague.nRoleLevel = num.intValue;
                
                num = [dict objectForKey:@"Sex"];
                if (num && (id)num != [NSNull null]) colleague.sex = num.intValue;
                else colleague.sex = RPSex_UnSpec;
                
                
                NSString * strPic = [dict objectForKey:@"UserImg"];
                if (strPic && strPic.length > 0) {
                    colleague.strImgPic = strPic;
                    colleague.strImgPicBig = [colleague.strImgPic stringByReplacingCharactersInRange:NSMakeRange(colleague.strImgPic.length - 6,2) withString:@"_2"];
                }
                
                NSDictionary * dictReportTo = [dict objectForKey:@"UserReport"];
                if (dictReportTo && ((id)dictReportTo != [NSNull null])) {
                    colleague.strReportToName = [self ValidateString:[dictReportTo objectForKey:@"UserName"]];
                    colleague.strReportToID = [self ValidateString:[dictReportTo objectForKey:@"UserID"]];
                }
                
                if (colleague.bRegist == NO)
                    colleague.strFirstName = colleague.strPhone;
                
                if (colleague.strFirstName.length > 0) {
                    NSString *subString = [colleague.strFirstName substringToIndex:1];
                    int a = [subString characterAtIndex:0];
                    if( a > 0x4e00 && a < 0x9fff)
                    {
                        char c = pinyinFirstLetter([subString characterAtIndex:0]);
                        colleague.strCompare = [[NSString alloc] initWithBytes:&c length:1 encoding:NSUTF8StringEncoding];
                        colleague.strSectionLetter = colleague.strCompare;
                    }
                    else if (a < 65)
                    {
                        colleague.bFirstAlph = YES;
                        colleague.strCompare = colleague.strFirstName;
                        colleague.strSectionLetter = @"#";
                    }
                    else
                    {
                        colleague.strCompare = colleague.strFirstName;
                        colleague.strSectionLetter = [colleague.strFirstName substringToIndex:1];
                    }
                    
                    [arrayRet addObject:colleague];
                }
            }
            successBlock(arrayRet);
         }
         failed:^(NSInteger nErrorCode, NSString *strDesc) {
              failedBlock(nErrorCode,strDesc);
          }];
    }
}

-(void)GetCustomerSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (self.bDemoMode) {
        [[RPOfflineData defaultInstance] GetCustomerSuccess:^(id dictResult) {
            successBlock(dictResult);
        } failed:^(NSInteger nErrorCode, NSString *strDesc) {
            failedBlock(nErrorCode,strDesc);
        }];
    }
    else
    {
        [RPNetCore doRequestBySimple:kAPIGetCustomerList withHead:[self GenRequestHead:YES] withBody:nil
         success:^(NSArray * arrayResult) {
             NSMutableArray * arrayRet = [[NSMutableArray alloc] init];
             for (NSDictionary * dict in arrayResult) {
                 RPCustomer * customer = [[RPCustomer alloc] init];
                 
                 customer.strID = [self ValidateString:[dict objectForKey:@"CustomerId"]];
                 customer.strAddress = [self ValidateString:[dict objectForKey:@"Address"]];
                 customer.strBirthday = [self ValidateString:[dict objectForKey:@"Birthday"]];
                 customer.strDistrict = [self ValidateString:[dict objectForKey:@"District"]];
                 customer.strEmail = [self ValidateString:[dict objectForKey:@"Email"]];
                 customer.strFirstName = [self ValidateString:[dict objectForKey:@"FirstName"]];
//                 customer.strSurName = [self ValidateString:[dict objectForKey:@"SurName"]];
                 customer.strPhone1 = [self ValidateString:[dict objectForKey:@"Phone1"]];
                 customer.strPhone2 = [self ValidateString:[dict objectForKey:@"Phone2"]];
                 
                 customer.isLink = ((NSNumber *)[dict objectForKey:@"IsRelate"]).boolValue;
                 customer.isVip = ((NSNumber *)[dict objectForKey:@"IsVip"]).boolValue;
                 customer.sex = ((NSNumber *)[dict objectForKey:@"Sex"]).boolValue;
                 
                 NSString * strPic = [dict objectForKey:@"CustImg"];
                 if (strPic && strPic.length > 0) {
                     customer.strImgPicUrl = strPic;
                     customer.strImgPicUrlBig = [customer.strImgPicUrl stringByReplacingCharactersInRange:NSMakeRange(customer.strImgPicUrl.length - 6,2) withString:@"_2"];
                 }
                 
                 if (customer.strFirstName.length > 0) {
                     NSString *subString = [customer.strFirstName substringToIndex:1];
                     int a = [subString characterAtIndex:0];
                     if( a > 0x4e00 && a < 0x9fff)
                     {
                         char c = pinyinFirstLetter([subString characterAtIndex:0]);
                         customer.strCompare = [[NSString alloc] initWithBytes:&c length:1 encoding:NSUTF8StringEncoding];
                         customer.strSectionLetter = customer.strCompare;
                     }
                     else if (a < 65)
                     {
                         customer.bFirstAlph = YES;
                         customer.strCompare = customer.strFirstName;
                         customer.strSectionLetter = @"#";
                     }
                     else
                     {
                         customer.strCompare = customer.strFirstName;
                         customer.strSectionLetter = [customer.strFirstName substringToIndex:1];
                     }
                 }
                 else
                 {
                     customer.strSectionLetter = @"#";
                 }
                 
                 [arrayRet addObject:customer];
             }
             successBlock(arrayRet);
         }
          failed:^(NSInteger nErrorCode, NSString *strDesc) {
              failedBlock(nErrorCode,strDesc);
          }];
    }
}

-(void)GetUsableRoleListSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
     [RPNetCore doRequestBySimple:kAPIGetUsableRoleList withHead:[self GenRequestHead:YES] withBody:nil
     success:^(NSArray * arrayResult) {
         NSMutableArray * arrayRet = [[NSMutableArray alloc] init];
         for (NSDictionary * dict in arrayResult) {
             RPRole * role = [[RPRole alloc] init];
             role.nRoleClass = ((NSNumber *)[dict objectForKey:@"Class"]).intValue;
             role.nRoleLevel = ((NSNumber *)[dict objectForKey:@"Level"]).intValue;
             role.strRoleID = [dict objectForKey:@"RoleId"];
             role.strRoleName = [dict objectForKey:@"RoleName"];
             [arrayRet addObject:role];
         }
         successBlock(arrayRet);
     }
     failed:^(NSInteger nErrorCode, NSString *strDesc) {
         failedBlock(nErrorCode,strDesc);
     }];
}

-(void)GetRoleUsableContent:(NSString *)strRoleID success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    [RPNetCore doRequestBySimple:kAPIGetRoleUsableContent withHead:[self GenRequestHead:YES] withBody:[NSArray arrayWithObjects:strRoleID,nil]
    success:^(NSArray * arrayResult) {
             NSMutableArray * arrayRet = [[NSMutableArray alloc] init];
             for (NSDictionary * dict in arrayResult) {
                 RPUnit * unit = [[RPUnit alloc] init];
                 unit.strUnitID = [dict objectForKey:@"DataId"];
                 unit.strUnitName = [dict objectForKey:@"DataName"];
                 [arrayRet addObject:unit];
             }
             successBlock(arrayRet);
         }
    failed:^(NSInteger nErrorCode, NSString *strDesc) {
              failedBlock(nErrorCode,strDesc);
          }];
}

-(void)InviteUser:(NSString *)strPhone RoleID:(NSString *)strRoleID RangeID:(NSString *)strRangeId
RoleRange:(RPRoleLevel)level success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    [RPNetCore doRequest:kAPIInviteUser withHead:[self GenRequestHead:YES] withBody:@{@"Phone":strPhone,@"RangeId":strRangeId,@"RoleId":strRoleID,@"RoleRange":[NSNumber numberWithInteger:level]}
    success:^(id dictResult) {
        successBlock(dictResult);
    }
    failed:^(NSInteger nErrorCode, NSString *strDesc) {
        failedBlock(nErrorCode,strDesc);
    }];
}


-(void)AddCustomer:(RPCustomer *)customer success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    NSString * strImage =  [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(customer.imgPic, 0.5)];
    if (strImage == nil) {
        strImage = @"";
    }
    
    [RPNetCore doRequest:kAPIAddCustomer withHead:[self GenRequestHead:YES] withBody:@{@"Address":customer.strAddress,@"Birthday":customer.strBirthday,@"CustImg":strImage,@"District":[NSNull null],@"Email":customer.strEmail,@"FirstName":customer.strFirstName,@"IsVip":[NSNumber numberWithBool:customer.isVip],@"Phone1":customer.strPhone1,@"Phone2":customer.strPhone2,@"Sex":[NSNumber numberWithInteger:customer.sex]}
    success:^(id dictResult) {
        successBlock(dictResult);
    }
    failed:^(NSInteger nErrorCode, NSString *strDesc) {
        failedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetAllStoreListSuccess:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (_bDemoMode) {
        [[RPOfflineData defaultInstance] GetStoreList:NO Success:^(id dictResult) {
            successBlock(dictResult);
        } failed:^(NSInteger nErrorCode, NSString *strDesc) {
            failedBlock(nErrorCode,strDesc);
        }];
    }
    else
    {
        [RPNetCore doRequestBySimple:kAPIGetAllStoreList withHead:[self GenRequestHead:YES] withBody:nil
         success:^(NSArray * arrayResult)
         {
             NSMutableArray * array = [[NSMutableArray alloc] init];
             for (NSDictionary * dict in arrayResult) {
                 RPStore * store = [[RPStore alloc] init];
                 
                 store.strArea = [self ValidateString:[dict objectForKey:@"Area"]];
                 store.strBrandName = [self ValidateString:[dict objectForKey:@"BrandName"]];
                 store.strCityName = [self ValidateString:[dict objectForKey:@"CityName"]];
                 store.strDealerName = [self ValidateString:[dict objectForKey:@"DealerName"]];
                 store.strDecorationDate = [self ValidateString:[dict objectForKey:@"DecorationDate"]];
                 store.strDistrictCode = [self ValidateString:[dict objectForKey:@"DistrictCode"]];
                 store.strInspDate = [self ValidateString:[dict objectForKey:@"InspDate"]];
                 store.strInspUser = [self ValidateString:[dict objectForKey:@"InspUser"]];
                 
                 store.strStorePhone = [dict objectForKey:@"Phone"];
                 store.strFax = [self ValidateString:[dict objectForKey:@"Fax"]];
                 store.strEmail = [self ValidateString:[dict objectForKey:@"Email"]];
                 store.nStartTime = ((NSNumber *)[dict objectForKey:@"StartTime"]).integerValue;
                 store.nEndTime = ((NSNumber *)[dict objectForKey:@"EndTime"]).integerValue;
                 store.nWeatherCode = ((NSNumber *)[dict objectForKey:@"WeatherCode"]).integerValue;
                 store.strAreaSquare = [self ValidateString:[dict objectForKey:@"AreaSquare"]];
                 
                 NSNumber * num = [dict objectForKey:@"IsOwn"];
                 if (num && (id)num != [NSNull null]) {
                     store.isStoreUser = num.boolValue;
                 }
                 
                 num = [dict objectForKey:@"IsPerfect"];
                 if (num && (id)num != [NSNull null]) {
                     store.isInfoComplete = num.boolValue;
                 }

                 store.strMarket = [self ValidateString:[dict objectForKey:@"Market"]];
                 store.strShopMap = [self ValidateString:[dict objectForKey:@"ShopMap"]];
                 store.strStoreAddress = [self ValidateString:[dict objectForKey:@"StoreAddress"]];
                 store.strStoreCode = [self ValidateString:[dict objectForKey:@"StoreCode"]];
                 store.strStoreID = [self ValidateString:[dict objectForKey:@"StoreId"]];
                 store.strStoreName = [self ValidateString:[dict objectForKey:@"StoreName"]];
                 
                 NSString * strPic = [dict objectForKey:@"StoreThumb"];
                 if (strPic && strPic.length > 0) {
                     store.strImageThumb = strPic;
                     store.strImageThumbBig = [store.strImageThumb stringByReplacingCharactersInRange:NSMakeRange(store.strImageThumb.length - 6,2) withString:@"_2"];
                 }
                 store.strWeatherCode = [self ValidateString:[dict objectForKey:@"WeatherCode"]];
                 
                 [array addObject:store];
             }
             successBlock(array);
         }
         failed:^(NSInteger nErrorCode,NSString * strDesc)
         {
             failedBlock(nErrorCode,strDesc);
         }];
    }
}

-(void)GetMaintenVendor:(NSString *)strStoreID success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (self.bDemoMode) {
        [[RPOfflineData defaultInstance] GetVendors:strStoreID success:^(id dictResult) {
            successBlock(dictResult);
        } failed:^(NSInteger nErrorCode, NSString *strDesc) {
            failedBlock(nErrorCode,strDesc);
        }];
    }
    else
    {
        [RPNetCore doRequestBySimple:kAPIGetMaintenVendor withHead:[self GenRequestHead:YES] withBody:[NSArray arrayWithObjects:strStoreID,nil] success:^(NSArray * arrayResult) {
            RPInspReporters * reports = [[RPInspReporters alloc] init];
            reports.arraySection = [[NSMutableArray alloc] init];
            NSMutableArray * arrayVendor = [[NSMutableArray alloc] init];
            
            for (NSDictionary * dict in arrayResult) {
                RPMaintenVendor * vendor = [[RPMaintenVendor alloc] init];
                vendor.strVendorID = [self ValidateString:[dict objectForKey:@"VendorId"]];
                vendor.strVendorName = [self ValidateString:[dict objectForKey:@"VendorName"]];
                vendor.strVendorType = [self ValidateString:[dict objectForKey:@"VendorType"]];
                [arrayVendor addObject:vendor];
                
                RPInspReporterSection * section = [[RPInspReporterSection alloc] init];
                section.strVendorID = vendor.strVendorID;
                section.arrayUser = [[NSMutableArray alloc] init];
                
                NSArray * arrayUser = [dict objectForKey:@"User"];
                for (NSDictionary * dictUser in arrayUser) {
                    RPInspReporterUser * user = [[RPInspReporterUser alloc] init];
                    user.bUserCollegue = YES;
                    RPColleague *  colleague = [[RPColleague alloc] init];
                    
                    colleague.strFirstName = [self ValidateString:[dictUser objectForKey:@"FirstName"]];
//                    colleague.strSurName = [self ValidateString:[dictUser objectForKey:@"SurName"]];
                    colleague.strBirthday = [self ValidateString:[dictUser objectForKey:@"Birthday"]];
                    colleague.strEmail = [self ValidateString:[dictUser objectForKey:@"Email"]];
                    colleague.strID = [self ValidateString:[dictUser objectForKey:@"UserId"]];
                    
                    NSNumber * num = [dictUser objectForKey:@"IsRegist"];
                    if (num && (id)num != [NSNull null]) colleague.bRegist = num.boolValue;
                    
                    colleague.strPhone = [self ValidateString:[dictUser objectForKey:@"Phone"]];
                    colleague.strRoleDesc = [self ValidateString:[dictUser objectForKey:@"RoleDesc"]];
                    
                    num = [dictUser objectForKey:@"RoleLevel"];
                    if (num && (id)num != [NSNull null]) colleague.nRoleLevel = num.intValue;
                    
                    num = [dictUser objectForKey:@"Sex"];
                    if (num && (id)num != [NSNull null]) colleague.sex = num.intValue;
                    else colleague.sex = RPSex_UnSpec;
                    
                    
                    NSString * strPic = [dict objectForKey:@"UserImg"];
                    if (strPic && strPic.length > 0) {
                        colleague.strImgPic = strPic;
                        colleague.strImgPicBig = [colleague.strImgPic stringByReplacingCharactersInRange:NSMakeRange(colleague.strImgPic.length - 6,2) withString:@"_2"];
                    }
                    
                    NSDictionary * dictReportTo = [dictUser objectForKey:@"UserReport"];
                    if (dictReportTo && ((id)dictReportTo != [NSNull null])) {
                        colleague.strReportToName = [self ValidateString:[dictReportTo objectForKey:@"UserName"]];
                        colleague.strReportToID = [self ValidateString:[dictReportTo objectForKey:@"UserID"]];
                    }
                    
                    if (colleague.bRegist == NO)
                        colleague.strFirstName = colleague.strPhone;
                    
                    if (colleague.strFirstName.length > 0) {
                        NSString *subString = [colleague.strFirstName substringToIndex:1];
                        int a = [subString characterAtIndex:0];
                        if( a > 0x4e00 && a < 0x9fff)
                        {
                            char c = pinyinFirstLetter([subString characterAtIndex:0]);
                            colleague.strCompare = [[NSString alloc] initWithBytes:&c length:1 encoding:NSUTF8StringEncoding];
                            colleague.strSectionLetter = colleague.strCompare;
                        }
                        else if (a < 65)
                        {
                            colleague.bFirstAlph = YES;
                            colleague.strCompare = colleague.strFirstName;
                            colleague.strSectionLetter = @"#";
                        }
                        else
                        {
                            colleague.strCompare = colleague.strFirstName;
                            colleague.strSectionLetter = [colleague.strFirstName substringToIndex:1];
                        }
                    }
                    
                    user.bSelected = YES;
                    user.collegue = colleague;
                    
                    [section.arrayUser addObject:user];
                }
                [reports.arraySection addObject:section];
            }
            successBlock([NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:arrayVendor,reports,nil] forKeys:[NSArray arrayWithObjects:@"Vendors",@"Reports", nil]]);
         }
         failed:^(NSInteger nErrorCode, NSString *strDesc) {
            failedBlock(nErrorCode,strDesc);
         }];
    }
}

-(void)GetMaintenStoreColleague:(NSString *)strStoreID success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (self.bDemoMode) {
        [[RPOfflineData defaultInstance] GetMaintenStoreColleague:strStoreID success:^(id dictResult) {
            successBlock(dictResult);
        } failed:^(NSInteger nErrorCode, NSString *strDesc) {
            failedBlock(nErrorCode,strDesc);
        }];
    }
    else
    {
        [RPNetCore doRequestBySimple:kAPIGetStoreColleague withHead:[self GenRequestHead:YES] withBody:[NSArray arrayWithObjects:strStoreID,nil]
         success:^(NSArray * arrayResult)
         {
             NSMutableArray * array = [[NSMutableArray alloc] init];
             for (NSDictionary * dict in arrayResult) {
                 RPContact * contact = [[RPContact alloc] init];
                 contact.strUserName = [self ValidateString:[dict objectForKey:@"UserName"]];
                 contact.strPhone = [self ValidateString:[dict objectForKey:@"Phone"]];
                 [array addObject:contact];
             }
             successBlock(array);
         }
         failed:^(NSInteger nErrorCode, NSString *strDesc) {
             failedBlock(nErrorCode,strDesc);
         }];
    }
}

-(void)SubmitCacheData:(RPCachData *)data success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    NSString * strApi = nil;
    
    switch (data.type) {
        case CACHETYPE_INSPECTION:
            strApi = kAPIUploadInspection;
            break;
        case CACHETYPE_RECTIFICITION:
            strApi = kAPIUploadRectification;
            break;
        case CACHETYPE_VISITING:
            strApi = kAPIUploadStoreVisit;
            break;
        case CACHETYPE_MAINTEN:
            strApi = kAPIUploadMainten;
            break;
        default:
            break;
    }
    
    [RPNetCore doRequest:strApi withHead:[self GenRequestHead:YES] withBodyString:data.strData success:^(id dictResult)
    {
        [_arrayCacheData removeObject:data];
        
        [[RPBDataBase defaultInstance] SetCacheDataSubmitted:data.strID];
        successBlock(dictResult);
    }
    failed:^(NSInteger nErrorCode, NSString *strDesc)
    {
        failedBlock(nErrorCode,strDesc);
    }];
}

-(void)SaveInspCacheData:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(RPInspData *)data isNormalExit:(BOOL)bNormal
{
    NSDictionary * dictBody = [self GenInspData:strStoreID Data:data];
    [[RPBDataBase defaultInstance] SaveTaskCacheData:self.colleagueLoginUser.strID Key:strStoreID CacheType:CACHETYPE_INSPECTION Data:dictBody Date:[self GenTimeStamp] Desc:strStoreName isNormalExit:bNormal];
}

-(void)SaveVisitCacheData:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(RPCVisitData *)data isNormalExit:(BOOL)bNormal
{
    NSDictionary * dictBody = [self GenVisitData:strStoreID Data:data];
    [[RPBDataBase defaultInstance] SaveTaskCacheData:self.colleagueLoginUser.strID Key:strStoreID CacheType:CACHETYPE_VISITING Data:dictBody Date:[self GenTimeStamp] Desc:strStoreName isNormalExit:bNormal];
}

-(void)SaveMaintenCacheData:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(RPMaintenanceData *)data isNormalExit:(BOOL)bNormal
{
    NSDictionary * dictBody = [self GenMaintenData:strStoreID Data:data Reporter:nil];
    [[RPBDataBase defaultInstance] SaveTaskCacheData:self.colleagueLoginUser.strID Key:strStoreID CacheType:CACHETYPE_MAINTEN Data:dictBody Date:[self GenTimeStamp] Desc:strStoreName isNormalExit:bNormal];
}

-(id)GetTaskCacheData:(NSString *)strStoreID CacheType:(CacheType)type
{
    TaskCachData * data = [[RPBDataBase defaultInstance] GetTaskCacheData:self.colleagueLoginUser.strID Key:strStoreID CacheType:type];
    if (data.strData) {
        NSError * error;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[data.strData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (jsonDic) {
            switch (type) {
                case CACHETYPE_INSPECTION:
                {
                    NSMutableArray * arrayCatagory = [[NSMutableArray alloc] init];
                    NSDictionary * dictInsp = [jsonDic objectForKey:@"Inspdata"];
                    if (dictInsp) {
                        NSMutableArray * arrayIssueData = [dictInsp objectForKey:@"IssuesData"];
                        for (NSDictionary * dict in arrayIssueData) {
                            RPInspCatagory * catagory = [[RPInspCatagory alloc] init];
                            catagory.markCatagory = ((NSNumber *)[dict objectForKey:@"Score"]).integerValue;
                            catagory.strCatagoryID = [dict objectForKey:@"ItemId"];
                            catagory.arrayIssue = [[NSMutableArray alloc] init];
                            NSArray * array = [dict objectForKey:@"Issues"];
                            
                            for (NSDictionary * dictIssue in array) {
                                RPInspIssue * issue = [[RPInspIssue alloc] init];
                                issue.strIssueDesc = [dictIssue objectForKey:@"IssueDesc"];
                                issue.strIssueTitle = [dictIssue objectForKey:@"Title"];
                                NSInteger nX = ((NSNumber *)[dictIssue objectForKey:@"X"]).integerValue;
                                NSInteger nY = ((NSNumber *)[dictIssue objectForKey:@"Y"]).integerValue;
                                issue.ptLocation = CGPointMake(nX, nY);
                                issue.bHasLocation = YES;
                                
                                issue.arrayIssueImg = [NSMutableArray arrayWithArray:@[[[RPInspIssueImage alloc] init],[[RPInspIssueImage alloc] init], [[RPInspIssueImage alloc] init]]];
                                
                                NSInteger nImageIndex = 0;
                                for (NSDictionary * dictImage in (NSArray *)[dictIssue objectForKey:@"IssueImgs"])
                                {
                                    RPInspIssueImage * image = [[RPInspIssueImage alloc] init];
                                    
                                    NSData * dataImg = [GTMBase64 decodeString:[dictImage objectForKey:@"ImgData"]];
                                    image.imgIssue = [UIImage imageWithData:dataImg];
                                    NSInteger x = ((NSNumber *)[dictImage objectForKey:@"RegX"]).integerValue;
                                    NSInteger y = ((NSNumber *)[dictImage objectForKey:@"RegY"]).integerValue;
                                    NSInteger width = ((NSNumber *)[dictImage objectForKey:@"RegWidth"]).integerValue;
                                    NSInteger height = ((NSNumber *)[dictImage objectForKey:@"RegHeight"]).integerValue;
                                    
                                    image.rcIssue = CGRectMake(x, y, width, height);
                                    [issue.arrayIssueImg replaceObjectAtIndex:nImageIndex withObject:image];
                                    nImageIndex ++;
                                }
                                
                                [catagory.arrayIssue addObject:issue];
                            }
                            [arrayCatagory addObject:catagory];
                        }
                    }
                    return arrayCatagory;
                }
                    break;
                case CACHETYPE_MAINTEN:
                {
                    RPMaintenanceData * dataMainten = [[RPMaintenanceData alloc] init];
                    dataMainten.arrayIssue = [[NSMutableArray alloc] init];
                    
                    NSArray * array = [jsonDic objectForKey:@"InspIssues"];
                    for (NSDictionary * dictIssue in array) {
                        RPInspIssue * issue = [[RPInspIssue alloc] init];
                        issue.strVendorID = [dictIssue objectForKey:@"Category"];
                        issue.strIssueDesc = [dictIssue objectForKey:@"Desc"];
                        issue.strIssueTitle = [dictIssue objectForKey:@"Title"];
                        NSInteger nX = ((NSNumber *)[dictIssue objectForKey:@"X"]).integerValue;
                        NSInteger nY = ((NSNumber *)[dictIssue objectForKey:@"Y"]).integerValue;
                        issue.ptLocation = CGPointMake(nX, nY);
                        issue.bHasLocation = YES;
                        
                        issue.arrayIssueImg = [NSMutableArray arrayWithArray:@[[[RPInspIssueImage alloc] init],[[RPInspIssueImage alloc] init], [[RPInspIssueImage alloc] init]]];
                        NSInteger nImageIndex = 0;
                        
                        for (NSDictionary * dictImage in (NSArray *)[dictIssue objectForKey:@"IssueImgs"])
                        {
                            RPInspIssueImage * image = [[RPInspIssueImage alloc] init];
                            
                            NSData * dataImg = [GTMBase64 decodeString:[dictImage objectForKey:@"ImgData"]];
                            image.imgIssue = [UIImage imageWithData:dataImg];
                            NSInteger x = ((NSNumber *)[dictImage objectForKey:@"RegX"]).integerValue;
                            NSInteger y = ((NSNumber *)[dictImage objectForKey:@"RegY"]).integerValue;
                            NSInteger width = ((NSNumber *)[dictImage objectForKey:@"RegWidth"]).integerValue;
                            NSInteger height = ((NSNumber *)[dictImage objectForKey:@"RegHeight"]).integerValue;
                            
                            image.rcIssue = CGRectMake(x, y, width, height);
                            [issue.arrayIssueImg replaceObjectAtIndex:nImageIndex withObject:image];
                            nImageIndex ++;
                        }
                        
                        [dataMainten.arrayIssue addObject:issue];
                    }
                    return dataMainten;
                    break;
                }
                case CACHETYPE_VISITING:
                {
                    RPCVisitData * dataVisit = [[RPCVisitData alloc] init];
                    dataVisit.arrayIssue = [[NSMutableArray alloc] init];
                    dataVisit.strDesc = [jsonDic objectForKey:@"Overall"];
                    dataVisit.mark = ((NSNumber *)[jsonDic objectForKey:@"Score"]).integerValue;
                    
                    NSArray * array = [jsonDic objectForKey:@"InspIssues"];
                    for (NSDictionary * dictIssue in array) {
                        RPInspIssue * issue = [[RPInspIssue alloc] init];
                        issue.strVendorID = [dictIssue objectForKey:@"Category"];
                        issue.strIssueDesc = [dictIssue objectForKey:@"Desc"];
                        issue.strIssueTitle = [dictIssue objectForKey:@"Title"];
                        NSInteger nX = ((NSNumber *)[dictIssue objectForKey:@"X"]).integerValue;
                        NSInteger nY = ((NSNumber *)[dictIssue objectForKey:@"Y"]).integerValue;
                        issue.ptLocation = CGPointMake(nX, nY);
                        issue.bHasLocation = YES;
                        
                        issue.arrayIssueImg = [NSMutableArray arrayWithArray:@[[[RPInspIssueImage alloc] init],[[RPInspIssueImage alloc] init], [[RPInspIssueImage alloc] init]]];
                        NSInteger nImageIndex = 0;
                        
                        for (NSDictionary * dictImage in (NSArray *)[dictIssue objectForKey:@"IssueImgs"])
                        {
                            RPInspIssueImage * image = [[RPInspIssueImage alloc] init];
                            
                            NSData * dataImg = [GTMBase64 decodeString:[dictImage objectForKey:@"ImgData"]];
                            image.imgIssue = [UIImage imageWithData:dataImg];
                            NSInteger x = ((NSNumber *)[dictImage objectForKey:@"RegX"]).integerValue;
                            NSInteger y = ((NSNumber *)[dictImage objectForKey:@"RegY"]).integerValue;
                            NSInteger width = ((NSNumber *)[dictImage objectForKey:@"RegWidth"]).integerValue;
                            NSInteger height = ((NSNumber *)[dictImage objectForKey:@"RegHeight"]).integerValue;
                            
                            image.rcIssue = CGRectMake(x, y, width, height);
                            [issue.arrayIssueImg replaceObjectAtIndex:nImageIndex withObject:image];
                            nImageIndex ++;
                        }
                        
                        [dataVisit.arrayIssue addObject:issue];
                    }
                    return dataVisit;
                }
                    break;
                default:
                    break;
            }
        }
    }
    return nil;
}

-(void)ClearCacheData:(NSString *)strStoreID CacheType:(CacheType)type
{
    [[RPBDataBase defaultInstance] ClearTaskCacheData:[RPBLogic defaultInstance].colleagueLoginUser.strID Key:strStoreID CacheType:type];
}
@end
