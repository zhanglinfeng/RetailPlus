//
//  RPMngChnTableViewCell.m
//  RetailPlus
//
//  Created by lin dong on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPMngChnTableViewCell.h"
#import "RPYuanTelApi.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;

@implementation RPMngChnTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAccount:(RPConfAccount *)account
{
    _account = account;
    
    _lbIndex.text = account.strID;
    if (account.bInited) {
        _lbUserName.text = account.strUserName;
        _lbUserName.alpha = 1;
        _lbIndex.alpha = 1;
        
        _btnStatus.hidden = NO;
        if (account.bChecked) {
            if (account.bLogined)
            {
                [_btnStatus setImage:[UIImage imageNamed:@"button_channel_log1.png"] forState:UIControlStateNormal];
                _lbIndex.textColor = [UIColor colorWithRed:18.0f/255 green:117.0f/255 blue:122.0f/255 alpha:1];
                _lbUserName.textColor = [UIColor colorWithRed:18.0f/255 green:117.0f/255 blue:122.0f/255 alpha:1];
            }
            else
            {
                [_btnStatus setImage:[UIImage imageNamed:@"button_channel_failed_no.png"] forState:UIControlStateNormal];
                _lbIndex.textColor = [UIColor colorWithRed:208.0f/255 green:29.0f/255 blue:57.0f/255 alpha:1];
                _lbUserName.textColor = [UIColor colorWithRed:208.0f/255 green:29.0f/255 blue:57.0f/255 alpha:1];
            }
        }
        else
        {
            [_btnStatus setImage:[UIImage imageNamed:@"button_channel_normal1.png"] forState:UIControlStateNormal];
            _lbIndex.textColor = [UIColor colorWithWhite:0.7 alpha:1];
            _lbUserName.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        }
    }
    else
    {
        _lbUserName.text = NSLocalizedStringFromTableInBundle(@"NEW ACCOUNT",@"RPString", g_bundleResorce,nil);
        _lbIndex.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        _lbUserName.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        _lbUserName.alpha = 0.3;
        _btnStatus.hidden = YES;
    }
}

-(IBAction)OnShowAccountDetail:(id)sender
{
    [_delegate OnShowChnDetail:_account.strID.integerValue - 1];
}

-(IBAction)OnLogin:(id)sender
{
    [SVProgressHUD showWithStatus:@""];
    [[RPYuanTelApi defaultInstance] LoginConf:_account.strUserName PassWord:_account.strPassWord success:^(id idResult) {
        [_delegate LoginEnd:_account.strID.integerValue - 1 Success:YES ChangeChecked:YES];
        [SVProgressHUD dismiss];
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [_delegate LoginEnd:_account.strID.integerValue - 1 Success:NO ChangeChecked:NO];
        [SVProgressHUD showErrorWithStatus:strDesc];
    }];
}
@end
