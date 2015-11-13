//
//  RPChangePswView.m
//  RetailPlus
//
//  Created by lin dong on 13-10-14.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import "SVProgressHUD.h"
#import "RPChangePswView.h"

extern NSBundle * g_bundleResorce;

@implementation RPChangePswView

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
    _viewFrame.layer.cornerRadius = 5;
    
    _viewTable1.layer.cornerRadius = 5;
    _viewTable1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewTable1.layer.borderWidth = 1;
    
    _viewTable2.layer.cornerRadius = 5;
    _viewTable2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewTable2.layer.borderWidth = 1;
    
    _tfNewPsw.adjustsFontSizeToFitWidth = YES;
    
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    [self addGestureRecognizer:singleTapGR];
}

-(void)clear
{
    _tfOldPsw.text = @"";
    _tfNewPsw.text = @"";
    _tfNewPswRepeat.text = @"";
}

-(IBAction)OnChangePsw:(id)sender
{
    if (_tfNewPsw.text.length==0)
    {
        NSString * str = NSLocalizedStringFromTableInBundle(@"New password can't be empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
        return;
    }
    if (_tfNewPswRepeat.text.length==0)
    {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Repeat password can't be empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
        return;
    }
    if ([_tfOldPsw.text isEqual:@""])
    {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Old password can't be empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
        return;
    }
    if (![_tfNewPsw.text isEqualToString:_tfNewPswRepeat.text]) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Repeat Password is different",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
        return;
    }
    NSString *s=[RPSDK isValidPassword:[RPSDK defaultInstance].userLoginDetail.strUserAcount Password:_tfNewPsw.text];
    if (s)
    {
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    
    NSString * str = NSLocalizedStringFromTableInBundle(@"Changing password...",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showWithStatus:str];
    
    [[RPSDK defaultInstance] ChangePWD:_tfOldPsw.text NewPassWord:_tfNewPsw.text Success:^(id idResult) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Change Password Success",@"RPString", g_bundleResorce,nil);
        
        [[RPSDK defaultInstance] SaveLoginUserName:[[[RPSDK defaultInstance]userLoginDetail ]strUserAcount] FullName:[NSString stringWithFormat:@"%@",[RPSDK defaultInstance].userLoginDetail.strFirstName] Password:[[RPSDK defaultInstance]strLoginPassword] autoLogin:NO];
        [RPSDK defaultInstance].strLoginPassword = _tfNewPsw.text;
        
        [SVProgressHUD showSuccessWithStatus:str];
        [self.delegate OnChangePswEnd];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
    }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self endEditing:YES];
}

-(IBAction)OnShowPsw:(id)sender
{
    [self endEditing:YES];
    [_tfOldPsw setSecureTextEntry:NO];
    [_tfNewPsw setSecureTextEntry:NO];
    [_tfNewPswRepeat setSecureTextEntry:NO];
}

-(IBAction)OnHidePsw:(id)sender
{
    [self endEditing:YES];
    [_tfOldPsw setSecureTextEntry:YES];
    [_tfNewPsw setSecureTextEntry:YES];
    [_tfNewPswRepeat setSecureTextEntry:YES];
}

@end
