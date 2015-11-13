//
//  RPLoginViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-8-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPLoginViewController.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"
#import "RPCacheSize.h"
#import "SimplePingHelper.h"

extern NSBundle * g_bundleResorce;

@interface RPLoginViewController ()

@end

@implementation RPLoginViewController

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

    
    CALayer *sublayer = _btnLogin.layer;
    sublayer.shadowOffset = CGSizeMake(0, 1);
    sublayer.shadowRadius =3.0;
    sublayer.shadowColor =[UIColor blackColor].CGColor;
    sublayer.shadowOpacity =0.5;
    
    sublayer = _btnSignUp.layer;
    sublayer.shadowOffset = CGSizeMake(0, 1);
    sublayer.shadowRadius =3.0;
    sublayer.shadowColor =[UIColor blackColor].CGColor;
    sublayer.shadowOpacity =0.5;
    
    sublayer = _btnHelp.layer;
    sublayer.cornerRadius =5.0;
    
    sublayer = _viewFrame.layer;
    sublayer.cornerRadius =6.0;
    
    _viewVerifyFrame.layer.cornerRadius = 6;
    [self setUpForDismissKeyboard];
    
  //  [self performSelectorOnMainThread:@selector(AutoLogin) withObject:nil waitUntilDone:NO];
    _tfUrl.hidden = YES;
//    NSNumber *numTestMode = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"TestMode"];
//    if(numTestMode && numTestMode.boolValue)
//       _tfUrl.hidden = NO;
    
    loginCount=0;
    
    _webSignUpAgree.backgroundColor = [UIColor clearColor];
    _webSignUpAgree.opaque = NO;
    _viewSignUpBorder.layer.cornerRadius = 8;
    
    for (id subview in _webSignUpAgree.subviews)
    if ([[subview class] isSubclassOfClass: [UIScrollView class]])
    {
        ((UIScrollView *)subview).bounces = NO;
    }
    
    NSString *fullPath = [NSBundle pathForResource:@"softsta"
                                            ofType:@"html" inDirectory:[[NSBundle mainBundle] bundlePath]];
    [_webSignUpAgree loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:fullPath]]];
    
//    _bServerAvailable = [[RPSDK defaultInstance] SetAvailableServer];
//    if (!_bServerAvailable)
//    {
//        [self CheckConnection];
//    }
//    else
//    {
//        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//        [[RPSDK defaultInstance] CheckVersion:app_Version Success:^(VersionModel * version) {
//            if (version.status == VersionStatus_Force)
//            {
//                NSString * strDesc = [NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTableInBundle(@"Found new version",@"RPString", g_bundleResorce,nil),version.strVersionNum];
//                RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"Update",@"RPString", g_bundleResorce,nil) clickButton:^(NSInteger indexButton){
//                    NSURL* url = [[ NSURL alloc] initWithString:version.strDownloadURL];
//                    [[UIApplication sharedApplication] openURL:url];
//                } otherButtonTitles:nil];
//                [alertView show];
//            }
//        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
//            NSString * str = NSLocalizedStringFromTableInBundle(@"Check Version Error",@"RPString", g_bundleResorce,nil);
//            [SVProgressHUD showErrorWithStatus:str];
//        }];
//    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _lbLabel.text = [NSString stringWithFormat:@"V%@",app_Version];
}

- (void)CheckConnection
{
    NetworkStatus sta = [RPSDK GetConnectionStatus];
    if (sta == NotReachable) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Network Unavailable\rPlease check your network",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
    }
    else
    {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Network Unavailable\rPlease check your network",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
    }
}

//- (void)pingResult:(NSNumber*)success {
//    _pingCount ++;
//	if (success.boolValue) {
//		NSLog(@"Success");
//        _pingSuccessCount++;
//	} else {
//		NSLog(@"Failure");
//	}
//    if (_pingCount == 3) {
//        if (_pingSuccessCount == 3) {
//            NSString * str = NSLocalizedStringFromTableInBundle(@"Connect server failed",@"RPString", g_bundleResorce,nil);
//            [SVProgressHUD showErrorWithStatus:str];
//        }
//        else
//        {
//            NSString * str = NSLocalizedStringFromTableInBundle(@"The network connection is not stable or available",@"RPString", g_bundleResorce,nil);
//            [SVProgressHUD showErrorWithStatus:str];
//        }
//        
//    }
//}


-(void)viewDidAppear:(BOOL)animated
{
    if ([[RPSDK defaultInstance] SetAvailableServer])
        [self AutoLogin];
    else
    {
        _textUserName.text = [[RPSDK defaultInstance] GetSavedFullName];
        _strUserName = [[RPSDK defaultInstance] GetSavedLoginUserName];
        [self CheckConnection];
    }
}

-(void)AutoLogin
{
    _textUserName.text = [[RPSDK defaultInstance] GetSavedFullName];
    _strUserName = [[RPSDK defaultInstance] GetSavedLoginUserName];
    
    NSString * strPsw = [[RPSDK defaultInstance] GetSavedPassword];
    if (strPsw) {
        _textPassWord.text = strPsw;
        _bAutoLogin = YES;
        [self UpdateAutoLoginImage];
        [self DoLogin];
    }
    
    if ([RPSDK defaultInstance].bDemoMode) {
        _textPassWord.text = @"Guest";
    }
}

- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                    [UIView beginAnimations:nil context:nil];
                    self.view.frame = CGRectMake(0, -80, self.view.frame.size.width, self.view.frame.size.height);
                    [UIView commitAnimations];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                    [UIView beginAnimations:nil context:nil];
                    
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
                    {
                        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                    }
                    else
                    {
                        self.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
                    }
                    
                    [UIView commitAnimations];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _textUserName) {
        if (_strUserName) {
            _strUserName = nil;
            _textUserName.text = @"";
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _textUserName) {
        [_textPassWord becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
        [self DoLogin];
    }
    return YES;
}

-(IBAction)OnLogin:(id)sender
{
   // long long l = [RPCacheSize GetSystemCacheSize];
    if ([[RPSDK defaultInstance] SetAvailableServer])
    {
        [self testModeSetUrl];
        [self DoLogin];
    }
    else
    {
        [self CheckConnection];
    }
}

-(IBAction)OnSignUp:(id)sender
{
    _bAutoLogin = NO;
    [self UpdateAutoLoginImage];
    
    if ([[RPSDK defaultInstance] SetAvailableServer])
    {
        NSInteger nOffset = 0;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            nOffset = 20;
        
        _viewSignUpAgree.frame = CGRectMake(self.view.frame.size.width, nOffset, self.view.frame.size.width, self.view.frame.size.height - nOffset);
        [self.view addSubview:_viewSignUpAgree];
        [UIView beginAnimations:nil context:nil];
        _viewSignUpAgree.frame = CGRectMake(0, nOffset, self.view.frame.size.width, self.view.frame.size.height - nOffset);
        [UIView commitAnimations];
    }
    else
    {
        [self CheckConnection];
    }
}

-(IBAction)OnSignUpAgree:(id)sender
{
    [self testModeSetUrl];
 
    NSInteger nOffset = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        nOffset = 20;
    
    _viewSignUpAgree.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - nOffset);
    
    RPSignUpViewController * vcSignUp = [[RPSignUpViewController alloc] initWithNibName:NSStringFromClass([RPSignUpViewController class]) bundle:g_bundleResorce];
    vcSignUp.delegate = self;
    vcSignUp.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vcSignUp animated:YES completion:^{
        
    }];
}

-(IBAction)OnSignUpAgreeBack:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    _viewSignUpAgree.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(IBAction)OnFindPsw:(id)sender
{
    _bAutoLogin = NO;
    [self UpdateAutoLoginImage];
    
    if ([[RPSDK defaultInstance] SetAvailableServer]) {
        [self testModeSetUrl];
        
        RPForgetPswViewController * vcForgetPsw = [[RPForgetPswViewController alloc] initWithNibName:NSStringFromClass([RPForgetPswViewController class]) bundle:g_bundleResorce];
        //vcForgetPsw.delegate = self;
        NSString * strUserName = _textUserName.text;
        if (_strUserName) {
            strUserName = _strUserName;
        }
        
        vcForgetPsw.phoneNumber=strUserName;
        vcForgetPsw.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vcForgetPsw animated:YES completion:^{
            
        }];
        //vcForgetPsw.view.frame = self.view.frame;
    }
    else
    {
        [self CheckConnection];
    }
}

-(void)DoLogin
{
//    [SVProgressHUD dismiss];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    [self.view endEditing:YES];
    
    self.view.userInteractionEnabled = NO;
    
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Log In...",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showWithStatus:strDesc];
    
    [self.view endEditing:YES];
    
    NSString * strUserName = _strUserName;
    if (strUserName == nil) {
        strUserName = _textUserName.text;
    }
    
    if (!strUserName || strUserName.length == 0) {
        self.view.userInteractionEnabled = YES;
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Username/Password Empty",@"RPString", g_bundleResorce,nil);
        
        [SVProgressHUD showErrorWithStatus:strDesc];
        return;
    }
    NSString * strPassWord = _textPassWord.text;
    if (!strPassWord) strPassWord = @"";
    
    NSUUID * uuid = [[UIDevice currentDevice] identifierForVendor];
    
    [[RPSDK defaultInstance] Login:strUserName PassWord:strPassWord DeviceID:[uuid UUIDString] DeviceName:[[UIDevice currentDevice] name] VerifyCode:@"" Success:^(id idResult) {
        [[RPSDK defaultInstance] SaveLoginUserName:strUserName FullName:[NSString stringWithFormat:@"%@",[RPSDK defaultInstance].userLoginDetail.strFirstName] Password:_textPassWord.text autoLogin:_bAutoLogin];
        [SVProgressHUD dismiss];

        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate OnLoginSuccess];
        }];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
 //       NSLog(@"failed");
        loginCount++;
        self.view.userInteractionEnabled = YES;
        
        if  (nErrorCode == RPSDKError_Login_RequireVCode)
        {
            _viewThrough.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:_viewThrough];
            [UIView beginAnimations:nil context:nil];
            _viewThrough.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
        else
        {
            if (loginCount>=5) {
                strDesc = NSLocalizedStringFromTableInBundle(@"Login failed five times\n need to verify",@"RPString", g_bundleResorce,nil);
                [SVProgressHUD showErrorWithStatus:strDesc];
                
                NSString * strUserName = _textUserName.text;
                if (_strUserName) {
                    strUserName = _strUserName;
                }
                
                NSString * userName=strUserName;
                [self verify:userName];
            }
        }
    }];
}

-(void)verify:(NSString *)phoneNumber
{
    RPForgetPswViewController * vcForgetPsw = [[RPForgetPswViewController alloc] initWithNibName:NSStringFromClass([RPForgetPswViewController class]) bundle:g_bundleResorce];
    //vcForgetPsw.delegate = self;
    vcForgetPsw.phoneNumber=phoneNumber;
    
    vcForgetPsw.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vcForgetPsw animated:YES completion:^{
        vcForgetPsw.lbtitle.text=NSLocalizedStringFromTableInBundle(@"Password verification",@"RPString", g_bundleResorce,nil);
    }];

}

-(IBAction)OnByPhone:(id)sender
{
    _deviceCert = CertDevice_Phone;
    _lbVerifyDesc.text = NSLocalizedStringFromTableInBundle(@"An Identifying Code has been sent to your bound mobile phone.Please input the code to get through the verification",@"RPString", g_bundleResorce,nil);
    
    [self OnGetCode:nil];
}

-(IBAction)OnByEmail:(id)sender
{
    _deviceCert = CertDevice_Email;
    _lbVerifyDesc.text = NSLocalizedStringFromTableInBundle(@"An Identifying Code has been sent to your bound email.Please input the code to get through the verification",@"RPString", g_bundleResorce,nil);
    
    [self OnGetCode:nil];
}

- (void)onTimer
{
    _nRemain --;
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"SEND AGAIN",@"RPString", g_bundleResorce,nil);
    NSString * str = [NSString stringWithFormat:@"%@(%02d)",strDesc,_nRemain];
    [_btnGetCode setTitle:str forState:UIControlStateNormal];
    
    if (_nRemain == 0) {
        _btnGetCode.userInteractionEnabled = YES;
        [_btnGetCode setBackgroundImage:[UIImage imageNamed:@"Button_middlesquare_02green.png"] forState:UIControlStateNormal];
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"GET CODE",@"RPString", g_bundleResorce,nil);
        [_btnGetCode setTitle:strDesc forState:UIControlStateNormal];
        
        [_timer invalidate];
    }
    
}

-(IBAction)OnGetCode:(id)sender
{
    NSString * strUserName = _strUserName;
    if (strUserName == nil) {
        strUserName = _textUserName.text;
    }
    
    [[RPSDK defaultInstance] RequestIdCert:strUserName CertDevice:_deviceCert CertType:CertType_LoginProtect withLoginToken:NO  Success:^(id idResult) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        _nRemain = 60;
        
        _btnGetCode.userInteractionEnabled = NO;
        [_btnGetCode setBackgroundImage:[UIImage imageNamed:@"Big square button.png"] forState:UIControlStateNormal];
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"SEND AGAIN",@"RPString", g_bundleResorce,nil);
        NSString * str = [NSString stringWithFormat:@"%@(%02d)",strDesc,_nRemain];
        [_btnGetCode setTitle:str forState:UIControlStateNormal];
        
        _viewVerify.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:_viewVerify];
        [UIView beginAnimations:nil context:nil];
        _viewVerify.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
    
    
}

-(IBAction)OnVerify:(id)sender
{
    NSString * strUserName = _strUserName;
    if (strUserName == nil) {
        strUserName = _textUserName.text;
    }
    
    NSUUID * uuid = [[UIDevice currentDevice] identifierForVendor];
    [[RPSDK defaultInstance] Login:strUserName PassWord:_textPassWord.text DeviceID:[uuid UUIDString] DeviceName:[[UIDevice currentDevice] name] VerifyCode:_tfVerify.text Success:^(id idResult) {
        [[RPSDK defaultInstance] SaveLoginUserName:strUserName FullName:[NSString stringWithFormat:@"%@",[RPSDK defaultInstance].userLoginDetail.strFirstName] Password:_textPassWord.text autoLogin:_bAutoLogin];
        [SVProgressHUD dismiss];
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate OnLoginSuccess];
        }];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        self.view.userInteractionEnabled = YES;
    }];
}

-(IBAction)OnThroughBack:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    _viewThrough.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(IBAction)OnVerifyBack:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    _viewVerify.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [_timer invalidate];
}

-(void)OnSignUpSuccess:(NSInteger)nInviteStatus Account:(NSString *)strAccount PassWord:(NSString *)strPassWord
{
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self.delegate OnSignUpSuccess:nInviteStatus];
//    }];
    
    _strUserName = nil;
    _textUserName.text = strAccount;
    _textPassWord.text = strPassWord;
    _bAutoLogin = NO;
    [self UpdateAutoLoginImage];
    [self DoLogin];
}

-(IBAction)OnAutoLogin:(id)sender
{
    _bAutoLogin = !_bAutoLogin;
    [self UpdateAutoLoginImage];
}

-(void)UpdateAutoLoginImage
{
    if (_bAutoLogin) {
        _ivAutoLogin.image = [UIImage imageNamed:@"icon_selected_setup.png"];
    }
    else
    {
        _ivAutoLogin.image = [UIImage imageNamed:@"icon_noselected_setup.png"];
    }
}

-(void)testModeSetUrl
{
//    NSNumber *numTestMode = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"TestMode"];
//    if(numTestMode && numTestMode.boolValue)
//        [[RPSDK defaultInstance] SetURL:_tfUrl.text];
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
@end
