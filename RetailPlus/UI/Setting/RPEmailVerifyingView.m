//
//  RPEmailVerifyingView.m
//  RetailPlus
//
//  Created by lin dong on 13-11-14.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPEmailVerifyingView.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

@implementation RPEmailVerifyingView

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
    _viewFrame.layer.cornerRadius = 8;
    _btnSend.layer.cornerRadius = 6;
    _btnSend.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnSend.layer.borderWidth = 1;
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

-(IBAction)OnSend:(id)sender
{
    [self Show];
}

-(void)Show
{
    [_timer invalidate];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    _nRemain = 60;
    
//    [[RPBLogic defaultInstance] RequestIdCert:[RPBLogic defaultInstance].simUserInfo.strPhoneNo DeviceType:CERTDEVICETYPE_PHONE CertType:CERTTYPE_CHGBOUNDMAIL success:^(id dictResult) {
//        NSString * str = NSLocalizedStringFromTableInBundle(@"Verify Code is sent",@"RPString", g_bundleResorce,nil);
//        [SVProgressHUD showSuccessWithStatus:str];
//    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
//        
//    }];
    
    [[RPSDK defaultInstance] BoundEmail:_strEmail SendEmail:[RPSDK defaultInstance].userLoginDetail.strUserEmail Success:^(id dictResult) {
        
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}

- (void)onTimer
{
    _nRemain --;
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"SEND AGAIN",@"RPString", g_bundleResorce,nil);
    NSString * str = [NSString stringWithFormat:@"%@(%02d)",strDesc,_nRemain];
    [_btnSend setTitle:str forState:UIControlStateNormal];
    
    if (_nRemain == 0) {
        _btnSend.userInteractionEnabled = YES;
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"GET CODE",@"RPString", g_bundleResorce,nil);
        [_btnSend setTitle:strDesc forState:UIControlStateNormal];
        
        [_timer invalidate];
    }
    
}

-(IBAction)OnOK:(id)sender
{
    [self.delegate OnEnd];
}
@end
