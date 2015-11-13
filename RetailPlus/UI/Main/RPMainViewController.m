//
//  RPMainViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-8-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPMainViewController.h"
#import "RPInspViewController.h"
#import "RPTrafficViewController.h"
#import "RPInviteViewController.h"
#import "RPColleagueCardViewController.h"
#import "RPCustomerCardViewController.h"
#import "RPNewCustomerViewController.h"
#import "RPStoreCardViewController.h"
#import "RPMaintenViewController.h"
#import "RPCVisitViewController.h"
#import "RPAccountSetupViewController.h"
#import "RPPersonalProfileViewController.h"
#import "RPLanguageViewController.h"
#import "RPFeedbackViewController.h"
#import "RPAboutViewController.h"
#import "RPForwardDocViewController.h"
#import "RPModifyCustomerViewController.h"
#import "ELCUIApplication.h"
#import "RPLoginViewController.h"
#import "RPPurchaseRecordViewController.h"
#import "RPKpiDataEntryViewController.h"
#import "RPBVisitViewController.h"
#import "RPLogBookViewController.h"
#import "RPCourtesyCallViewController.h"
#import "RPTrainingViewController.h"
#import "RPDynamicVK.h"
#import "RPLiveVideoViewController.h"
#import "RPCodeQueryViewController.h"
#import "RPModifyStoreViewController.h"
#import "RPGuideViewController.h"

#import "SVProgressHUD.h"
#import "RPCacheManagementViewController.h"

#import "RPCheckVersion.h"

#import "RPShakeNotify.h"
#import "RPVisualMerchandisingViewController.h"
#import "RPConfCallViewController.h"
#import "RPRetailConsultingViewController.h"
#import "RPDailyStockViewController.h"
#import "RPELearningViewController.h"

#import "RPTaskViewController.h"

LangType g_langType = LangType_Auto;
NSString * g_strLangCode;
NSBundle * g_bundleResorce;


@interface RPMainViewController ()

@end

@implementation RPMainViewController

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
    
    [[RPDynamicVK defaultInstance] AddDynamicCloseButton];
    
    _viewMenu.delegate = self;
    
//    NSString *path = [[ NSBundle mainBundle ] pathForResource:@"Base" ofType:@"lproj" ];
//    g_bundleResorce = [NSBundle bundleWithPath:path];
    if ([RPSDK defaultInstance].bDemoMode)
        [_viewMenu reloadUI];
    else
        [_viewMenu reloadUI];
    
    [[RPShakeNotify defaultInstance] Start:self.view];
    [RPShakeNotify defaultInstance].delegate = self;
//    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgePanGestureRecognizerHanlde:)];
//    screenEdgePanGestureRecognizer.edges = UIRectEdgeLeft;
//    
//    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
//    [keywindow addGestureRecognizer:screenEdgePanGestureRecognizer];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        _viewTopBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    }
    else {
       _viewTopBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    }
    
    CGSize szScreen = [[UIScreen mainScreen] bounds].size;
    CGRect rcMain = self.view.frame;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        _rcTaskArea = CGRectMake(0, _viewTopBar.frame.size.height, rcMain.size.width, rcMain.size.height - _viewTopBar.frame.size.height);
        _rcSystemTaskArea = CGRectMake(0, _viewTopBar.frame.size.height, rcMain.size.width, rcMain.size.height - _viewTopBar.frame.size.height - _viewToolbar.frame.size.height);
    }
    else
    {
        _rcTaskArea = CGRectMake(0, _viewTopBar.frame.size.height, szScreen.width, szScreen.height - _viewTopBar.frame.size.height - 20);
        _rcSystemTaskArea = CGRectMake(0, _viewTopBar.frame.size.height, self.view.frame.size.width, szScreen.height - _viewTopBar.frame.size.height - 20 - _viewToolbar.frame.size.height);
    }
    
    
    
    _viewMenu.frame = CGRectMake(0, _rcTaskArea.origin.y - _rcTaskArea.size.height, _rcTaskArea.size.width, _rcTaskArea.size.height);;
    
    [self.view insertSubview:_viewMenu belowSubview:_viewTopBar];
    _bMenuHide = YES;
    _bNewMenuHide=YES;
    _bFirstAppear = YES;
    
    _vcAddress = [[RPAddressBookViewController alloc] initWithNibName:NSStringFromClass([RPAddressBookViewController class]) bundle:nil];
    _vcAddress.delegate = self;
    
    _vcSetting = [[RPSettingViewController alloc] initWithNibName:NSStringFromClass([RPSettingViewController class]) bundle:g_bundleResorce];
    _vcSetting.delegate = self;
    
    _vcMain = [[RPMainPageViewController alloc] initWithNibName:NSStringFromClass([RPMainPageViewController class]) bundle:g_bundleResorce];
    _vcMain.vcFrame = self;
    _vcMain.delegate = self;
    _vcMain.delegateStore = self;
    _vcMain.delegateTask = self;
    _vcMain.delegateMain = self;
    
    _vcStoreMng = [[RPStoreManagerViewController alloc] initWithNibName:NSStringFromClass([RPStoreManagerViewController class]) bundle:g_bundleResorce];
    _vcStoreMng.delegate = self;
    
    _vcMessageCenter = [[RPMCViewController alloc] initWithNibName:NSStringFromClass([RPMCViewController class]) bundle:nil];
    _vcMessageCenter.view.frame = CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_vcMessageCenter.view];
    
    NSArray *nib = [g_bundleResorce loadNibNamed:@"RPWakeUpView" owner:self options:nil];
    _viewWakeUp = [nib objectAtIndex:0];
    _viewWakeUp.delegate = self;
    
    _lbInfoCount.layer.cornerRadius = 2;
    
    _vcGuide = [[RPGuideViewController alloc] initWithNibName:NSStringFromClass([RPGuideViewController class]) bundle:nil];
    
    
    [self refreshBackBtn];
    
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
   // _vcMessageCenter.delegate = self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        CGSize szScreen = [[UIScreen mainScreen] bounds].size;
        CGRect rcMain = self.view.frame;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            _rcTaskArea = CGRectMake(0, _viewTopBar.frame.size.height, rcMain.size.width, rcMain.size.height - _viewTopBar.frame.size.height);
            _rcSystemTaskArea = CGRectMake(0, _viewTopBar.frame.size.height, rcMain.size.width, rcMain.size.height - _viewTopBar.frame.size.height - _viewToolbar.frame.size.height);
        }
        else
        {
            _rcTaskArea = CGRectMake(0, _viewTopBar.frame.size.height, szScreen.width, szScreen.height - _viewTopBar.frame.size.height - 20);
            _rcSystemTaskArea = CGRectMake(0, _viewTopBar.frame.size.height, self.view.frame.size.width, szScreen.height - _viewTopBar.frame.size.height - 20 - _viewToolbar.frame.size.height);
        }
    }
}

//- (void)screenEdgePanGestureRecognizerHanlde:(UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer {
//    NSLog(@"screenEdgePanGestureRecognizer");
//}

-(IBAction)OnMessageCenter:(id)sender
{
    [self.view addSubview:_vcMessageCenter.view];
    [self.view bringSubviewToFront:_vcMessageCenter.view];
    
    if (_vcCurTask) {
        [_vcCurTask.view endEditing:NO];
    }
    
    if (_vcCurSystemTask) {
        [_vcCurSystemTask.view endEditing:NO];
    }
    
    [UIView beginAnimations:nil context:nil];
     _vcMessageCenter.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    [_vcMessageCenter ReloadMessage];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (_bFirstAppear) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
        NSString *string = [def valueForKey:@"userLanguage"];
        
        if(string.length == 0){
            
            //获取系统当前语言版本(中文zh-Hans,英文en)
            
            NSArray* languages = [def objectForKey:@"AppleLanguages"];
            
            NSString *current = [languages objectAtIndex:0];
            
            string = current;
            
            [def setValue:current forKey:@"userLanguage"];
            
            [def synchronize];//持久化，不加的话不会保存
        }
        
        //获取文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
        
        NSBundle * bundle = [NSBundle bundleWithPath:path];//生成bundle
        
        [bundle load];
        
        RPLoginViewController * vcLogin = [[RPLoginViewController alloc] initWithNibName:NSStringFromClass([RPLoginViewController class]) bundle:g_bundleResorce];
        vcLogin.delegate = self;
        [self presentViewController:vcLogin animated:YES completion:^{
            
        }];
        _bFirstAppear = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)OnMenuBtnClick:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    
    if (_bMenuHide)
        _viewMenu.frame = _rcTaskArea;
    else
        _viewMenu.frame = CGRectMake(0, _rcTaskArea.origin.y - _rcTaskArea.size.height, _rcTaskArea.size.width, _rcTaskArea.size.height);
    
    [UIView commitAnimations];
    _bMenuHide = !_bMenuHide;
    [_btnMenu setSelected:!_bMenuHide];
    
    [self refreshBackBtn];
}

//- (IBAction)OnMenu:(id)sender
//{
//    [UIView beginAnimations:nil context:nil];
//    
//    if (_bMenuHide)
//        _viewMenu.frame = _rcTaskArea;
//    else
//        _viewMenu.frame = CGRectMake(0, _rcTaskArea.origin.y - _rcTaskArea.size.height, _rcTaskArea.size.width, _rcTaskArea.size.height);
//    
//    [UIView commitAnimations];
//    _bMenuHide = !_bMenuHide;
////    [_btnMenu setSelected:!_bMenuHide];
//    
//    [self refreshBackBtn];
//}

-(void)HideTaskAnimationStopped
{
    [_vcCurTask.view removeFromSuperview];
    _vcCurTask = nil;
    [self refreshBackBtn];
}

-(void)HideSystemTaskAnimationStopped
{
    [_vcCurSystemTask HideTitleBar];
    [_vcCurSystemTask.view removeFromSuperview];
    _vcCurSystemTask = nil;
}

-(void)OnBackTask
{
    if (_vcCurTask != nil) {
        if ([_vcCurTask OnBack]) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(HideTaskAnimationStopped)];
            
            _vcCurTask.view.frame = CGRectMake(0, _rcTaskArea.origin.y + _rcTaskArea.size.height + 20, _rcTaskArea.size.width, _rcTaskArea.size.height);;
            
            _btnMenu.frame = CGRectMake(_btnMenu.frame.origin.x, _btnMenu.frame.size.height, _btnMenu.frame.size.width, _btnMenu.frame.size.height);
            _btnMenu.hidden = NO;
            _lbTask.hidden = NO;
            
            _btnMenu.frame = CGRectMake(_btnMenu.frame.origin.x, 0, _btnMenu.frame.size.width, _btnMenu.frame.size.height);
            _lbTask.frame = CGRectMake(_lbTask.frame.origin.x, -_lbTask.frame.size.height, _lbTask.frame.size.width, _lbTask.frame.size.height);
            
            [UIView commitAnimations];
        }
        [self refreshBackBtn];
        return;
    }
    
    if (_bMenuHide == NO) {
        _bMenuHide = YES;
        [_btnMenu setSelected:NO];
        [UIView beginAnimations:nil context:nil];
        _viewMenu.frame = CGRectMake(0, _rcTaskArea.origin.y - _rcTaskArea.size.height, _rcTaskArea.size.width, _rcTaskArea.size.height);
        [UIView commitAnimations];
        
        [self refreshBackBtn];
        return;
    }
    
    if (_vcCurSystemTask != nil) {
        if ([_vcCurSystemTask OnBack]) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(HideTaskAnimationStopped)];
            
            _vcCurTask.view.frame = CGRectMake(0, _rcTaskArea.origin.y + _rcTaskArea.size.height, _rcTaskArea.size.width, _rcTaskArea.size.height);;
            
            _btnMenu.frame = CGRectMake(_btnMenu.frame.origin.x, _btnMenu.frame.size.height, _btnMenu.frame.size.width, _btnMenu.frame.size.height);
            _btnMenu.hidden = NO;
            _lbTask.hidden = NO;
            
            _btnMenu.frame = CGRectMake(_btnMenu.frame.origin.x, 0, _btnMenu.frame.size.width, _btnMenu.frame.size.height);
            _lbTask.frame = CGRectMake(_lbTask.frame.origin.x, -_lbTask.frame.size.height, _lbTask.frame.size.width, _lbTask.frame.size.height);
            
            [UIView commitAnimations];
        }
        [self refreshBackBtn];
        return;
    }
}

-(void)refreshBackBtn
{
    if (_vcCurTask != nil || _bMenuHide == NO || (_vcCurSystemTask != nil && [_vcCurSystemTask isLastView] == NO)) {
        _btnBack.alpha = 1;
        _btnBack.userInteractionEnabled = YES;
    }
    else
    {
        _btnBack.alpha = 0.3;
        _btnBack.userInteractionEnabled = NO;
    }
}

-(IBAction)OnBackBtnClick:(id)sender
{
    [self OnBackTask];
}

#pragma mark - RPMenuViewDelegate
-(void)OnHideMenu
{
    _bMenuHide = YES;
    [_btnMenu setSelected:NO];
    [self refreshBackBtn];
}
-(void)OnHideNewMenu
{
    _bNewMenuHide=YES;
//    [_btnMenu setSelected:NO];
    [self refreshBackBtn];
}

#pragma mark - RPLoginViewControllerDelegate
-(void)OnSignUpSuccess:(NSInteger)nInviteStatus
{
    [self reloadMainUI];
    [self ShowCurSystemTask:_vcMain];
}

-(void)OnLoginSuccess
{
    [self reloadMainUI];
    [self ShowCurSystemTask:_vcMain];
    [_vcMessageCenter ReloadMessage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidTimeout:) name:kApplicationDidTimeoutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationLogout:) name:kApplicationLogoutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationLogout:) name:kApplicationLogoutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationServerStatusChange:) name:kApplicationServerStatusNotify object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infomationCountChange:) name:kInfomationCenterNotification object:nil];
    
    if ([RPSDK defaultInstance].bFirstOpen) {
         [self OnShowGuide];
    }
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    [[RPSDK defaultInstance] CheckVersion:app_Version Success:^(VersionModel * version) {
//        if (version.status == VersionStatus_Force)
//        {
//            NSString * strDesc = [NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTableInBundle(@"Found new version",@"RPString", g_bundleResorce,nil),version.strVersionNum];
//            RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"Update",@"RPString", g_bundleResorce,nil) clickButton:^(NSInteger indexButton){
//                NSURL* url = [[ NSURL alloc] initWithString:version.strDownloadURL];
//                [[UIApplication sharedApplication] openURL:url];
//                [self OnLogout];
//            } otherButtonTitles:nil];
//            [alertView show];
//        }
//    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
//        NSString * str = NSLocalizedStringFromTableInBundle(@"Check Version Error",@"RPString", g_bundleResorce,nil);
//        [SVProgressHUD showErrorWithStatus:str];
//    }];
    [RPCheckVersion CheckVersion];
}

- (void)infomationCountChange:(NSNotification *) notif
{
    NSNumber * num = notif.object;
    if (num) {
        if (num.integerValue == 0)
        {
            _lbInfoCount.hidden = YES;
        }
        else
        {
            _lbInfoCount.hidden = NO;
            _lbInfoCount.text = [NSString stringWithFormat:@"%d",num.integerValue];
            
            UIFont *font = [UIFont systemFontOfSize:13];
            CGSize size = CGSizeMake(320,_lbInfoCount.frame.size.height);
            CGSize labelsize = [_lbInfoCount.text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            if (labelsize.width < labelsize.height)
                labelsize.width = labelsize.height;
            
            _lbInfoCount.frame = CGRectMake(_lbInfoCount.frame.origin.x, _lbInfoCount.frame.origin.y, labelsize.width, labelsize.height );
        }
    }
    else
        _lbInfoCount.hidden = YES;
}

- (void)applicationServerStatusChange:(NSNotification *) notif
{
    NSNumber * num = notif.object;
    if (num.boolValue == NO)
        _ivOffline.hidden = NO;
    else
        _ivOffline.hidden = YES;
}

- (void)applicationLogout:(NSNotification *) notif
{
    NSNumber * num = notif.object;
    
    if (num.integerValue == 0)
        [SVProgressHUD dismiss];
    else if (num.integerValue != RPSDKError_NoConnection)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kApplicationLogoutNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kInfomationCenterNotification object:nil];
        _lbInfoCount.hidden = YES;
        
        NSString * strMsg = @"";
        switch (num.integerValue) {
            case RPSDKError_AccountFrozen:
                strMsg = NSLocalizedStringFromTableInBundle(@"Your account has been frozen.",@"RPString", g_bundleResorce,nil);
                break;
            case RPSDKError_AccountLoginOtherPlace:
                strMsg = NSLocalizedStringFromTableInBundle(@"Your account has been logined in other place, please note the account security.",@"RPString", g_bundleResorce,nil);
                break;
            case RPSDKError_AccountExpire:
                strMsg = NSLocalizedStringFromTableInBundle(@"Connect to server is expired, please relogin",@"RPString", g_bundleResorce,nil);
                break;
            default:
                break;
        }
        
        NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strMsg cancelButtonTitle:strOK clickButton:^(NSInteger indexButton){
            [_viewWakeUp OnEnd];
            [self OnLogout];
        } otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) applicationDidTimeout:(NSNotification *) notif
{
//    NSLog(@"时间到＝＝＝＝");
//    RPLoginViewController *controller = [[RPLoginViewController alloc] initWithNibName:@"RPLoginViewController" bundle:[NSBundle mainBundle]] ;
//    [self presentViewController:controller animated:YES completion:^{}];
//    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
//    
//    [keywindow addSubview:];
    
    if (![RPSDK defaultInstance].IsAutoLogin)
    {
        _viewWakeUp.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _viewWakeUp.vcParent = self;
        [self.view addSubview:_viewWakeUp];
        [self.view bringSubviewToFront:_viewWakeUp];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kApplicationDidTimeoutNotification object:nil];
    }
}

#pragma mark - DetailTask Command
-(IBAction)OnAddressBook:(id)sender
{
//    if ([_vcCurSystemTask isKindOfClass:[RPAddressBookViewController class]]) {
//        return;
//    }
//    if (_vcCurSystemTask) {
//        [self OnBackTask];
//    }
//    
//    _vcAddress.delegate = self;
//    _vcAddress.view.frame = CGRectMake(0, _rcSystemTaskArea.origin.y + _rcSystemTaskArea.size.height, _rcSystemTaskArea.size.width, _rcSystemTaskArea.size.height);
//    
//    [UIView beginAnimations:nil context:nil];
//    _vcAddress.view.frame = _rcSystemTaskArea;
//    [UIView commitAnimations];
//    
//    [self.view insertSubview:_vcAddress.view belowSubview:_viewToolbar];
//    
//    _vcCurSystemTask = _vcAddress;
    [self ShowCurSystemTask:_vcAddress];

}

-(IBAction)OnHome:(id)sender
{
    [self ShowCurSystemTask:_vcMain];
}

-(IBAction)OnStoreManager:(id)sender
{
    [self ShowCurSystemTask:_vcStoreMng];
}

-(IBAction)OnSetting:(id)sender
{
    [_vcSetting Reload];
    [self ShowCurSystemTask:_vcSetting];
}

-(IBAction)OnInspection:(id)sender
{
    RPInspViewController * vcInsp = [[RPInspViewController alloc] initWithNibName:NSStringFromClass([RPInspViewController class]) bundle:g_bundleResorce];
    vcInsp.vcFrame = self;
    [self ShowCurTask:vcInsp];
}

-(IBAction)OnTrafficData:(id)sender
{
    RPTrafficViewController * vcTraffic = [[RPTrafficViewController alloc] initWithNibName:NSStringFromClass([RPTrafficViewController class]) bundle:nil];
    [self ShowCurTask:vcTraffic];
}

-(void)OnInviteEnd
{
    [self OnBackTask];
  //  [_vcAddress ReloadData];
}

-(void)OnAddCustomEnd
{
    [self OnBackTask];
    [_vcAddress ReloadData];
}

-(void)OnReloadTitle
{
    if (_vcCurTask.strTaskName) {
        _lbTask.text = _vcCurTask.strTaskName;
    }
}

-(void)ShowCurSystemTaskAnimationStopped
{
    [_vcCurSystemTask ShowTitleBar];
}

-(void)ShowCurSystemTask:(RPSystemTaskBaseViewController *)vcCurSysTask
{
    [self OnBackTask];
    if (_vcCurSystemTask == vcCurSysTask) {
        return;
    }
    
    if (_vcCurSystemTask) {
        if (_vcCurSystemTask != nil) {
            [_btnSysMenuHome setSelected:NO];
            [_btnSysMenuAddress setSelected:NO];
            [_btnSysMenuStore setSelected:NO];
            [_btnSysMenuConfig setSelected:NO];
            
            [_vcCurSystemTask HideTitleBar];
            [_vcCurSystemTask.view removeFromSuperview];
            _vcCurSystemTask = nil;
        }
    }
 
    [_btnSysMenuHome setSelected:NO];
    [_btnSysMenuAddress setSelected:NO];
    [_btnSysMenuStore setSelected:NO];
    [_btnSysMenuConfig setSelected:NO];
    
    if (vcCurSysTask == _vcAddress) {
        [_btnSysMenuAddress setSelected:YES];
    }
    
    if (vcCurSysTask == _vcStoreMng) {
        [_btnSysMenuStore setSelected:YES];
    }
    
    if (vcCurSysTask == _vcSetting) {
        [_btnSysMenuConfig setSelected:YES];
    }
    
    if (vcCurSysTask == _vcMain) {
        [_btnSysMenuHome setSelected:YES];
    }
//
//    if (vcCurSysTask == _vcAddress) {
//        [_btnSysMenuAddress setSelected:YES];
//    }
//    
//    if (vcCurSysTask == _vcAddress) {
//        [_btnSysMenuAddress setSelected:YES];
//    }
    
    
    _vcCurSystemTask = vcCurSysTask;
    
    vcCurSysTask.view.frame = CGRectMake(0, _rcSystemTaskArea.origin.y + _rcSystemTaskArea.size.height, _rcSystemTaskArea.size.width, _rcSystemTaskArea.size.height);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ShowCurSystemTaskAnimationStopped)];
    vcCurSysTask.view.frame = _rcSystemTaskArea;
    [UIView commitAnimations];
    
    [self refreshBackBtn];
    [self.view insertSubview:vcCurSysTask.view belowSubview:_viewToolbar];
}

-(void)ShowCurTask:(RPTaskBaseViewController *)vcCurTask
{
    vcCurTask.view.frame = CGRectMake(self.view.frame.size.width, _viewTopBar.frame.size.height, _rcTaskArea.size.width, _rcTaskArea.size.height);
    
    [UIView beginAnimations:nil context:nil];
    vcCurTask.view.frame = _rcTaskArea;

    
    [self.view addSubview:vcCurTask.view];
    
    _vcCurTask = vcCurTask;
    
    if (_vcCurTask.strTaskName) {
        
        _lbTask.frame = CGRectMake(_lbTask.frame.origin.x, -_lbTask.frame.size.height, _lbTask.frame.size.width, _lbTask.frame.size.height);
        _btnMenu.frame = CGRectMake(_btnMenu.frame.origin.x, 0, _btnMenu.frame.size.width, _btnMenu.frame.size.height);
        
        _lbTask.hidden = NO;
        _btnMenu.hidden = NO;
        
         _lbTask.frame = CGRectMake(_lbTask.frame.origin.x, 0, _lbTask.frame.size.width, _lbTask.frame.size.height);
        
        _btnMenu.frame = CGRectMake(_btnMenu.frame.origin.x, _btnMenu.frame.size.height, _btnMenu.frame.size.width, _btnMenu.frame.size.height);
        
        _lbTask.text = _vcCurTask.strTaskName;
    }
    
    [UIView commitAnimations];
    
    [self refreshBackBtn];
}

-(void)OnShowGuide
{
    [self HideCurTask];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        _vcGuide.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
    else
        _vcGuide.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [_vcGuide Reload];
    
    [self.view addSubview:_vcGuide.view];
}

-(void)OnSelectColleague:(UserDetailInfo *)colleague
{
    RPColleagueCardViewController * vcColleague = [[RPColleagueCardViewController alloc] initWithNibName:NSStringFromClass([RPColleagueCardViewController class]) bundle:g_bundleResorce];
    vcColleague.vcFrame = self;
    vcColleague.delegate = self;
    [self ShowCurTask:vcColleague];
    vcColleague.colleague = colleague;
}

-(void)OnSelectCustomer:(Customer *)customer
{
    RPCustomerCardViewController * vcCustomer = [[RPCustomerCardViewController alloc] initWithNibName:NSStringFromClass([RPCustomerCardViewController class]) bundle:g_bundleResorce];
    vcCustomer.vcFrame = self;
    vcCustomer.delegate = self;
    vcCustomer.delegateBusiness=self;
    [self ShowCurTask:vcCustomer];
    vcCustomer.customer = customer;
}

-(void)OnInvite
{
    RPInviteViewController * vcInvite = [[RPInviteViewController alloc] initWithNibName:NSStringFromClass([RPInviteViewController class]) bundle:g_bundleResorce];
    vcInvite.vcFrame = self;
    vcInvite.delegate = self;
    [self ShowCurTask:vcInvite];
}

-(void)OnAddCustomer
{
    RPModifyCustomerViewController * vcNewCustomer = [[RPModifyCustomerViewController alloc] initWithNibName:NSStringFromClass([RPModifyCustomerViewController class]) bundle:g_bundleResorce];
    vcNewCustomer.vcFrame = self;
    vcNewCustomer.delegate = self;
    vcNewCustomer.isAdd=YES;
    [self ShowCurTask:vcNewCustomer];
}
//-(void)OnPurchaseRecord
//{
//    RPPurchaseRecordViewController *vcPurchaseRecord=[[RPPurchaseRecordViewController alloc]initWithNibName:NSStringFromClass([RPPurchaseRecordViewController class]) bundle:nil];
//    vcPurchaseRecord.vcFrame=self;
//    vcPurchaseRecord.delegate=self;
//    [self ShowCurTask:vcPurchaseRecord];
//}
-(void)OnEditCustomer:(Customer *)customer;
{
    RPModifyCustomerViewController * vcEditCustomer = [[RPModifyCustomerViewController alloc] initWithNibName:NSStringFromClass([RPModifyCustomerViewController class]) bundle:g_bundleResorce];
    vcEditCustomer.vcFrame = self;
    vcEditCustomer.delegate = self;
    [self ShowCurTask:vcEditCustomer];
    vcEditCustomer.customer = customer;
}

-(void)OnCustomerPurchase:(Customer *)customer
{
    RPPurchaseRecordViewController * vcEditCustomer = [[RPPurchaseRecordViewController alloc] initWithNibName:NSStringFromClass([RPPurchaseRecordViewController class]) bundle:g_bundleResorce];
    vcEditCustomer.vcFrame = self;
    vcEditCustomer.delegate = self;
    [self ShowCurTask:vcEditCustomer];
    vcEditCustomer.customer = customer;
}

-(void)OnTaskEnd
{
 //   [self OnBackTask];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(HideTaskAnimationStopped)];
    
    _vcCurTask.view.frame = CGRectMake(0, _rcTaskArea.origin.y + _rcTaskArea.size.height, _rcTaskArea.size.width, _rcTaskArea.size.height);;
    
    _btnMenu.frame = CGRectMake(_btnMenu.frame.origin.x, _btnMenu.frame.size.height, _btnMenu.frame.size.width, _btnMenu.frame.size.height);
    _btnMenu.hidden = NO;
    _lbTask.hidden = NO;
    
    _btnMenu.frame = CGRectMake(_btnMenu.frame.origin.x, 0, _btnMenu.frame.size.width, _btnMenu.frame.size.height);
    _lbTask.frame = CGRectMake(_lbTask.frame.origin.x, -_lbTask.frame.size.height, _lbTask.frame.size.width, _lbTask.frame.size.height);
    
    [UIView commitAnimations];
    
    _vcCurTask = nil;
    [_vcSetting Reload];
    [_vcMain Reload];
}

-(void)OnSelectStoreManagerStore:(StoreDetailInfo *)store
{
    RPStoreCardViewController * vcStoreCard = [[RPStoreCardViewController alloc] initWithNibName:NSStringFromClass([RPStoreCardViewController class]) bundle:g_bundleResorce];
    vcStoreCard.delegate = self;
    vcStoreCard.vcCtrl = self;
    [self ShowCurTask:vcStoreCard];
    vcStoreCard.store = store;
}

-(void)OnSelTask:(TaskCommand)cmd
{
//    _bMenuHide = YES;
//    [_btnMenu setSelected:NO];
//    [UIView beginAnimations:nil context:nil];
//    _viewMenu.frame = CGRectMake(0, _rcTaskArea.origin.y - _rcTaskArea.size.height, _rcTaskArea.size.width, _rcTaskArea.size.height);
//    [UIView commitAnimations];
    
    switch (cmd) {
        case TASKCOMMAND_Inspection:
        {
            RPInspViewController * vcInsp = [[RPInspViewController alloc] initWithNibName:NSStringFromClass([RPInspViewController class]) bundle:g_bundleResorce];
            vcInsp.vcFrame = self;
            vcInsp.delegate = self;
            [self ShowCurTask:vcInsp];
        }
            break;
        case TASKCOMMAND_Maintenance:
        {
            RPMaintenViewController * vcInsp = [[RPMaintenViewController alloc] initWithNibName:NSStringFromClass([RPMaintenViewController class]) bundle:g_bundleResorce];
            vcInsp.vcFrame = self;
            vcInsp.delegate = self;
            [self ShowCurTask:vcInsp];
        }
            break;
        case TASKCOMMAND_ConstructionVisiting:
        {
            RPCVisitViewController * vcInsp = [[RPCVisitViewController alloc] initWithNibName:NSStringFromClass([RPCVisitViewController class]) bundle:g_bundleResorce];
            vcInsp.vcFrame = self;
            vcInsp.delegate = self;
            [self ShowCurTask:vcInsp];
        }
            break;
        case TASKCOMMAND_KPIDataEntry:
        {
            RPKpiDataEntryViewController * vcInsp = [[RPKpiDataEntryViewController alloc] initWithNibName:NSStringFromClass([RPKpiDataEntryViewController class]) bundle:g_bundleResorce];
            vcInsp.delegate = self;
            [self ShowCurTask:vcInsp];
        }
            break;
        case TASKCOMMAND_LIVEVIDEO:
        {
            RPLiveVideoViewController * vcInsp = [[RPLiveVideoViewController alloc] initWithNibName:NSStringFromClass([RPLiveVideoViewController class]) bundle:g_bundleResorce];
            vcInsp.delegate = self;
            [self ShowCurTask:vcInsp];
        }
            break;
        case TASKCOMMAND_BoutiqueVisiting:
        {
            RPBVisitViewController * vcInsp = [[RPBVisitViewController alloc] initWithNibName:NSStringFromClass([RPBVisitViewController class]) bundle:g_bundleResorce];
            vcInsp.delegate = self;
            vcInsp.vcFrame = self;
            [self ShowCurTask:vcInsp];
        }
            break;
        case TASKCOMMAND_LogBook:
        {
            RPLogBookViewController * vcInsp = [[RPLogBookViewController alloc] initWithNibName:NSStringFromClass([RPLogBookViewController class]) bundle:g_bundleResorce];
            vcInsp.delegate = self;
            vcInsp.vcFrame = self;
            [self ShowCurTask:vcInsp];
        }
            break;
        case TASKCOMMAND_CourtesyCall:
        {
            if ([RPRights hasRightsFunc:[RPSDK defaultInstance].llRights type:RPRightsFuncType_Customer]) {
                RPCourtesyCallViewController *vcInsp = [[RPCourtesyCallViewController alloc] initWithNibName:NSStringFromClass([RPCourtesyCallViewController class]) bundle:g_bundleResorce];
                vcInsp.delegate = self;
                vcInsp.vcFrame = self;
                [self ShowCurTask:vcInsp];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
            }
        }
            break;
        case TASKCOMMAND_ConfCall:
        {
            if ([RPRights hasRightsFunc:[RPSDK defaultInstance].llRights type:RPRightsFuncType_Customer]) {
                RPConfCallViewController *vcInsp = [[RPConfCallViewController alloc] initWithNibName:NSStringFromClass([RPConfCallViewController class]) bundle:g_bundleResorce];
                vcInsp.delegate = self;
                [self ShowCurTask:vcInsp];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
            }
        }
            break;
        case TASKCOMMAND_DailyStock:
        {
            RPDailyStockViewController *vcInsp = [[RPDailyStockViewController alloc] initWithNibName:NSStringFromClass([RPDailyStockViewController class]) bundle:[NSBundle mainBundle]];
            vcInsp.vcFrame=self;
            vcInsp.delegate = self;
            [self ShowCurTask:vcInsp];
        }
            break;
        case TASKCOMMAND_Elearning:
        {
            RPELearningViewController *vcInsp = [[RPELearningViewController alloc] initWithNibName:NSStringFromClass([RPELearningViewController class]) bundle:[NSBundle mainBundle]];
            vcInsp.vcFrame=self;
            vcInsp.delegate = self;
            [self ShowCurTask:vcInsp];
        }
            break;
        case TASKCOMMAND_Training:
        {
            RPTrainingViewController *vcInsp = [[RPTrainingViewController alloc] initWithNibName:NSStringFromClass([RPTrainingViewController class]) bundle:nil];
            vcInsp.vcFrame = self;
            [self ShowCurTask:vcInsp];
        }
            break;
        case TASKCOMMAND_CodeQuery:
        {
            RPCodeQueryViewController *vcCodeQuery=[[RPCodeQueryViewController alloc]initWithNibName:NSStringFromClass([RPCodeQueryViewController class]) bundle:g_bundleResorce];
            vcCodeQuery.vcFrame=self;
            vcCodeQuery.delegate=self;
            [self ShowCurTask:vcCodeQuery];
        }
            break;
        case TASKCOMMAND_Visual:
        {
             RPVisualMerchandisingViewController*vcVisual=[[RPVisualMerchandisingViewController alloc]initWithNibName:NSStringFromClass([RPVisualMerchandisingViewController class]) bundle:g_bundleResorce];
            vcVisual.vcFrame=self;
            vcVisual.delegate=self;
            [self ShowCurTask:vcVisual];
        }
            break;
        case TASKCOMMAND_RetailConsulting:
        {
            RPRetailConsultingViewController *vcVisual=[[RPRetailConsultingViewController alloc]initWithNibName:NSStringFromClass([RPRetailConsultingViewController class]) bundle:g_bundleResorce];
//            vcVisual.vcFrame=self;
            vcVisual.delegate=self;
            [self ShowCurTask:vcVisual];
        }
            break;
        default:
            break;
    }
    
}
-(void)OnSelNewTask:(newTaskCommand)cmd
{
    //    _bMenuHide = YES;
    //    [_btnMenu setSelected:NO];
    //    [UIView beginAnimations:nil context:nil];
    //    _viewMenu.frame = CGRectMake(0, _rcTaskArea.origin.y - _rcTaskArea.size.height, _rcTaskArea.size.width, _rcTaskArea.size.height);
    //    [UIView commitAnimations];
    
    switch (cmd) {
        case N_TASKCOMMAND_Inspection:
        {
            RPInspViewController * vcInsp = [[RPInspViewController alloc] initWithNibName:NSStringFromClass([RPInspViewController class]) bundle:g_bundleResorce];
            vcInsp.vcFrame = self;
            vcInsp.delegate = self;
            [self ShowCurTask:vcInsp];
        }
            break;
        case N_TASKCOMMAND_Maintenance:
        {
            RPMaintenViewController * vcInsp = [[RPMaintenViewController alloc] initWithNibName:NSStringFromClass([RPMaintenViewController class]) bundle:g_bundleResorce];
            vcInsp.vcFrame = self;
            vcInsp.delegate = self;
            [self ShowCurTask:vcInsp];
        }
            break;
        case N_TASKCOMMAND_ConstructionVisiting:
        {
            RPCVisitViewController * vcInsp = [[RPCVisitViewController alloc] initWithNibName:NSStringFromClass([RPCVisitViewController class]) bundle:g_bundleResorce];
            vcInsp.vcFrame = self;
            vcInsp.delegate = self;
            [self ShowCurTask:vcInsp];
        }
            break;
        case N_TASKCOMMAND_KPIDataEntry:
        {
            RPKpiDataEntryViewController * vcInsp = [[RPKpiDataEntryViewController alloc] initWithNibName:NSStringFromClass([RPKpiDataEntryViewController class]) bundle:g_bundleResorce];
            vcInsp.delegate = self;
            [self ShowCurTask:vcInsp];
        }
            break;
        case N_TASKCOMMAND_BoutiqueVisiting:
        {
            RPBVisitViewController * vcInsp = [[RPBVisitViewController alloc] initWithNibName:NSStringFromClass([RPBVisitViewController class]) bundle:g_bundleResorce];
            vcInsp.delegate = self;
            vcInsp.vcFrame = self;
            [self ShowCurTask:vcInsp];
        }
            break;
        case N_TASKCOMMAND_LogBook:
        {
            RPLogBookViewController * vcInsp = [[RPLogBookViewController alloc] initWithNibName:NSStringFromClass([RPLogBookViewController class]) bundle:g_bundleResorce];
            vcInsp.delegate = self;
            vcInsp.vcFrame = self;
            [self ShowCurTask:vcInsp];
        }
            break;
        case N_TASKCOMMAND_CourtesyCall:
        {
            if ([RPRights hasRightsFunc:[RPSDK defaultInstance].llRights type:RPRightsFuncType_Customer])
            {
                RPCourtesyCallViewController *vcInsp = [[RPCourtesyCallViewController alloc] initWithNibName:NSStringFromClass([RPCourtesyCallViewController class]) bundle:g_bundleResorce];
                vcInsp.delegate = self;
                vcInsp.vcFrame = self;
                [self ShowCurTask:vcInsp];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
            }
        }
        default:
            break;
    }
}
-(void)OnAccountSetup
{
    RPAccountSetupViewController * vcTarget = [[RPAccountSetupViewController alloc] initWithNibName:NSStringFromClass([RPAccountSetupViewController class]) bundle:g_bundleResorce];
//    vcInsp.vcFrame = self;
    vcTarget.delegate = self;
    [self ShowCurTask:vcTarget];
}

-(void)OnPersonalProfile
{
    RPPersonalProfileViewController * vcTarget = [[RPPersonalProfileViewController alloc] initWithNibName:NSStringFromClass([RPPersonalProfileViewController class]) bundle:g_bundleResorce];
    vcTarget.delegate = self;
    vcTarget.delegateMain = self;
    vcTarget.loginProfile = [RPSDK defaultInstance].userLoginDetail;
    vcTarget.vcFrame = self;
    //    vcInsp.delegate = self;
    [self ShowCurTask:vcTarget];
}
-(void)OnCacheManagement
{
    RPCacheManagementViewController *vcCacheManagement=[[RPCacheManagementViewController alloc]initWithNibName:NSStringFromClass([RPCacheManagementViewController class]) bundle:g_bundleResorce];
    vcCacheManagement.vcFrame = self;
    [self ShowCurTask:vcCacheManagement];
}
-(void)OnChgLang
{
    RPLanguageViewController * vcLanguage = [[RPLanguageViewController alloc] initWithNibName:NSStringFromClass([RPLanguageViewController class]) bundle:g_bundleResorce];
    vcLanguage.delegate = self;
    vcLanguage.type = g_langType;
    [self ShowCurTask:vcLanguage];
}

-(void)OnFeedback
{
    [self HideCurTask];
    
    RPFeedbackViewController * vcTarget = [[RPFeedbackViewController alloc] initWithNibName:NSStringFromClass([RPFeedbackViewController class]) bundle:g_bundleResorce];
        vcTarget.vcFrame = self;
        vcTarget.delegate = self;
    [self ShowCurTask:vcTarget];
}

-(void)OnUpdateStoreEnd:(StoreDetailInfo *)store
{
    [self OnTaskEnd];
    [_vcStoreMng UpdateStore:store];
}

-(void)OnUpdateTaskEnd
{
    [self OnTaskEnd];
    [_vcMain UpdateTask];
}

-(void)OnUpdateTaskAfterAddCalendar
{
    [_vcMain UpdateTask];
}

-(void)OnAbout
{
    RPAboutViewController * vcTarget = [[RPAboutViewController alloc] initWithNibName:NSStringFromClass([RPAboutViewController class]) bundle:g_bundleResorce];
    vcTarget.delegate = self;
    [self ShowCurTask:vcTarget];
}

-(void)OnDeleteUser
{
    [self OnBackTask];
    [_vcAddress ReloadData];
}

-(void)OnLogout
{
//    _vcAddress.view.hidden = YES;
//    _vcStoreMng.view.hidden = YES;
    _vcSetting.view.hidden = YES;
//    _vcMain.view.hidden = YES;
    
    [self OnBackTask];
    
    
    [_vcMessageCenter ClearMessage];
    
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
    
    [[RPSDK defaultInstance] UpdateDeviceToken:@"" Success:^(id idResult) {
        
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
    
    [[RPSDK defaultInstance] Logout];
    
    RPLoginViewController * vcLogin = [[RPLoginViewController alloc] initWithNibName:NSStringFromClass([RPLoginViewController class]) bundle:g_bundleResorce];
    vcLogin.delegate = self;
    [self presentViewController:vcLogin animated:YES completion:^{
        
    }];
    
    _bFirstAppear = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kApplicationDidTimeoutNotification object:nil];
}

-(void)OnChangeProfileEnd
{
    [_vcSetting OnChangeProfileEnd];
    [_vcAddress ReloadData];
}

-(void)HideCurTask
{
    if (_vcCurTask) {
        _vcCurTask.view.frame = CGRectMake(0, _rcTaskArea.origin.y + _rcTaskArea.size.height, _rcTaskArea.size.width, _rcTaskArea.size.height);
        
        _btnMenu.frame = CGRectMake(_btnMenu.frame.origin.x, _btnMenu.frame.size.height, _btnMenu.frame.size.width, _btnMenu.frame.size.height);
        _btnMenu.hidden = NO;
        _lbTask.hidden = NO;
        
        _btnMenu.frame = CGRectMake(_btnMenu.frame.origin.x, 0, _btnMenu.frame.size.width, _btnMenu.frame.size.height);
        _lbTask.frame = CGRectMake(_lbTask.frame.origin.x, -_lbTask.frame.size.height, _lbTask.frame.size.width, _lbTask.frame.size.height);
        
        [_vcCurTask.view removeFromSuperview];
        
        _vcCurTask = nil;
        
        [self refreshBackBtn];
    }
}

-(void)OnStoreCVisit:(StoreDetailInfo *)store
{
    [self HideCurTask];
    
    RPCVisitViewController * vcInsp = [[RPCVisitViewController alloc] initWithNibName:NSStringFromClass([RPCVisitViewController class]) bundle:g_bundleResorce];
    vcInsp.vcFrame = self;
    vcInsp.delegate = self;
    [self ShowCurTask:vcInsp];
    vcInsp.storeSelected = store;
}

-(void)OnStoreBVisit:(StoreDetailInfo *)store CacheDataId:(NSString *)strCacheDataId NeedLoadData:(BOOL)bNeedLoad
{
    [self HideCurTask];
    
    RPBVisitViewController * vcInsp = [[RPBVisitViewController alloc] initWithNibName:NSStringFromClass([RPBVisitViewController class]) bundle:g_bundleResorce];
    vcInsp.vcFrame = self;
    vcInsp.delegate = self;
    [self ShowCurTask:vcInsp];
    vcInsp.storeSelected = store;
    if (bNeedLoad)
        [vcInsp continueVisit:strCacheDataId];
}

-(void)OnStoreLogbook:(StoreDetailInfo *)store
{
    [self HideCurTask];
    
    RPLogBookViewController * vcInsp = [[RPLogBookViewController alloc] initWithNibName:NSStringFromClass([RPLogBookViewController class]) bundle:g_bundleResorce];
    vcInsp.delegate = self;
    vcInsp.vcFrame = self;
    [self ShowCurTask:vcInsp];
    vcInsp.storeSelected = store;
}

-(void)OnStoreKPIEntry:(StoreDetailInfo *)store
{
    [self HideCurTask];
    
    RPKpiDataEntryViewController * vcInsp = [[RPKpiDataEntryViewController alloc] initWithNibName:NSStringFromClass([RPKpiDataEntryViewController class]) bundle:g_bundleResorce];
    vcInsp.delegate = self;
    [self ShowCurTask:vcInsp];
    vcInsp.storeSelected = store;
}

-(void)OnLiveVideo:(StoreDetailInfo *)store
{
    [self HideCurTask];
    
    RPLiveVideoViewController * vcInsp = [[RPLiveVideoViewController alloc] initWithNibName:NSStringFromClass([RPLiveVideoViewController class]) bundle:g_bundleResorce];
    vcInsp.delegate = self;
    [self ShowCurTask:vcInsp];
    vcInsp.storeSelected = store;
}

-(void)OnEditStore:(StoreDetailInfo *)store
{
    [self HideCurTask];
    
    RPModifyStoreViewController * vcInsp = [[RPModifyStoreViewController alloc] initWithNibName:NSStringFromClass([RPModifyStoreViewController class]) bundle:g_bundleResorce];
    vcInsp.delegate = self;
    vcInsp.vcFrame = self;
    [self ShowCurTask:vcInsp];
    vcInsp.storeSelected = store;
}

-(void)OnStoreHandover:(StoreDetailInfo *)store
{
    [self HideCurTask];
    
    RPInspViewController * vcInsp = [[RPInspViewController alloc] initWithNibName:NSStringFromClass([RPInspViewController class]) bundle:g_bundleResorce];
    vcInsp.vcFrame = self;
    vcInsp.delegate = self;
    [self ShowCurTask:vcInsp];
    vcInsp.storeSelected = store;
}

-(void)OnStoreMaintenance:(StoreDetailInfo *)store
{
    [self HideCurTask];
    
    RPMaintenViewController * vcInsp = [[RPMaintenViewController alloc] initWithNibName:NSStringFromClass([RPMaintenViewController class]) bundle:g_bundleResorce];
    vcInsp.vcFrame = self;
    vcInsp.delegate = self;
    [self ShowCurTask:vcInsp];
    vcInsp.storeSelected = store;
}
-(void)OnDailyStock:(StoreDetailInfo *)store
{
    [self HideCurTask];
    RPDailyStockViewController *vcDS=[[RPDailyStockViewController alloc]initWithNibName:NSStringFromClass([RPDailyStockViewController class]) bundle:nil];
    vcDS.vcFrame=self;
    vcDS.delegate=self;
    vcDS.tag=-1;
    vcDS.storeSelected=store;
    [self ShowCurTask:vcDS];
    
}
-(void)OnChgLangEnd:(LangType)type
{
    g_langType = type;
    switch (g_langType) {
        case LangType_Auto:
        {
            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
            NSArray * languages = [defs objectForKey:@"AppleLanguages"];
            NSString * preferredLang = [languages objectAtIndex:0];
            if ([preferredLang isEqualToString:@"zh-Hans"]) {
                g_strLangCode = @"zh-Hans";
            }
            else
            {
                g_strLangCode = @"Base";
            }
        }
            break;
        case LangType_English:
            g_strLangCode = @"Base";
            break;
        case  LangType_Hans:
            g_strLangCode = @"zh-Hans";
            break;
    }
    
    NSString *path = [[ NSBundle mainBundle ] pathForResource:g_strLangCode ofType:@"lproj" ];
    g_bundleResorce = [NSBundle bundleWithPath:path];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filename=[documentDirectory stringByAppendingPathComponent:@"language.plist"];
    //输入写入
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:g_langType] forKey:@"LanguageEnum"];
    [dict writeToFile:filename atomically:YES];
    
    [self reloadMainUI];
    
    [self OnBackTask];
}

-(void)OnForwardDoc:(Document *)doc
{
    RPForwardDocViewController * vcForward = [[RPForwardDocViewController alloc] initWithNibName:NSStringFromClass([RPForwardDocViewController class]) bundle:nil];
    vcForward.delegate = self;
    vcForward.doc = doc;
    [self ShowCurTask:vcForward];
}
-(void)OnStoreBVisit:(BVisitListModel *)bVisitListModel Store:(StoreDetailInfo *)store
{
    RPBVisitViewController * vcInsp = [[RPBVisitViewController alloc] initWithNibName:NSStringFromClass([RPBVisitViewController class]) bundle:g_bundleResorce];
    vcInsp.vcFrame = self;
    vcInsp.delegate = self;
    [self ShowCurTask:vcInsp];
    
    [vcInsp OnEditOtherReport:bVisitListModel Store:store];
}
-(void)reloadMainUI
{
    _vcAddress = [[RPAddressBookViewController alloc] initWithNibName:NSStringFromClass([RPAddressBookViewController class]) bundle:nil];
    _vcAddress.vcFrame = self;
    _vcAddress.delegate = self;

    _vcSetting = [[RPSettingViewController alloc] initWithNibName:NSStringFromClass([RPSettingViewController class]) bundle:g_bundleResorce];
    _vcSetting.delegate = self;

    _vcMain = [[RPMainPageViewController alloc] initWithNibName:NSStringFromClass([RPMainPageViewController class]) bundle:g_bundleResorce];
    _vcMain.vcFrame = self;
    _vcMain.delegate = self;
    _vcMain.delegateStore = self;
    _vcMain.delegateTask = self;
    _vcMain.delegateMain = self;
    
    _vcStoreMng = [[RPStoreManagerViewController alloc] initWithNibName:NSStringFromClass([RPStoreManagerViewController class]) bundle:g_bundleResorce];
    _vcStoreMng.delegate = self;

    _vcMessageCenter = [[RPMCViewController alloc] initWithNibName:NSStringFromClass([RPMCViewController class]) bundle:nil];
    _vcMessageCenter.view.frame = CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    _vcMessageCenter.delegate = self;
    [self.view addSubview:_vcMessageCenter.view];
    
    NSArray *nib = [g_bundleResorce loadNibNamed:@"RPWakeUpView" owner:self options:nil];
    _viewWakeUp = [nib objectAtIndex:0];
    _viewWakeUp.delegate = self;
    
    if ([RPSDK defaultInstance].bDemoMode)
        [_viewMenu reloadUI];
    else
        [_viewMenu reloadUI];
    
    [self ShowCurSystemTask:_vcSetting];
}

-(void)OnCustomerlist:(UserDetailInfo *)colleague
{
    [self HideCurTask];
    [_vcAddress OnCustomerlist:colleague];
}

-(void)OnModifyUserProfile:(UserDetailInfo *)colleague
{
    [self HideCurTask];
    
    RPPersonalProfileViewController * vcTarget = [[RPPersonalProfileViewController alloc] initWithNibName:NSStringFromClass([RPPersonalProfileViewController class]) bundle:g_bundleResorce];
    vcTarget.delegate = self;
    vcTarget.delegateMain = self;
    vcTarget.loginProfile = colleague;
    vcTarget.vcFrame = self;
    //    vcInsp.delegate = self;
    [self ShowCurTask:vcTarget];
}

-(void)OnModifyUserStatus
{
    [_vcAddress ReloadData];
}

-(void)OnSystemTaskViewChanged
{
    [self refreshBackBtn];
    
    [UIView beginAnimations:nil context:nil];
    
    if (_vcCurSystemTask.strTaskName || _vcCurSystemTask.strTaskName.length != 0) {
        _lbTask.frame = CGRectMake(_lbTask.frame.origin.x, -_lbTask.frame.size.height, _lbTask.frame.size.width, _lbTask.frame.size.height);
        _btnMenu.frame = CGRectMake(_btnMenu.frame.origin.x, 0, _btnMenu.frame.size.width, _btnMenu.frame.size.height);
        
        _lbTask.hidden = NO;
        _btnMenu.hidden = NO;
        
        _lbTask.frame = CGRectMake(_lbTask.frame.origin.x, 0, _lbTask.frame.size.width, _lbTask.frame.size.height);
        
        _btnMenu.frame = CGRectMake(_btnMenu.frame.origin.x, _btnMenu.frame.size.height, _btnMenu.frame.size.width, _btnMenu.frame.size.height);
        
        _lbTask.text = _vcCurSystemTask.strTaskName;
    }
    else
    {
        _btnMenu.frame = CGRectMake(_btnMenu.frame.origin.x, _btnMenu.frame.size.height, _btnMenu.frame.size.width, _btnMenu.frame.size.height);
        _btnMenu.hidden = NO;
        _lbTask.hidden = NO;
        
        _btnMenu.frame = CGRectMake(_btnMenu.frame.origin.x, 0, _btnMenu.frame.size.width, _btnMenu.frame.size.height);
        _lbTask.frame = CGRectMake(_lbTask.frame.origin.x, -_lbTask.frame.size.height, _lbTask.frame.size.width, _lbTask.frame.size.height);
    }
    
    [UIView commitAnimations];
}

-(void)OnICSelectUser:(UserDetailInfo *)user
{
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Current task will be closed,confirm to continue?",@"RPString", g_bundleResorce,nil);
    NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    NSString *strGuide=NSLocalizedStringFromTableInBundle(@"CONTINUE",@"RPString", g_bundleResorce,nil);
    RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
        if (indexButton==0)
        {
            
        }
        else if(indexButton==1)
        {
            [_vcMessageCenter OnBack:nil];
            
            [self HideCurTask];
            
            RPColleagueCardViewController * vcColleague = [[RPColleagueCardViewController alloc] initWithNibName:NSStringFromClass([RPColleagueCardViewController class]) bundle:g_bundleResorce];
            vcColleague.vcFrame = self;
            vcColleague.delegate = self;
            [self ShowCurTask:vcColleague];
            vcColleague.colleague = user;
        }
    }otherButtonTitles:strGuide, nil];
    [alertView show];
}

-(void)OnCustomerCCall:(Customer *)customer
{
    [self HideCurTask];
    RPCourtesyCallViewController *vcInsp = [[RPCourtesyCallViewController alloc] initWithNibName:NSStringFromClass([RPCourtesyCallViewController class]) bundle:g_bundleResorce];
    vcInsp.delegate = self;
    vcInsp.vcFrame = self;
    [self ShowCurTask:vcInsp];
    [vcInsp OnCallWithCustomer:customer];
}

-(NSInteger)GetShakeNotifyType
{
    if (_vcCurTask == nil) {
        if (_vcCurSystemTask == _vcMain) {
            if ([_vcMain GetPageIndex] == 0) {
                return 1;
            }
        }
    }
    return -1;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)OnSelectTask:(TaskInfo *)info
{
    RPTaskViewController * vcCustomer = [[RPTaskViewController alloc] initWithNibName:NSStringFromClass([RPTaskViewController class]) bundle:g_bundleResorce];
    vcCustomer.info = info;
    vcCustomer.delegate = self;
    [self ShowCurTask:vcCustomer];
}
@end
