//
//  RPForgetPswVerifyView.m
//  RetailPlus
//
//  Created by lin dong on 13-11-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPForgetPswVerifyView.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

@implementation RPForgetPswVerifyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)awakeFromNib
{
    _viewTextFrame.layer.cornerRadius = 6;
}

-(void)setBVerifyByPhone:(BOOL)bVerifyByPhone
{
    _bVerifyByPhone = bVerifyByPhone;
    if (_timer) {
        [_timer invalidate];
    }
    
    if (bVerifyByPhone) {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"An Identifying Code has been sent to your bound mobile phone.Please input the code to get through the verification",@"RPString", g_bundleResorce,nil);
        _lbDesc.text = strDesc;
    }
    else
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"An Identifying Code has been sent to your bound email.Please input the code to get through the verification",@"RPString", g_bundleResorce,nil);
        _lbDesc.text = strDesc;
    }
    
    _tfCode.text = @"";
    
    [self OnGetCode:nil];
}

-(IBAction)OnGetCode:(id)sender
{
    [self.delegate OnGetCode:_bVerifyByPhone];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    _nRemain = 60;
    
    _btnGetCode.userInteractionEnabled = NO;
    [_btnGetCode setBackgroundImage:[UIImage imageNamed:@"Big square button.png"] forState:UIControlStateNormal];
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"SEND AGAIN",@"RPString", g_bundleResorce,nil);
    NSString * str = [NSString stringWithFormat:@"%@(%02d)",strDesc,_nRemain];
    [_btnGetCode setTitle:str forState:UIControlStateNormal];
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
    if (_tfCode.text.length > 0)
         [self.delegate OnVerify:_tfCode.text];
    else
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Verify Code is empty",@"RPString", g_bundleResorce,nil);
         [SVProgressHUD showErrorWithStatus:strDesc];
    }
}
@end
