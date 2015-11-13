//
//  RPCVisitViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-9-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPCVisitViewController.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"

extern NSBundle * g_bundleResorce;

@interface RPCVisitViewController ()

@end

@implementation RPCVisitViewController
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
    _viewStoreList.sitType = SituationType_Visit;
    _viewStoreList.delegate = self;
    
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"PROJECT INSPECTION",@"RPString", g_bundleResorce,nil);
    
    CALayer *sublayer = _btnGo.layer;
    sublayer.shadowOffset = CGSizeMake(0, 1);
    sublayer.shadowRadius =3.0;
    sublayer.shadowColor =[UIColor blackColor].CGColor;
    sublayer.shadowOpacity =0.5;
    
    sublayer = _btnHistory.layer;
    sublayer.shadowOffset = CGSizeMake(0, 1);
    sublayer.shadowRadius =3.0;
    sublayer.shadowColor =[UIColor blackColor].CGColor;
    sublayer.shadowOpacity =0.5;
    
    sublayer = _btnSelectStore.layer;
    sublayer.cornerRadius = 4;
    sublayer.borderColor = [UIColor lightGrayColor].CGColor;
    sublayer.borderWidth = 1;
    
    sublayer = _viewFrame.layer;
    sublayer.cornerRadius = 6;
    
    _step = VISITSTEP_STOREDETAIL;
    
    _viewDetail.vcFrame = self.vcFrame;
    _viewDetail.delegate = self;
    
    _dataVisit = [[CVisitData alloc] init];
    
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


-(void)OnVisitEnd
{
    [self dismissView:_viewDetail];
    _step = VISITSTEP_STOREDETAIL;
    _bConfirmQuit = YES;
    [self.delegate OnTaskEnd];
}
-(void)backVisit
{
    [self dismissView:_viewDetail];
    _step = VISITSTEP_STOREDETAIL;
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
    _step = VISITSTEP_STOREDETAIL;
    
    if ([store.strStoreId isEqualToString:_storeSelected.strStoreId]) return;
    
    _storeSelected = store;

    _dataVisit = [[CVisitData alloc] init];
    _dataVisit.arrayIssue = [[NSMutableArray alloc] init];
    _dataVisit.strImgShopUrl = store.strShopMap;
    
    [_imgStore setImageWithURLString:store.strStoreThumbBig];
    
    [_btnSelectStore setTitle:store.strStoreName forState:UIControlStateNormal];
    _lbAddress.text = store.strStoreAddress;
    
    _dataVisit.reporters = [[InspReporters alloc] init];
    
    _dataVisit.reporters.arraySection = [[NSMutableArray alloc] init];
    InspReporterSection * section = [[InspReporterSection alloc] init];
    
    section.strTitle1 = [NSString stringWithFormat:@"%@ %@ Visiting Report",store.strStoreName,store.strBrandName];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd-MM-yyyy"];
    section.strTitle2 = [NSString stringWithFormat:@"%@,by %@",[dateformatter stringFromDate:[NSDate date]],[RPSDK defaultInstance].userLoginDetail.strFirstName];
    
    section.arrayUser = [[NSMutableArray alloc] init];
    
    InspReporterUser * user = [[InspReporterUser alloc] init];
    user.bSelected = YES;
    user.bUserCollegue = YES;
    user.collegue = [RPSDK defaultInstance].userLoginDetail;
    [section.arrayUser addObject:user];
    
    [_dataVisit.reporters.arraySection addObject:section];
    
    _viewStoreCard.store = _storeSelected;
    
//    CVisitData * data = [[RPSDK defaultInstance] GetTaskCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_VISITING];
//    if (data) {
//        _dataVisit.arrayIssue = data.arrayIssue;
//        _dataVisit.mark = data.mark;
//        _dataVisit.strDesc = data.strDesc;
//    }
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
    
    _step = VISITSTEP_SELECTSHOP;
}

-(void)ShowDetail
{
    
    
    //读是否有缓存
    BVisitData * data = [[RPSDK defaultInstance] GetTaskCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_VISITING];
    if (data)
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Existing cache,if you continue, the cache will be empty",@"RPString", g_bundleResorce,nil);
        NSString * strOK = NSLocalizedStringFromTableInBundle(@"CONTINUE",@"RPString", g_bundleResorce,nil);
        NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1)//如果有缓存，则清掉
            {
                [[RPSDK defaultInstance]ClearCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_VISITING];
                //清理界面内存上存在的数据
                _dataVisit.strDesc=@"";
                _dataVisit.mark=MARK_NONE;
                [_dataVisit.arrayIssue removeAllObjects];
                
                _viewDetail.storeSelected = _storeSelected;
                _viewDetail.dataVisit = _dataVisit;
                
                _viewDetail.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
                
                [self.view addSubview:_viewDetail];
                
                [UIView beginAnimations:nil context:nil];
                _viewDetail.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
                _step = VISITSTEP_DETAIL;
            }
        } otherButtonTitles:strOK,nil];
        [alertView show];
    }
    else
    {
        _viewDetail.storeSelected = _storeSelected;
        _viewDetail.dataVisit = _dataVisit;
        
        _viewDetail.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [self.view addSubview:_viewDetail];
        
        [UIView beginAnimations:nil context:nil];
        _viewDetail.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        
        _step = VISITSTEP_DETAIL;
        
    }
}

-(IBAction)OnInspDetail:(id)sender
{
    if (_storeSelected == nil) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No Store Selected",@"RPString", g_bundleResorce,nil)];
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
        case VISITSTEP_DETAIL:
            if ([_viewDetail OnBack]) {
                [self dismissView:_viewDetail];
                _step = VISITSTEP_STOREDETAIL;
            }
            break;
        case VISITSTEP_SELECTSHOP:
            [_viewStoreList dismiss];
            
            [self dismissView:_viewStoreList];
            _step = VISITSTEP_STOREDETAIL;
            break;
        default:
        {
            if (!_bModified) {
                _bConfirmQuit = YES;
                [self.delegate OnTaskEnd];
            }
            else
            {
                NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Current data will be erased!\r\nConfirm to exit visiting?",@"RPString", g_bundleResorce,nil);
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
    
    _step = VISITSTEP_SELECTSHOP;
}

- (IBAction)OnHelp:(id)sender
{
   [RPGuide ShowGuide:self.view];
}

- (IBAction)OnContinue:(id)sender
{
    if (_storeSelected == nil) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No Store Selected",@"RPString", g_bundleResorce,nil)];
        return;
    }
    
    CVisitData * data = [[RPSDK defaultInstance] GetTaskCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_VISITING];
    if (data) {
        data.strImgShopUrl=_dataVisit.strImgShopUrl;
        data.reporters = _dataVisit.reporters;
        _dataVisit = data;
        _viewDetail.storeSelected=_storeSelected;
        _viewDetail.dataVisit=_dataVisit;
        
        _viewDetail.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [self.view addSubview:_viewDetail];
        _viewDetail.vcFrame=self.vcFrame;
        _viewDetail.delegate=self;
        
        [UIView beginAnimations:nil context:nil];
        _viewDetail.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        
        _step = VISITSTEP_DETAIL;
    }
    else
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"This store have no unfinished report",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:strDesc];
    }
}
@end
