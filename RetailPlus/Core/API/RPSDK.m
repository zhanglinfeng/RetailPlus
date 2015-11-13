//
//  RPSDK.m
//  RetailPlus
//
//  Created by lin dong on 13-11-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "RPMutableDictionary.h"
#import "ASIHTTPRequest.h"
#import "RPBDataBase.h"
#import "GTMBase64.h"
#import "pinyin.h"
#import "RPSDKError.h"
#import "RPSDK.h"
#import "RPNetModule.h"
#import "NSData+AES.h"
#import "SVProgressHUD.h"

extern NSBundle    * g_bundleResorce;
extern NSString    * g_strDeviceToken;

@implementation RPSDK

static RPSDK *defaultObject;

#pragma mark Static Function
+(NSString *)GetCacheDir
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *imageDir = [NSString stringWithFormat:@"%@/Caches", documentDirectory];
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
    
    double dScaleWidth = size.width / image.size.width;
    double dScaleHeight = size.height / image.size.height;
    double dScale = dScaleHeight;
    
    if (dScaleWidth < dScaleHeight) {
        dScale = dScaleWidth;
    }
    
    [image drawInRect:CGRectMake((size.width - image.size.width * dScale) / 2,(size.height - image.size.height * dScale) / 2,image.size.width * dScale,image.size.height * dScale)];
    
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

+(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

+(UIImage *) loadImageFromURL:(NSString *)fileURL
{
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[fileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    result = [UIImage imageWithData:data];
    return result;
}

+(NetworkStatus) GetConnectionStatus
{
    if ([RPSDK defaultInstance].bDemoMode)
        return ReachableViaWiFi;
    
    return [RPNetModule GetConnectionStatus];
}

+(NSInteger)DateToYear:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    return[formatter stringFromDate:date].integerValue;
}

+(NSInteger)DateToQuarter:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"q"];
    return[formatter stringFromDate:date].integerValue;
}

+(NSInteger)DateToMonth:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    return[formatter stringFromDate:date].integerValue;
}

+(NSInteger)DateToWeek:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"w"];
    return[formatter stringFromDate:date].integerValue;
}
+(NSString *)numberFormatter:(NSNumber*)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *string = [formatter stringFromNumber:number];
    return string;
}

+(NSString *)noStyleNumber:(NSNumber*)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterNoStyle;
    
    NSString *string = [formatter stringFromNumber:number];
    return string;
}

+(NSString *)isValidPassword:(NSString *)strUserName Password:(NSString *)strPassword
{
    if (strPassword.length < 6)
    {
        return NSLocalizedStringFromTableInBundle(@"The password is too short,please re-setting",@"RPString", g_bundleResorce,nil);
    }
    
    if (strPassword.length > 20)
    {
        return NSLocalizedStringFromTableInBundle(@"The password is too long,please re-setting",@"RPString", g_bundleResorce,nil);
    }
    
    if ([strPassword isEqualToString:strUserName]) {
        return NSLocalizedStringFromTableInBundle(@"The password cannot be same as username,please re-setting",@"RPString", g_bundleResorce,nil);
    }
    
    BOOL bFound = NO;
    NSArray * arrayString = [NSArray arrayWithObjects:@"123456",@"1234567",@"12345678",@"123456789",@"1234567890",nil];
    for (NSString * strCompare in arrayString) {
        if ([strCompare isEqualToString:strPassword]) {
            bFound = YES;
            break;
        }
    }
    if (bFound) {
        return NSLocalizedStringFromTableInBundle(@"There is a risk to use current password,please re-setting",@"RPString", g_bundleResorce,nil);
    }
    
    NSString * strSubString = nil;
    BOOL bSame = YES;
    for (NSInteger n = 0; n < strPassword.length; n++) {
        NSString * strSubStringGet = [strPassword substringWithRange:NSMakeRange(n, 1)];
        if (strSubString) {
            if (![strSubString isEqualToString:strSubStringGet]) {
                bSame = NO;
                break;
            }
        }
        strSubString = strSubStringGet;
    }
    if (bSame) {
        return NSLocalizedStringFromTableInBundle(@"There is a risk to use current password,please re-setting",@"RPString", g_bundleResorce,nil);
    }
    
    return nil;
}

#pragma mark ------
+(RPSDK *)defaultInstance
{
    @synchronized(self){
        if (!defaultObject)
        {
            defaultObject = [[self alloc] init];
        }
    }
    return defaultObject;
}

-(id)init
{
    id ret = [super init];
    if (ret) {
//        NSString *versionStr = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"ServerUrl"];
//        _strApiBaseUrl = versionStr;
        
        _bDemoMode = NO;
        NSNumber *numDemoMode = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"DemoMode"];
        if(numDemoMode)
            _bDemoMode = numDemoMode.boolValue;
        
        //_bDemoMode = YES;
        
        _dataOffline = [[RPOfflineData alloc] init];
        _arrayCacheData = [[NSMutableArray alloc] init];
        
        _bKeyBoradShow = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShown:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardDidHideNotification object:nil];
        
        self.cacheDocumentLive = [[ASIDownloadCache alloc] init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        [self.cacheDocumentLive setStoragePath:[documentDirectory stringByAppendingPathComponent:@"cacheDocumentLive"]];
        [self.cacheDocumentLive setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
        
        self.cacheTraining = [[ASIDownloadCache alloc] init];
        [self.cacheTraining setStoragePath:[documentDirectory stringByAppendingPathComponent:@"cacheTraining"]];
        [self.cacheTraining setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
        
        self.cacheElearning = [[ASIDownloadCache alloc] init];
        [self.cacheElearning setStoragePath:[documentDirectory stringByAppendingPathComponent:@"cacheElearning"]];
        [self.cacheElearning setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
        
        _bFirstOpen = YES;
        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentDirectory = [paths objectAtIndex:0];
        NSString *filename=[documentDirectory stringByAppendingPathComponent:@"system.plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
        NSNumber * numFirstOpen = [data objectForKey:@"FirstOpen"];
        if (numFirstOpen && !numFirstOpen.boolValue) {
            _bFirstOpen = NO;
        }
    }
    return ret;
}

- (void)keyboardWillShown:(NSNotification*)aNotification{
    // 键盘信息字典
    _bKeyBoradShow = YES;
}

- (void)keyboardWillHide:(NSNotification*)aNotification{
    // 键盘信息字典
    _bKeyBoradShow = NO;
}

-(NSString *)GetSid
{
    return [RPNetModule GetSid];
}

-(NSString *)genURL:(NSString *)strURL
{
    if (_bDemoMode) {
        return strURL;
    }
    return [NSString stringWithFormat:@"%@/%@",_strApiBaseUrl,strURL];
}

-(NSString *)ValidString:(NSDictionary *)dict forKey:(NSString *)strKey
{
    NSString * strValue = [dict objectForKey:strKey];
    if (strValue == nil || (id)strValue == [NSNull null]) {
        strValue = @"";
    }
    return strValue;
}

-(NSNumber *)ValidNumber:(NSDictionary *)dict forKey:(NSString *)strKey defaultValue:(NSInteger)nDefault
{
    NSNumber * numValue = [dict objectForKey:strKey];
    if (numValue == nil || (id)numValue == [NSNull null]) {
        numValue = [NSNumber numberWithInt:nDefault];
    }
    return numValue;
}

-(NSNumber *)ValidDoubleNumber:(NSDictionary *)dict forKey:(NSString *)strKey defaultValue:(double)dDefault
{
    NSNumber * numValue = [dict objectForKey:strKey];
    if (numValue == nil || (id)numValue == [NSNull null]) {
        numValue = [NSNumber numberWithDouble:dDefault];
    }
    return numValue;
}

-(NSDate *)ValidDate:(NSDictionary *)dict forKey:(NSString *)strKey
{
    NSString * strValue = [dict objectForKey:strKey];
    if (strValue == nil || (id)strValue == [NSNull null]) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:strValue];
}

-(NSMutableDictionary *)genBodyDataDict:(id)idApi withToken:(BOOL)bHasToken
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:idApi forKey:@"Data"];
    if (bHasToken) {
        if (!_strToken) return nil;
        [dict setObject:_strToken forKey:@"Token"];
    }
    else
    {
        [dict setObject:@"" forKey:@"Token"];
    }
    return dict;
}

-(NSString *)createMD5:(NSString *)signString
{
    const char*cStr =[signString UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return[NSString stringWithFormat:
           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
           result[0], result[1], result[2], result[3],
           result[4], result[5], result[6], result[7],
           result[8], result[9], result[10], result[11],
           result[12], result[13], result[14], result[15]
           ];
}

-(void)SetURL:(NSString *)strURL
{
    _strApiBaseUrl = strURL;
}


#pragma mark LocalData
-(NSString *)GetSavedLoginUserName
{
    if (_bDemoMode) return @"Guest";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filename=[documentDirectory stringByAppendingPathComponent:@"system.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    return [data objectForKey:@"LoginUserName"];
}

-(NSString *)GetSavedFullName
{
    if (_bDemoMode) return @"Guest";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filename=[documentDirectory stringByAppendingPathComponent:@"system.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    return [data objectForKey:@"FullName"];
}

-(NSString *)GetSavedPassword
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filename=[documentDirectory stringByAppendingPathComponent:@"system.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSNumber * numAuto = [data objectForKey:@"AutoLogin"];
    if (numAuto.boolValue) {
        NSString * strEnc = [data objectForKey:@"LoginPsw"];
        if (strEnc)
        {
            NSData * data = [GTMBase64 decodeString:strEnc];
            if (data)
            {
                NSData * data2 = [data AES256DecryptWithKey:@"RetailPlus123"];
                if  (data2)
                    return [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
            }
        }
    }
    return nil;
}

-(BOOL)IsAutoLogin
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filename=[documentDirectory stringByAppendingPathComponent:@"system.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSNumber * numAuto = [data objectForKey:@"AutoLogin"];
    if (numAuto.boolValue)
        return numAuto.boolValue;
    return NO;
}

-(void)SaveLoginUserName:(NSString *)strUserName FullName:(NSString *)strFullName Password:(NSString *)strPassword autoLogin:(BOOL)bAutoLogin
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filename=[documentDirectory stringByAppendingPathComponent:@"system.plist"];
    //输入写入
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:strUserName forKey:@"LoginUserName"];
    [dict setObject:strFullName forKey:@"FullName"];
    
    if (bAutoLogin) {
        NSData * data = [strPassword dataUsingEncoding:NSUTF8StringEncoding];
        NSData * dataEnc = [data AES256EncryptWithKey:@"RetailPlus123"];
        NSString * strEnc = [GTMBase64 stringByEncodingData:dataEnc];
        [dict setObject:strEnc forKey:@"LoginPsw"];
        
        [dict setObject:[NSNumber numberWithBool:bAutoLogin] forKey:@"AutoLogin"];
    }
    else
    {
        [dict setObject:@"" forKey:@"LoginPsw"];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"AutoLogin"];
    }
    
    [dict setObject:[NSNumber numberWithBool:NO] forKey:@"FirstOpen"];
    
    [dict writeToFile:filename atomically:YES];
}

-(void)SaveAutoRemindData:(AutoRemaindType)type Data:(NSMutableArray *)array
{
    [[RPBDataBase defaultInstance] SaveAutoRemindData:_userLoginDetail.strUserId Type:AutoRemaindType_SubmitEmail Data:array];
}

-(NSMutableArray *)ReadAutoRemindData:(AutoRemaindType)type
{
    return [[RPBDataBase defaultInstance] ReadAutoRemindData:_userLoginDetail.strUserId Type:type];
}

#pragma mark ReceiveDict Decode
-(UserDetailInfo *)CreateUserDetailByDict:(NSDictionary *)dict
{
    if (dict == nil || ![dict isKindOfClass:[NSDictionary class]]) return nil;
    
    UserDetailInfo * userDetailInfo = [[UserDetailInfo alloc] init];
    
    userDetailInfo.strUserId = [self ValidString:dict forKey:@"UserId"];
    userDetailInfo.strUserCode = [self ValidString:dict forKey:@"UserCode"];
    userDetailInfo.strUserAcount = [self ValidString:dict forKey:@"UserAcount"];
    userDetailInfo.strUserEmail = [self ValidString:dict forKey:@"UserEmail"];
    userDetailInfo.strFirstName = [self ValidString:dict forKey:@"FirstName"];
//    userDetailInfo.strSurName = [self ValidString:dict forKey:@"SurName"];
    
    NSString * strPortrait = [self ValidString:dict forKey:@"Portrait"];
    if (strPortrait && strPortrait.length > 0) {
        userDetailInfo.strPortraitImg = strPortrait;
        userDetailInfo.strPortraitImgBig = [userDetailInfo.strPortraitImg stringByReplacingCharactersInRange:NSMakeRange(userDetailInfo.strPortraitImg.length - 6,2) withString:@"_2"];
    }
    
    userDetailInfo.strAlternatePhone = [self ValidString:dict forKey:@"AlternatePhone"];
    userDetailInfo.strInterest = [self ValidString:dict forKey:@"Interest"];
    userDetailInfo.strBirthDate = [self ValidString:dict forKey:@"BirthDate"];
    userDetailInfo.nBirthYear = [self ValidNumber:dict forKey:@"BirthYear" defaultValue:0].integerValue;
    
    userDetailInfo.sex = [self ValidNumber:dict forKey:@"Gender" defaultValue:Sex_Male].integerValue;
    userDetailInfo.IsPublicAge = [self ValidNumber:dict forKey:@"IsPublicAge" defaultValue:NO].boolValue;
    userDetailInfo.IsLoginProtection = [self ValidNumber:dict forKey:@"IsLoginProtection" defaultValue:NO].boolValue;
    
    userDetailInfo.strRoleName = [self ValidString:dict forKey:@"RoleName"];
    userDetailInfo.strDomainName = [self ValidString:dict forKey:@"DomainName"];
    userDetailInfo.strReportTo = [self ValidString:dict forKey:@"ReportTo"];
    userDetailInfo.strReportToUserId = [self ValidString:dict forKey:@"ReportToId"];
    
    userDetailInfo.rank = [self ValidNumber:dict forKey:@"Rank" defaultValue:Rank_Assistant].integerValue;
    
    userDetailInfo.strEnterpise = [self ValidString:dict forKey:@"Enterpise"];
    userDetailInfo.strOfficePhoneNumber = [self ValidString:dict forKey:@"OfficePhoneNumber"];
    userDetailInfo.strOfficeAddress = [self ValidString:dict forKey:@"OfficeAddress"];
    userDetailInfo.strWorkEmail = [self ValidString:dict forKey:@"WorkEmail"];
    
    userDetailInfo.strTag1 = [self ValidString:dict forKey:@"Tag1"];
    userDetailInfo.strTag2 = [self ValidString:dict forKey:@"Tag2"];
    userDetailInfo.strTag3 = [self ValidString:dict forKey:@"Tag3"];
    
    userDetailInfo.bCanDelete = [self ValidNumber:dict forKey:@"DeletePermission" defaultValue:NO].boolValue;
    userDetailInfo.bCanModify = [self ValidNumber:dict forKey:@"EditPermission" defaultValue:NO].boolValue;
    userDetailInfo.status = [self ValidNumber:dict forKey:@"Status" defaultValue:UserStatus_Normal].integerValue;
    
    userDetailInfo.strDefaultPosId = [self ValidString:dict forKey:@"DefaultPositionId"];
    userDetailInfo.arrayPosition = [[NSMutableArray alloc] init];
    
    NSArray * arrayPos = [dict objectForKey:@"UserPositionList"];
    if (arrayPos && (id)arrayPos != [NSNull null]) {
        for (NSDictionary * dictPos in arrayPos) {
            RPPosition * pos = [[RPPosition alloc] init];
            pos.strPositionId = [self ValidString:dictPos forKey:@"PostionId"];
            pos.strPositionName = [self ValidString:dictPos forKey:@"PostionName"];
            pos.strRoleId = [self ValidString:dictPos forKey:@"RoleId"];
            pos.strRoleName = [self ValidString:dictPos forKey:@"RoleName"];
            pos.rank = [self ValidNumber:dictPos forKey:@"Rank" defaultValue:Rank_Assistant].integerValue;
            [userDetailInfo.arrayPosition addObject:pos];
        }
    }
    
    NSDate * dateJoin = [self ValidDate:dict forKey:@"JoinDate"];
    if (!dateJoin) userDetailInfo.strJoinedDate = @"";
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        userDetailInfo.strJoinedDate = [formatter stringFromDate:dateJoin];
    }
    
    if (userDetailInfo.strFirstName.length > 0) {
        NSString *subString = [userDetailInfo.strFirstName substringToIndex:1];
        int a = [subString characterAtIndex:0];
        if( a > 0x4e00 && a < 0x9fff)
        {
            char c = pinyinFirstLetter([subString characterAtIndex:0]);
            userDetailInfo.strCompare = [[NSString alloc] initWithBytes:&c length:1 encoding:NSUTF8StringEncoding];
            userDetailInfo.strSectionLetter = userDetailInfo.strCompare;
        }
        else if ((a >= 65 && a <= 90) || (a >= 97 && a <= 122))
        {
            userDetailInfo.strCompare = userDetailInfo.strFirstName;
            userDetailInfo.strSectionLetter = [userDetailInfo.strFirstName substringToIndex:1];
        }
        else
        {
            userDetailInfo.bFirstAlph = YES;
            userDetailInfo.strCompare = userDetailInfo.strFirstName;
            userDetailInfo.strSectionLetter = @"#";
        }
    }
    else
    {
        userDetailInfo.strSectionLetter = @"#";
    }
    
    return userDetailInfo;
}

-(StoreDetailInfo *)CreateStoreDetailByDict:(NSDictionary *)dict
{
    StoreDetailInfo * storeDetailInfo = [[StoreDetailInfo alloc] init];
    storeDetailInfo.strStoreId = [self ValidString:dict forKey:@"StoreId"];
    storeDetailInfo.strDomainID= [self ValidString:dict forKey:@"DomainId"];
    NSString * strThumb = [self ValidString:dict forKey:@"StoreThumb"];
    if (strThumb && strThumb.length > 0) {
        storeDetailInfo.strStoreThumb = strThumb;
        storeDetailInfo.strStoreThumbBig = [storeDetailInfo.strStoreThumb stringByReplacingCharactersInRange:NSMakeRange(storeDetailInfo.strStoreThumb.length - 6,2) withString:@"_2"];
    }
    
    storeDetailInfo.strBrandName = [self ValidString:dict forKey:@"BrandName"];
    storeDetailInfo.strStoreName = [self ValidString:dict forKey:@"StoreName"];
    storeDetailInfo.strStoreAddress = [self ValidString:dict forKey:@"StoreAddress"];
    storeDetailInfo.isOwn = [self ValidNumber:dict forKey:@"IsOwn" defaultValue:NO].boolValue;
    storeDetailInfo.isPerfect = [self ValidNumber:dict forKey:@"IsPerfect" defaultValue:NO].boolValue;
    
    storeDetailInfo.strStoreCode = [self ValidString:dict forKey:@"StoreCode"];
    storeDetailInfo.strStorePostCode = [self ValidString:dict forKey:@"PostCode"];
    storeDetailInfo.strStoreOrganize = [self ValidString:dict forKey:@"Organize"];
    storeDetailInfo.strStoreType = [self ValidString:dict forKey:@"StoreType"];
    
    storeDetailInfo.strCityName = [self ValidString:dict forKey:@"CityName"];
    storeDetailInfo.strCity = [self ValidString:dict forKey:@"City"];
    storeDetailInfo.strDealerName = [self ValidString:dict forKey:@"DealerName"];
    storeDetailInfo.strMarket = [self ValidString:dict forKey:@"Market"];
    storeDetailInfo.strShopMap = [self ValidString:dict forKey:@"ShopMap"];
    storeDetailInfo.strArea = [self ValidString:dict forKey:@"Area"];
    storeDetailInfo.strDecorationDate = [self ValidString:dict forKey:@"DecorationDate"];
    storeDetailInfo.strEmail = [self ValidString:dict forKey:@"Email"];
    storeDetailInfo.strFax = [self ValidString:dict forKey:@"Fax"];
    storeDetailInfo.strStartTime = [self ValidString:dict forKey:@"StartTime"];
    storeDetailInfo.strEndTime = [self ValidString:dict forKey:@"EndTime"];;
    storeDetailInfo.strAreaSquare = [self ValidString:dict forKey:@"AreaSquare"];
    storeDetailInfo.strWeatherCode = [self ValidString:dict forKey:@"WeatherCode"];
    storeDetailInfo.strPhone = [self ValidString:dict forKey:@"Phone"];
    storeDetailInfo.llRights = [self ValidNumber:dict forKey:@"BitMap" defaultValue:0].longLongValue;
    storeDetailInfo.strDomainNo = [self ValidString:dict forKey:@"DomainNo"];
    storeDetailInfo.strParentDomainId = [self ValidString:dict forKey:@"ParentDomainId"];
    
    storeDetailInfo.arrayShopMap = [[NSMutableArray alloc] init];
    
    NSArray * arrayMaps = [dict objectForKey:@"Blueprints"];
    if (arrayMaps && (id)arrayMaps != [NSNull null]) {
        for (NSDictionary * dictMaps in arrayMaps) {
            StoreShopMap * map = [[StoreShopMap alloc] init];
            map.strId = [self ValidString:dictMaps forKey:@"Id"];
            map.strTitle = [self ValidString:dictMaps forKey:@"Name"];
            map.strUrl = [self ValidString:dictMaps forKey:@"Url"];
            [storeDetailInfo.arrayShopMap addObject:map];
        }
    }
    return storeDetailInfo;
}

-(Customer *)CreateCustomByDict:(NSDictionary *)dict
{
    Customer * customer = [[Customer alloc] init];
    customer.strCustomerId = [self ValidString:dict forKey:@"CustomerId"];
    customer.strFirstName = [self ValidString:dict forKey:@"FirstName"];
//    customer.strSurName = [self ValidString:dict forKey:@"SurName"];
    customer.strPhone1 = [self ValidString:dict forKey:@"Phone1"];
    customer.strPhone2 = [self ValidString:dict forKey:@"Phone2"];
    customer.isVip = [self ValidNumber:dict forKey:@"IsVip" defaultValue:NO].boolValue;
    customer.strCareerId = [self ValidString:dict forKey:@"CareerId"];
    customer.strChildrenDesc = [self ValidString:dict forKey:@"ChildrenDesc"];
    customer.strMemorialDaysDesc = [self ValidString:dict forKey:@"MemorialDaysDesc"];
    
    customer.strInterest = [self ValidString:dict forKey:@"Interest"];
    customer.strDistrict = [self ValidString:dict forKey:@"Location"];
    customer.strStoreDesc = [self ValidString:dict forKey:@"StoreDesc"];
    customer.strStoreId = [self ValidString:dict forKey:@"StoreId"];
    customer.strTitle = [self ValidString:dict forKey:@"Title"];
    
    customer.strRelationUserId = [self ValidString:dict forKey:@"UserId"];
    customer.isRelate = NO;
    if ([customer.strRelationUserId isEqualToString:_userLoginDetail.strUserId])
        customer.isRelate = YES;
    
    customer.strRelationUserName = [self ValidString:dict forKey:@"LinkUserName"];
    customer.rankRelationUser = [self ValidNumber:dict forKey:@"LinkUserRank" defaultValue:Rank_Assistant].integerValue;
    
    NSString * strCustImg = [self ValidString:dict forKey:@"CustImg"];
    if (strCustImg && strCustImg.length > 0) {
        customer.strCustImg = strCustImg;
        customer.strCustImgBig = [customer.strCustImg stringByReplacingCharactersInRange:NSMakeRange(customer.strCustImg.length - 6,2) withString:@"_2"];
    }
    
    customer.Sex = [self ValidNumber:dict forKey:@"Sex" defaultValue:Sex_NotAssign].integerValue;
    customer.strBirthDate = [self ValidString:dict forKey:@"BirthDate"];
    customer.nBirthYear = [self ValidNumber:dict forKey:@"BirthYear" defaultValue:0].integerValue;
    customer.strAddress = [self ValidString:dict forKey:@"Address"];
    customer.strEmail = [self ValidString:dict forKey:@"Email"];
    
    if (customer.strFirstName.length > 0) {
        NSString *subString = [customer.strFirstName substringToIndex:1];
        int a = [subString characterAtIndex:0];
        if( a >= 0x4e00 && a < 0x9fff)
        {
            char c = pinyinFirstLetter([subString characterAtIndex:0]);
            customer.strCompare = [[NSString alloc] initWithBytes:&c length:1 encoding:NSUTF8StringEncoding];
            customer.strSectionLetter = customer.strCompare;
        }
        else if ((a >= 65 && a <= 90) || (a >= 97 && a <= 122))
        {
            customer.strCompare = customer.strFirstName;
            customer.strSectionLetter = [customer.strFirstName substringToIndex:1];
        }
        else
        {
            customer.bFirstAlph = YES;
            customer.strCompare = customer.strFirstName;
            customer.strSectionLetter = @"#";
        }
    }
    else
    {
        customer.strSectionLetter = @"#";
    }
    
    return customer;
}

#pragma mark System
-(BOOL)SetAvailableServer
{
    if (self.bDemoMode) {
        return YES;
    }
    
    _strApiBaseUrl = @"";
    [RPNetModule ClearSid];
    
    NetworkStatus sta = [RPSDK GetConnectionStatus];
    if (sta == NotReachable) {
        return NO;
    }
    
    for (NSInteger n = 0; n < 10; n ++) {
        NSString * strKey = @"ServerUrl";
        if (n > 0) {
            strKey = [NSString stringWithFormat:@"%@%d",strKey,n + 1];
        }
        
        NSString *versionStr = [[NSBundle mainBundle]objectForInfoDictionaryKey:strKey];
        if (versionStr == nil) return NO;
        
        NSString * strUrl = [NSString stringWithFormat:@"%@//version.txt",versionStr];
        
        
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                              returningResponse:&response
                                                          error:&error];
        if (data)
        {
            _strApiBaseUrl = versionStr;
            return YES;
        }
    }
    
    _strApiBaseUrl = nil;
    return NO;
}

-(NSInteger)CompareVersion:(NSArray *)array Compare:(NSArray *)array2
{
    NSInteger nRet = 0;
    for (NSInteger n = 0; n < 3; n ++) {
        NSInteger nVer = ((NSString *)[array objectAtIndex:n]).intValue;
        NSInteger nVer2 = ((NSString *)[array2 objectAtIndex:n]).intValue;
        if (nVer > nVer2)
        {
            nRet = 1;
            break;
        }
        if (nVer < nVer2)
        {
            nRet = -1;
            break;
        }
    }
    return nRet;
}

-(VersionModel *)CheckVersion:(NSString *)strCurrentVersion
{
    if (self.bDemoMode) {
        VersionModel * model = [[VersionModel alloc] init];
        model.status = VersionStatus_Latest;
        return model;
    }
    
    for (NSInteger n = 0; n < 10; n ++) {
        NSString * strKey = @"ServerUrl";
        if (n > 0) {
            strKey = [NSString stringWithFormat:@"%@%d",strKey,n + 1];
        }
        
        NSString *versionStr = [[NSBundle mainBundle]objectForInfoDictionaryKey:strKey];
        if (versionStr == nil) break;
        
        NSString * strUrl = [NSString stringWithFormat:@"%@//version.txt",versionStr];
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                              returningResponse:&response
                                                          error:&error];
        if (data) {
            NSError * error;
            NSDictionary * dictDecode = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&error];
            if (dictDecode) {
                VersionModel * model = [[VersionModel alloc] init];
                model.strVersionNum = [dictDecode objectForKey:@"High"];
                model.strDownloadURL = [dictDecode objectForKey:@"Url"];
                model.strVersionDesc =  [dictDecode objectForKey:@"Desc"];
                
                NSString * strMaxVersion = [dictDecode objectForKey:@"High"];
                NSString * strMinVersion = [dictDecode objectForKey:@"Low"];
                
                NSArray * arrayCurrent = [strCurrentVersion componentsSeparatedByString:@"."];
                NSArray * arrayMax = [strMaxVersion componentsSeparatedByString:@"."];
                NSArray * arrayMin = [strMinVersion componentsSeparatedByString:@"."];
                
                model.status = VersionStatus_Latest;
//                for (NSInteger n = 0; n < 3; n ++) {
//                    NSString * str = [arrayCurrent objectAtIndex:n];
//                    NSInteger nCur = str.integerValue;
//                    str = [arrayMax objectAtIndex:n];
//                    NSInteger nMax = str.integerValue;
//                    str = [arrayMin objectAtIndex:n];
//                    NSInteger nMin = str.integerValue;
//                    if (nCur < nMin) {
//                        model.status = VersionStatus_Force;
//                        break;
//                    }
//                    if (nCur > nMax) {
//                        model.status = VersionStatus_Force;
//                        break;
//                    }
//                    if (nCur < nMax) {
//                        model.status = VersionStatus_recommend;
//                        break;
//                    }
//                }
                
                NSInteger nCompare = [self CompareVersion:arrayCurrent Compare:arrayMax];
                if (nCompare > 0) {
                    model.status = VersionStatus_Force;
                    return model;
                }
                else if (nCompare < 0)
                {
                    model.status = VersionStatus_recommend;
                }
                else
                {
                    model.status = VersionStatus_Latest;
                    return model;
                }
                
                nCompare = [self CompareVersion:arrayCurrent Compare:arrayMin];
                if (nCompare > 0) {
                    model.status = VersionStatus_recommend;
                }
                else if (nCompare < 0)
                {
                    model.status = VersionStatus_Force;
                }
                else
                {
                    model.status = VersionStatus_recommend;
                }
                
                return model;
            }
        }
    }
    return nil;
}

-(void)GetWeatherInfo:(NSString *)strWeatherCode success:(RPSDKSuccess)successBlock failed:(RPSDKFailed)failedBlock{
    
    [RPNetModule GetWeatherInfo:strWeatherCode success:^(id idResult) {
        successBlock(idResult);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        failedBlock(nErrorCode,strDesc);
    }];
}


-(void)CheckVersion:(NSString *)strCurrentVersion Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:[NSNumber numberWithInt:DeviceType_IOS] forKey:@"DeviceType"];
    [dictAPI setObject:strCurrentVersion forKey:@"CurrentVersion"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict withToken:NO];
    [RPNetModule doRequest:[self genURL:@"Common/CheckVersion"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        VersionModel * model = [[VersionModel alloc] init];
        model.strDownloadURL = [self ValidString:dictResult forKey:@"DownLoadUrl"];
        model.strVersionDesc = [self ValidString:dictResult forKey:@"VersionDesc"];
        model.strVersionNum = [self ValidString:dictResult forKey:@"VersionNum"];
        model.status = [self ValidNumber:dictResult forKey:@"VersionStatus" defaultValue:VersionStatus_Force].integerValue;
        
        SuccessBlock(model);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}


-(void)FeedBack:(NSString *)strContent Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strContent forKey:@"Content"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Common/Feedback"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)CheckAuthActionSta:(NSString *)strAuthCode Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode)
    {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strAuthCode forKey:@"AuthCode"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Common/CheckAuthActionSta"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)SendMessage:(SendMessageType)type Title:(NSString *)strTitle Detail:(NSString *)strDetail Member:(NSString *)strMembers Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:[NSNumber numberWithInteger:type] forKey:@"Type"];
    [dictAPI setObject:strTitle forKey:@"Subject"];
    [dictAPI setObject:strDetail forKey:@"Body"];
    [dictAPI setObject:strMembers forKey:@"Recipients"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Common/SendMessage"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

#pragma mark User
-(void)Login:(NSString *)strUserName PassWord:(NSString *)strPassWord DeviceID:(NSString *)strDeviceID DeviceName:(NSString *)strDeviceName VerifyCode:(NSString *)strVerifyCode Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strUserName forKey:@"UserName"];
    [dictAPI setObject:[self createMD5:strPassWord] forKey:@"PassWord"];
    [dictAPI setObject:strDeviceID forKey:@"DeviceID"];
    [dictAPI setObject:strDeviceName forKey:@"DeviceName"];
    [dictAPI setObject:[NSNumber numberWithInt:DeviceType_IOS] forKey:@"DeviceType"];
    [dictAPI setObject:strVerifyCode forKey:@"VerifyCode"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict withToken:NO];
    [RPNetModule doRequest:[self genURL:@"User/Login"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        _dateExpire = [self ValidDate:dictResult forKey:@"Expires"];
        _strToken = [self ValidString:dictResult forKey:@"AuthToken"];
        _llRights = [self ValidNumber:dictResult forKey:@"Rights" defaultValue:0].longLongValue;
        _llOwnedModel = [self ValidNumber:dictResult forKey:@"ModuleRights" defaultValue:0].longLongValue;
        _bVoip = [self ValidNumber:dictResult forKey:@"IsVoip" defaultValue:0].boolValue;
        
        [self GetUserDetailInfo:@"" Success:^(UserDetailInfo * userDetail) {
            _userLoginDetail = userDetail;
            _strLoginPassword = strPassWord;
            _arrayCacheData = [[RPBDataBase defaultInstance] GetCacheDataArray:_userLoginDetail.strUserId];
            _timerCheckSession = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(OnCheckSession) userInfo:nil repeats:YES];
            
            [self UpdateDeviceToken:g_strDeviceToken Success:^(id idResult) {
                
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                
            }];
            
            SuccessBlock(nil);
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            FailedBlock(nErrorCode,strDesc);
        }];
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)OnCheckSession
{
    if (_bDemoMode) {
        return;
    }
    
    if (_bKeyBoradShow) {
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:_userLoginDetail.strUserId forKey:@"UserId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/HeartBeat"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kApplicationLogoutNotification object:[NSNumber numberWithInteger:0]];
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kApplicationLogoutNotification object:[NSNumber numberWithInteger:nErrorCode]];
        
        if (nErrorCode != RPSDKError_NoConnection) {
            _userLoginDetail = nil;
            _strToken = nil;
            [_timerCheckSession invalidate];
            _timerCheckSession = nil;
        }
    }];
}

-(void)Logout
{
    _bFirstOpen = NO;
    
    [RPNetModule ClearSid];
    
    [_timerCheckSession invalidate];
    _timerCheckSession = nil;
    
    NSString * strLoginUserName = [self GetSavedLoginUserName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filename=[documentDirectory stringByAppendingPathComponent:@"system.plist"];
    //输入写入
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:strLoginUserName forKey:@"LoginUserName"];
    [dict setObject:[self GetSavedFullName] forKey:@"FullName"];
    
    [dict setObject:@"" forKey:@"LoginPsw"];
    [dict setObject:[NSNumber numberWithBool:NO] forKey:@"AutoLogin"];
    [dict setObject:[NSNumber numberWithBool:NO] forKey:@"FirstOpen"];
    
    [dict writeToFile:filename atomically:YES];
    
    _userLoginDetail = nil;
    _strToken = nil;
    [_arrayCacheData removeAllObjects];
}

-(void)ChangePWD:(NSString *)strOldPWD NewPassWord:(NSString *)strNewPWD Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        FailedBlock(RPSDKError_Unknown,@"");
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    if (strOldPWD.length == 0)
        [dictAPI setObject:@"" forKey:@"OldPWD"];
    else
        [dictAPI setObject:[self createMD5:strOldPWD] forKey:@"OldPWD"];
    
    [dictAPI setObject:[self createMD5:strNewPWD] forKey:@"NewPWD"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/ChangePWD"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)InviteUser:(NSString *)strPhone UserName:(NSString *)strUserName PositionID:(NSString *)strPositionID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strPhone forKey:@"Phone"];
    [dictAPI setObject:strPositionID forKey:@"PositionID"];
    [dictAPI setObject:strUserName forKey:@"UserName"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/InviteUser"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)UpdateUserProfile:(UserProfileUpdate *)profile Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    
    if (!profile.strFirstName) profile.strFirstName = @"";
//    if (!profile.strSurName) profile.strSurName = @"";
    if (!profile.strWorkEmail) profile.strWorkEmail = @"";
    if (!profile.strBirthDate) profile.strBirthDate = @"";
    if (!profile.strInterest) profile.strInterest = @"";
    if (!profile.strAlternatePhone) profile.strAlternatePhone = @"";
    if (!profile.strOnBoard) profile.strOnBoard = @"";
    if (!profile.strOfficeAddress) profile.strOfficeAddress = @"";
    if (!profile.strOfficePhone) profile.strOfficePhone = @"";
    if (!profile.strUserAccount) profile.strUserAccount = @"";
    
    [dictAPI setObject:profile.strUserId forKey:@"UserId"];
    [dictAPI setObject:profile.strFirstName forKey:@"FirstName"];
//    [dictAPI setObject:profile.strSurName forKey:@"SurName"];
    [dictAPI setObject:profile.strWorkEmail forKey:@"WorkEmail"];
    [dictAPI setObject:profile.strUserAccount forKey:@"UserAccount"];
    
    [dictAPI setObject:profile.strBirthDate forKey:@"BirthDate"];
    [dictAPI setObject:[NSNumber numberWithInteger:profile.nBirthYear] forKey:@"BirthYear"];
    
    [dictAPI setObject:profile.strInterest forKey:@"Interest"];
    [dictAPI setObject:profile.strAlternatePhone forKey:@"AlternatePhone"];
    
    [dictAPI setObject:profile.strOfficePhone forKey:@"OfficePhone"];
    [dictAPI setObject:profile.strOfficeAddress forKey:@"OfficeAddress"];
    [dictAPI setObject:profile.strOnBoard forKey:@"OnBoard"];
    
    NSString * strImage =  [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(profile.imgUser, 0.5)];
    if (strImage == nil) {
        strImage = @"";
    }
    [dictAPI setObject:strImage forKey:@"Portrait"];

    [dictAPI setObject:[NSNumber numberWithBool:profile.IsPublicAge] forKey:@"IsPublicAge"];
    [dictAPI setObject:[NSNumber numberWithInteger:profile.sex] forKey:@"Gender"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/UpdateUserProfile"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        if  ([profile.strUserId isEqualToString:_userLoginDetail.strUserId])
        {
            [self SaveLoginUserName:profile.strUserAccount FullName:profile.strFirstName Password:[self GetSavedPassword] autoLogin:[self IsAutoLogin]];
        }
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)SetLoginProtectionStatus:(BOOL)isProtect Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:[NSNumber numberWithBool:isProtect] forKey:@"IsLoginProtection"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/SetLoginProtectionStatus"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)UpdateDeviceName:(NSString *)strDeviceID DeviceName:(NSString *)strDeviceName Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strDeviceID forKey:@"LoginDeviceId"];
    [dictAPI setObject:strDeviceName forKey:@"DeviceName"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/UpdateDeviceName"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)Quit:(NSString *)strUserId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strUserId forKey:@"UserId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/Quit"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)BoundEmail:(NSString *)strEmail SendEmail:(NSString *)strSendEmail Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strEmail forKey:@"NewEmail"];
    [dictAPI setObject:strSendEmail forKey:@"SendEmail"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/BoundEmail"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetLoginDeviceList:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        FailedBlock(RPSDKError_Unknown,@"");
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/GetLoginDeviceList"] isCheckWifi:NO withData:dict success:^(NSMutableArray * arrayResult) {
        NSMutableArray * arrayDevice = [[NSMutableArray alloc] init];
        for (NSDictionary * dictDevice in arrayResult) {
            LoginDevice * device = [[LoginDevice alloc] init];
            device.strDeviceName = [self ValidString:dictDevice forKey:@"DeviceName"];
            DeviceType typeDevice = [self ValidNumber:dictDevice forKey:@"DeviceType" defaultValue:-1].integerValue;
            switch (typeDevice) {
                case DeviceType_Android:
                    device.strDeviceType = @"ANDROID";
                    break;
                case DeviceType_IOS:
                    device.strDeviceType = @"IOS";
                    break;
                default:
                    device.strDeviceType = @"UNKNOWN";
                    break;
            }
            device.strDeviceUUID = [self ValidString:dictDevice forKey:@"DeviceUUID"];
            device.strLastLoginDate = [self ValidString:dictDevice forKey:@"LastLoginDate"];
            device.strLoginDeviceId = [self ValidString:dictDevice forKey:@"LoginDeviceId"];
            [arrayDevice addObject:device];
        }
        SuccessBlock(arrayDevice);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetUserDetailInfo:(NSString *)strUserID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strUserID forKey:@"UserId"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/GetUserDetailInfo"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        UserDetailInfo * userInfo = [self CreateUserDetailByDict:dictResult];
        SuccessBlock(userInfo);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetUserInfoList:(Rank)rank Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:[NSNumber numberWithInteger:rank] forKey:@"Rank"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    NSString * strUrl = nil;
    if (_bDemoMode)
        strUrl = [NSString stringWithFormat:@"User/GetUserInfoList%d",rank];
    else
        strUrl = @"User/GetUserInfoList";
        
    [RPNetModule doRequest:[self genURL:strUrl] isCheckWifi:NO withData:dict success:^(NSMutableArray * arrayResult) {
        NSMutableArray * arrayUser = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            UserDetailInfo * userInfo = [self CreateUserDetailByDict:dict];
            [arrayUser addObject:userInfo];
        }
        SuccessBlock(arrayUser);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetUserRankCount:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/GetUserRankCount"] isCheckWifi:NO withData:dict success:^(NSMutableArray * arrayResult) {
        UserRankCount * userRankCount = [[UserRankCount alloc] init];
        for(NSDictionary * dictCount in arrayResult)
        {
            Rank rank = [self ValidNumber:dictCount forKey:@"Rank" defaultValue:-1].integerValue;
            NSInteger nCount = [self ValidNumber:dictCount forKey:@"Count" defaultValue:0].integerValue;
            switch(rank)
            {
                case Rank_Manager:
                    userRankCount.nCountManager = nCount;
                    break;
                case Rank_StoreManager:
                    userRankCount.nCountStoreManager = nCount;
                    break;
                case Rank_Assistant:
                    userRankCount.nCountAssistant = nCount;
                    break;
                case Rank_Vendor:
                    userRankCount.nCountVendor = nCount;
                    break;
                default:
                    break;
            }
        }
        SuccessBlock(userRankCount);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

//我没权限
-(void)GetUserListByVendor:(SituationType)sitType VendorID:(NSString *)strVendorID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:[NSNumber numberWithInt:sitType] forKey:@"SituationType"];
    [dictAPI setObject:strVendorID forKey:@"VendorID"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/GetUserListByVendor"] isCheckWifi:NO withData:dict success:^(NSMutableArray * arrayResult) {
        NSMutableArray * arrayUser = [[NSMutableArray alloc] init];
        for (NSDictionary * dictUser in arrayResult) {
            UserDetailInfo * user = [self CreateUserDetailByDict:dictUser];
            [arrayUser addObject:user];
        }
        SuccessBlock(arrayUser);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetReportToUser:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    
}

-(void)RequestIdCert:(NSString *)strCertNO CertDevice:(CertDevice)certDeviceType CertType:(CertType)certType withLoginToken:(BOOL)bWithToken  Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        FailedBlock(RPSDKError_Unknown,@"");
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strCertNO forKey:@"IdcertNo"];
    [dictAPI setObject:[NSNumber numberWithInteger:certDeviceType] forKey:@"IdcertDevice"];
    [dictAPI setObject:[NSNumber numberWithInteger:certType] forKey:@"IdcertType"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:bWithToken];
    [RPNetModule doRequest:[self genURL:@"User/RequestIdCert"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        _strToken = [dictResult objectForKey:@"AuthToken"];
        _llRights = [self ValidNumber:dictResult forKey:@"Rights" defaultValue:0].longLongValue;
        
        [self GetUserDetailInfo:@"" Success:^(UserDetailInfo * userDetail) {
            _userLoginDetail = userDetail;
            SuccessBlock(nil);
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            FailedBlock(nErrorCode,strDesc);
        }];
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)VerifyIdCert:(NSString *)strVerifyCode CertType:(CertType)certType Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        FailedBlock(RPSDKError_Unknown,@"");
        return;
    }
    if (strVerifyCode==nil)
    {
        strVerifyCode=@"";
    }
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strVerifyCode forKey:@"VerifyCode"];
    [dictAPI setObject:[NSNumber numberWithInteger:certType] forKey:@"IdcertType"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/VerifyIdCert"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetInviteRoleList:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        FailedBlock(RPSDKError_Unknown,@"");
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/GetInviteRoleList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * arrayRole = [[NSMutableArray alloc] init];
        for (NSDictionary * dictRole in arrayResult) {
            InviteRole * role = [[InviteRole alloc] init];
            role.strRoleID = [self ValidString:dictRole forKey:@"RoleId"];
            role.strRoleName = [self ValidString:dictRole forKey:@"RoleName"];
            role.strDomainTypeName = [self ValidString:dictRole forKey:@"DomainTypeName"];
            role.rankRole = [self ValidNumber:dictRole forKey:@"Rank" defaultValue:Rank_Assistant].integerValue;
            [arrayRole addObject:role];
        }
        SuccessBlock(arrayRole);

    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetInvitePositionListByRole:(NSString *)strRoleID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        FailedBlock(RPSDKError_Unknown,@"");
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strRoleID forKey:@"RoleId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/GetInvitePositionList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * arrayPosition = [[NSMutableArray alloc] init];
        for (NSDictionary * dictPosition in arrayResult) {
            InvitePosition * position = [[InvitePosition alloc] init];
            position.strPositionID = [self ValidString:dictPosition forKey:@"PostionId"];
            position.strDomainName = [self ValidString:dictPosition forKey:@"DomainName"];
            [arrayPosition addObject:position];
        }
        SuccessBlock(arrayPosition);
        
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)UpdateDeviceToken:(NSString *)strDeviceToken Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        FailedBlock(RPSDKError_Unknown,@"");
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strDeviceToken forKey:@"DeviceToken"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/UpdateDeviceToken"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetExistUserTagSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/GetUserExistTag"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock([[NSMutableArray alloc] initWithArray:arrayResult]);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)SetUserTags:(NSString *)strUserId Tag1:(NSString *)strTag1 Tag2:(NSString *)strTag2 Tag3:(NSString *)strTag3 Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strUserId forKey:@"ContactorId"];
    [dictAPI setObject:strTag1 forKey:@"Tag1"];
    [dictAPI setObject:strTag2 forKey:@"Tag2"];
    [dictAPI setObject:strTag3 forKey:@"Tag3"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/SetUserTag"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)LockUser:(NSString *)strUserId Lock:(BOOL)bLock Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strUserId forKey:@"UserId"];
    if (bLock)
        [dictAPI setObject:[NSNumber numberWithInteger:UserStatus_Locked] forKey:@"Status"];
    else
        [dictAPI setObject:[NSNumber numberWithInteger:UserStatus_Normal] forKey:@"Status"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/SetUserStatus"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)ResetPsw:(NSString *)strUserId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strUserId forKey:@"UserId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/ResetUserPassword"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetPositionList:(NSString *)strUserId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strUserId forKey:@"UserId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/GetUserPositionList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)SetUserPosition:(NSString *)strUserId Position:(NSString *)strPositionId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strUserId forKey:@"UserId"];
    [dictAPI setObject:strPositionId forKey:@"PositionId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/SetUserPosition"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)RemoveUserPosition:(NSString *)strUserId Position:(NSString *)strPositionId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strUserId forKey:@"UserId"];
    [dictAPI setObject:strPositionId forKey:@"PositionId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/RemoveUserPosition"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)SetDefaultPosition:(NSString *)strUserId Position:(NSString *)strPositionId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strUserId forKey:@"UserId"];
    [dictAPI setObject:strPositionId forKey:@"PositionId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/SetUserDefaultPosition"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)SetUserReportTo:(NSString *)strUserId ReportTo:(NSString *)strReportToId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strUserId forKey:@"UserId"];
    [dictAPI setObject:strReportToId forKey:@"ReportToId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"User/SetUserReportTo"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

#pragma mark Store
-(void)GetDomainListSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Store/GetDomainList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult)
        {
            DomainInfo * info = [[DomainInfo alloc] init];
            info.strDomainID = [self ValidString:dict forKey:@"DomainId"];
            info.strDomainName = [self ValidString:dict forKey:@"DomainName"];
            info.strParentDomainID = [self ValidString:dict forKey:@"ParentDomainId"];
            info.strDomainCode = [self ValidString:dict forKey:@"DomainNo"];
            [array addObject:info];
        }
        SuccessBlock(array);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetStoreList:(SituationType)sitType Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:[NSNumber numberWithInt:sitType] forKey:@"SituationType"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Store/GetStoreList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * arrayStore = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            StoreDetailInfo * store = [self CreateStoreDetailByDict:dict];
            [arrayStore addObject:store];
        }
        SuccessBlock(arrayStore);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetVendorList:(NSString *)strStoreID SituationType:(SituationType)sitType Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    [dictAPI setObject:[NSNumber numberWithInteger:sitType] forKey:@"SituationType"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Store/GetVendorList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * arrayVendor = [[NSMutableArray alloc] init];
        for (NSDictionary * dictVendor in arrayResult) {
            Vendor * vendorAdd = [[Vendor alloc] init];
            vendorAdd.strVendorID = [self ValidString:dictVendor forKey:@"VendorId"];
            vendorAdd.strAssetType = [self ValidString:dictVendor forKey:@"AssetTypeName"];
            vendorAdd.strVendorName = [self ValidString:dictVendor forKey:@"VendorName"];
            [arrayVendor addObject:vendorAdd];
        }
        SuccessBlock(arrayVendor);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetAssetCategoryList:(NSString *)strStoreID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Store/GetAssetCategoryList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayVendor) {
        InspData * data = [[InspData alloc] init];
        data.arrayInsp = [[NSMutableArray alloc] init];
        
        for (NSDictionary * dictVendor in arrayVendor) {
            InspVendor * vendorAdd = [[InspVendor alloc] init];
            vendorAdd.strVendorID = [self ValidString:dictVendor forKey:@"VendorId"];
            vendorAdd.strAssetType = [self ValidString:dictVendor forKey:@"AssetTypeName"];
            vendorAdd.strVendorName = [self ValidString:dictVendor forKey:@"VendorName"];
            vendorAdd.arrayCatagory = [[NSMutableArray alloc] init];
            
            NSArray * catagories = [dictVendor objectForKey:@"Categorys"];
            for (NSDictionary * catagoryDict in catagories) {
                InspCatagory * catagoryAdd = [[InspCatagory alloc] init];
                catagoryAdd.strCatagoryDesc = [self ValidString:catagoryDict forKey:@"CategoryDesc"];
                catagoryAdd.strCatagoryID = [self ValidString:catagoryDict forKey:@"CategoryId"];
                catagoryAdd.strCatagoryName = [self ValidString:catagoryDict forKey:@"CategoryName"];
                
                NSString * strUnit = [self ValidString:catagoryDict forKey:@"Unit"];
                NSNumber * num = [self ValidNumber:catagoryDict forKey:@"Quantity" defaultValue:0];
                if (num.integerValue != 0) {
                    catagoryAdd.strCatagoryDesc = [NSString stringWithFormat:@"%@(%d %@)",catagoryAdd.strCatagoryDesc,num.integerValue,strUnit];
                }
                
                [vendorAdd.arrayCatagory addObject:catagoryAdd];
            }
            
            [data.arrayInsp addObject:vendorAdd];
        }
        
        SuccessBlock(data);
        
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)UpdateStoreProfile:(StoreDetailInfo *)info Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:info.strStoreId forKey:@"StoreId"];
    [dictAPI setObject:info.strStoreCode forKey:@"StoreCode"];
    [dictAPI setObject:info.strStoreName forKey:@"StoreName"];
    [dictAPI setObject:info.strStoreAddress forKey:@"StoreAddress"];
    [dictAPI setObject:info.strEmail forKey:@"Email"];
    [dictAPI setObject:info.strFax forKey:@"Fax"];
    [dictAPI setObject:info.strStartTime forKey:@"StartTime"];
    [dictAPI setObject:info.strEndTime forKey:@"EndTime"];
    [dictAPI setObject:[NSNumber numberWithFloat:info.strAreaSquare.floatValue] forKey:@"AreaSquare"];
    [dictAPI setObject:info.strStorePostCode forKey:@"PostCode"];
    [dictAPI setObject:info.strPhone forKey:@"Phone"];
    
    NSString * strImage = @"";
    if (info.imgStore) {
        strImage =  [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(info.imgStore, 0.5)];
        if (strImage == nil) {
            strImage = @"";
        }
    }
    [dictAPI setObject:strImage forKey:@"StoreThumb"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"store/UpdateStore"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictStore)
     {
         StoreDetailInfo * store = [self CreateStoreDetailByDict:dictStore];
         SuccessBlock(store);
     }
     failed:^(NSInteger nErrorCode, NSString *strDesc) {
         FailedBlock(nErrorCode,strDesc);
     }];
}

#pragma mark Customer
-(void)GetCustomerCareerList:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Customer/GetCareerList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * arrayCustomer = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            CustomerCareer * career = [[CustomerCareer alloc] init];
            career.strCustomerCareerId = [dict objectForKey:@"CareerId"];
            career.strCustomerCareerDesc = [dict objectForKey:@"CareerDesc"];
            [arrayCustomer addObject:career];
        }
        SuccessBlock(arrayCustomer);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetCustomerList:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Customer/GetCustomerList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * arrayCustomer = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            Customer * custom = [self CreateCustomByDict:dict];
            [arrayCustomer addObject:custom];
        }
        SuccessBlock(arrayCustomer);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)AddCustomer:(Customer *)customer Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    
    [dictAPI setObject:customer.strAddress forKey:@"Address"];
    [dictAPI setObject:customer.strBirthDate forKey:@"BirthDate"];
    [dictAPI setObject:[NSNumber numberWithInteger:customer.nBirthYear] forKey:@"BirthYear"];
    [dictAPI setObject:customer.strCareerId forKey:@"CareerId"];
    [dictAPI setObject:customer.strChildrenDesc forKey:@"ChildrenDesc"];
    NSString * strImage = @"";
    if (customer.imgCust) {
        strImage =  [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(customer.imgCust, 0.5)];
        if (strImage == nil) {
            strImage = @"";
        }
    }
    [dictAPI setObject:strImage forKey:@"CustImg"];
    [dictAPI setObject:customer.strEmail forKey:@"Email"];
    [dictAPI setObject:customer.strFirstName forKey:@"FirstName"];
    [dictAPI setObject:customer.strInterest forKey:@"Interest"];
    [dictAPI setObject:[NSNumber numberWithBool:customer.isVip] forKey:@"IsVip"];
    [dictAPI setObject:customer.strDistrict forKey:@"Location"];
    [dictAPI setObject:customer.strMemorialDaysDesc forKey:@"MemorialDaysDesc"];
    [dictAPI setObject:customer.strPhone1 forKey:@"Phone1"];
    [dictAPI setObject:customer.strPhone2 forKey:@"Phone2"];
    [dictAPI setObject:[NSNumber numberWithInteger:customer.Sex] forKey:@"Sex"];
    [dictAPI setObject:customer.strStoreId forKey:@"StoreId"];
    [dictAPI setObject:customer.strTitle forKey:@"Title"];
   
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Customer/AddCustomer"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)ModifyCustomer:(Customer *)customer Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    
    [dictAPI setObject:customer.strAddress forKey:@"Address"];
    [dictAPI setObject:customer.strBirthDate forKey:@"BirthDate"];
    [dictAPI setObject:[NSNumber numberWithInteger:customer.nBirthYear] forKey:@"BirthYear"];
    [dictAPI setObject:customer.strCareerId forKey:@"CareerId"];
    [dictAPI setObject:customer.strChildrenDesc forKey:@"ChildrenDesc"];
    NSString * strImage = @"";
    if (customer.imgCust) {
        strImage =  [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(customer.imgCust, 0.5)];
        if (strImage == nil) {
            strImage = @"";
        }
    }
    [dictAPI setObject:strImage forKey:@"CustImg"];
    [dictAPI setObject:customer.strCustomerId forKey:@"CustomerId"];
    [dictAPI setObject:customer.strEmail forKey:@"Email"];
    [dictAPI setObject:customer.strFirstName forKey:@"FirstName"];
    [dictAPI setObject:customer.strInterest forKey:@"Interest"];
    [dictAPI setObject:[NSNumber numberWithBool:customer.isVip] forKey:@"IsVip"];
    [dictAPI setObject:customer.strDistrict forKey:@"Location"];
    [dictAPI setObject:customer.strMemorialDaysDesc forKey:@"MemorialDaysDesc"];
    [dictAPI setObject:customer.strPhone1 forKey:@"Phone1"];
    [dictAPI setObject:customer.strPhone2 forKey:@"Phone2"];
    [dictAPI setObject:[NSNumber numberWithInteger:customer.Sex] forKey:@"Sex"];
    [dictAPI setObject:customer.strStoreId forKey:@"StoreId"];
    [dictAPI setObject:customer.strTitle forKey:@"Title"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Customer/UpdateCustomerInfo"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)LinkageBreakCustomer:(NSString *)strCustomerId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strCustomerId forKey:@"CustomerId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Customer/UnBindCustomer"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetCustomerPurchaseList:(NSString *)strCustomerId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strCustomerId forKey:@"CustomerId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Customer/GetPurchaseList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            CustomerPurchase * purchase = [[CustomerPurchase alloc] init];
            purchase.strProductName = [self ValidString:dict forKey:@"ProductName"];
            purchase.strPurchaseId = [self ValidString:dict forKey:@"PurchaseId"];
            purchase.strStoreId = [self ValidString:dict forKey:@"StoreId"];
            purchase.numProductAmount = [self ValidDoubleNumber:dict forKey:@"ProductAmount" defaultValue:0];
            purchase.numProductPrice = [self ValidDoubleNumber:dict forKey:@"ProductPrice" defaultValue:0];
            purchase.numProductQty = [self ValidNumber:dict forKey:@"ProductQty" defaultValue:0];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy-MM-dd"];
            purchase.strPurchaseDate = [self ValidString:dict forKey:@"PurchaseDate"];
            
            [array addObject:purchase];
        }
        SuccessBlock(array);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)DeleteCustomerPurchase:(NSString *)strCustomerId PurchaseId:(NSString *)strPurchaseId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strCustomerId forKey:@"CustomerId"];
    [dictAPI setObject:strPurchaseId forKey:@"PurchaseId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Customer/RemovePurchase"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)ModifyCustomerPurchase:(NSString *)strCustomerId Purchase:(CustomerPurchase *)purchase Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strCustomerId forKey:@"CustomerId"];
    
    [dictAPI setObject:purchase.strStoreId forKey:@"StoreId"];
    [dictAPI setObject:purchase.strProductName forKey:@"ProductName"];
    [dictAPI setObject:purchase.numProductAmount forKey:@"ProductAmount"];
    [dictAPI setObject:purchase.numProductPrice forKey:@"ProductPrice"];
    [dictAPI setObject:purchase.numProductQty forKey:@"ProductQty"];
    [dictAPI setObject:purchase.strPurchaseDate forKey:@"PurchaseDate"];
    [dictAPI setObject:purchase.strPurchaseId forKey:@"PurchaseId"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Customer/UpdatePurchase"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)AddCustomerPurchase:(NSString *)strCustomerId Purchase:(CustomerPurchase *)purchase Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strCustomerId forKey:@"CustomerId"];
    
    [dictAPI setObject:purchase.strStoreId forKey:@"StoreId"];
    [dictAPI setObject:purchase.strProductName forKey:@"ProductName"];
    [dictAPI setObject:purchase.numProductAmount forKey:@"ProductAmount"];
    [dictAPI setObject:purchase.numProductPrice forKey:@"ProductPrice"];
    [dictAPI setObject:purchase.numProductQty forKey:@"ProductQty"];
    [dictAPI setObject:purchase.strPurchaseDate forKey:@"PurchaseDate"];

    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Customer/AddPurchase"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

#pragma mark Documents

-(Document *)CreateDocumentByDict:(NSDictionary *)dict
{
    Document * doc = [[Document alloc] init];
    doc.strDocumentID = [self ValidString:dict forKey:@"DocId"];
    doc.strDocumentCode = [self ValidString:dict forKey:@"DocCode"];
    doc.strDocType = [self ValidString:dict forKey:@"DocType"];
    doc.strCreateTime = [self ValidString:dict forKey:@"CreateDate"];
    doc.strBrandName = [self ValidString:dict forKey:@"BrandName"];
    doc.strAuthor = [self ValidString:dict forKey:@"Author"];
    doc.strDomainNo = [self ValidString:dict forKey:@"DomainNo"];
    NSString * strFileName = [self ValidString:dict forKey:@"DocName"];
    NSInteger n = [strFileName rangeOfString:@"^"].location;
    if (n != NSNotFound)
    {
        doc.strFileName = [strFileName substringToIndex:n];
        doc.strDescEx = [strFileName substringFromIndex:n + 1];
    }
    else
    {
        doc.strFileName = strFileName;
        doc.strDescEx = @"";
    }
    
    doc.strDocumentURL = [self ValidString:dict forKey:@"DocUrl"];
    doc.strStoreName = [self ValidString:dict forKey:@"StoreName"];
    doc.isReceived = [self ValidNumber:dict forKey:@"IsReceived" defaultValue:NO].boolValue;
    doc.isSendBySelf = [self ValidNumber:dict forKey:@"IsSendBySelf" defaultValue:NO].boolValue;
    doc.rankAuthor = [self ValidNumber:dict forKey:@"Rank" defaultValue:NO].integerValue;
    doc.isNew = ![self ValidNumber:dict forKey:@"IsRead" defaultValue:NO].boolValue;
    doc.isEdit=[self ValidNumber:dict forKey:@"IsEdit" defaultValue:NO].boolValue;
    doc.isFinish=[self ValidNumber:dict forKey:@"IsFinish" defaultValue:NO].boolValue;
    doc.fileSize=((NSNumber *)[dict objectForKey:@"FileSize"]).floatValue;
    return doc;
}

-(void)GetDocumentList:(NSString *)strDocmentID GetDocType:(GetDocType)typeGet Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (!strDocmentID) {
        strDocmentID = @"";
    }
    NSMutableArray * arrayDoc = [[NSMutableArray alloc] init];
    switch (typeGet) {
        case GetDocType_All:
        case GetDocType_Sent:
        {
            RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
            [dictAPI setObject:strDocmentID forKey:@"DocId"];
            [dictAPI setObject:[NSNumber numberWithInteger:typeGet] forKey:@"DocType"];
            NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
            NSString * strUrl = @"Document/GetDocumentList";
            if (_bDemoMode) {
                strUrl = [NSString stringWithFormat:@"%@%d",strUrl,typeGet];
            }
            [RPNetModule doRequest:[self genURL:strUrl] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
                NSMutableArray * arrayRet = [[NSMutableArray alloc] init];
                for (NSDictionary * dictDoc in arrayResult) {
                    Document * doc = [self CreateDocumentByDict:dictDoc];
                    [arrayRet addObject:doc];
                }
                SuccessBlock(arrayRet);
            } failed:^(NSInteger nErrorCode, NSString *strDesc) {
                FailedBlock(nErrorCode,strDesc);
            }];
            
        }
            break;
        case GetDocType_UnSent:
        {
            for (CachData * data in _arrayCacheData) {
                Document * doc = [[Document alloc] init];
                doc.strAuthor = [NSString stringWithFormat:@"%@",_userLoginDetail.strFirstName];
                doc.rankAuthor = _userLoginDetail.rank;
                
                NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                doc.dataUnSent = data;
                switch (data.type) {
                    case CACHETYPE_INSPECTION:
                        doc.strDocType = @"INSPECTION";
                        break;
                    case CACHETYPE_MAINTEN:
                        doc.strDocType = @"MAINTENANCE";
                        break;
                    case CACHETYPE_RECTIFICITION:
                        doc.strDocType = @"RECTIFICITION";
                        break;
                    case CACHETYPE_VISITING:
                        doc.strDocType = @"VISIT";
                        break;
                    case CACHETYPE_BVISITING:
                        doc.strDocType = @"BVISIT";
                        break;
                    case CACHETYPE_ELEARNINGEXAM:
                        doc.strDocType = @"ELEARNING EXAM";
                        break;
                }
                [arrayDoc addObject:doc];
            }
        }
            SuccessBlock(arrayDoc);
            break;
        case GetDocType_UnFinished:
        {
            NSArray * arrayCache = [[RPBDataBase defaultInstance] GetAllTaskCacheData:_userLoginDetail.strUserId];
            for (TaskCachData * data in arrayCache) {
                Document * doc = [[Document alloc] init];
                
                doc.strAuthor = [NSString stringWithFormat:@"%@",_userLoginDetail.strFirstName];
                doc.rankAuthor = _userLoginDetail.rank;
                NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                doc.strCreateTime = [dateformatter stringFromDate:data.date];
                doc.strUnfinishStoreId = data.strKey;
                doc.strUnfinishDesc = data.strDesc;
                doc.UnfinishDocType = data.type;
                doc.strDocumentID = data.strID;
                
                switch (data.type) {
                    case CACHETYPE_INSPECTION:
                        doc.strDocType = @"INSPECTION";
                        break;
                    case CACHETYPE_MAINTEN:
                        doc.strDocType = @"MAINTENANCE";
                        break;
                    case CACHETYPE_RECTIFICITION:
                        doc.strDocType = @"RECTIFICITION";
                        break;
                    case CACHETYPE_VISITING:
                        doc.strDocType = @"VISIT";
                        break;
                    case CACHETYPE_BVISITING:
                     //   doc.strDocType = @"BVISIT";
                    {
                        BVisitData * data = [[RPSDK defaultInstance] GetTaskCacheDataById:doc.strDocumentID CacheType:CACHETYPE_BVISITING];
                        doc.strDocType = [NSString stringWithFormat:@"BVISIT %@",data.strTitle];
                    }
                        break;
                    case CACHETYPE_ELEARNINGEXAM:
                        doc.strDocType = @"ELEARNING EXAM";
                        break;
                }
                [arrayDoc addObject:doc];
            }
        }
            SuccessBlock(arrayDoc);
            break;
        default:
            break;
    }
}

-(NSArray *)GetUnfinishedDoc:(CacheType)type
{
    NSMutableArray * arrayDoc = [[NSMutableArray alloc] init];
    NSArray * arrayCache = [[RPBDataBase defaultInstance] GetAllTaskCacheData:_userLoginDetail.strUserId];
    for (TaskCachData * data in arrayCache) {
        if (data.type == type) {
            Document * doc = [[Document alloc] init];
            
            doc.strAuthor = [NSString stringWithFormat:@"%@",_userLoginDetail.strFirstName];
            doc.rankAuthor = _userLoginDetail.rank;
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            doc.strCreateTime = [dateformatter stringFromDate:data.date];
            doc.strUnfinishStoreId = data.strKey;
            doc.strUnfinishDesc = data.strDesc;
            doc.UnfinishDocType = data.type;
            doc.strDocumentID = data.strID;
            
            switch (data.type) {
                case CACHETYPE_INSPECTION:
                    doc.strDocType = @"INSPECTION";
                    break;
                case CACHETYPE_MAINTEN:
                    doc.strDocType = @"MAINTENANCE";
                    break;
                case CACHETYPE_RECTIFICITION:
                    doc.strDocType = @"RECTIFICITION";
                    break;
                case CACHETYPE_VISITING:
                    doc.strDocType = @"VISIT";
                    break;
                case CACHETYPE_BVISITING:
                    //   doc.strDocType = @"BVISIT";
                {
                    BVisitData * data = [[RPSDK defaultInstance] GetTaskCacheDataById:doc.strDocumentID CacheType:CACHETYPE_BVISITING];
                    doc.strDocType = [NSString stringWithFormat:@"BVISIT %@",data.strTitle];
                }
                    break;
                case CACHETYPE_ELEARNINGEXAM:
                    doc.strDocType = @"ELEARNING EXAM";
                    break;
            }
            [arrayDoc addObject:doc];
        }
    }
    return arrayDoc;
}

-(void)HaveLatestDocument:(NSString *)strDocmentID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        FailedBlock(RPSDKError_Unknown,@"");
        return;
    }
    
    if (!strDocmentID) {
        strDocmentID = @"";
    }
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strDocmentID forKey:@"DocId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Document/HaveLatestDocument"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)ForwardDocument:(NSString *)strDocmentID RecvUserList:(NSArray *)arrayUser RecvMailList:(NSArray *)arrayEmail Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strDocmentID forKey:@"DocId"];
    
    NSMutableArray * arrayUserSent = [[NSMutableArray alloc] init];
    for (NSString * strUser in arrayUser) {
        NSDictionary * dict = [NSDictionary dictionaryWithObject:strUser forKey:@"UserId"];
        [arrayUserSent addObject:dict];
    }
    [dictAPI setObject:arrayUserSent forKey:@"RecvUsers"];
    
    NSMutableArray * arrayEmailSent = [[NSMutableArray alloc] init];
    for (NSString * strEmail in arrayEmail) {
        NSDictionary * dict = [NSDictionary dictionaryWithObject:strEmail forKey:@"Email"];
        [arrayEmailSent addObject:dict];
    }
    [dictAPI setObject:arrayEmailSent forKey:@"RecvEmails"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Document/ForwardDocument"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)DeleteDocument:(NSString *)strDocmentID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strDocmentID forKey:@"DocId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Document/DeleteDocument"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)SetDocumentRead:(NSString *)strDocmentID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strDocmentID forKey:@"DocId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Document/UpdateDocStatus"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

#pragma mark Reports
-(void)GetReports:(NSString *)strReportID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        FailedBlock(RPSDKError_Unknown,@"");
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strReportID forKey:@"msgid"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Message/GetMessage"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dictResult in  arrayResult) {
            MCReport * report = [[MCReport alloc] init];
            report.strReportID = [self ValidString:dictResult forKey:@"MegId"];
            report.strReportName = [self ValidString:dictResult forKey:@"DocName"];
            report.strReportType = [self ValidString:dictResult forKey:@"DocType"];
            report.strReportUrl = [self ValidString:dictResult forKey:@"DocUrl"];
            report.dateReport = [self ValidDate:dictResult forKey:@"DeliveryDate"];
            
            NSDictionary * dictSender = [dictResult objectForKey:@"DeliveryBy"];
            report.strSenderID = [self ValidString:dictSender forKey:@"UserId"];
            report.strSenderName = [self ValidString:dictSender forKey:@"UserName"];
            report.rank = [self ValidNumber:dictSender forKey:@"RoleLevel" defaultValue:Rank_Assistant].integerValue;
            report.strImgPic = [self ValidString:dictSender forKey:@"UserImg"];
            
            [array addObject:report];
        }
        SuccessBlock(array);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

#pragma mark Infomation Center
-(void)GetICUnreadCountSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Message/GetICUnreadCount"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dictResult in  arrayResult) {
            ICUnread * unRead = [[ICUnread alloc] init];
            unRead.type = ((NSNumber *)[dictResult objectForKey:@"ICType"]).integerValue;
            unRead.nCount = ((NSNumber *)[dictResult objectForKey:@"Count"]).integerValue;
            [array addObject:unRead];
        }
        SuccessBlock(array);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetICList:(NSString *)strLastID Type:(ICType)type GetNew:(BOOL)bGetNew GetCount:(NSInteger)nCount Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        if (strLastID != nil && strLastID.length > 0)
        {
            FailedBlock(RPSDKError_Unknown,@"");
            return;
        }
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strLastID forKey:@"LastID"];
    [dictAPI setObject:[NSNumber numberWithBool:bGetNew] forKey:@"GetNew"];
    [dictAPI setObject:[NSNumber numberWithInteger:nCount] forKey:@"Count"];
    [dictAPI setObject:[NSNumber numberWithInteger:type] forKey:@"ICType"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    NSString * strUrl = @"Message/GetICList";
    if(_bDemoMode)
       strUrl = [NSString stringWithFormat:@"%@%d",strUrl,type];
    
    [RPNetModule doRequest:[self genURL:strUrl] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for(NSDictionary * dict in arrayResult)
        {
            ICDetailInfo * info = [[ICDetailInfo alloc] init];
            info.strID = [self ValidString:dict forKey:@"Id"];
            info.strParam = [self ValidString:dict forKey:@"DataParam"];
            info.strSubject = [self ValidString:dict forKey:@"Subject"];
            info.format = [self ValidNumber:dict forKey:@"MsgType" defaultValue:ICMsgFormat_Text].integerValue;
            info.typeMsg = [self ValidNumber:dict forKey:@"ICType" defaultValue:ICMsgType_SystemNotify].integerValue;
            info.userPost = [self CreateUserDetailByDict:[dict objectForKey:@"UserDetail"]];
            info.dtTime = [self ValidDate:dict forKey:@"AddTime"];
            info.strFileSize = [self ValidString:dict forKey:@"FileSize"];
            [array addObject:info];
        }
        SuccessBlock(array);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)PostBroadCastInfo:(NSString *)strInfo Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        FailedBlock(RPSDKError_Unknown,@"");
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strInfo forKey:@"Msg"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Message/PostBroadCastInfo"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)PostMessage:(ICMsgFormat)format Content:(id)idSentContent RecvUser:(NSString *)strUserId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    if (strUserId)
        [dictAPI setObject:strUserId forKey:@"recvUser"];
    else
        [dictAPI setObject:@"" forKey:@"recvUser"];
    
    [dictAPI setObject:[NSNumber numberWithInteger:format] forKey:@"MsgFormat"];
    
    switch (format) {
        case ICMsgFormat_Text:
            [dictAPI setObject:(NSString *)idSentContent forKey:@"Msg"];
            break;
        case ICMsgFormat_Picture:
        {
            UIImage * img = (UIImage *)idSentContent;
            [dictAPI setObject:[GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(img, 0.5)] forKey:@"Msg"];
        }
            break;
        case ICMsgFormat_Voice:
            [dictAPI setObject:[GTMBase64 stringByEncodingData:(NSData *)idSentContent] forKey:@"Msg"];
            break;
        default:
            break;
    }
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Message/PostMsg"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

#pragma mark Message


#pragma mark Task
-(TaskInfo*)CreateTaskByDict:(NSDictionary *)dict
{
    TaskInfo *task=[[TaskInfo alloc]init];
    task.strCode=[self ValidString:dict forKey:@"TaskNo"];
    task.strTaskId=[self ValidString:dict forKey:@"TaskInfoId"];
    UserDetailInfo *deliveryUser=[[UserDetailInfo alloc]init];
    deliveryUser.strFirstName=[self ValidString:dict forKey:@"DeliveryUser"];
    deliveryUser.rank=[self ValidNumber:dict forKey:@"DeliveryUserRank" defaultValue:Rank_Assistant].integerValue;
    deliveryUser.strPortraitImg = [self ValidString:dict forKey:@"DeliveryUserImg"];
    deliveryUser.strRoleName = [self ValidString:dict forKey:@"DeliveryUserTitle"];
    deliveryUser.strUserId = [self ValidString:dict forKey:@"DeliveryUserId"];
    task.userInitiator=deliveryUser;
    
    UserDetailInfo *receiveUser=[[UserDetailInfo alloc]init];
    receiveUser.strFirstName=[self ValidString:dict forKey:@"ReceiveUser"];
    receiveUser.rank=[self ValidNumber:dict forKey:@"ReceiveUserRank" defaultValue:Rank_Assistant].integerValue;
    receiveUser.strPortraitImg = [self ValidString:dict forKey:@"ReceiveUserImg"];
    receiveUser.strRoleName = [self ValidString:dict forKey:@"ReceiveUserTitle"];
    receiveUser.strUserId = [self ValidString:dict forKey:@"ReceiveUserId"];
    task.userExecutor=receiveUser;
    
    task.state=[self ValidNumber:dict forKey:@"TaskStatus" defaultValue:0].integerValue;
    task.strTitle=[self ValidString:dict forKey:@"Title"];
    task.typeTask=[self ValidNumber:dict forKey:@"TaskType" defaultValue:TASK_BVisit].integerValue;
    task.strDesc=[self ValidString:dict forKey:@"Desc"];
    task.bAllDay = [self ValidNumber:dict forKey:@"IsAllDay" defaultValue:NO].boolValue;
    task.isNew = [self ValidNumber:dict forKey:@"IsNew" defaultValue:NO].boolValue;
    
    task.strOther = [self ValidString:dict forKey:@"DataSourceId"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    task.dateEnd = [formatter dateFromString:[self ValidString:dict forKey:@"Deadline"]];
    task.dateCreate = [formatter dateFromString:[self ValidString:dict forKey:@"CreateDate"]];
    NSString * strFinishDate = [self ValidString:dict forKey:@"FinishDate"];
    if (strFinishDate.length > 0) {
        task.dateFinish = [formatter dateFromString:strFinishDate];
    }
    
    task.typeColor=[self ValidNumber:dict forKey:@"Color" defaultValue:0].integerValue;
    return task;
}

-(void)AddTask:(NSMutableArray *)arrayTask Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableArray * arrayDic = [[NSMutableArray alloc] init];
    for (TaskInfo *task in arrayTask)
    {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:task.strOther forKey:@"DataSourceId"];
        [dict setObject:task.userInitiator.strUserId forKey:@"DeliveryId"];
        [dict setObject:task.userExecutor.strUserId forKey:@"ReceiveId"];
        [dict setObject:[NSNumber numberWithInteger:task.typeTask] forKey:@"TaskType"];
        [dict setObject:[NSNumber numberWithInteger:task.state] forKey:@"TaskStatus"];
        [dict setObject:task.strTitle forKey:@"Title"];
        [dict setObject:task.strDesc forKey:@"Desc"];
        [dict setObject:[NSNumber numberWithInteger:task.typeColor] forKey:@"Color"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString * strDate = [formatter stringFromDate:task.dateEnd];
        [dict setObject:strDate forKey:@"Deadline"];
        
        [dict setObject:[NSNumber numberWithBool:task.bAllDay] forKey:@"IsAllDay"];
        [arrayDic addObject:dict];
    }
    [dictAPI setObject:arrayDic forKey:@"TaskInfoData"];
    NSMutableDictionary * dict = [self genBodyDataDict:arrayDic  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"task/AddTaskInfo"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetTaskList:(NSString *)strSearch IsFinished:(BOOL)bFinished IsInitiator:(BOOL)bInitiator IsExecutor:(BOOL)bExecutor Color:(ColorType)color TaskType:(TaskType)type Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:[NSNumber numberWithBool:bFinished] forKey:@"IsFinish"];
    if (color >= 0) {
         [dictAPI setObject:[NSNumber numberWithInteger:color] forKey:@"Color"];
    }
   
    [dictAPI setObject:[NSNumber numberWithInteger:type] forKey:@"Type"];
    if (!(bExecutor && bInitiator))
    {
        if (bExecutor || bInitiator) {
            if (bInitiator)
                [dictAPI setObject:[NSNumber numberWithInteger:1] forKey:@"TaskUser"];
            else
                [dictAPI setObject:[NSNumber numberWithInteger:2] forKey:@"TaskUser"];
        }
    }
    
    if (!bExecutor && !bInitiator) {
        [SVProgressHUD dismiss];
        FailedBlock(-1,@"param error");
        return;
    }
    
    if (strSearch && strSearch.length > 0) {
        [dictAPI setObject:strSearch forKey:@"KeyWords"];
    }
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"task/GetTaskList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayRet) {
        for(NSDictionary * dict in arrayRet)
        {
            TaskInfo * task = [self CreateTaskByDict:dict];
            [array addObject:task];
        }
        SuccessBlock(array);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}
-(void)ForwardTask:(NSString *)strTaskId Executor:(NSString *)executorId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strTaskId forKey:@"TaskId"];
    [dictAPI setObject:executorId forKey:@"ReceiveId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"task/AssignTask"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)deleteTask:(NSString *)strTaskId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strTaskId forKey:@"TaskId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"task/DeleteTask"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)finishTask:(NSString *)strTaskId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strTaskId forKey:@"TaskId"];
    [dictAPI setObject:[NSNumber numberWithInteger:TASKSTATE_finished] forKey:@"TaskStatus"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"task/UpdateTaskStatus"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}


-(void)EditTask:(TaskInfo *)task Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:task.strTaskId forKey:@"TaskInfoId"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString * strDate = [formatter stringFromDate:task.dateEnd];
    [dictAPI setObject:strDate forKey:@"Deadline"];
    
    [dictAPI setObject:[NSNumber numberWithBool:task.bAllDay] forKey:@"IsAllDay"];
    [dictAPI setObject:[NSNumber numberWithInteger:task.typeColor] forKey:@"Color"];
    [dictAPI setObject:task.strTitle forKey:@"Title"];
    [dictAPI setObject:task.strDesc forKey:@"Desc"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"task/EditTask"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)HasNewTaskSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
//    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"HasFinishedTask"];
//    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"HasUnderwayTask"];
//    SuccessBlock(dict);
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"task/GetNewTaskFlag"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        SuccessBlock(dictResult);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)SetTaskRead:(TaskInfo *)info Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:info.strTaskId forKey:@"TaskId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"task/SetTaskRead"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        info.isNew = NO;
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

#pragma mark ----------
#pragma mark Business Submit Data
-(NSDictionary *)GenInspData:(NSString *)strStoreID Data:(InspData *)data
{
    NSMutableDictionary * dictBody = [[NSMutableDictionary alloc] init];
    [dictBody setObject:strStoreID forKey:@"StoreId"];
    
    if (!data.strDesc) data.strDesc = @"";
    [dictBody setObject:data.strDesc forKey:@"Overall"];
    [dictBody setObject:[NSNumber numberWithInteger:data.mark] forKey:@"TotalScore"];
    
    NSMutableArray * arrayEmail = [[NSMutableArray alloc] init];
    NSMutableArray * arrayColleague = [[NSMutableArray alloc] init];
    
    for (InspReporterSection * section in data.reporters.arraySection) {
        for (InspReporterUser * user in section.arrayUser) {
            if (user.bSelected) {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                if (user.bUserCollegue)
                {
                    [dict setObject:user.collegue.strUserId forKey:@"UserId"];
                    [dict setObject:@"" forKey:@"DataId"];
                    [arrayColleague addObject:dict];
                    
                    if (user.collegue.strWorkEmail.length > 0) {
                        NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] init];
                        [dict2 setObject:user.collegue.strWorkEmail forKey:@"Email"];
                        [dict2 setObject:@"" forKey:@"DataId"];
                        [arrayEmail addObject:dict2];
                    }
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
    for (InspVendor * vendor in data.arrayInsp)
    {
        for (InspCatagory * catagory in vendor.arrayCatagory) {
            NSMutableDictionary * dictCatagory = [[NSMutableDictionary alloc] init];
            [dictCatagory setObject:catagory.strCatagoryID forKey:@"ItemId"];
            [dictCatagory setObject:[NSNumber numberWithInteger:catagory.markCatagory] forKey:@"Score"];
            
            NSMutableArray * arrayIssues = [[NSMutableArray alloc] init];
            for (InspIssue * issue in catagory.arrayIssue) {
                NSMutableDictionary * dictIssue = [[NSMutableDictionary alloc] init];
                [dictIssue setObject:issue.strIssueDesc forKey:@"IssueDesc"];
                [dictIssue setObject:@"" forKey:@"IssueGid"];
                [dictIssue setObject:issue.strIssueTitle forKey:@"Title"];
                [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.x] forKey:@"X"];
                [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.y] forKey:@"Y"];
                
                NSMutableArray * arrayImage = [[NSMutableArray alloc] init];
                for (InspIssueImage * image in issue.arrayIssueImg) {
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

-(NSDictionary *)GenRectificationData:(NSString *)strStoreID Data:(InspData *)data
{
    NSMutableDictionary * dictBody = [[NSMutableDictionary alloc] init];
    [dictBody setObject:strStoreID forKey:@"storeId"];
    
    NSMutableArray * arrayEmail = [[NSMutableArray alloc] init];
    NSMutableArray * arrayColleague = [[NSMutableArray alloc] init];
    
    for (InspReporterSection * section in data.reporters.arraySection) {
        for (InspReporterUser * user in section.arrayUser) {
            if (user.bSelected) {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                if (user.bUserCollegue)
                {
                    [dict setObject:user.collegue.strUserId forKey:@"UserId"];
                    if (section.strVendorID) {
                        [dict setObject:section.strVendorID forKey:@"DataId"];
                    }
                    [arrayColleague addObject:dict];
                    
                    if (user.collegue.strWorkEmail.length > 0) {
                        NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] init];
                        [dict2 setObject:user.collegue.strWorkEmail forKey:@"Email"];
                        if (section.strVendorID) {
                            [dict2 setObject:section.strVendorID forKey:@"DataId"];
                        }
                        [arrayEmail addObject:dict2];
                    }
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
    for (InspVendor * vendor in data.arrayInsp)
    {
        for (InspCatagory * catagory in vendor.arrayCatagory) {
            NSMutableDictionary * dictCatagory = [[NSMutableDictionary alloc] init];
            [dictCatagory setObject:catagory.strCatagoryID forKey:@"ItemId"];
            [dictCatagory setObject:[NSNumber numberWithInteger:catagory.markCatagory] forKey:@"Score"];
            
            NSMutableArray * arrayIssues = [[NSMutableArray alloc] init];
            for (InspIssue * issue in catagory.arrayIssue) {
                NSMutableDictionary * dictIssue = [[NSMutableDictionary alloc] init];
                [dictIssue setObject:issue.strIssueDesc forKey:@"IssueDesc"];
                [dictIssue setObject:@"" forKey:@"IssueGid"];
                [dictIssue setObject:issue.strIssueTitle forKey:@"Title"];
                
                [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.x] forKey:@"X"];
                [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.y] forKey:@"Y"];
                
                NSMutableArray * arrayImage = [[NSMutableArray alloc] init];
                for (InspIssueImage * image in issue.arrayIssueImg) {
                    if (image.imgIssue == nil && image.strUrl.length > 0) {
                        image.imgIssue = [RPSDK loadImageFromURL:image.strUrl];
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

-(NSDictionary *)GenVisitData:(NSString *)strStoreID Data:(CVisitData *)data
{
    NSMutableDictionary * dictBody = [[NSMutableDictionary alloc] init];
    [dictBody setObject:strStoreID forKey:@"StoreId"];
    
    if (!data.strDesc) data.strDesc = @"";
    [dictBody setObject:data.strDesc forKey:@"Overall"];
    [dictBody setObject:[NSNumber numberWithInteger:data.mark] forKey:@"Score"];
    
    NSMutableArray * arrayEmail = [[NSMutableArray alloc] init];
    NSMutableArray * arrayColleague = [[NSMutableArray alloc] init];
    
    if (data.reporters != nil) {
        for (InspReporterSection * section in data.reporters.arraySection) {
            for (InspReporterUser * user in section.arrayUser) {
                if (user.bSelected) {
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                    if (user.bUserCollegue)
                    {
                        [dict setObject:user.collegue.strUserId forKey:@"UserId"];
                        [dict setObject:@"" forKey:@"DataId"];
                        [arrayColleague addObject:dict];
                        
                        if (user.collegue.strWorkEmail.length > 0) {
                            NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] init];
                            [dict2 setObject:user.collegue.strWorkEmail forKey:@"Email"];
                            [dict2 setObject:@"" forKey:@"DataId"];
                            [arrayEmail addObject:dict2];
                        }
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
    for (InspIssue * issue in data.arrayIssue) {
        NSMutableDictionary * dictIssue = [[NSMutableDictionary alloc] init];
        [dictIssue setObject:issue.strIssueDesc forKey:@"Desc"];
        [dictIssue setObject:@"" forKey:@"IssueId"];
        [dictIssue setObject:issue.strIssueTitle forKey:@"Title"];
        [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.x] forKey:@"X"];
        [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.y] forKey:@"Y"];
        
        
        NSMutableArray * arrayImage = [[NSMutableArray alloc] init];
        for (InspIssueImage * image in issue.arrayIssueImg) {
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

-(NSDictionary *)GenMaintenData:(NSString *)strStoreID Data:(MaintenanceData *)data Reporter:(InspReporters *)reports
{
    NSMutableDictionary * dictBody = [[NSMutableDictionary alloc] init];
    [dictBody setObject:strStoreID forKey:@"StoreId"];
    
    NSMutableArray * arrayEmail = [[NSMutableArray alloc] init];
    NSMutableArray * arrayColleague = [[NSMutableArray alloc] init];
    
    if (reports != nil) {
        for (InspReporterSection * section in reports.arraySection) {
            for (InspReporterUser * user in section.arrayUser) {
                if (user.bSelected) {
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                    if (user.bUserCollegue)
                    {
                        [dict setObject:user.collegue.strUserId forKey:@"UserId"];
                        if (section.strVendorID) {
                            [dict setObject:section.strVendorID forKey:@"DataId"];
                        }
                        [arrayColleague addObject:dict];
                        
                        if (user.collegue.strWorkEmail.length > 0) {
                            NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] init];
                            [dict2 setObject:user.collegue.strWorkEmail forKey:@"Email"];
                            if (section.strVendorID) {
                                [dict2 setObject:section.strVendorID forKey:@"DataId"];
                            }
                            [arrayEmail addObject:dict2];
                        }
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
        MaintenContact * contact = [data.arrayContacts objectAtIndex:0];
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
    for (InspIssue * issue in data.arrayIssue) {
        NSMutableDictionary * dictIssue = [[NSMutableDictionary alloc] init];
        [dictIssue setObject:issue.strIssueDesc forKey:@"Desc"];
        [dictIssue setObject:issue.strIssueTitle forKey:@"Title"];
        [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.x] forKey:@"X"];
        [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.y] forKey:@"Y"];
        [dictIssue setObject:issue.strVendorID forKey:@"Category"];
        
        NSMutableArray * arrayImage = [[NSMutableArray alloc] init];
        for (InspIssueImage * image in issue.arrayIssueImg) {
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


#pragma mark Business Local Cache
-(id)GetTaskCacheDataById:(NSString *)strCacheDataId CacheType:(CacheType)type
{
    TaskCachData * data = [[RPBDataBase defaultInstance] GetTaskCacheData:_userLoginDetail.strUserId ByCacheDataId:strCacheDataId CacheType:type];
    return [self GenTaskCacheData:data CacheType:type];
}

-(id)GetTaskCacheData:(NSString *)strKey CacheType:(CacheType)type
{
    TaskCachData * data = [[RPBDataBase defaultInstance] GetTaskCacheData:_userLoginDetail.strUserId Key:strKey CacheType:type];
    return [self GenTaskCacheData:data CacheType:type];
}

-(id)GenTaskCacheData:(TaskCachData *)data CacheType:(CacheType)type
{
    if (data.strData) {
        NSError * error;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[data.strData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (jsonDic) {
            switch (type) {
                case CACHETYPE_INSPECTION:
                {
                    InspData * data = [[InspData alloc] init];
                    
                    NSMutableArray * arrayCatagory = [[NSMutableArray alloc] init];
                    NSDictionary * dictInsp = [jsonDic objectForKey:@"Inspdata"];
                    data.mark =  ((NSNumber *)[jsonDic objectForKey:@"TotalScore"]).integerValue;
                    data.strDesc =  [jsonDic objectForKey:@"Overall"];
                    
                    if (dictInsp) {
                        NSMutableArray * arrayIssueData = [dictInsp objectForKey:@"IssuesData"];
                        for (NSDictionary * dict in arrayIssueData) {
                            InspCatagory * catagory = [[InspCatagory alloc] init];
                            catagory.markCatagory = ((NSNumber *)[dict objectForKey:@"Score"]).integerValue;
                            catagory.strCatagoryID = [dict objectForKey:@"ItemId"];
                            catagory.arrayIssue = [[NSMutableArray alloc] init];
                            NSArray * array = [dict objectForKey:@"Issues"];
                            
                            for (NSDictionary * dictIssue in array) {
                                InspIssue * issue = [[InspIssue alloc] init];
                                issue.strIssueDesc = [dictIssue objectForKey:@"IssueDesc"];
                                issue.strIssueTitle = [dictIssue objectForKey:@"Title"];
                                NSInteger nX = ((NSNumber *)[dictIssue objectForKey:@"X"]).integerValue;
                                NSInteger nY = ((NSNumber *)[dictIssue objectForKey:@"Y"]).integerValue;
                                issue.ptLocation = CGPointMake(nX, nY);
                                issue.bHasLocation = YES;
                                
                                issue.arrayIssueImg = [NSMutableArray arrayWithArray:@[[[InspIssueImage alloc] init],[[InspIssueImage alloc] init], [[InspIssueImage alloc] init]]];
                                
                                NSInteger nImageIndex = 0;
                                for (NSDictionary * dictImage in (NSArray *)[dictIssue objectForKey:@"IssueImgs"])
                                {
                                    InspIssueImage * image = [[InspIssueImage alloc] init];
                                    
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
                    data.arrayInsp = arrayCatagory;
                    
                    return data;
                }
                    break;
                case CACHETYPE_MAINTEN:
                {
                    MaintenanceData * dataMainten = [[MaintenanceData alloc] init];
                    dataMainten.arrayIssue = [[NSMutableArray alloc] init];
                    
                    NSArray * array = [jsonDic objectForKey:@"InspIssues"];
                    for (NSDictionary * dictIssue in array) {
                        InspIssue * issue = [[InspIssue alloc] init];
                        issue.strVendorID = [dictIssue objectForKey:@"Category"];
                        issue.strIssueDesc = [dictIssue objectForKey:@"Desc"];
                        issue.strIssueTitle = [dictIssue objectForKey:@"Title"];
                        NSInteger nX = ((NSNumber *)[dictIssue objectForKey:@"X"]).integerValue;
                        NSInteger nY = ((NSNumber *)[dictIssue objectForKey:@"Y"]).integerValue;
                        issue.ptLocation = CGPointMake(nX, nY);
                        issue.bHasLocation = YES;
                        
                        issue.arrayIssueImg = [NSMutableArray arrayWithArray:@[[[InspIssueImage alloc] init],[[InspIssueImage alloc] init], [[InspIssueImage alloc] init]]];
                        NSInteger nImageIndex = 0;
                        
                        for (NSDictionary * dictImage in (NSArray *)[dictIssue objectForKey:@"IssueImgs"])
                        {
                            InspIssueImage * image = [[InspIssueImage alloc] init];
                            
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
                    CVisitData * dataVisit = [[CVisitData alloc] init];
                    dataVisit.arrayIssue = [[NSMutableArray alloc] init];
                    dataVisit.strDesc = [jsonDic objectForKey:@"Overall"];
                    dataVisit.mark = ((NSNumber *)[jsonDic objectForKey:@"Score"]).integerValue;
                    
                    NSArray * array = [jsonDic objectForKey:@"InspIssues"];
                    for (NSDictionary * dictIssue in array) {
                        InspIssue * issue = [[InspIssue alloc] init];
                        issue.strVendorID = [dictIssue objectForKey:@"Category"];
                        issue.strIssueDesc = [dictIssue objectForKey:@"Desc"];
                        issue.strIssueTitle = [dictIssue objectForKey:@"Title"];
                        NSInteger nX = ((NSNumber *)[dictIssue objectForKey:@"X"]).integerValue;
                        NSInteger nY = ((NSNumber *)[dictIssue objectForKey:@"Y"]).integerValue;
                        issue.ptLocation = CGPointMake(nX, nY);
                        issue.bHasLocation = YES;
                        
                        issue.arrayIssueImg = [NSMutableArray arrayWithArray:@[[[InspIssueImage alloc] init],[[InspIssueImage alloc] init], [[InspIssueImage alloc] init]]];
                        NSInteger nImageIndex = 0;
                        
                        for (NSDictionary * dictImage in (NSArray *)[dictIssue objectForKey:@"IssueImgs"])
                        {
                            InspIssueImage * image = [[InspIssueImage alloc] init];
                            
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
                case CACHETYPE_BVISITING:
                {
                    BVisitData * dataBVisit = [[BVisitData alloc] init];
                    dataBVisit.strComment = [jsonDic objectForKey:@"Overall"];
                    dataBVisit.strTitle = [jsonDic objectForKey:@"Title"];
                    dataBVisit.strTemplateId = [jsonDic objectForKey:@"TemplateId"];
                    dataBVisit.strTemplateName = [jsonDic objectForKey:@"TemplateName"];
                    dataBVisit.strTemplateDesc = [jsonDic objectForKey:@"TemplateDesc"];
                    dataBVisit.strCategoryTag = [jsonDic objectForKey:@"CategoryTag"];
                    dataBVisit.strSourceReportId = [jsonDic objectForKey:@"SourceReportId"];
                    NSNumber * num = ((NSNumber *)[jsonDic objectForKey:@"Status"]);
                    if (num && (id)num != [NSNull null]) {
                        dataBVisit.nStatus =  num.integerValue;
                    }
                    
                    
                    dataBVisit.arrayCatagory = [[NSMutableArray alloc] init];
                    
                    NSDictionary * dictVisit = [jsonDic objectForKey:@"BVisitData"];
                    if (dictVisit) {
                        NSMutableArray * arrayIssueData = [dictVisit objectForKey:@"IssuesData"];
                        for (NSDictionary * dictItem in arrayIssueData) {
                            NSString * strCategoryName = [dictItem objectForKey:@"CategoryName"];
                            BVisitCategory * categoryAdd = nil;
                            for (BVisitCategory * category in dataBVisit.arrayCatagory) {
                                if ([category.strCategoryName isEqualToString:strCategoryName]) {
                                    categoryAdd = category;
                                    break;
                                }
                            }
                            if (categoryAdd == nil) {
                                categoryAdd = [[BVisitCategory alloc] init];
                                categoryAdd.strCategoryName = strCategoryName;
                                categoryAdd.arrayItem = [[NSMutableArray alloc] init];
                                [dataBVisit.arrayCatagory addObject:categoryAdd];
                            }
                            
                            BVisitItem * item = [[BVisitItem alloc] init];
                            item.strItemId = [dictItem objectForKey:@"ItemId"];
                            item.strItemTitle = [dictItem objectForKey:@"ItemTitle"];
                            item.strItemDesc = [dictItem objectForKey:@"ItemDesc"];
                            item.fWeight = ((NSNumber *)[dictItem objectForKey:@"Weight"]).floatValue;
                            item.mark = ((NSNumber *)[dictItem objectForKey:@"Score"]).integerValue;
                            item.arrayIssue = [[NSMutableArray alloc] init];
                            [categoryAdd.arrayItem addObject:item];
                            
                            NSArray * issues = [dictItem objectForKey:@"Issues"];
                            for (NSDictionary * dictIssue in issues){
                                InspIssue * issue = [[InspIssue alloc] init];
                                issue.strIssueDesc =[self ValidString:dictIssue forKey:@"IssueDesc"];
                                issue.strIssueID = [self ValidString:dictIssue forKey:@"IssueGid"];
                                issue.strIssueTitle = [self ValidString:dictIssue forKey:@"Title"];
                                issue.arrayIssueImg = [[NSMutableArray alloc] init];
                                
                                NSInteger nX = [self ValidNumber:dictIssue forKey:@"X" defaultValue:-1].integerValue;
                                NSInteger nY = [self ValidNumber:dictIssue forKey:@"Y" defaultValue:-1].integerValue;
                                
                                issue.strMapId = [self ValidString:dictIssue forKey:@"BlueprintId"];
                                
                                if (issue.strMapId.length > 0 && nX >= 0 && nY >= 0) {
                                    issue.bHasLocation = YES;
                                    issue.ptLocation = CGPointMake(nX, nY);
                                }
                                
                                issue.arrayIssueImg = [NSMutableArray arrayWithArray:@[[[InspIssueImage alloc] init],[[InspIssueImage alloc] init], [[InspIssueImage alloc] init]]];
                                NSInteger nImageIndex = 0;
                                
                                for (NSDictionary * dictImage in (NSArray *)[dictIssue objectForKey:@"IssueImgs"])
                                {
                                    InspIssueImage * image = [[InspIssueImage alloc] init];
                                    
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
                                
                                [item.arrayIssue addObject:issue];
                            }
                        }
                    }
                    return dataBVisit;
                }
                    break;
                default:
                    break;
            }
        }
    }
    return nil;
}

-(void)SubmitCacheData:(CachData *)data Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    NSString * strApi = nil;
    
    switch (data.type) {
        case CACHETYPE_INSPECTION:
            strApi = [self genURL:@"Inspection/UploadInspection"];
            break;
        case CACHETYPE_RECTIFICITION:
            strApi = [self genURL:@"Rectification/UploadRectification"];
            break;
        case CACHETYPE_VISITING:
            strApi = [self genURL:@"StoreVisit/UploadStoreVisit"];
            break;
        case CACHETYPE_MAINTEN:
            strApi = [self genURL:@"Maintenance/UploadStoreMnt"];
            break;
        case CACHETYPE_BVISITING:
            strApi = [self genURL:@"BoutiqueVisit/SubmitBVisit"];
            break;
        case CACHETYPE_ELEARNINGEXAM:
            strApi = [self genURL:@"ELearning/UploadExam"];
            break;
    }
    
    NSError * error;
    NSData *JSONData = [data.strData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dictBody = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&error];
    
    NSMutableDictionary * dict = nil;
    if (data.type != CACHETYPE_ELEARNINGEXAM) {
        dict = [self genBodyDataDict:dictBody withToken:YES];
    }
    else
    {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        [array addObject:dictBody];
        dict = [self genBodyDataDict:array withToken:YES];
    }
    
    [RPNetModule doRequest:strApi isCheckWifi:NO withData:dict success:^(id idResult) {
        [_arrayCacheData removeObject:data];
        [[RPBDataBase defaultInstance] SetCacheDataSubmitted:data.strID];
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(BOOL)SaveUploadCache:(NSDictionary *)dictBody Type:(CacheType)type Desc:(NSString *)strDesc
{
    return [[RPBDataBase defaultInstance] SaveUploadCache:_userLoginDetail.strUserId CacheType:type Data:dictBody Date:[RPNetModule genTimeStamp] Desc:strDesc ToArray:_arrayCacheData];
}

-(void)ClearUploadCache:(NSString *)strId
{
    [[RPBDataBase defaultInstance] SetCacheDataSubmitted:strId];
    _arrayCacheData = [[RPBDataBase defaultInstance] GetCacheDataArray:_userLoginDetail.strUserId];
}

-(void)ClearCacheData:(NSString *)strStoreID CacheType:(CacheType)type
{
    [[RPBDataBase defaultInstance] ClearTaskCacheData:self.userLoginDetail.strUserId Key:strStoreID CacheType:type];
}

-(void)ClearCacheDataById:(NSString *)strId
{
    [[RPBDataBase defaultInstance] ClearCacheDataById:strId];
}

-(void)SaveInspCacheData:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(InspData *)data isNormalExit:(BOOL)bNormal
{
    NSDictionary * dictBody = [self GenInspData:strStoreID Data:data];
    [[RPBDataBase defaultInstance] SaveTaskCacheData:_userLoginDetail.strUserId Key:strStoreID CacheType:CACHETYPE_INSPECTION Data:dictBody Date:[RPNetModule genTimeStamp] Desc:strStoreName isNormalExit:bNormal];
}

-(void)SaveVisitCacheData:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(CVisitData *)data isNormalExit:(BOOL)bNormal
{
    NSDictionary * dictBody = [self GenVisitData:strStoreID Data:data];
    [[RPBDataBase defaultInstance] SaveTaskCacheData:_userLoginDetail.strUserId Key:strStoreID CacheType:CACHETYPE_VISITING Data:dictBody Date:[RPNetModule genTimeStamp] Desc:strStoreName isNormalExit:bNormal];
}

-(void)SaveMaintenCacheData:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(MaintenanceData *)data isNormalExit:(BOOL)bNormal
{
    NSDictionary * dictBody = [self GenMaintenData:strStoreID Data:data Reporter:nil];
    [[RPBDataBase defaultInstance] SaveTaskCacheData:_userLoginDetail.strUserId Key:strStoreID CacheType:CACHETYPE_MAINTEN Data:dictBody Date:[RPNetModule genTimeStamp] Desc:strStoreName isNormalExit:bNormal];
}

-(NSString *)SaveBVisitCacheData:(NSString *)strStoreID Desc:(NSString *)strDesc Data:(BVisitData *)data isNormalExit:(BOOL)bNormal
{
    NSDictionary * dictBody = [self GenBVisitData:strStoreID Data:data];
    return [[RPBDataBase defaultInstance] SaveTaskCacheData:_userLoginDetail.strUserId Key:strStoreID CacheType:CACHETYPE_BVISITING Data:dictBody Date:[RPNetModule genTimeStamp] Desc:strDesc isNormalExit:bNormal];
}

-(void)UpdateBVisitCacheData:(NSString *)strCacheDataId StroeId:(NSString *)strStoreID Desc:(NSString *)strDesc Data:(BVisitData *)data isNormalExit:(BOOL)bNormal
{
    NSDictionary * dictBody = [self GenBVisitData:strStoreID Data:data];
    [[RPBDataBase defaultInstance] UpdateTaskCacheData:_userLoginDetail.strUserId CacheDataId:strCacheDataId CacheType:CACHETYPE_BVISITING Data:dictBody Date:[RPNetModule genTimeStamp] Desc:strDesc isNormalExit:bNormal];
}

-(void)SaveReportToUser:(ReportToUserSaveType)type Reporters:(NSArray *)arraySection
{
    [[RPBDataBase defaultInstance] SaveReportToUser:_userLoginDetail.strUserId ReportType:type Date:[RPNetModule genTimeStamp] Reporters:arraySection];
}

-(void)GetReportToUser:(ReportToUserSaveType)type VendorId:(NSString *)strVendorId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    __block NSMutableArray * arrayRet = [[NSMutableArray alloc] init];
    __block NSArray * arrayReportUser = [[RPBDataBase defaultInstance] GetReportToUser:_userLoginDetail.strUserId ReportType:type VendorId:strVendorId];
    
    [self GetUserInfoList:0 Success:^(NSArray * arrayUser) {
        for (InspReporterUser * user in arrayReportUser)
        {
            if (user.bUserCollegue) {
                for (UserDetailInfo * detail in arrayUser) {
                    if ([user.strEmail isEqualToString:detail.strUserId]) {
                        user.strEmail = @"";
                        user.bSelected = YES;
                        user.collegue = detail;
                        [arrayRet addObject:user];
                        break;
                    }
                }
            }
            else
            {
                user.bSelected = YES;
                [arrayRet addObject:user];
            }
        }
        SuccessBlock(arrayRet);
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

#pragma mark Inspection
//UploadInspection
-(void)GetInspHistory:(NSString *)strStoreID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Inspection/GetInspectionList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            InspReportResult * data = [[InspReportResult alloc] init];
            data.arrayDetail = [[NSMutableArray alloc] init];
            data.strResultID = [self ValidString:dict forKey:@"InspId"];
            data.strStoreName = [self ValidString:dict forKey:@"StoreName"];
            data.strBrandName = [self ValidString:dict forKey:@"BrandName"];
            data.strInspctor = [self ValidString:dict forKey:@"Inspector"];
            data.strInspectionDate = [self ValidString:dict forKey:@"InspectionDate"];
            data.arrayDetail = [[NSMutableArray alloc] init];
            data.bSelected = NO;
            
            NSArray * details = [dict objectForKey:@"IssuesData"];
            for (NSDictionary * dictDetail in details) {
                InspReportResultDetail * rsDetail = [[InspReportResultDetail alloc] init];
                
                rsDetail.strCatagoryID = [self ValidString:dictDetail forKey:@"ItemId"];
                rsDetail.mark = [self ValidNumber:dictDetail forKey:@"Score" defaultValue:MARK_NONE].integerValue;
                
                rsDetail.arrayIssue = [[NSMutableArray alloc] init];
                
                NSArray * issues = [dictDetail objectForKey:@"Issues"];
                for (NSDictionary * dictIssue in issues){
                    InspIssue * issue = [[InspIssue alloc] init];
                    issue.strIssueDesc =[self ValidString:dictIssue forKey:@"IssueDesc"];
                    issue.strIssueID = [self ValidString:dictIssue forKey:@"IssueGid"];
                    issue.strIssueTitle = [self ValidString:dictIssue forKey:@"Title"];
                    issue.arrayIssueImg = [[NSMutableArray alloc] init];
                    
                    NSInteger nX = [self ValidNumber:dictIssue forKey:@"X" defaultValue:-1].integerValue;
                    NSInteger nY = [self ValidNumber:dictIssue forKey:@"Y" defaultValue:-1].integerValue;
                    if (nX >= 0 && nY >= 0) {
                        issue.bHasLocation = YES;
                        issue.ptLocation = CGPointMake(nX, nY);
                    }
                    
                    NSArray * images = [dictIssue objectForKey:@"IssueImgs"];
                    
                    issue.arrayIssueImg = [NSMutableArray arrayWithArray:@[[[InspIssueImage alloc] init],[[InspIssueImage alloc] init], [[InspIssueImage alloc] init]]];
                    NSInteger n = 0;
                    for (NSDictionary * image in images) {
                        InspIssueImage * issueImage = [[InspIssueImage alloc] init];
                        NSString * strPic = [self ValidString:image forKey:@"ImgData"];
                        if (strPic.length > 0) {
                            issueImage.strUrl = strPic;
                            
                            NSInteger nHeight = [self ValidNumber:image forKey:@"RegHeight" defaultValue:-1].integerValue;
                            NSInteger nWidth = [self ValidNumber:image forKey:@"RegWidth" defaultValue:-1].integerValue;
                            NSInteger nX = [self ValidNumber:image forKey:@"RegX" defaultValue:-1].integerValue;
                            NSInteger nY = [self ValidNumber:image forKey:@"RegY" defaultValue:-1].integerValue;
                            
                            if (nHeight >= 0 && nWidth >= 0 && nX >= 0 && nY >= 0) {
                                issueImage.rcIssue = CGRectMake(nX, nY, nWidth, nHeight);
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
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

//UploadInspection
-(void)SubmitInsp:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(InspData *)data Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    NSDictionary * dictBody = [self GenInspData:strStoreID Data:data];
    NSMutableDictionary * dict = [self genBodyDataDict:dictBody withToken:YES];
    
    [RPNetModule doRequest:[self genURL:@"Inspection/UploadInspection"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        if ([self SaveUploadCache:dictBody Type:CACHETYPE_INSPECTION Desc:strStoreName]) {
            FailedBlock(RPSDKError_SubmitAddToCache,[RPSDKError GetErrorDesc:RPSDKError_SubmitAddToCache]);
        }
        else
        {
            FailedBlock(RPSDKError_SubmitAddToCacheFailed,[RPSDKError GetErrorDesc:RPSDKError_SubmitAddToCacheFailed]);
        }
    }];
}

#pragma mark Rectification
//UploadRectification
-(void)SubmitRectification:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(InspData *)data Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    NSDictionary * dictBody = [self GenRectificationData:strStoreID Data:data];
    NSMutableDictionary * dict = [self genBodyDataDict:dictBody withToken:YES];
    
    [RPNetModule doRequest:[self genURL:@"Rectification/UploadRectification"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        if ([self SaveUploadCache:dictBody Type:CACHETYPE_RECTIFICITION Desc:strStoreName]) {
            FailedBlock(RPSDKError_SubmitAddToCache,[RPSDKError GetErrorDesc:RPSDKError_SubmitAddToCache]);
        }
        else
        {
            FailedBlock(RPSDKError_SubmitAddToCacheFailed,[RPSDKError GetErrorDesc:RPSDKError_SubmitAddToCacheFailed]);
        }
    }];
}

#pragma mark StoreMnt
//UploadStoreMnt
-(void)SubmitMainten:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(MaintenanceData *)data Reporter:(InspReporters *)reports Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    NSDictionary * dictBody = [self GenMaintenData:strStoreID Data:data Reporter:reports];
    NSMutableDictionary * dict = [self genBodyDataDict:dictBody withToken:YES];
    
    [RPNetModule doRequest:[self genURL:@"Maintenance/UploadStoreMnt"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        if ([self SaveUploadCache:dictBody Type:CACHETYPE_MAINTEN Desc:strStoreName]) {
            FailedBlock(RPSDKError_SubmitAddToCache,[RPSDKError GetErrorDesc:RPSDKError_SubmitAddToCache]);
        }
        else
        {
            FailedBlock(RPSDKError_SubmitAddToCacheFailed,[RPSDKError GetErrorDesc:RPSDKError_SubmitAddToCacheFailed]);
        }
    }];
}

-(void)GetStoreMntUserList:(NSString *)strStoreID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Store/GetStoreMntUserList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * arrayContact = [[NSMutableArray alloc] init];
        for (NSDictionary * dictUser in arrayResult) {
            MaintenContact * contact = [[MaintenContact alloc] init];
            contact.bColleague = YES;
            contact.strPhone = [self ValidString:dictUser forKey:@"Phone"];
            contact.strUserName = [self ValidString:dictUser forKey:@"UserName"];
            [arrayContact addObject:contact];
        }
        SuccessBlock(arrayContact);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

#pragma mark CVisiting
-(void)SubmitVisit:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(CVisitData *)data Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    NSDictionary * dictBody = [self GenVisitData:strStoreID Data:data];
    NSMutableDictionary * dict = [self genBodyDataDict:dictBody withToken:YES];
    
    [RPNetModule doRequest:[self genURL:@"StoreVisit/UploadStoreVisit"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        if ([self SaveUploadCache:dictBody Type:CACHETYPE_VISITING Desc:strStoreName]) {
            FailedBlock(RPSDKError_SubmitAddToCache,[RPSDKError GetErrorDesc:RPSDKError_SubmitAddToCache]);
        }
        else
        {
            FailedBlock(RPSDKError_SubmitAddToCacheFailed,[RPSDKError GetErrorDesc:RPSDKError_SubmitAddToCacheFailed]);
        }
    }];
}

#pragma mark BVisiting
-(void)GetBVisitTemplate:(NSString *)strStoreID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"BoutiqueVisit/GetBVisitTemplate"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dictVisit in arrayResult) {
            BVisitTemplate * visit = [[BVisitTemplate alloc] init];
            visit.strTemplateId = [self ValidString:dictVisit forKey:@"TemplateId"];
            visit.strTemplateName = [self ValidString:dictVisit forKey:@"TemplateName"];
            visit.strTemplateDesc = [self ValidString:dictVisit forKey:@"TemplateDesc"];
            visit.strCategoryTag = [self ValidString:dictVisit forKey:@"CategoryTag"];
            visit.nCatagoryCount = [self ValidNumber:dictVisit forKey:@"CategoryCount" defaultValue:0].integerValue;
            [array addObject:visit];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetBVisitTemplateDetail:(NSString *)strTemplateId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
{
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strTemplateId forKey:@"TemplateId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    
    NSString * strUrl = @"BoutiqueVisit/GetBVisitTemplateDetail";
    if (_bDemoMode) {
        strUrl = [NSString stringWithFormat:@"%@%@",strUrl,strTemplateId];
    }
    
    [RPNetModule doRequest:[self genURL:strUrl] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dictCatagory in arrayResult) {
           BVisitCategory * data = [[BVisitCategory alloc] init];
           data.strCategoryName = [self ValidString:dictCatagory forKey:@"CategoryName"];
           data.arrayItem = [[NSMutableArray alloc] init];
            
           NSArray * arrayItemGet = [dictCatagory objectForKey:@"TemplateItems"];
           for (NSDictionary * dictItemGet in arrayItemGet) {
               BVisitItem * item = [[BVisitItem alloc] init];
               item.strItemId = [self ValidString:dictItemGet forKey:@"ItemId"];
               item.strItemTitle = [self ValidString:dictItemGet forKey:@"ItemTitle"];
               item.strItemDesc = [self ValidString:dictItemGet forKey:@"ItemDesc"];
               item.fWeight = [self ValidNumber:dictItemGet forKey:@"Weight" defaultValue:0].floatValue;
               item.mark = BVisitMark_EMPTY;
               [data.arrayItem addObject:item];
           }
           [array addObject:data];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(NSDictionary *)GenBVisitData:(NSString *)strStoreID Data:(BVisitData *)data
{
    NSMutableDictionary * dictBody = [[NSMutableDictionary alloc] init];
    [dictBody setObject:strStoreID forKey:@"StoreId"];
    
    if (!data.strComment) data.strComment = @"";
    if (!data.strTitle) data.strTitle = @"";
    
    [dictBody setObject:data.strComment forKey:@"Overall"];
    [dictBody setObject:data.strTitle forKey:@"Title"];
    [dictBody setObject:[NSNumber numberWithFloat:data.fPoint] forKey:@"Point"];
    [dictBody setObject:data.strTemplateId forKey:@"TemplateId"];
    [dictBody setObject:data.strTemplateName forKey:@"TemplateName"];
    [dictBody setObject:data.strTemplateDesc forKey:@"TemplateDesc"];
    [dictBody setObject:data.strCategoryTag forKey:@"CategoryTag"];
    if (data.strSourceReportId==nil) {
        data.strSourceReportId=@"";
    }
    [dictBody setObject:data.strSourceReportId forKey:@"SourceReportId"];
    [dictBody setObject:[NSNumber numberWithInteger:data.nStatus] forKey:@"Status"];
    NSMutableArray * arrayEmail = [[NSMutableArray alloc] init];
    NSMutableArray * arrayColleague = [[NSMutableArray alloc] init];
    
    for (InspReporterSection * section in data.reporters.arraySection) {
        for (InspReporterUser * user in section.arrayUser) {
            if (user.bSelected) {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                if (user.bUserCollegue)
                {
                    [dict setObject:user.collegue.strUserId forKey:@"UserId"];
                    [dict setObject:@"" forKey:@"DataId"];
                    [arrayColleague addObject:dict];
                    
                    if (user.collegue.strWorkEmail.length > 0) {
                        NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] init];
                        [dict2 setObject:user.collegue.strWorkEmail forKey:@"Email"];
                        [dict2 setObject:@"" forKey:@"DataId"];
                        [arrayEmail addObject:dict2];
                    }
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
    
    NSMutableArray * arrayPoint = [[NSMutableArray alloc] init];
    for (BVisitCategory * catagory in data.arrayCatagory) {
        NSMutableDictionary * dictPoint = [[NSMutableDictionary alloc] init];
        [dictPoint setObject:catagory.strCategoryName forKey:@"CategoryName"];
        [dictPoint setObject:[NSNumber numberWithFloat:catagory.fPoint] forKey:@"CategoryPoint"];
        [arrayPoint addObject:dictPoint];
    }
    [dictBody setObject:arrayPoint forKey:@"PointList"];
    
    NSMutableDictionary * dictBVisitData = [[NSMutableDictionary alloc] init];
    NSMutableArray * arrayCatagory = [[NSMutableArray alloc] init];
    for (BVisitCategory * category in data.arrayCatagory)
    {
        for (BVisitItem * item in category.arrayItem) {
            NSMutableDictionary * dictCatagory = [[NSMutableDictionary alloc] init];
            [dictCatagory setObject:category.strCategoryName forKey:@"CategoryName"];
            [dictCatagory setObject:item.strItemId forKey:@"ItemId"];
            [dictCatagory setObject:item.strItemTitle forKey:@"ItemTitle"];
            [dictCatagory setObject:item.strItemDesc forKey:@"ItemDesc"];
            [dictCatagory setObject:[NSNumber numberWithInteger:item.mark] forKey:@"Score"];
            [dictCatagory setObject:[NSNumber numberWithFloat:item.fWeight] forKey:@"Weight"];
            
            NSMutableArray * arrayIssues = [[NSMutableArray alloc] init];
            for (InspIssue * issue in item.arrayIssue) {
                NSMutableDictionary * dictIssue = [[NSMutableDictionary alloc] init];
                [dictIssue setObject:issue.strIssueDesc forKey:@"IssueDesc"];
                [dictIssue setObject:@"" forKey:@"IssueGid"];
                [dictIssue setObject:issue.strIssueTitle forKey:@"Title"];
                if (issue.bHasLocation && issue.strMapId)
                    [dictIssue setObject:issue.strMapId forKey:@"BlueprintId"];
                else
                    [dictIssue setObject:@"" forKey:@"BlueprintId"];
                
                [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.x] forKey:@"X"];
                [dictIssue setObject:[NSNumber numberWithInteger:issue.ptLocation.y] forKey:@"Y"];
                
                NSMutableArray * arrayImage = [[NSMutableArray alloc] init];
                for (InspIssueImage * image in issue.arrayIssueImg) {
                    if (image.imgIssue == nil && image.strUrl.length > 0) {
                        image.imgIssue = [RPSDK loadImageFromURL:image.strUrl];
                    }
                    
                    if (image.imgIssue) {
                        NSMutableDictionary * dictImage = [[NSMutableDictionary alloc] init];
                        NSString * strImage =  [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(image.imgIssue, 0.5)];
                        
                        [dictImage setObject:strImage forKey:@"ImgData"];
                        
//                        NSInteger nleng = strImage.length;
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
    
    [dictBVisitData setObject:arrayCatagory forKey:@"IssuesData"];
    [dictBody setObject:dictBVisitData forKey:@"BVisitData"];
    return dictBody;
}

-(void)SubmitBVisit:(NSString *)strStoreID StoreName:(NSString *)strStoreName Data:(BVisitData *)data Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    NSDictionary * dictBody = [self GenBVisitData:strStoreID Data:data];
    NSMutableDictionary * dict = [self genBodyDataDict:dictBody withToken:YES];
    
    [RPNetModule doRequest:[self genURL:@"BoutiqueVisit/SubmitBVisit"] isCheckWifi:NO withData:dict success:^(id idResult) {
        [self SaveReportToUser:ReportToUserSaveType_BVisit Reporters:data.reporters.arraySection];
        NSString *reportId=[self ValidString:idResult forKey:@"ReportId"];
        SuccessBlock(reportId);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        if ([self SaveUploadCache:dictBody Type:CACHETYPE_BVISITING Desc:strStoreName]) {
            FailedBlock(RPSDKError_SubmitAddToCache,[RPSDKError GetErrorDesc:RPSDKError_SubmitAddToCache]);
        }
        else
        {
            FailedBlock(RPSDKError_SubmitAddToCacheFailed,[RPSDKError GetErrorDesc:RPSDKError_SubmitAddToCacheFailed]);
        }
    }];
}
-(InspIssue *)CreateIssueByDict:(NSDictionary *)dictIssue
{
        InspIssue * issue = [[InspIssue alloc] init];
        issue.strIssueDesc = [dictIssue objectForKey:@"IssueDesc"];
        issue.strIssueTitle = [dictIssue objectForKey:@"Title"];
    issue.strIssueID=[dictIssue objectForKey:@"IssueGid"];
        NSInteger nX = ((NSNumber *)[dictIssue objectForKey:@"X"]).integerValue;
        NSInteger nY = ((NSNumber *)[dictIssue objectForKey:@"Y"]).integerValue;
        issue.ptLocation = CGPointMake(nX, nY);
        issue.bHasLocation = YES;
        
        issue.arrayIssueImg = [NSMutableArray arrayWithArray:@[[[InspIssueImage alloc] init],[[InspIssueImage alloc] init], [[InspIssueImage alloc] init]]];
        
        NSInteger nImageIndex = 0;
        for (NSDictionary * dictImage in (NSArray *)[dictIssue objectForKey:@"IssueImgs"])
        {
            InspIssueImage * image = [[InspIssueImage alloc] init];
            
           // NSData * dataImg = [GTMBase64 decodeString:[dictImage objectForKey:@"ImgData"]];
           // image.imgIssue = [UIImage imageWithData:dataImg];
            image.strUrl = [dictImage objectForKey:@"ImgData"];
            NSInteger x = ((NSNumber *)[dictImage objectForKey:@"RegX"]).integerValue;
            NSInteger y = ((NSNumber *)[dictImage objectForKey:@"RegY"]).integerValue;
            NSInteger width = ((NSNumber *)[dictImage objectForKey:@"RegWidth"]).integerValue;
            NSInteger height = ((NSNumber *)[dictImage objectForKey:@"RegHeight"]).integerValue;
            
            image.rcIssue = CGRectMake(x, y, width, height);
            [issue.arrayIssueImg replaceObjectAtIndex:nImageIndex withObject:image];
            nImageIndex ++;
        }
    return issue;
}
-(void)searchBVisitIssue:(NSString *)strSearch StartDate:(NSString*)startDate EndDate:(NSString*)endDate DomianId:(NSString *)domainId ReportId:(NSString *)reportId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (strSearch==nil)
    {
        strSearch=@"";
    }
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strSearch forKey:@"KeyWords"];
    [dictAPI setObject:startDate forKey:@"BeginDate"];
    [dictAPI setObject:endDate forKey:@"EndDate"];
    [dictAPI setObject:reportId forKey:@"ReportId"];
    [dictAPI setObject:domainId forKey:@"DomainId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"BoutiqueVisit/SearchBVisit"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dictVisit in arrayResult) {
            BVisitSearchRetCatagory * searchRetCatagory = [[BVisitSearchRetCatagory alloc] init];
            NSDictionary *storeInfoDic=[dictVisit objectForKey:@"StoreInfo"];
            searchRetCatagory.storeInfo = [self CreateStoreDetailByDict:storeInfoDic];
            NSMutableDictionary *issueSearchDic=[dictVisit objectForKey:@"SearchIssues"];
            NSMutableArray *arrayIssueSearch=[[NSMutableArray alloc]init];
            for (NSDictionary * dict in issueSearchDic)
            {
                BVisitIssueSearchRet *issueSearch=[[BVisitIssueSearchRet alloc]init];
                issueSearch.strBoutiqueVisitId=[self ValidString:dict forKey:@"BoutiqueVisitId"];
                issueSearch.strIssueId=[self ValidString:dict forKey:@"IssueId"];
                issueSearch.strStoreId=[self ValidString:dict forKey:@"StoreId"];
                issueSearch.strUserId=[self ValidString:dict forKey:@"UserId"];
                issueSearch.strUserName=[self ValidString:dict forKey:@"UserName"];
                issueSearch.rank=[self ValidNumber:dict forKey:@"Rank" defaultValue:0].integerValue;
                issueSearch.strModelName=[self ValidString:dict forKey:@"TemplateName"];
                issueSearch.strCatagoryName=[self ValidString:dict forKey:@"CategoryTag"];
                issueSearch.strItemName=[self ValidString:dict forKey:@"QuestionnaireTitle"];
                issueSearch.strPostTime=[self ValidString:dict forKey:@"BoutiqueVisitDate"];
                NSDictionary *issueDic=[dict objectForKey:@"Issue"];
                InspIssue * issue = [[InspIssue alloc] init];
                issue=[self CreateIssueByDict:issueDic];
                issueSearch.issue=issue;
                
                NSArray *arrayTaskDic=[issueDic objectForKey:@"TaskList"];
                NSMutableArray *arrayTask=[[NSMutableArray alloc]init];
                for (NSDictionary *dicTask in arrayTaskDic)
                {
                    TaskInfo *task=[self CreateTaskByDict:dicTask];
                    [arrayTask addObject:task];
                }
                issueSearch.arrayTask=arrayTask;
                
                [arrayIssueSearch addObject:issueSearch];
            }
            searchRetCatagory.arrayIssueSearchRet =arrayIssueSearch;
            searchRetCatagory.bExpend=YES;
            [array addObject:searchRetCatagory];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
    
}

-(void)SubmitBVisitIssue:(BVisitIssueSearchData *)issueData Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    NSMutableDictionary * dictBody = [[NSMutableDictionary alloc] init];
    NSMutableArray * arrayEmail = [[NSMutableArray alloc] init];
    NSMutableArray * arrayColleague = [[NSMutableArray alloc] init];
    NSMutableArray * arrayIssueId=[[NSMutableArray alloc]init];
    for (InspReporterSection * section in issueData.reporters.arraySection) {
        for (InspReporterUser * user in section.arrayUser) {
            if (user.bSelected) {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                if (user.bUserCollegue)
                {
                    [dict setObject:user.collegue.strUserId forKey:@"UserId"];
                    [arrayColleague addObject:dict];
                    
                    if (user.collegue.strWorkEmail.length > 0) {
                        NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] init];
                        [dict2 setObject:user.collegue.strWorkEmail forKey:@"Email"];
                        [arrayEmail addObject:dict2];
                    }
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
    
    for (BVisitIssueSearchRet *issueSearchRet in issueData.arrayIssue)
    {
        [arrayIssueId addObject:issueSearchRet.strIssueId];
    }
    
    [dictBody setObject:arrayEmail forKey:@"EmailList"];
    [dictBody setObject:arrayColleague forKey:@"UserList"];
    [dictBody setObject:arrayIssueId forKey:@"IssueId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictBody withToken:YES];
    [RPNetModule doRequest:[self genURL:@"BoutiqueVisit/SubmitBVisitIssue"] isCheckWifi:NO withData:dict success:^(id idResult) {
         NSString *reportId=[self ValidString:idResult forKey:@"ReportId"];
        SuccessBlock(reportId);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
    }];
}




-(BVisitListModel *)CreateBVisitListModelByDict:(NSDictionary *)dictModel
{
    BVisitListModel * data = [[BVisitListModel alloc] init];
    data.strReportId = [self ValidString:dictModel forKey:@"ReportId"];
    data.strReportTitle = [self ValidString:dictModel forKey:@"ReportTitle"];
    data.strDate = [self ValidString:dictModel forKey:@"Date"];
    data.strStoreId = [self ValidString:dictModel forKey:@"StoreId"];
    data.strStoreName = [self ValidString:dictModel forKey:@"StoreName"];
    data.rank=[self ValidNumber:dictModel forKey:@"Rank" defaultValue:Rank_Assistant].integerValue;
    data.strUserName = [self ValidString:dictModel forKey:@"UserName"];
    NSDictionary * dicBVItem = [dictModel objectForKey:@"BVisitData"];
    data.bVisitData = [[BVisitData alloc] init];
    if (dicBVItem && (id)dicBVItem != [NSNull null])
    {
        data.bVisitData.strSourceReportId = [self ValidString:dictModel forKey:@"ReportId"];
        data.bVisitData.strTemplateId = [self ValidString:dictModel forKey:@"TemplateId"];
        data.bVisitData.strTemplateName = [self ValidString:dictModel forKey:@"TemplateName"];
        data.bVisitData.strTemplateDesc = [self ValidString:dictModel forKey:@"TemplateDesc"];
        data.bVisitData.strCategoryTag = [self ValidString:dictModel forKey:@"CategoryTag"];
        data.bVisitData.strComment = [self ValidString:dictModel forKey:@"Remark"];
        data.bVisitData.strTitle = [self ValidString:dictModel forKey:@"ReportTitle"];
        data.bVisitData.nStatus = 0;
        
        data.bVisitData.reporters = [[InspReporters alloc] init];
        data.bVisitData.reporters.arraySection = [[NSMutableArray alloc] init];
        InspReporterSection * sec = [[InspReporterSection alloc] init];
        sec.strTitle1 = NSLocalizedStringFromTableInBundle(@"Boutique Visit Reportt",@"RPString", g_bundleResorce,nil);
        sec.strTitle2 = data.bVisitData.strTitle;
        sec.arrayUser = [[NSMutableArray alloc] init];
        [data.bVisitData.reporters.arraySection addObject:sec];
        
        NSMutableArray * arrayMapSet = [[NSMutableArray alloc] init];
        NSArray * arrayMaps = [dictModel objectForKey:@"Blueprints"];
        if (arrayMaps && (id)arrayMaps != [NSNull null])
        {
            for(NSDictionary * dictMap in arrayMaps)
            {
                StoreShopMap * map = [[StoreShopMap alloc] init];
                map.strId = [self ValidString:dictMap forKey:@"Id"];
                map.strTitle = [self ValidString:dictMap forKey:@"Name"];
                map.strUrl = [self ValidString:dictMap forKey:@"Url"];
                [arrayMapSet addObject:map];
            }
        }
        data.bVisitData.arrayMap = arrayMapSet;
        
        NSMutableArray * arrayCatagory = [[NSMutableArray alloc] init];
        
        
        NSArray * arrayIssuesData = [dicBVItem objectForKey:@"IssuesData"];
        for(NSDictionary * dictIssue in arrayIssuesData)
        {
            NSString * strCatagoryName = [self ValidString:dictIssue forKey:@"CategoryName"];
            BVisitCategory * cataGet = nil;
            for(BVisitCategory * cata in arrayCatagory)
            {
                if ([cata.strCategoryName isEqualToString:strCatagoryName])
                {
                    cataGet = cata;
                    break;
                }
            }
            if (cataGet == nil)
            {
                cataGet = [[BVisitCategory alloc] init];
                cataGet.strCategoryName = strCatagoryName;
                cataGet.arrayItem = [[NSMutableArray alloc] init];
                [arrayCatagory addObject:cataGet];
            }
            
            BVisitItem * item = [[BVisitItem alloc] init];
            item.strItemId = [self ValidString:dictIssue forKey:@"ItemId"];
            item.strItemTitle = [self ValidString:dictIssue forKey:@"ItemTitle"];
            item.strItemDesc = [self ValidString:dictIssue forKey:@"ItemDesc"];
            item.mark = [self ValidNumber:dictIssue forKey:@"Score" defaultValue:BVisitMark_EMPTY].integerValue;
            item.fWeight = [self ValidNumber:dictIssue forKey:@"Weight" defaultValue:0].floatValue;
            item.arrayIssue = [[NSMutableArray alloc] init];
            [cataGet.arrayItem addObject:item];
            
            NSArray * arrayIssue = [dictIssue objectForKey:@"Issues"];
            if (arrayIssue && (id)arrayIssue != [NSNull null])
            {
                for(NSDictionary * dictIssueDetail in arrayIssue)
                {
                    InspIssue * issu = [[InspIssue alloc] init];
                    issu.strIssueID = [self ValidString:dictIssueDetail forKey:@"IssueGid"];
                    issu.strIssueTitle = [self ValidString:dictIssueDetail forKey:@"Title"];
                    issu.strIssueDesc = [self ValidString:dictIssueDetail forKey:@"IssueDesc"];
                    issu.strMapId = [self ValidString:dictIssueDetail forKey:@"BlueprintId"];
                    issu.bHasLocation = NO;
                    
                    NSInteger nX = [self ValidNumber:dictIssueDetail forKey:@"X" defaultValue:0].integerValue;
                    NSInteger nY = [self ValidNumber:dictIssueDetail forKey:@"Y" defaultValue:0].integerValue;
                    if (nX || nY)
                    {
                        issu.bHasLocation = YES;
                    }
                    issu.ptLocation = CGPointMake(nX, nY);
                    
                    issu.arrayIssueImg = [[NSMutableArray alloc] init];
                    
                    NSMutableArray * arrayImgs = [dictIssueDetail objectForKey:@"IssueImgs"];
                    if (arrayImgs && (id)arrayImgs != [NSNull null])
                    {
                        for(NSDictionary * dictImg in arrayImgs)
                        {
                            InspIssueImage * img = [[InspIssueImage alloc] init];
                            img.strUrl = [self ValidString:dictImg forKey:@"ImgData"];
                            NSInteger nX = [self ValidNumber:dictImg forKey:@"RegX" defaultValue:0].integerValue;
                            NSInteger nY = [self ValidNumber:dictImg forKey:@"RegY" defaultValue:0].integerValue;
                            NSInteger nWidth = [self ValidNumber:dictImg forKey:@"RegWidth" defaultValue:0].integerValue;
                            NSInteger nHeight = [self ValidNumber:dictImg forKey:@"RegHeight" defaultValue:0].integerValue;
                            
                            img.rcIssue = CGRectMake(nX, nY, nWidth, nHeight);
                           [issu.arrayIssueImg addObject:img];
                        }
                    }
                    
                    [item.arrayIssue addObject:issu];
                }
            }
        }
        data.bVisitData.arrayCatagory = arrayCatagory;
    }
    return data;
}

-(void)GetBVisitListSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    
    NSString * strUrl = @"BoutiqueVisit/GetBVisitList";
    
    [RPNetModule doRequest:[self genURL:strUrl] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dictModel in arrayResult) {
            [array addObject:[self CreateBVisitListModelByDict:dictModel]];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetBVisitById:(NSString *)reportId  Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:reportId forKey:@"ReportId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    
    NSString * strUrl = @"BoutiqueVisit/GetBVisitById";
    
    [RPNetModule doRequest:[self genURL:strUrl] isCheckWifi:NO withData:dict success:^(NSDictionary * dicResult) {
        
          BVisitListModel *bVisitListModel = [self CreateBVisitListModelByDict:dicResult];
        
        SuccessBlock(bVisitListModel);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetBVisitIssueById:(NSString *)strIssueId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strIssueId forKey:@"IssueId"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"task/GetIssueById"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock([self CreateIssueByDict:idResult]);
        
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

#pragma mark Log Book
-(LogBookDetail *)CreateLogBookDetailByDict:(NSDictionary *)dict
{
    LogBookDetail * detail = [[LogBookDetail alloc] init];
    detail.strID = [self ValidString:dict forKey:@"TimeLineId"];
    detail.strTitle = [self ValidString:dict forKey:@"Subject"];
    detail.strDesc = [self ValidString:dict forKey:@"Content"];
    detail.bFocus = [self ValidNumber:dict forKey:@"Favorite" defaultValue:0].integerValue;
    detail.dtPostTime = [self ValidDate:dict forKey:@"StrAddDate"];
    detail.strTagId = [self ValidString:dict forKey:@"TagId"];
    detail.strTagDesc = [self ValidString:dict forKey:@"TagDesc"];
    
    detail.arrayComment = [[NSMutableArray alloc] init];
    detail.arrayImageBig = [[NSMutableArray alloc] init];
    detail.arrayImageSmall = [[NSMutableArray alloc] init];
    
    
    NSArray * arrayImage = [dict objectForKey:@"Images"];
    if ([arrayImage isKindOfClass:[NSArray class]]) {
        for (NSDictionary * dictImg in arrayImage) {
            NSString * strFileName = [dictImg objectForKey:@"FileDirPath"];
            [detail.arrayImageBig addObject:strFileName];
            NSString * strFileNameSmall = [strFileName stringByReplacingCharactersInRange:NSMakeRange(strFileName.length - 4,4) withString:@"_thumb.jpg"];
            [detail.arrayImageSmall addObject:strFileNameSmall];
        }
    }
    
    detail.userPost = [self CreateUserDetailByDict:[dict objectForKey:@"UserDetail"]];
    detail.nCommentCount = [self ValidNumber:dict forKey:@"CommentsCount" defaultValue:0].integerValue;
    detail.bMyPost = [detail.userPost.strUserId isEqualToString:self.userLoginDetail.strUserId] ? YES : NO;
    detail.bRead = [self ValidNumber:dict forKey:@"Read" defaultValue:NO].boolValue;
    return detail;
}

-(LogBookDetail *)CreateLogBookSearchDetailByDict:(NSDictionary *)dict
{
    LogBookDetail * detail = [self CreateLogBookDetailByDict:dict];
    detail.store = [self CreateStoreDetailByDict:[dict objectForKey:@"StoreModel"]];
    return detail;
}

-(void)GetLogBookList:(NSString *)strStoreId FiltMyPost:(BOOL)bFiltMyPost FiltUnRead:(BOOL)bFiltUnRead FiltFocus:(BOOL)bFiltFocus FiltTag:(NSString *)strTagId LastId:(NSString *)strLastLogBookId GetNew:(BOOL)bGetNew Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        if (strLastLogBookId != nil && strLastLogBookId.length > 0) {
            FailedBlock(RPSDKError_Unknown,@"");
            return;
        }
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreId forKey:@"StoreId"];
    [dictAPI setObject:[NSNumber numberWithBool:bFiltMyPost] forKey:@"MyPost"];
    [dictAPI setObject:[NSNumber numberWithBool:bFiltUnRead] forKey:@"Unread"];
    [dictAPI setObject:[NSNumber numberWithBool:bFiltFocus] forKey:@"Unfav"];
    [dictAPI setObject:strTagId forKey:@"TagId"];
    [dictAPI setObject:strLastLogBookId forKey:@"LastHadndOverId"];
    [dictAPI setObject:@"" forKey:@"ParentId"];
    [dictAPI setObject:[NSNumber numberWithBool:bGetNew] forKey:@"GetNew"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"HandoverBook/GetHandOverList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            LogBookDetail * detail = [self CreateLogBookDetailByDict:dict];
            [array addObject:detail];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}


-(void)GetLogBookCommentList:(NSString *)strStoreId LogBookId:(NSString *)strLogBookId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strLogBookId forKey:@"HadndOverId"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"HandoverBook/GetHandOverComments"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            LogBookDetail * detail = [self CreateLogBookDetailByDict:dict];
            [array addObject:detail];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetLogBookDetail:(NSString *)strLogBookId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strLogBookId forKey:@"HadndOverId"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"HandoverBook/GetHandOverByID"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        LogBookDetail * detail = [self CreateLogBookDetailByDict:dictResult];
        SuccessBlock(detail);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)PostLogBook:(NSString *)strStoreId Title:(NSString *)strTitle Desc:(NSString *)strDesc Images:(NSMutableArray *)arrayImage Tag:(NSString *)strTagId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreId forKey:@"StoreId"];
    [dictAPI setObject:strTitle forKey:@"Title"];
    [dictAPI setObject:strDesc forKey:@"Desc"];
    [dictAPI setObject:strTagId forKey:@"TagId"];
    NSMutableArray * arrayImageStr = [[NSMutableArray alloc] init];
    for (UIImage * image in arrayImage) {
        NSString * strImage =  [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(image, 0.5)];
        [arrayImageStr addObject:strImage];
    }
    [dictAPI setObject:arrayImageStr forKey:@"images"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"HandoverBook/PostHandOver"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)FocusLogBook:(NSString *)strId Focus:(BOOL)bFocus Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strId forKey:@"HadndOverId"];
    [dictAPI setObject:[NSNumber numberWithBool:bFocus] forKey:@"Unfav"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"handoverbook/FavoriteHandOver"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)DeleteLogBook:(NSString *)strId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strId forKey:@"HadndOverId"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"HandoverBook/DeleteHandOver"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)CommentLogBook:(NSString *)strStoreId LogBookID:(NSString *)strLogBookId Comment:(NSString *)strComment Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreId forKey:@"StoreId"];
    [dictAPI setObject:strLogBookId forKey:@"HadndOverId"];
    [dictAPI setObject:strComment forKey:@"Comment"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"HandoverBook/CommentHandOver"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)SearchLogBook:(NSString *)strStoreId LastLogBookID:(NSString *)strLastLogBookId Condition:(NSString *)strSearch Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreId forKey:@"StoreId"];
    [dictAPI setObject:strLastLogBookId forKey:@"LastHadndOverId"];
    
    if (strSearch == nil) strSearch = @"";
    
    [dictAPI setObject:strSearch forKey:@"Search"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"HandoverBook/SearchHandOver"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            LogBookDetail * detail = [self CreateLogBookSearchDetailByDict:dict];
            [array addObject:detail];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetLogBookTagSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"HandoverBook/GetLogBookTag"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            LogBookTag * tag = [[LogBookTag alloc] init];
            tag.strTagId = [self ValidString:dict forKey:@"TagId"];
            tag.strDesc = [self ValidString:dict forKey:@"TagDesc"];
            [array addObject:tag];
        }
        SuccessBlock(array);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}


#pragma mark KPI
-(void)GetKPISalesDataList:(NSString *)strStoreID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"KPIReport/GetKPISalesDataList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * arrayRet = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            KPISalesData * data = [[KPISalesData alloc] init];
            data.mode = [self ValidNumber:dict forKey:@"KPIMode" defaultValue:KPIMode_Day].integerValue;
            switch (data.mode) {
                case KPIMode_Hour:
                {
                     NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit fromDate:[self ValidDate:dict forKey:@"Date"]];
                    data.nYear = [components year];
                    data.nMonth = [components month];
                    data.nDay = [components day];
                    data.nHour = [components hour];
                }
                    break;
                case KPIMode_Day:
                {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    
                    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[formatter dateFromString:[dict objectForKey:@"Date"]]];
                    
                    data.nYear = [components year];
                    data.nMonth = [components month];
                    data.nDay = [components day];
                }
                    break;
                default:
                    break;
            }
            data.nAmount = [self ValidNumber:dict forKey:@"Amount" defaultValue:0].integerValue;
            data.nProQty = [self ValidNumber:dict forKey:@"ProQty" defaultValue:0].integerValue;
            data.nTraQty = [self ValidNumber:dict forKey:@"TraQty" defaultValue:0].integerValue;
            [arrayRet addObject:data];
        }
        SuccessBlock(arrayRet);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetKPITrafficDataList:(NSString *)strStoreID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"KPIReport/GetKPITrafficDataList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * arrayRet = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            KPITrafficData * data = [[KPITrafficData alloc] init];
            data.mode = [self ValidNumber:dict forKey:@"KPIMode" defaultValue:KPIMode_Day].integerValue;
            switch (data.mode) {
                case KPIMode_Hour:
                {
                    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit fromDate:[self ValidDate:dict forKey:@"Date"]];
                    data.nYear = [components year];
                    data.nMonth = [components month];
                    data.nDay = [components day];
                    data.nHour = [components hour];
                }
                    break;
                case KPIMode_Day:
                {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    
                    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[formatter dateFromString:[dict objectForKey:@"Date"]]];
                    
                    data.nYear = [components year];
                    data.nMonth = [components month];
                    data.nDay = [components day];
                }
                    break;
                default:
                    break;
            }
            data.nTraffic = [self ValidNumber:dict forKey:@"Traffic" defaultValue:0].integerValue;
            [arrayRet addObject:data];
        }
        SuccessBlock(arrayRet);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)SetKPISalesData:(NSString *)strStoreID SalesData:(NSArray *)arraySale Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (KPISalesData * data in arraySale) {
        if (data.nProQty >= 0 || data.nTraQty >= 0 || data.nAmount >= 0) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            switch (data.mode) {
                case KPIMode_Day:
                    [dict setObject:[NSString stringWithFormat:@"%04d-%02d-%02d",data.nYear,data.nMonth,data.nDay] forKey:@"Date"];
                    break;
                case KPIMode_Hour:
                    [dict setObject:[NSString stringWithFormat:@"%04d-%02d-%02d %02d:00:00",data.nYear,data.nMonth,data.nDay,data.nHour] forKey:@"Date"];
                    break;
            }
            
            [dict setObject:[NSString stringWithFormat:@"%d",data.mode] forKey:@"KPIMode"];
            NSInteger nTraQty = data.nTraQty > 0 ? data.nTraQty : 0;
            NSInteger nProQty = data.nProQty > 0 ? data.nProQty : 0;
            NSInteger nAmount = data.nAmount > 0 ? data.nAmount : 0;
            
            [dict setObject:[NSString stringWithFormat:@"%d",nTraQty] forKey:@"TraQty"];
            [dict setObject:[NSString stringWithFormat:@"%d",nProQty] forKey:@"ProQty"];
            [dict setObject:[NSString stringWithFormat:@"%d",nAmount] forKey:@"Amount"];
            
            [array addObject:dict];
        }
    }
    [dictAPI setObject:array forKey:@"KPISalesData"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"KPIReport/SetKPISalesData"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)SetKPITrafficData:(NSString *)strStoreID TrafficData:(NSArray *)arrayTraffic Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (KPITrafficData * data in arrayTraffic) {
        if (data.nTraffic >= 0) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            switch (data.mode) {
                case KPIMode_Day:
                    [dict setObject:[NSString stringWithFormat:@"%04d-%02d-%02d",data.nYear,data.nMonth,data.nDay] forKey:@"Date"];
                    break;
                case KPIMode_Hour:
                    [dict setObject:[NSString stringWithFormat:@"%04d-%02d-%02d %02d:00:00",data.nYear,data.nMonth,data.nDay,data.nHour] forKey:@"Date"];
                    break;
            }
            
            [dict setObject:[NSString stringWithFormat:@"%d",data.mode] forKey:@"KPIMode"];
            NSInteger nTraffic = data.nTraffic > 0 ? data.nTraffic : 0;
            
            [dict setObject:[NSString stringWithFormat:@"%d",nTraffic] forKey:@"Traffic"];
            [array addObject:dict];
        }
    }
    [dictAPI setObject:array forKey:@"KPITrafficData"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"KPIReport/SetKPITrafficData"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)DeleteKPISalesData:(NSString *)strStoreID Date:(NSString *)strDate Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    [dictAPI setObject:strDate forKey:@"Date"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"KPIReport/DeleteKPISalesData"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)DeleteKPITrafficData:(NSString *)strStoreID Date:(NSString *)strDate Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    [dictAPI setObject:strDate forKey:@"Date"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"KPIReport/DeleteKPITrafficData"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetSubDomainKPIData:(NSString *)strParentDomainID DateRange:(KPIDateRange *)range Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI =[[RPMutableDictionary alloc] init];
    [dictAPI setObject:strParentDomainID forKey:@"ParentDomainId"];
    
    NSMutableDictionary * dictDateRange = [[NSMutableDictionary alloc] init];
    [dictDateRange setObject:[NSNumber numberWithInteger:range.type] forKey:@"KPIDateRangeType"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [dictDateRange setObject:[formatter stringFromDate:range.date] forKey:@"Date"];
    [dictDateRange setObject:[NSNumber numberWithInteger:range.nIndex] forKey:@"Index"];
    [dictDateRange setObject:[NSNumber numberWithInteger:range.nYear] forKey:@"Year"];
    
    [dictAPI setObject:dictDateRange forKey:@"KPIDateRange"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    NSString * strUrl = @"KPIReport/GetSubDomainKPIData";
    if (_bDemoMode)
    {
        if ([strParentDomainID isEqualToString:@"0"]) {
            NSMutableArray * array = [[NSMutableArray alloc] init];
            SuccessBlock(array);
            return;
        }
        
        if (strParentDomainID && strParentDomainID.length > 0)
            strUrl = [NSString stringWithFormat:@"%@%@",strUrl,strParentDomainID];
        else
            strUrl = [NSString stringWithFormat:@"%@0",strUrl];
    }
    
    [RPNetModule doRequest:[self genURL:strUrl] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            KPIDomainData * data = [[KPIDomainData alloc] init];
            data.strDomainID = [self ValidString:dict forKey:@"DomainID"];
            data.strDomainName = [self ValidString:dict forKey:@"DomainName"];
            data.nAmount = [self ValidNumber:dict forKey:@"Amount" defaultValue:0].longLongValue;
            data.nTraffic = [self ValidNumber:dict forKey:@"Traffic" defaultValue:0].longLongValue;
            data.nTraQty = [self ValidNumber:dict forKey:@"TraQty" defaultValue:0].longLongValue;
            data.nProQty = [self ValidNumber:dict forKey:@"ProQty" defaultValue:0].longLongValue;
            data.bHasChild = [self ValidNumber:dict forKey:@"HasChild" defaultValue:0].boolValue;
            if (data.nTraffic == 0)
                data.nConvPercent = 0;
            else
                data.nConvPercent = (double)data.nTraQty / data.nTraffic * 100;
            
            data.bFav = [self ValidNumber:dict forKey:@"IsFavorite" defaultValue:NO].boolValue;
            
            [array addObject:data];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

#pragma mark CourtesyCall
-(void)GetCourtesyCallTypeSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"CourtesyCall/GetCourtesyCallType"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            CourtesyCallType * type = [[CourtesyCallType alloc] init];
            type.strCourtesyCallTips = [self ValidString:dict forKey:@"CourtesyCallTips"];
            type.strCourtesyCallTypeId = [self ValidString:dict forKey:@"CourtesyCallTypeId"];
            type.strDescription = [self ValidString:dict forKey:@"Description"];
            type.strTypeName = [self ValidString:dict forKey:@"TypeName"];
            [array addObject:type];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetCourtesyCallInfoList:(NSString *)strUserID isCompleted:(BOOL)bComplete Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strUserID forKey:@"UserId"];
    [dictAPI setObject:[NSNumber numberWithBool:bComplete] forKey:@"IsCompleted"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"CourtesyCall/GetCourtesyCallInfo"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            CourtesyCallInfo * info = [[CourtesyCallInfo alloc] init];
            info.strID = [self ValidString:dict forKey:@"CourtesyCallInfoId"];
            info.strCourtesyCallTypeId = [self ValidString:dict forKey:@"CourtesyCallTypeId"];
            info.strTelephoneNo = [self ValidString:dict forKey:@"TelephoneNo"];
            info.strComment = [self ValidString:dict forKey:@"CCComments"];
            info.bRemind = [self ValidNumber:dict forKey:@"IsReminder" defaultValue:NO].boolValue;
            info.isCompleted = [self ValidNumber:dict forKey:@"IsCompleted" defaultValue:NO].boolValue;
            info.isSatisfied = [self ValidNumber:dict forKey:@"IsSatisfied" defaultValue:NO].boolValue;
            info.dateCC = [self ValidDate:dict forKey:@"CCDate"];
            info.datePlan = [self ValidDate:dict forKey:@"PlanDate"];
            info.dateRemind = [self ValidDate:dict forKey:@"ReminderDate"];
            info.customer = [self CreateCustomByDict:[dict objectForKey:@"CustomerData"]];
            info.userCaller = [self CreateUserDetailByDict:[dict objectForKey:@"UserDetailData"]];

            [array addObject:info];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetCourtesyCallInfoList:(NSString *)strStoreID Date:(NSDate *)date Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * strDate = [formatter stringFromDate:date];
    [dictAPI setObject:strDate forKey:@"Date"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"CourtesyCall/GetCourtesyCallByStoreId"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            CourtesyCallInfo * info = [[CourtesyCallInfo alloc] init];
            info.strID = [self ValidString:dict forKey:@"CourtesyCallInfoId"];
            info.strCourtesyCallTypeId = [self ValidString:dict forKey:@"CourtesyCallTypeId"];
            info.strTelephoneNo = [self ValidString:dict forKey:@"TelephoneNo"];
            info.strComment = [self ValidString:dict forKey:@"CCComments"];
            info.bRemind = [self ValidNumber:dict forKey:@"IsReminder" defaultValue:NO].boolValue;
            info.isCompleted = [self ValidNumber:dict forKey:@"IsCompleted" defaultValue:NO].boolValue;
            info.isSatisfied = [self ValidNumber:dict forKey:@"IsSatisfied" defaultValue:NO].boolValue;
            info.dateCC = [self ValidDate:dict forKey:@"CCDate"];
            info.datePlan = [self ValidDate:dict forKey:@"PlanDate"];
            info.dateRemind = [self ValidDate:dict forKey:@"ReminderDate"];
            info.customer = [self CreateCustomByDict:[dict objectForKey:@"CustomerData"]];
            info.userCaller = [self CreateUserDetailByDict:[dict objectForKey:@"UserDetailData"]];
            
            [array addObject:info];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)AddCourtesyCallInfo:(CourtesyCallInfo *)info Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:info.customer.strCustomerId forKey:@"CustomerId"];
    [dictAPI setObject:info.strCourtesyCallTypeId forKey:@"CourtesyCallTypeId"];
    [dictAPI setObject:info.strComment forKey:@"CCComments"];
    [dictAPI setObject:info.strTelephoneNo forKey:@"TelephoneNo"];
    [dictAPI setObject:[NSNumber numberWithBool:YES] forKey:@"IsSatisfied"];
    [dictAPI setObject:[NSNumber numberWithBool:info.isCompleted] forKey:@"IsCompleted"];
    [dictAPI setObject:[NSNumber numberWithBool:info.bRemind] forKey:@"IsReminder"];
    
    if (info.dateCC) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString * strDate = [formatter stringFromDate:info.dateCC];
        [dictAPI setObject:strDate forKey:@"CCDate"];
    }
    
    if (info.datePlan) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString * strDate = [formatter stringFromDate:info.datePlan];
        [dictAPI setObject:strDate forKey:@"PlanDate"];
    }
    
    if (info.dateRemind) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString * strDate = [formatter stringFromDate:info.dateRemind];
        [dictAPI setObject:strDate forKey:@"ReminderDate"];
    }
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"CourtesyCall/AddCourtesyCallInfo"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)EditCourtesyCallInfo:(CourtesyCallInfo *)info Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:info.strID forKey:@"CourtesyCallInfoId"];
    [dictAPI setObject:info.customer.strCustomerId forKey:@"CustomerId"];
    [dictAPI setObject:info.strCourtesyCallTypeId forKey:@"CourtesyCallTypeId"];
    [dictAPI setObject:info.strComment forKey:@"CCComments"];
    [dictAPI setObject:info.strTelephoneNo forKey:@"TelephoneNo"];
    [dictAPI setObject:[NSNumber numberWithBool:YES] forKey:@"IsSatisfied"];
    [dictAPI setObject:[NSNumber numberWithBool:info.isCompleted] forKey:@"IsCompleted"];
    [dictAPI setObject:[NSNumber numberWithBool:info.bRemind] forKey:@"IsReminder"];
    
    if (info.dateCC) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString * strDate = [formatter stringFromDate:info.dateCC];
        [dictAPI setObject:strDate forKey:@"CCDate"];
    }
    
    if (info.datePlan) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString * strDate = [formatter stringFromDate:info.datePlan];
        [dictAPI setObject:strDate forKey:@"PlanDate"];
    }
    
    if (info.dateRemind) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString * strDate = [formatter stringFromDate:info.dateRemind];
        [dictAPI setObject:strDate forKey:@"ReminderDate"];
    }
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"CourtesyCall/EditCourtesyCallInfo"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)DeleteCourtesyCallInfo:(NSString *)strCoutesyCallInfoId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strCoutesyCallInfoId forKey:@"CourtesyCallInfoId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"CourtesyCall/DeleteCourtesyCallInfo"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetCCPSubAccount:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Voip/GetCCPSubAccount"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        CCPSubAccount * account = [[CCPSubAccount alloc] init];
        account.strSubAccountSid = [self ValidString:dictResult forKey:@"subAccountSid"];
        account.strSubToken = [self ValidString:dictResult forKey:@"subToken"];
        account.strVoipAccount = [self ValidString:dictResult forKey:@"voipAccount"];
        account.strVoipPwd = [self ValidString:dictResult forKey:@"voipPwd"];
        account.strVoipToken = [self ValidString:dictResult forKey:@"voipToken"];
        SuccessBlock(account);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)CompleteVoipCall:(CCPVoipCall *)call Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (_bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:call.strVoipToken forKey:@"VoipToken"];
    [dictAPI setObject:call.strCourtesyCallId forKey:@"CCallId"];
    [dictAPI setObject:call.strCourtesyCallTypeId forKey:@"CCallTypeID"];
    [dictAPI setObject:call.strCustomerId forKey:@"CustomerID"];
    [dictAPI setObject:call.strTelephoneNo forKey:@"PhoneNo"];
    [dictAPI setObject:call.strRemark forKey:@"Remark"];
    [dictAPI setObject:[NSNumber numberWithInteger:call.nDuration] forKey:@"Duratiion"];
    [dictAPI setObject:[NSNumber numberWithInteger:call.typeThrough]  forKey:@"CallType"];
    [dictAPI setObject:[NSNumber numberWithInteger:call.bSuccess]  forKey:@"IsSuccess"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Voip/CompleteVoipCall"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}


-(void)GetCcInfoByStoreId:(NSString *)strStoreID Date:(NSDate *)date Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * strDate = [formatter stringFromDate:date];
    [dictAPI setObject:strDate forKey:@"Date"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"CourtesyCall/GetCcInfoByStoreId"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            CourtesyCallInfo * info = [[CourtesyCallInfo alloc] init];
            info.strID = [self ValidString:dict forKey:@"CourtesyCallInfoId"];
            info.strCourtesyCallTypeId = [self ValidString:dict forKey:@"CourtesyCallTypeId"];
            info.strTelephoneNo = [self ValidString:dict forKey:@"TelephoneNo"];
            info.strComment = [self ValidString:dict forKey:@"CCComments"];
            info.bRemind = [self ValidNumber:dict forKey:@"IsReminder" defaultValue:NO].boolValue;
            info.isCompleted = [self ValidNumber:dict forKey:@"IsCompleted" defaultValue:NO].boolValue;
            info.isSatisfied = [self ValidNumber:dict forKey:@"IsSatisfied" defaultValue:NO].boolValue;
            info.dateCC = [self ValidDate:dict forKey:@"CCDate"];
            info.datePlan = [self ValidDate:dict forKey:@"PlanDate"];
            info.dateRemind = [self ValidDate:dict forKey:@"ReminderDate"];
            info.customer = [self CreateCustomByDict:[dict objectForKey:@"CustomerData"]];
            info.userCaller = [self CreateUserDetailByDict:[dict objectForKey:@"UserDetailData"]];
            
            info.strRecordUrl = [self ValidString:dict forKey:@"RecordUrl"];
            info.typeThrough = [self ValidNumber:dict forKey:@"CallType" defaultValue:0].integerValue;
            info.bSuccess = [self ValidNumber:dict forKey:@"IsSuccess" defaultValue:NO].boolValue;
            info.nDuration = [self ValidNumber:dict forKey:@"Duration" defaultValue:0].integerValue;
            
            [array addObject:info];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

#pragma mark Training
-(void)GetTraningFolderDocsSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Common/QueryAttachments"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            TrainingFolder * folder = [[TrainingFolder alloc] init];
            folder.strFolderName = [self ValidString:dict forKey:@"AttachmentType"];
            folder.arrayDoc = [[NSMutableArray alloc] init];
            
            NSMutableArray * arrayDoc = [dict objectForKey:@"Attachments"];
            for (NSDictionary * dictDoc in arrayDoc) {
                TrainingDoc * doc = [[TrainingDoc alloc] init];
                doc.strID = [self ValidString:dictDoc forKey:@"AttachmentId"];
                doc.strFileName = [self ValidString:dictDoc forKey:@"AttachmentName"];
                doc.strCreator = [self ValidString:dictDoc forKey:@"Creator"];
                doc.strDate = [self ValidString:dictDoc forKey:@"AddDate"];
                doc.strUrl = [self ValidString:dictDoc forKey:@"AthUrl"];
                doc.dbSize = [self ValidNumber:dictDoc forKey:@"FileSize" defaultValue:0].doubleValue;
                [folder.arrayDoc addObject:doc];
            }
            [array addObject:folder];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

#pragma mark Live Video
-(void)GetLiveCameraList:(NSString *)strStoreID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
     [dictAPI setObject:strStoreID forKey:@"StoreId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Store/GetStoreCamera"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in arrayResult) {
            LiveCamera * cam = [[LiveCamera alloc] init];
            cam.strID = [self ValidString:dict forKey:@"CameraId"];
            cam.strCameraName = [self ValidString:dict forKey:@"CameraName"];
            cam.strLiveURL = [self ValidString:dict forKey:@"CameraUrl"];
            [array addObject:cam];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

#pragma mark Goods Tracking
-(void)GetGoodsTrackingInfo:(NSString *)strCode Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strCode forKey:@"ProNo"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"Product/GetProTraceInfo"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        if (dictResult) {
            GoodsTrackingInfo * info = [[GoodsTrackingInfo alloc] init];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"yyyy/MM/dd"];
            info.strDate = [dateformatter stringFromDate:[NSDate date]];
            info.strID = [RPSDK genUUID];
            info.strCode = [self ValidString:dictResult forKey:@"ProNo"];
            info.strDetail = [self ValidString:dictResult forKey:@"ProDesc"];
            SuccessBlock(info);
            return;
        }
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(BOOL)InsertGoodsTrackingInfo:(GoodsTrackingInfo *)info
{
   return [[RPBDataBase defaultInstance] InsertGoodsTracking:self.userLoginDetail.strUserId Tracking:info];
}

-(BOOL)DeleteGoodsTrackingInfo:(NSString *)strTrackingID
{
    return [[RPBDataBase defaultInstance] DeleteGoodTracking:self.userLoginDetail.strUserId TrackingID:strTrackingID];
}

-(NSArray *)GetGoodsTrackingList:(NSString *)strFilter
{
    return [[RPBDataBase defaultInstance] GetGoodsTrackingList:self.userLoginDetail.strUserId Filter:strFilter];
}

#pragma mark Retail Consulting
-(void)UploadRetailConsult:(NSString *)strDetail Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:strDetail forKey:@"Content"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"RetailConsul/UploadConsul"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}
@end
