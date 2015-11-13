//
//  RPMobileVerifyingView.m
//  RetailPlus
//
//  Created by lin dong on 13-11-14.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import "RPMobileVerifyingView.h"
#import "SVProgressHUD.h"

extern NSBundle  * g_bundleResorce;

@implementation RPMobileVerifyingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    _viewFrame.layer.cornerRadius = 8;
    _viewCodeFrame.layer.cornerRadius = 6;
    _viewCodeFrame.layer.borderWidth = 1;
    _viewCodeFrame.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnSendAgain.layer.cornerRadius = 6;
    _btnSendAgain.layer.borderWidth = 1;
    _btnSendAgain.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self setUpForDismissKeyboard];
}

- (void)setUpForDismissKeyboard {
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapAnywhereToDismissKeyboard:)];
    [self addGestureRecognizer:singleTapGR];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self endEditing:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)Show
{
    [self endEditing:YES];
    [_timer invalidate];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    _nRemain = 60;
    
    [[RPSDK defaultInstance] RequestIdCert:[RPSDK defaultInstance].userLoginDetail.strUserAcount CertDevice:CertDevice_Phone CertType:CertType_ChangeBoundMail withLoginToken:YES Success:^(id idResult) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Verify Code is sent",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showSuccessWithStatus:str];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}

- (void)onTimer
{
    _nRemain --;
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"SEND AGAIN",@"RPString", g_bundleResorce,nil);
    NSString * str = [NSString stringWithFormat:@"%@(%02d)",strDesc,_nRemain];
    [_btnSendAgain setTitle:str forState:UIControlStateNormal];
    
    if (_nRemain == 0) {
        _btnSendAgain.userInteractionEnabled = YES;
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"GET CODE",@"RPString", g_bundleResorce,nil);
        [_btnSendAgain setTitle:strDesc forState:UIControlStateNormal];
        
        [_timer invalidate];
    }
    
}

-(IBAction)OnSend:(id)sender
{
    [self Show];
}

-(IBAction)OnVerify:(id)sender
{
    [[RPSDK defaultInstance] VerifyIdCert:_tfCode.text CertType:CertType_ChangeBoundMail Success:^(id idResult) {
        [[RPSDK defaultInstance] BoundEmail:_strEmail SendEmail:@"" Success:^(id dictResult) {
            [self.delegate OnEnd];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {

    }];
    
    [self endEditing:YES];
    
    
}
@end
