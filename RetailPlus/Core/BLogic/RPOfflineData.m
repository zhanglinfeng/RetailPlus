//
//  RPOfflineData.m
//  RetailPlus
//
//  Created by lin dong on 13-10-25.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import "pinyin.h"
#import "RPOfflineData.h"
#import "RPBDataBase.h"

@implementation RPOfflineData

static RPOfflineData *defaultObject;
extern NSBundle * g_bundleResorce;

+(RPOfflineData *)defaultInstance
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
    self = [super init];
    if (self) {
        NSString * strPath = [g_bundleResorce pathForResource:@"OfflineData" ofType:@"sqlite"];
        _dbPointer = [[PLSqliteDatabase alloc] initWithPath:strPath];
        if (_dbPointer) {
            if ([_dbPointer open]) {
                return self;
            }
        }
    }
    return nil;
}

-(UserDetailInfo *)ColleageFromDataSet:(id<PLResultSet>)ds
{
    UserDetailInfo * colleague = [[UserDetailInfo alloc] init];
    colleague.strUserId = [ds objectForColumn:@"ID"];
    colleague.strFirstName = [ds objectForColumn:@"FirstName"];
//    colleague.strSurName = [ds objectForColumn:@"SurName"];
    colleague.strPortraitImg = [NSString stringWithFormat:@"%@/Base.lproj/%@",[[NSBundle mainBundle]resourcePath],[ds objectForColumn:@"Image"]];
    colleague.strPortraitImgBig = colleague.strPortraitImg;
    colleague.strUserAcount = [ds objectForColumn:@"Name"];
    colleague.sex = ((NSNumber *)[ds objectForColumn:@"sex"]).integerValue;
    colleague.rank = ((NSNumber *)[ds objectForColumn:@"Level"]).integerValue;
    colleague.strBirthDate = @"12-23";
    colleague.nBirthYear = 1980;
    colleague.strRoleName = @"Brand Manager";
    
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
    
    return colleague;
}

-(void)Login:(NSString *)strUserName PassWord:(NSString *)strPassWord success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock
{
    NSString * strSql = [NSString stringWithFormat:@"select  count(*) as count from Colleague where name = '%@' and password = '%@'",strUserName,strPassWord];
    
    id<PLResultSet> ds = [_dbPointer executeQuery:strSql];
    if ([ds next]) {
        NSNumber * num = [ds objectForColumn:@"count"];
        if (num.integerValue == 1)
        {
            successBlock(nil);
            return;
        }
    }
    
    failedBlock(-1,nil);
    return;
}

-(void)GetUserInfo:(NSString *)strUserID success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock
{
    NSString * strSql = [NSString stringWithFormat:@"select  * from Colleague where Name = '%@'",strUserID];
    id<PLResultSet> ds = [_dbPointer executeQuery:strSql];
    if ([ds next]) {
        UserDetailInfo * colleague = [self ColleageFromDataSet:ds];
        successBlock(colleague);
        return;
    }
    failedBlock(-1,nil);
    return;
}

-(void)GetStoreList:(BOOL)bOwn Success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock
{
    NSString * strSql = [NSString stringWithFormat:@"select  * from store"];
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    id<PLResultSet> ds = [_dbPointer executeQuery:strSql];
    while ([ds next]) {
        StoreDetailInfo * store = [[StoreDetailInfo alloc] init];
        store.strStoreId = [ds objectForColumn:@"ID"];

        NSString * strSql2 = [NSString stringWithFormat:@"select count(*) as count from ReColleagueStore where StoreID = '%@' and ColleagueID = '%@'",store.strStoreId,[RPSDK defaultInstance].userLoginDetail.strUserId];
        id<PLResultSet> ds2 = [_dbPointer executeQuery:strSql2];
        if ([ds2 next]) {
            NSNumber * num = [ds2 objectForColumn:@"count"];
            if (num.integerValue > 0) {
                store.isOwn = YES;
            }
        }
        
        if (bOwn && !store.isOwn){
            continue;
        }
        
        store.strStoreName = [ds objectForColumn:@"Name"];
        store.strBrandName = [ds objectForColumn:@"BrandName"];
        store.isPerfect = YES;
        store.strShopMap =  [NSString stringWithFormat:@"%@/Base.lproj/%@",[[NSBundle mainBundle]resourcePath],[ds objectForColumn:@"Map"]];
        store.strStoreThumb =  [NSString stringWithFormat:@"%@/Base.lproj/%@",[[NSBundle mainBundle]resourcePath],[ds objectForColumn:@"Thumb"]];
        store.strStoreThumbBig = store.strStoreThumb;
        
        store.strStoreAddress = [ds objectForColumn:@"Address"];
//        store.nStartTime = ((NSNumber *)[ds objectForColumn:@"StartTime"]).integerValue;
//        store.nEndTime = ((NSNumber *)[ds objectForColumn:@"EndTime"]).integerValue;
        store.strStartTime = @"09:30";
        store.strEndTime = @"22:00";
        
        store.strArea = [ds objectForColumn:@"Area"];
        store.strAreaSquare = [ds objectForColumn:@"AreaSquare"];
        store.strPhone = [ds objectForColumn:@"Phone"];
        store.strFax = [ds objectForColumn:@"Fax"];
        store.strEmail = [ds objectForColumn:@"Email"];
        
        [array addObject:store];
    }
    
    successBlock(array);
    return;
}

-(void)GetCustomerSuccess:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock
{
    NSString * strSql = [NSString stringWithFormat:@"select * from ReColleageCustomer as a,Customer as b where a.CustomerID = b.ID and a.ColleagueID = '%@'",[RPSDK defaultInstance].userLoginDetail.strUserId];
    id<PLResultSet> ds = [_dbPointer executeQuery:strSql];
    NSMutableArray * array = [[NSMutableArray alloc] init];
    while ([ds next]) {
        Customer * customer = [[Customer alloc] init];
        customer.strFirstName = [ds objectForColumn:@"FirstName"];
//        customer.strSurName = [ds objectForColumn:@"SurName"];
        customer.strCustImg = [NSString stringWithFormat:@"%@/Base.lproj/%@",[[NSBundle mainBundle]resourcePath],[ds objectForColumn:@"Image"]];
        customer.strCustImgBig = customer.strCustImg;
        customer.strCustomerId = [ds objectForColumn:@"ID"];
        customer.strAddress = [ds objectForColumn:@"Address"];
        customer.strBirthDate = @"12-25";
        customer.nBirthYear = 1982;
        customer.strEmail = [ds objectForColumn:@"Email"];
        customer.strDistrict = [ds objectForColumn:@"District"];
        customer.strPhone1 = [ds objectForColumn:@"Phone1"];
        customer.strPhone2 = [ds objectForColumn:@"Phone2"];
        customer.isVip = ((NSNumber *)[ds objectForColumn:@"isVip"]).boolValue;
        customer.sex = ((NSNumber *)[ds objectForColumn:@"Sex"]).boolValue;
        
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
        
        [array addObject:customer];
    }
    successBlock(array);
}

-(void)GetColleagueCountSuccess:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock
{
    UserRankCount * state = [[UserRankCount alloc] init];
    
    for (NSInteger n = 0; n < 4; n ++) {
        NSString * strSql = [NSString stringWithFormat:@"select  count(*) as count from Colleague where Level = %d",n + 1];
        
        id<PLResultSet> ds = [_dbPointer executeQuery:strSql];
        if ([ds next]) {
            NSNumber * num = [ds objectForColumn:@"count"];
            if (num.integerValue > 0)
            {
                switch (n + 1) {
                    case 1:
                        state.nCountManager = num.integerValue;
                        break;
                    case 2:
                        state.nCountStoreManager = num.integerValue;
                        break;
                    case 3:
                        state.nCountAssistant = num.integerValue;
                        break;
                    case 4:
                        state.nCountVendor = num.integerValue;
                        break;
                    default:
                        break;
                }
            }
        }
    }
    successBlock(state);
    return;
}

-(void)GetColleague:(NSInteger)nRoleLevel success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
 
    NSString * strSql = [NSString stringWithFormat:@"select  * from Colleague where Level = %d",nRoleLevel];
    id<PLResultSet> ds = [_dbPointer executeQuery:strSql];
    while ([ds next]) {
        UserDetailInfo * colleague = [self ColleageFromDataSet:ds];
        [array addObject:colleague];
    }
    
    successBlock(array);
}

-(void)GetMCReports:(NSString *)strReportID success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock
{
     NSMutableArray * array = [[NSMutableArray alloc] init];
    
    if ([strReportID isEqualToString:@"0"])
    {
        MCReport * report = [[MCReport alloc] init];
        
        report.strReportID = @"1";
        report.strReportName = @"GuggieInspectionReport.pdf";
        report.strReportType = @"Inspection Report";
        report.strReportUrl = [NSString stringWithFormat:@"%@/Base.lproj/%@",[[NSBundle mainBundle]resourcePath],@"inspreport.pdf"];
        NSString * strDate = @"2013-10-28 11:10:00";
        if (strDate && (id)strDate != [NSNull null]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            report.dateReport = [[NSDate alloc] init];
            report.dateReport = [formatter dateFromString:strDate];
        }
        
        
        report.strSenderID = @"0";
        report.strSenderName = @"ivy";
        report.rank = 1;
        report.strImgPic = [NSString stringWithFormat:@"%@/Base.lproj/%@",[[NSBundle mainBundle]resourcePath],@"c0.jpg"];
        
        [array addObject:report];
    }
    successBlock(array);
}

-(void)GetInspCatagory:(NSString *)strStoreID success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock
{
    NSString * strSql = [NSString stringWithFormat:@"select  * from ReStoreVendor as a,Vendor as b where a.storeid = '%@' and a.vendorid = b.id",strStoreID];
    
    InspData * data = [[InspData alloc] init];
    data.arrayInsp = [[NSMutableArray alloc] init];
    
    
    id<PLResultSet> ds = [_dbPointer executeQuery:strSql];
    while ([ds next]) {
        InspVendor * vendor = [[InspVendor alloc] init];
        vendor.strVendorID = [ds objectForColumn:@"ID"];
        vendor.strVendorName = [ds objectForColumn:@"Name"];
        vendor.strAssetType = [ds objectForColumn:@"Type"];
        vendor.arrayCatagory = [[NSMutableArray alloc] init];
        
        NSString * strSql = [NSString stringWithFormat:@"select  * from InspCategory where vendorid = '%@'",vendor.strVendorID];
        id<PLResultSet> ds2 = [_dbPointer executeQuery:strSql];
        while ([ds2 next])  {
            InspCatagory * catagory = [[InspCatagory alloc] init];
            catagory.strCatagoryDesc = [ds2 objectForColumn:@"Desc"];
            catagory.strCatagoryID = [ds2 objectForColumn:@"ID"];
            catagory.strCatagoryName = [ds2 objectForColumn:@"Name"];
            
            NSString * strUnit = [ds2 objectForColumn:@"Unit"];
            NSNumber * num = [ds2 objectForColumn:@"Quantity"];
            if (num && (id)num != [NSNull null] && num.integerValue > 0) {
                catagory.strCatagoryDesc = [NSString stringWithFormat:@"%@(%d %@)",catagory.strCatagoryDesc,num.integerValue,strUnit];
            }
            
            [vendor.arrayCatagory addObject:catagory];
        }
        
        [data.arrayInsp addObject:vendor];
    }
    successBlock(data);
    
    return;
}

-(void)GetInspReports:(NSString *)strStoreID success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    InspReportResult * data = [[InspReportResult alloc] init];
    data.arrayDetail = [[NSMutableArray alloc] init];
    data.strResultID = @"1";
    data.strStoreName = @"";
    data.strBrandName = @"Guggie";
    data.strInspctor = @"Ivy";
    data.strInspectionDate = @"2013-10-28";
    data.arrayDetail = [[NSMutableArray alloc] init];
    data.bSelected = NO;
    
    InspReportResultDetail * rsDetail = [[InspReportResultDetail alloc] init];
    rsDetail.strCatagoryID = @"1";
    rsDetail.mark = MARK_1;
    rsDetail.arrayIssue = [[NSMutableArray alloc] init];
    
    InspIssue * issue = [[InspIssue alloc] init];
    issue.strIssueDesc = @"空调有点漏水，见图";
    issue.strIssueID = @"1";
    issue.strIssueTitle = @"空调漏水";
    issue.bHasLocation = YES;
    issue.ptLocation = CGPointMake(130, 80);
    issue.arrayIssueImg = [NSMutableArray arrayWithArray:@[[[InspIssueImage alloc] init],[[InspIssueImage alloc] init], [[InspIssueImage alloc] init]]];
    InspIssueImage * issueImage = [[InspIssueImage alloc] init];
    issueImage.imgIssue = [UIImage imageNamed:@"i1.jpg"];
    issueImage.rcIssue = CGRectMake(200, 300, 100, 100);
    [issue.arrayIssueImg replaceObjectAtIndex:0 withObject:issueImage];
    
    [rsDetail.arrayIssue addObject:issue];
    
    [data.arrayDetail addObject:rsDetail];
    [array addObject:data];
    
    successBlock(array);
}

-(void)GetVendors:(NSString *)strStoreID success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock
{
    NSString * strSql = [NSString stringWithFormat:@"select  * from ReStoreVendor as a,Vendor as b where a.storeid = '%@' and a.vendorid = b.id",strStoreID];
    
    NSMutableArray * arrayVendor = [[NSMutableArray alloc] init];
    
    id<PLResultSet> ds = [_dbPointer executeQuery:strSql];
    while ([ds next]) {
        Vendor * vendor = [[Vendor alloc] init];
        vendor.strVendorID = [ds objectForColumn:@"ID"];
        vendor.strVendorName = [ds objectForColumn:@"Name"];
        vendor.strAssetType = [ds objectForColumn:@"Type"];
        [arrayVendor addObject:vendor];
    }
    
    successBlock(arrayVendor);
    return;
}

-(void)GetUserListByVendor:(NSString *)strVendorID success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock
{
    NSMutableArray * arrayUser = [[NSMutableArray alloc] init];
    NSString * strSql2 = [NSString stringWithFormat:@"select * from ReVendorColleague as a,Colleague as b where a.ColleagueID = b.ID and a.VendorID = '%@'",strVendorID];
    id<PLResultSet> ds2 = [_dbPointer executeQuery:strSql2];
    while ([ds2 next]) {
        UserDetailInfo *  user = [self ColleageFromDataSet:ds2];
        
        [arrayUser addObject:user];
    }
    successBlock(arrayUser);
    return;
}


-(void)GetMaintenStoreColleague:(NSString *)strStoreID success:(RPRuntimeOfflineSuccess)successBlock failed:(RPRuntimeOfflineFailed)failedBlock
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSString * strSql = [NSString stringWithFormat:@"select  * from ReColleagueStore as a,Colleague as b where a.StoreID = '%@' and a.ColleagueID = b.ID",strStoreID];
    id<PLResultSet> ds = [_dbPointer executeQuery:strSql];
    while ([ds next]) {
        MaintenContact * contact = [[MaintenContact alloc] init];
        contact.strPhone = [ds objectForColumn:@"Name"];
        contact.strUserName = [NSString stringWithFormat:@"%@",[ds objectForColumn:@"FirstName"]];
        
        [array addObject:contact];
    }
    successBlock(array);
}
@end
