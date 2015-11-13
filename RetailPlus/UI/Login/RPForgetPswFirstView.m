//
//  RPForgetPswFirstView.m
//  RetailPlus
//
//  Created by lin dong on 13-11-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPForgetPswFirstView.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

@implementation RPForgetPswFirstView

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
    _viewTextFrame.layer.cornerRadius = 6;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)OnMobile:(id)sender
{
    if (_tfNumber.text.length == 0)
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Please input Mobile Phone Number/PR ID",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:strDesc];
    }
    else
        [self.delegate OnByMobilePhone:_tfNumber.text];
}

-(IBAction)OnEmail:(id)sender
{
    if (_tfNumber.text.length == 0)
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Please input Mobile Phone Number/PR ID",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:strDesc];
    }
    else
        [self.delegate OnByEmail:_tfNumber.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}
@end
