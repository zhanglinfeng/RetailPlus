//
//  RPMngChnDetailView.m
//  RetailPlus
//
//  Created by lin dong on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPMngChnDetailView.h"
#import "RPYuanTelApi.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"

extern NSBundle * g_bundleResorce;

@implementation RPMngChnDetailView

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
    _viewTextFrame.layer.cornerRadius = 8;
    _viewTextFrame.layer.borderWidth = 1;
    _viewTextFrame.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
}

-(void)setAccount:(RPConfAccount *)account
{
    _account = account;
    _tfUserName.text = account.strUserName;
    _tfPassWord.text = account.strPassWord;
    
    _viewFrame.layer.cornerRadius = 8;
    _viewTextFrame.layer.cornerRadius = 8;
    _viewTextFrame.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
}

-(IBAction)OnLogin:(id)sender
{
    if (_tfUserName.text.length == 0 || _tfPassWord.text.length == 0) {
        NSString * strError = NSLocalizedStringFromTableInBundle(@"Username/Password Empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:strError];
        return;
    }
    
    [SVProgressHUD showWithStatus:@""];
    [[RPYuanTelApi defaultInstance] LoginConf:_tfUserName.text PassWord:_tfPassWord.text success:^(id idResult) {
        _account.strUserName = _tfUserName.text;
        _account.strPassWord = _tfPassWord.text;
        _account.bLogined = YES;
        _account.bInited = YES;
        [_delegate LoginEnd:_account.strID.integerValue - 1 Success:YES ChangeChecked:YES];
        [SVProgressHUD dismiss];
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:strDesc];
    }];
}

-(IBAction)OnDelete:(id)sender
{
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Are you sure to delete this account?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            _account.strUserName = @"";
            _account.strPassWord = @"";
            _account.bLogined = NO;
            _account.bInited = NO;
            _account.bChecked = NO;
            [_delegate DeleteEnd:_account.strID.integerValue - 1];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
}

@end
