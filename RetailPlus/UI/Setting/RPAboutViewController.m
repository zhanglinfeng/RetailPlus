//
//  RPAboutViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-10-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPAboutViewController.h"
#import "SVProgressHUD.h"


extern NSBundle * g_bundleResorce;

@interface RPAboutViewController ()

@end

@implementation RPAboutViewController

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
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"ABOUT RETAIL PLUS",@"RPString", g_bundleResorce,nil);
    _viewFrame.layer.cornerRadius = 8;
    _viewNewVersionFrame.layer.cornerRadius = 8;
    
    _viewTableFrame.layer.cornerRadius = 6;
    
    _tvNewVerDesc.layer.cornerRadius = 6;
    _tvNewVerDesc.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tvNewVerDesc.layer.borderWidth = 1;
    
    _btnUpdate.layer.cornerRadius = 6;
    _btnUpdate.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnUpdate.layer.borderWidth = 1;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    _lbVersion.text = [NSString stringWithFormat:@"%@(Build:%@)",app_Version,BuildVersion];
    
    _lbServer.text = [RPSDK defaultInstance].strApiBaseUrl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)OnOk:(id)sender
{
    [self.delegate OnTaskEnd];
}

-(IBAction)OnRate:(id)sender
{
    
}

-(IBAction)OnFunctionInstruction:(id)sender
{
    
}

-(IBAction)OnCheckVersion:(id)sender
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    _version = [[RPSDK defaultInstance] CheckVersion:app_Version];
    if (_version) {
        if (_version.status != VersionStatus_Latest) {
            [self ShowNewVersion];
        }
        else
        {
            NSString * str = NSLocalizedStringFromTableInBundle(@"Latest Version",@"RPString", g_bundleResorce,nil);
            [SVProgressHUD showSuccessWithStatus:str];
        }
    }
    else
    {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Network Unavailable\rPlease check your network",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
    }
    
    
//    [[RPSDK defaultInstance] CheckVersion:app_Version Success:^(VersionModel * version) {
//        _version = version;
//        if (version.status != VersionStatus_Latest) {
//            [self ShowNewVersion];
//        }
//        else
//        {
//            NSString * str = NSLocalizedStringFromTableInBundle(@"Latest Version",@"RPString", g_bundleResorce,nil);
//            [SVProgressHUD showSuccessWithStatus:str];
//        }
//    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
//
//    }];
}

-(IBAction)OnContactUS:(id)sender
{
    
}
-(IBAction)OnFeedback:(id)sender
{
    _bFeedback=YES;
    [self.delegate OnFeedback];
}

- (IBAction)OnVisitOfficialSite:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.retailplus.com.cn/"]];
}
-(IBAction)OnUpdate:(id)sender
{
    NSURL* url = [[ NSURL alloc] initWithString:_version.strDownloadURL];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)ShowNewVersion
{
    NSString * str = NSLocalizedStringFromTableInBundle(@"CHECK NEW VERSION",@"RPString", g_bundleResorce,nil);
    self.strTaskName = str;
    [self.delegate OnReloadTitle];
    
    _viewNewVersion.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewNewVersion];
    
    _tvNewVerDesc.text = _version.strVersionDesc;
    _lbNewVersion.text = _version.strVersionNum;
    
    if (VersionStatus_recommend) {
        str = NSLocalizedStringFromTableInBundle(@"Update Now(Recommond)",@"RPString", g_bundleResorce,nil);
    }
    if (VersionStatus_Force) {
        str = NSLocalizedStringFromTableInBundle(@"Update Now(Necessary)",@"RPString", g_bundleResorce,nil);
    }
    [_btnUpdate setTitle:str forState:UIControlStateNormal];
    
    [UIView beginAnimations:nil context:nil];
    _viewNewVersion.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    _bShowUpdate = YES;
}

-(IBAction)OnHelp:(id)sender
{
    [self.delegate OnShowGuide];
}

-(BOOL)OnBack
{
    if (_bShowUpdate) {
        [UIView beginAnimations:nil context:nil];
        _viewNewVersion.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        _bShowUpdate = NO;
        
        NSString * str = NSLocalizedStringFromTableInBundle(@"ABOUT RETAIL PLUS",@"RPString", g_bundleResorce,nil);
        self.strTaskName = str;
        [self.delegate OnReloadTitle];
        
        return NO;
    }
    
    return YES;
}
@end
