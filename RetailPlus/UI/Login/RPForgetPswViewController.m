//
//  RPForgetPswViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-11-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPForgetPswViewController.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

@interface RPForgetPswViewController ()

@end

@implementation RPForgetPswViewController

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
    CGSize szScreen = [[UIScreen mainScreen] bounds].size;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        _viewBorder.frame = CGRectMake(0, 20, szScreen.width, szScreen.height - 20);
    else
        _viewBorder.frame = CGRectMake(0, 0, szScreen.width, szScreen.height - 20);
    
    _viewFirst.delegate = self;
    _viewVerify.delegate = self;
    _viewChgPsw.delegate = self;
    
    _rcMoveout = CGRectMake(_viewFrame.frame.origin.x - _viewFrame.frame.size.width, _viewFrame.frame.origin.y, _viewFrame.frame.size.width, _viewFrame.frame.size.height);
    _rcCurrent = _viewFrame.frame;
    _rcStandby = CGRectMake(_viewFrame.frame.origin.x + _viewFrame.frame.size.width, _viewFrame.frame.origin.y, _viewFrame.frame.size.width, _viewFrame.frame.size.height);
    
    _viewFirst.frame = _rcCurrent;
    _viewVerify.frame = _rcStandby;
    _viewChgPsw.frame = _rcStandby;
    
    [_viewFrame addSubview:_viewFirst];
    [_viewFrame addSubview:_viewVerify];
    [_viewFrame addSubview:_viewChgPsw];
    
    _nStep = 1;
    
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    [self.view addGestureRecognizer:singleTapGR];
    
    _viewFirst.tfNumber.text=_phoneNumber;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

-(IBAction)OnBackBtn:(id)sender
{
    switch (_nStep) {
        case 1:
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            break;
        case 2:
            [UIView beginAnimations:nil context:nil];
            _viewFirst.frame = _rcCurrent;
            _viewVerify.frame = _rcStandby;
            [UIView commitAnimations];
            _nStep = 1;
            break;
        case 3:
            [UIView beginAnimations:nil context:nil];
            _viewVerify.frame = _rcCurrent;
            _viewChgPsw.frame = _rcStandby;
            [UIView commitAnimations];
            _nStep = 2;
            break;
    }
    [self.view endEditing:YES];
}

-(void)OnByMobilePhone:(NSString *)strNumber
{
    [self.view endEditing:YES];
    _strNumber = strNumber;
    _viewVerify.bVerifyByPhone = YES;
}

-(void)OnByEmail:(NSString *)strNumber
{
    [self.view endEditing:YES];
    _strNumber = strNumber;
    _viewVerify.bVerifyByPhone = NO;
}

-(void)OnGetCode:(BOOL)bVerifyByPhone
{
    CertDevice type;
    if (bVerifyByPhone)
        type = CertDevice_Phone;
    else
        type = CertDevice_Email;
    
    [[RPSDK defaultInstance] RequestIdCert:_strNumber CertDevice:type CertType:CertType_ChangePWD withLoginToken:NO Success:^(id dictResult) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Verify Code is sent",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showSuccessWithStatus:str];
        
        [UIView beginAnimations:nil context:nil];
        _viewFirst.frame = _rcMoveout;
        _viewVerify.frame = _rcCurrent;
        [UIView commitAnimations];
        _nStep = 2;
        [self.view endEditing:YES];
        
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {

    }];
}

-(void)OnVerify:(NSString *)strVerifyCode
{
    [[RPSDK defaultInstance] VerifyIdCert:strVerifyCode CertType:CertType_ChangePWD Success:^(id dictResult) {
        [UIView beginAnimations:nil context:nil];
        _viewVerify.frame = _rcMoveout;
        _viewChgPsw.frame = _rcCurrent;
        [UIView commitAnimations];
        
        _viewChgPsw.bVerifyByPhone = _viewVerify.bVerifyByPhone;
        
        _nStep = 3;
        [self.view endEditing:YES];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {

    }];
}

-(void)OnChangePsw:(NSString *)strPsw
{
    [[RPSDK defaultInstance] ChangePWD:@"" NewPassWord:strPsw Success:^(id dictResult) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
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
