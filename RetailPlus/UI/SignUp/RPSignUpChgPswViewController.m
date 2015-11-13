//
//  RPSignUpChgPswViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-8-13.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "RPSignUpChgPswViewController.h"
#import "RPSignUpProfileViewController.h"

extern NSBundle  * g_bundleResorce;

@interface RPSignUpChgPswViewController ()

@end

@implementation RPSignUpChgPswViewController

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
    
    CALayer * sublayer = _viewChgPsw.layer;
    sublayer.cornerRadius =6.0;
    
    sublayer = _btnChgPsw.layer;
    sublayer.shadowOffset = CGSizeMake(0, 1);
    sublayer.shadowRadius =3.0;
    sublayer.shadowColor =[UIColor blackColor].CGColor;
    sublayer.shadowOpacity =0.5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_tfPswConfirm.text.length == 0) {
        _ivYes.hidden = YES;
        _ivNo.hidden = YES;
    }
    else
    {
        if ([_tfPsw.text isEqualToString:_tfPswConfirm.text]) {
            _ivYes.hidden = NO;
            _ivNo.hidden = YES;
        }
        else
        {
            _ivYes.hidden = YES;
            _ivNo.hidden = NO;
        }
    }
}

-(IBAction)OnOk:(id)sender
{
    [self.view endEditing:YES];

    if (_tfPsw.text.length == 0 || _tfPswConfirm.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Password Empty",@"RPString", g_bundleResorce,nil)];
        return;
    }
    
    if (![_tfPsw.text isEqualToString:_tfPswConfirm.text])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Password Not Match",@"RPString", g_bundleResorce,nil)];
        return;
    }
    
    [SVProgressHUD showWithStatus:@""];
    NSString *s=[RPSDK isValidPassword:_strUserAccount Password:_tfPsw.text];
    if (s)
    {
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    
    [[RPSDK defaultInstance] ChangePWD:@"" NewPassWord:_tfPsw.text Success:^(id idResult) {
        [SVProgressHUD dismiss];
        
        RPSignUpProfileViewController * vcSignUpProfile = [[RPSignUpProfileViewController alloc] initWithNibName:NSStringFromClass([RPSignUpProfileViewController class]) bundle:g_bundleResorce];
        vcSignUpProfile.strUserPassword = _tfPsw.text;
        vcSignUpProfile.strUserAccount = _strUserAccount;
        
        vcSignUpProfile.delegate = self.delegate;
        vcSignUpProfile.vcFrame = self.vcFrame;
        vcSignUpProfile.nInvitedStatus = self.nInvitedStatus;
        [self.navigationController pushViewController:vcSignUpProfile animated:YES];
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
