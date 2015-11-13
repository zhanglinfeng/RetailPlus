//
//  RPSignUpVerifyViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-8-13.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "RPSignUpVerifyViewController.h"
#import "RPSignUpChgPswViewController.h"
#import "SVProgressHUD.h"

extern NSBundle  * g_bundleResorce;

@interface RPSignUpVerifyViewController ()

@end

@implementation RPSignUpVerifyViewController

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
    
    CALayer *sublayer = _btnGetCode.layer;
    sublayer.shadowOffset = CGSizeMake(0, 1);
    sublayer.shadowRadius =3.0;
    sublayer.shadowColor =[UIColor blackColor].CGColor;
    sublayer.shadowOpacity =0.5;
    
    sublayer = _btnVerify.layer;
    sublayer.shadowOffset = CGSizeMake(0, 1);
    sublayer.shadowRadius =3.0;
    sublayer.shadowColor =[UIColor blackColor].CGColor;
    sublayer.shadowOpacity =0.5;
    
    sublayer = _viewPhone.layer;
    sublayer.cornerRadius =5.0;
    
    sublayer = _viewVerify.layer;
    sublayer.cornerRadius =6.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)OnGetCode:(id)sender
{
    [self.view endEditing:YES];
    
    if (_tfPhone.text.length == 0) {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Phone Number Empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:strDesc];
        return;
    }
    
    _btnGetCode.userInteractionEnabled = NO;
    
    [[RPSDK defaultInstance] RequestIdCert:_tfPhone.text CertDevice:CertDevice_Phone CertType:CertType_SignUp withLoginToken:NO Success:^(id idResult) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        _nRemain = 60;
        
        _btnGetCode.userInteractionEnabled = NO;
        [_btnGetCode setBackgroundImage:[UIImage imageNamed:@"Big square button.png"] forState:UIControlStateNormal];
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"SEND AGAIN",@"RPString", g_bundleResorce,nil);
        NSString * str = [NSString stringWithFormat:@"%@(%02d)",strDesc,_nRemain];
        [_btnGetCode setTitle:str forState:UIControlStateNormal];
        
        str = NSLocalizedStringFromTableInBundle(@"Verify Code is sent",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showSuccessWithStatus:str];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        _btnGetCode.userInteractionEnabled = YES;
    }];
    
    
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

-(IBAction)OnVerify:(id)sender
{
    [self.view endEditing:YES];
    
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Verfying...",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showWithStatus:strDesc];
    self.view.userInteractionEnabled = NO;
    
    if (_tfCode.text == nil) _tfCode.text = @"";
    
    [[RPSDK defaultInstance] VerifyIdCert:_tfCode.text CertType:CertType_SignUp Success:^(id idResult) {
        [SVProgressHUD dismiss];
        self.view.userInteractionEnabled = YES;
        
        RPSignUpChgPswViewController * vcSignUpChgPsw = [[RPSignUpChgPswViewController alloc] initWithNibName:NSStringFromClass([RPSignUpChgPswViewController class]) bundle:g_bundleResorce];
        vcSignUpChgPsw.delegate = self.delegate;
        vcSignUpChgPsw.strUserAccount = _tfPhone.text;
        vcSignUpChgPsw.vcFrame = self.vcFrame;
        vcSignUpChgPsw.strPhoneNo = _tfPhone.text;
        vcSignUpChgPsw.nInvitedStatus = 0;
        [self.navigationController pushViewController:vcSignUpChgPsw animated:YES];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Verify Error",@"RPString", g_bundleResorce,nil)];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
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
