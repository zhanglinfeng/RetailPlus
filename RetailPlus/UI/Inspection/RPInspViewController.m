//
//  RPInspViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-8-19.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "RPInspViewController.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"

extern NSBundle * g_bundleResorce;

@interface RPInspViewController ()

@end

@implementation RPInspViewController

@synthesize storeSelected = _storeSelected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    NSArray *array = [g_bundleResorce loadNibNamed:@"CustomView" owner:self options:nil];
    _viewStoreList = [array objectAtIndex:1];
    _viewStoreList.delegate = self;
    _viewStoreList.sitType = SituationType_Inspection;
    
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"BOUTIQUE HANDOVER",@"RPString", g_bundleResorce,nil);
    
//    CALayer *sublayer = _btnGo.layer;
//    sublayer.shadowOffset = CGSizeMake(0, 1);
//    sublayer.shadowRadius =3.0;
//    sublayer.shadowColor =[UIColor blackColor].CGColor;
//    sublayer.shadowOpacity =0.5;
//    
//    sublayer = _btnHistory.layer;
//    sublayer.shadowOffset = CGSizeMake(0, 1);
//    sublayer.shadowRadius =3.0;
//    sublayer.shadowColor =[UIColor blackColor].CGColor;
//    sublayer.shadowOpacity =0.5;
//    
//    sublayer = _btnSelectStore.layer;
//    sublayer.cornerRadius = 4;
//    sublayer.borderColor = [UIColor lightGrayColor].CGColor;
//    sublayer.borderWidth = 1;
//    
//    sublayer = _btnRectify.layer;
//    sublayer.shadowOffset = CGSizeMake(0, 1);
//    sublayer.shadowRadius =3.0;
//    sublayer.shadowColor =[UIColor blackColor].CGColor;
//    sublayer.shadowOpacity =0.5;
//    
//    sublayer = _viewFrame.layer;
//    sublayer.cornerRadius = 6;
    
    _step = INSPSTEP_STOREDETAIL;
    
    _viewDetail.vcFrame = self.vcFrame;
    _viewDetail.delegate = self;
    
    array = [g_bundleResorce loadNibNamed:@"RPStoreCardView" owner:self options:nil];
    _viewStoreCard = [array objectAtIndex:0];
    CGSize szScreen = [[UIScreen mainScreen] bounds].size;
    _viewStoreCard.frame = CGRectMake(8, 15, 304, szScreen.height - 125);
    _viewStoreCard.delegate = self;
    [self.view insertSubview:_viewStoreCard belowSubview:_viewBottom];
    [_viewStoreCard Hide:YES];
    
    _bModified = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    [self OnSelectedStore:storeSelected];
}

-(void)OnSelectedStore:(StoreDetailInfo *)store
{
    [self dismissView:_viewStoreList];
    _step = INSPSTEP_STOREDETAIL;
    
    if ([store.strStoreId isEqualToString:_storeSelected.strStoreId]) return;
    
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTableInBundle(@"Please wait...",@"RPString", g_bundleResorce,nil)];
    
    _storeSelected = store;
    _dataInsp = [[InspData alloc] init];
    NSString * strShopMap = store.strShopMap;
    
    
    _dataInsp.arrayInsp = [[NSMutableArray alloc] init];
    //_imgStore.image = store.imageThumb;
    //[_imgStore setImageWithURL:[NSURL URLWithString:[store.strImageThumbBig stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    //[_btnSelectStore setTitle:store.strStoreName forState:UIControlStateNormal];
    //_lbAddress.text = store.strStoreAddress;
    
    [[RPSDK defaultInstance] GetAssetCategoryList:store.strStoreId
    Success:^(InspData * data) {
        _dataInsp = data;
        _dataInsp.strImgShopUrl = strShopMap;
        
        _dataInsp.reporters = [[InspReporters alloc] init];
        
        _dataInsp.reporters.arraySection = [[NSMutableArray alloc] init];
        InspReporterSection * section = [[InspReporterSection alloc] init];
        
        section.strTitle1 = [NSString stringWithFormat:@"%@ %@",store.strStoreName,store.strBrandName];

        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"dd-MM-yyyy"];
        section.strTitle2 = [NSString stringWithFormat:@"%@,by %@",[dateformatter stringFromDate:[NSDate date]],[RPSDK defaultInstance].userLoginDetail.strFirstName];
        
        section.arrayUser = [[NSMutableArray alloc] init];
        
        InspReporterUser * user = [[InspReporterUser alloc] init];
        user.bSelected = YES;
        user.bUserCollegue = YES;
        user.collegue = [RPSDK defaultInstance].userLoginDetail;
        [section.arrayUser addObject:user];
        
        [_dataInsp.reporters.arraySection addObject:section];
        
//        NSMutableArray * arrayCache = [[RPSDK defaultInstance] GetTaskCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_INSPECTION];
//        if (arrayCache)
//        {
//            for (InspCatagory * catagoryCache in arrayCache) {
//                for (InspVendor * vendor in _dataInsp.arrayInsp) {
//                    BOOL bFound = NO;
//                    for (InspCatagory * catagory in vendor.arrayCatagory) {
//                        if ([catagory.strCatagoryID isEqualToString:catagoryCache.strCatagoryID]) {
//                            catagory.markCatagory = catagoryCache.markCatagory;
//                            catagory.arrayIssue = catagoryCache.arrayIssue;
//                            bFound = YES;
//                            break;
//                        }
//                    }
//                    if (bFound) break;
//                }
//            }
//        }
        
        [SVProgressHUD dismiss];
    }
    Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
    
    _viewStoreCard.store = _storeSelected;
}

-(IBAction)OnSelectStore:(id)sender
{
    _viewStoreList.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    _viewStoreList.tfSearch.text=@"";
    [self.view insertSubview:_viewStoreList belowSubview:_viewBottom];
    
    [UIView beginAnimations:nil context:nil];
    _viewStoreList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    [_viewStoreList reloadStore];
    
    _step = INSPSTEP_SELECTSHOP;
}

-(void)ShowDetail
{
    _viewDetail.storeSelected = _storeSelected;
    _viewDetail.dataInsp = _dataInsp;
    
    _viewDetail.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:_viewDetail];
    
    [UIView beginAnimations:nil context:nil];
    _viewDetail.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    _step = INSPSTEP_DETAIL;
}

-(IBAction)OnInspDetail:(id)sender
{
    if (_storeSelected == nil) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No Store Selected",@"RPString", g_bundleResorce,nil)];
        return;
    }
    
    if (_dataInsp == nil || _dataInsp.arrayInsp == nil || _dataInsp.arrayInsp.count == 0) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"No Inspection Data Existed",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
        return;
    }
    //判断是否整改过，如果整改过则清理整改数据，改为验收
    if (_viewDetail.bInspectReport == NO) {
        _dataInsp.reporters = [[InspReporters alloc] init];
        
        _dataInsp.reporters.arraySection = [[NSMutableArray alloc] init];
        InspReporterSection * section = [[InspReporterSection alloc] init];
        
        section.strTitle1 = [NSString stringWithFormat:@"%@ %@",_storeSelected.strStoreName,_storeSelected.strBrandName];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"dd-MM-yyyy"];
        section.strTitle2 = [NSString stringWithFormat:@"%@,by %@",[dateformatter stringFromDate:[NSDate date]],[RPSDK defaultInstance].userLoginDetail.strFirstName];
        
        section.arrayUser = [[NSMutableArray alloc] init];
        
        InspReporterUser * user = [[InspReporterUser alloc] init];
        user.bSelected = YES;
        user.bUserCollegue = YES;
        user.collegue = [RPSDK defaultInstance].userLoginDetail;
        [section.arrayUser addObject:user];
        
        [_dataInsp.reporters.arraySection addObject:section];
        
        for (InspVendor * vendor in _dataInsp.arrayInsp)
        {
            for (InspCatagory * catagory in vendor.arrayCatagory) {
                catagory.markCatagory = MARK_NONE;
                catagory.arrayIssue = [[NSMutableArray alloc] init];
            }
        }
    }
    
    //读取验收数据
    InspData * data = [[RPSDK defaultInstance] GetTaskCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_INSPECTION];
    _dataInsp.mark = data.mark;
    _dataInsp.strDesc = data.strDesc;
    
    NSMutableArray * arrayCache = data.arrayInsp;
    if (arrayCache)
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Existing cache,if you continue, the cache will be empty",@"RPString", g_bundleResorce,nil);
        NSString * strOK = NSLocalizedStringFromTableInBundle(@"CONTINUE",@"RPString", g_bundleResorce,nil);
        NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1)//清掉验收数据
            {
                [[RPSDK defaultInstance]ClearCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_INSPECTION];
                
                for (InspVendor * vendor in _dataInsp.arrayInsp)
                {
                    for (InspCatagory * catagory in vendor.arrayCatagory) {
                        catagory.markCatagory = MARK_NONE;
                        catagory.arrayIssue = [[NSMutableArray alloc] init];
                    }
                }
                //清掉界面内存数据
                _dataInsp.mark = MARK_NONE;
                _dataInsp.strDesc = @"";
                
                _bModified = YES;
                _viewDetail.bInspectReport = YES;
                [self ShowDetail];
            }
        } otherButtonTitles:strOK,nil];
        [alertView show];
    }
    else
    {
        _bModified = YES;
        _viewDetail.bInspectReport = YES;
        [self ShowDetail];
    }
}

-(IBAction)OnInspReports:(id)sender
{
    if (_storeSelected == nil) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No Store Selected",@"RPString", g_bundleResorce,nil)];
        return;
    }
    
    if ([RPRights hasRightsFunc:_storeSelected.llRights type:RPRightsFuncType_SubmitRectifyReport])
    {
        _viewReports.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        _viewReports.delegate = self;
        
        [self.view addSubview:_viewReports];
        
        [UIView beginAnimations:nil context:nil];
        _viewReports.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [_viewReports GetReports:_storeSelected];
        [UIView commitAnimations];
        _step = INSPSTEP_REPORTS;
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
    }
}

-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}

-(void)OnCombineReportsEnd:(NSArray *)arrayReportsDetail
{
    _bModified = YES;
    
    [self dismissView:_viewReports];
    _step = INSPSTEP_STOREDETAIL;
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd-MM-yyyy"];
    
//    RPInspReporterSection * sectionAll = [[RPInspReporterSection alloc] init];
//    sectionAll.strTitle1 = [NSString stringWithFormat:@"%@ %@ Rectifying Report_Overall",_storeSelected.strStoreName,_storeSelected.strBrandName];
//

//    sectionAll.strTitle2 = [NSString stringWithFormat:@"%@,by %@ %@",[dateformatter stringFromDate:[NSDate date]],[RPBLogic defaultInstance].colleagueLoginUser.strFirstName,[RPBLogic defaultInstance].colleagueLoginUser.strSurName];
//    sectionAll.arrayUser = [[NSMutableArray alloc] init];
//    
//    RPInspReporterUser * user = [[RPInspReporterUser alloc] init];
//    user.bSelected = YES;
//    user.bUserCollegue = YES;
//    user.collegue = [RPBLogic defaultInstance].colleagueLoginUser;
//    [sectionAll.arrayUser addObject:user];
    
    _repRectify = [[InspReporters alloc] init];
    _repRectify.arraySection = [[NSMutableArray alloc] init];
    
    for (InspVendor * vendor in _dataInsp.arrayInsp)
    {
        for (InspCatagory * category in vendor.arrayCatagory)
        {
            category.arrayIssue = [[NSMutableArray alloc] init];
            category.markCatagory = MARK_NONE;
            
            for (InspReportResultDetail * detail in arrayReportsDetail) {
                if ([category.strCatagoryID isEqualToString:detail.strCatagoryID]) {
                    category.arrayIssue = detail.arrayIssue;
                    category.markCatagory = detail.mark;
                    break;
                }
            }
        }

        InspReporterSection * section = [[InspReporterSection alloc] init];
        section.strTitle1 = [NSString stringWithFormat:@"%@ %@ Rectifying Report_%@",_storeSelected.strStoreName,_storeSelected.strBrandName,vendor.strVendorName];
        section.strTitle2 = [NSString stringWithFormat:@"%@,by %@",[dateformatter stringFromDate:[NSDate date]],[RPSDK defaultInstance].userLoginDetail.strFirstName];
        section.strVendorID = vendor.strVendorID;
        section.arrayUser = [[NSMutableArray alloc] init];
        
        InspReporterUser * user = [[InspReporterUser alloc] init];
        user.bSelected = YES;
        user.bUserCollegue = YES;
        user.collegue = [RPSDK defaultInstance].userLoginDetail;
        [section.arrayUser addObject:user];
        
        [[RPSDK defaultInstance] GetUserListByVendor:SituationType_Inspection VendorID:vendor.strVendorID Success:^(NSArray * arrayUser) {
            for (UserDetailInfo * colleague in arrayUser) {
                InspReporterUser * user = [[InspReporterUser alloc] init];
                user.bSelected = YES;
                user.bUserCollegue = YES;
                user.collegue = colleague;
                [section.arrayUser addObject:user];
            }
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
        
        [_repRectify.arraySection addObject:section];
    }
    
 //   [_dataInsp.reporters.arraySection insertObject:sectionAll atIndex:0];
    
    _viewDetail.bInspectReport = NO;
    _viewDetail.repRectify = _repRectify;
    
    [self ShowDetail];
}

-(BOOL)OnBack
{
    [SVProgressHUD dismiss];
    if (_bConfirmQuit) {
        return YES;
    }
    
    switch (_step) {
        case INSPSTEP_DETAIL:
            if ([_viewDetail OnBack]) {
                [self dismissView:_viewDetail];
                _step = INSPSTEP_STOREDETAIL;
            }
            break;
        case INSPSTEP_SELECTSHOP:
            [_viewStoreList dismiss];
            [self dismissView:_viewStoreList];
            _step = INSPSTEP_STOREDETAIL;
            break;
        case INSPSTEP_REPORTS:
            [self dismissView:_viewReports];
            _step = INSPSTEP_STOREDETAIL;
            break;
        default:
        {
            if (!_bModified) {
                _bConfirmQuit = YES;
                [self.delegate OnTaskEnd];
            }
            else
            {
                NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Current data will be erased!\r\nConfirm to exit boutique handover?",@"RPString", g_bundleResorce,nil);
                NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
                NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
                
                RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
                    if (indexButton == 1) {
                        _bConfirmQuit = YES;
                        [self.delegate OnTaskEnd];
                    }
                } otherButtonTitles:strOK,nil];
                [alertView show];
            }
        }
            return NO;
            break;
    };
    return NO;
}

-(void)OnRectifyEnd
{
    [self dismissView:_viewDetail];
    _step = INSPSTEP_STOREDETAIL;
    _bModified = NO;
}

-(void)OnInspEnd
{
    [self dismissView:_viewDetail];
    _step = INSPSTEP_STOREDETAIL;
    _bConfirmQuit = YES;
    [self.delegate OnTaskEnd];
}

-(void)OnSelectStore
{
    _viewStoreList.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    _viewStoreList.tfSearch.text=@"";
    [self.view insertSubview:_viewStoreList belowSubview:_viewBottom];
    
    [UIView beginAnimations:nil context:nil];
    _viewStoreList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    [_viewStoreList reloadStore];
    
    _step = INSPSTEP_SELECTSHOP;
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self.view];
}

- (IBAction)OnContinue:(id)sender
{
    InspData * data = [[RPSDK defaultInstance] GetTaskCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_INSPECTION];
    _dataInsp.mark = data.mark;
    _dataInsp.strDesc = data.strDesc;
    
    NSMutableArray * arrayCache = data.arrayInsp;
    if (arrayCache)
    {
        for (InspCatagory * catagoryCache in arrayCache) {
            for (InspVendor * vendor in _dataInsp.arrayInsp) {
                BOOL bFound = NO;
                for (InspCatagory * catagory in vendor.arrayCatagory) {
                    if ([catagory.strCatagoryID isEqualToString:catagoryCache.strCatagoryID]) {
                        catagory.markCatagory = catagoryCache.markCatagory;
                        catagory.arrayIssue = catagoryCache.arrayIssue;
                        bFound = YES;
                        break;
                    }
                }
                if (bFound) break;
            }
        }
        _bModified = YES;
        _viewDetail.bInspectReport = YES;
        [self ShowDetail];
    }
    else
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"This store have no unfinished report",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:strDesc];
    }

}
@end
