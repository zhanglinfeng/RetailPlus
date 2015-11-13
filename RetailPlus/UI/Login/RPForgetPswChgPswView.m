//
//  RPForgetPswChgPswView.m
//  RetailPlus
//
//  Created by lin dong on 13-11-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPForgetPswChgPswView.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

@implementation RPForgetPswChgPswView

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

-(IBAction)OnShowPsw:(id)sender
{
    [self endEditing:YES];
    [_tfPsw setSecureTextEntry:NO];
    [_tfRepeat setSecureTextEntry:NO];
}

-(IBAction)OnHidePsw:(id)sender
{
    [self endEditing:YES];
    [_tfPsw setSecureTextEntry:YES];
    [_tfRepeat setSecureTextEntry:YES];
}

-(IBAction)OnChangePsw:(id)sender
{
    
    if (![_tfPsw.text isEqualToString:_tfRepeat.text]) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Repeat Password is different",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
        return;
    }
    NSString *s=[RPSDK isValidPassword:[RPSDK defaultInstance].userLoginDetail.strUserAcount Password:_tfRepeat.text];
    //NSLog(@"%@",[RPSDK defaultInstance].userLoginDetail.strUserAcount);
    
    if (s)
    {
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    [self.delegate OnChangePsw:_tfPsw.text];
}

-(void)setBVerifyByPhone:(BOOL)bVerifyByPhone
{
    _bVerifyByPhone = bVerifyByPhone;
    if (bVerifyByPhone) {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Mobile Phone Number Verified,\r\nSet Your new password",@"RPString", g_bundleResorce,nil);
        _lbDesc.text = strDesc;
    }
    else
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Email Verified,\r\nSet Your new password",@"RPString", g_bundleResorce,nil);
        _lbDesc.text = strDesc;
    }
}

@end
