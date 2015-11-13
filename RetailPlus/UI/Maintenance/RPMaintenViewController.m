//
//  RPMaintenViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-9-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPMaintenViewController.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

@interface RPMaintenViewController ()

@end

@implementation RPMaintenViewController
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
    _viewStoreList.sitType = SituationType_Maintenance;
    
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"BOUTIQUE MAINTENANCE",@"RPString", g_bundleResorce,nil);
    
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
//    sublayer = _viewFrame.layer;
//    sublayer.cornerRadius = 6;
    
    _step = MAINTEN_STOREDETAIL;
    
    _viewDetail.vcFrame = self.vcFrame;
    _viewDetail.delegate = self;
    
    _dataMainten = [[MaintenanceData alloc] init];
    
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


-(void)OnMaintenEnd
{
    [self dismissView:_viewDetail];
    _step = MAINTEN_STOREDETAIL;
    _bConfirmQuit = YES;
    [self.delegate OnTaskEnd];
}

-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}

-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    [self OnSelectedStore:storeSelected];
}

-(void)OnSelectedStore:(StoreDetailInfo *)store
{
    [self dismissView:_viewStoreList];
    _step = MAINTEN_STOREDETAIL;
    
    if ([store.strStoreId isEqualToString:_storeSelected.strStoreId]) return;
    
    _storeSelected = store;
    
    _dataMainten.arrayIssue = [[NSMutableArray alloc] init];
    _dataMainten.strImgShopUrl = store.strShopMap;
    
    [_imgStore setImageWithURLString:store.strStoreThumbBig];
    
    [_btnSelectStore setTitle:store.strStoreName forState:UIControlStateNormal];
    _lbAddress.text = store.strStoreAddress;

    _arrayContact = _arrayVendor = nil;
    
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTableInBundle(@"Please wait...",@"RPString", g_bundleResorce,nil)];
    
    [[RPSDK defaultInstance] GetStoreMntUserList:_storeSelected.strStoreId Success:^(NSMutableArray * arrayResult){
        _arrayContact = arrayResult;
        
        [[RPSDK defaultInstance] GetVendorList:_storeSelected.strStoreId SituationType:SituationType_Maintenance Success:^(NSArray * arrayVendor){
            _arrayVendor = [[NSMutableArray alloc] initWithArray:arrayVendor];
            _dataMainten.reporters = [[InspReporters alloc] init];
            _dataMainten.reporters.arraySection = [[NSMutableArray alloc] init];
            
            for (Vendor * vendor in _arrayVendor) {
                InspReporterSection * section = [[InspReporterSection alloc] init];
                section.strTitle1 = [NSString stringWithFormat:@"%@ %@",_storeSelected.strStoreName,_storeSelected.strBrandName];
                section.strTitle1 = [NSString stringWithFormat:@"%@ %@ Maintenance \r\n Application_%@",_storeSelected.strStoreName,_storeSelected.strBrandName,vendor.strAssetType];
                section.strVendorID = vendor.strVendorID;
                
                NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                [dateformatter setDateFormat:@"dd-MM-yyyy"];
                section.strTitle2 = [NSString stringWithFormat:@"%@,by %@",[dateformatter stringFromDate:[NSDate date]],[RPSDK defaultInstance].userLoginDetail.strFirstName];
                
                section.arrayUser = [[NSMutableArray alloc] init];
                InspReporterUser * user = [[InspReporterUser alloc] init];
                user.bSelected = YES;
                user.bUserCollegue = YES;
                user.collegue = [RPSDK defaultInstance].userLoginDetail;
                [section.arrayUser addObject:user];
                
                [[RPSDK defaultInstance] GetUserListByVendor:SituationType_Maintenance VendorID:vendor.strVendorID Success:^(NSArray * arrayUser) {
                    for (UserDetailInfo * user in arrayUser) {
                        InspReporterUser * repUser = [[InspReporterUser alloc] init];
                        repUser.bUserCollegue = YES;
                        repUser.collegue = user;
                        repUser.bSelected = YES;
                        [section.arrayUser addObject:repUser];
                    }
                    [SVProgressHUD dismiss];
                } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                    [SVProgressHUD dismiss];
                }];
                
                [_dataMainten.reporters.arraySection  addObject:section];
            }
            
            if (arrayVendor.count == 0) {
                [SVProgressHUD dismiss];
            }
            
//            MaintenanceData * data = [[RPSDK defaultInstance] GetTaskCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_MAINTEN];
//            if (data)
//            {
//                _dataMainten.arrayIssue = data.arrayIssue;
//                
//                for (InspIssue * issue in data.arrayIssue) {
//                    for (Vendor * vendor in _arrayVendor) {
//                        if ([vendor.strVendorID isEqualToString:issue.strVendorID]) {
//                            issue.strVendorName = vendor.strVendorName;
//                            issue.strVendorType = vendor.strAssetType;
//                            break;
//                        }
//                    }
//                }
//            }
        }Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD dismiss];
        }];
    }
    Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
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
    
    _step = MAINTEN_SELECTSHOP;
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self.view];
}

- (IBAction)OnContinue:(id)sender
{
    if (_arrayVendor.count == 0) {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"This store dose not have any maintenance vendor",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:strDesc];
        return;
    }
    
    MaintenanceData * data = [[RPSDK defaultInstance] GetTaskCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_MAINTEN];
    if (data)
    {
        _dataMainten.arrayIssue = data.arrayIssue;
        
        for (InspIssue * issue in data.arrayIssue) {
            for (Vendor * vendor in _arrayVendor) {
                if ([vendor.strVendorID isEqualToString:issue.strVendorID]) {
                    issue.strVendorName = vendor.strVendorName;
                    issue.strVendorType = vendor.strAssetType;
                    break;
                }
            }
        }
        _viewDetail.storeSelected = _storeSelected;
        _viewDetail.dataMainten = _dataMainten;
        _viewDetail.arrayVendor = _arrayVendor;
        _viewDetail.arrayContact = _arrayContact;
        
        _viewDetail.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [self.view addSubview:_viewDetail];
        
        [UIView beginAnimations:nil context:nil];
        _viewDetail.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        
        _step = MAINTEN_DETAIL;
    }
    else
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"This store have no unfinished report",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:strDesc];
    }
}

-(void)ShowDetail
{
//    _viewDetail.storeSelected = _storeSelected;
//    _viewDetail.dataMainten = _dataMainten;
//    _viewDetail.arrayVendor = _arrayVendor;
//    _viewDetail.arrayContact = _arrayContact;
//    
//    _viewDetail.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
//    
//    [self.view addSubview:_viewDetail];
//    
//    [UIView beginAnimations:nil context:nil];
//    _viewDetail.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];
//    
//    _step = MAINTEN_DETAIL;
    if (_arrayVendor.count == 0) {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"This store dose not have any maintenance vendor",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:strDesc];
        return;
    }
    
    MaintenanceData * data = [[RPSDK defaultInstance] GetTaskCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_MAINTEN];
    if (data)
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Existing cache,if you continue, the cache will be empty",@"RPString", g_bundleResorce,nil);
        NSString * strOK = NSLocalizedStringFromTableInBundle(@"CONTINUE",@"RPString", g_bundleResorce,nil);
        NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1)
            {
                [[RPSDK defaultInstance]ClearCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_MAINTEN];
                _viewDetail.storeSelected = _storeSelected;
                _viewDetail.dataMainten = _dataMainten;
                _viewDetail.arrayVendor = _arrayVendor;
                _viewDetail.arrayContact = _arrayContact;
                
                _viewDetail.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
                
                [self.view addSubview:_viewDetail];
                
                [UIView beginAnimations:nil context:nil];
                _viewDetail.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
                
                _step = MAINTEN_DETAIL;
            }
        } otherButtonTitles:strOK,nil];
        [alertView show];
    }
    else
    {
        _viewDetail.storeSelected = _storeSelected;
        _viewDetail.dataMainten = _dataMainten;
        _viewDetail.arrayVendor = _arrayVendor;
        _viewDetail.arrayContact = _arrayContact;
        
        _viewDetail.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [self.view addSubview:_viewDetail];
        
        [UIView beginAnimations:nil context:nil];
        _viewDetail.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        
        _step = MAINTEN_DETAIL;
        
    }
    
}

-(IBAction)OnInspDetail:(id)sender
{
    if (_storeSelected == nil) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No Store Selected",@"RPString", g_bundleResorce,nil)];
        return;
    }
    
    if (_arrayContact == nil || _arrayVendor == nil) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Data initialize failed",@"RPString", g_bundleResorce,nil)];
        return;
    }
    
    _bModified = YES;
    [self ShowDetail];
}

-(BOOL)OnBack
{
    [SVProgressHUD dismiss];
    if (_bConfirmQuit) {
        return YES;
    }
    
    switch (_step) {
        case MAINTEN_DETAIL:
            if ([_viewDetail OnBack]) {
                [self dismissView:_viewDetail];
                _step = MAINTEN_STOREDETAIL;
            }
            break;
        case MAINTEN_SELECTSHOP:
            [_viewStoreList dismiss];
            [self dismissView:_viewStoreList];
            _step = MAINTEN_STOREDETAIL;
            break;
        default:
        {
            if (!_bModified) {
                _bConfirmQuit = YES;
                [self.delegate OnTaskEnd];
            }
            else
            {
                NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Current data will be erased!\r\nConfirm to exit maintenance?",@"RPString", g_bundleResorce,nil);
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

-(void)OnSelectStore
{
    _viewStoreList.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    _viewStoreList.tfSearch.text=@"";
    [self.view insertSubview:_viewStoreList belowSubview:_viewBottom];
    
    [UIView beginAnimations:nil context:nil];
    _viewStoreList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    [_viewStoreList reloadStore];
    
    _step = MAINTEN_SELECTSHOP;
}
@end
