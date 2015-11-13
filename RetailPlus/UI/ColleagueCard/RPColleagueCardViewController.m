//
//  RPColleagueCardViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-8-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "RPColleagueCardViewController.h"
#import "UIImageView+WebCache.h"
#import "RPBlockUIAlertView.h"

extern NSBundle * g_bundleResorce;

@interface RPColleagueCardViewController ()

@end

@implementation RPColleagueCardViewController

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
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"COLLEAGUE CARD",@"RPString", g_bundleResorce,nil);
    
    [_svFrame addSubview:_viewInfo];
    _svFrame.contentSize = CGSizeMake(_viewInfo.frame.size.width, _viewInfo.frame.size.height);
    
    _viewFrame.layer.cornerRadius = 10;
    _view1.layer.cornerRadius=6;
    _view2.layer.cornerRadius=6;
    _view3.layer.cornerRadius=6;
    _view4.layer.cornerRadius=6;
    
    _btnStore.layer.cornerRadius = 6;
    _btnStore.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnStore.layer.borderWidth = 1;
    
    _viewFrame.frame = CGRectMake(_viewFrame.frame.origin.x, _viewFrame.frame.origin.y, _viewFrame.frame.size.width, _ivPic.frame.size.height + _btnSizeChg.frame.size.height);
    _bSmall = YES;
    [_btnSizeChg setImage:[UIImage imageNamed:@"botton_pageextend_01@2x.png"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)OnSizeChg:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    
    if (_bSmall) {
        
        NSInteger nHeight = _ivPic.frame.size.height + _viewInfo.frame.size.height + _btnSizeChg.frame.size.height;
        if (nHeight > _viewTask.frame.size.height ) {
            nHeight = _viewTask.frame.size.height ;
        }

         _viewFrame.frame = CGRectMake(_viewFrame.frame.origin.x, _viewFrame.frame.origin.y, _viewFrame.frame.size.width, nHeight);
        [_btnSizeChg setImage:[UIImage imageNamed:@"botton_pagerollup_01@2x.png"] forState:UIControlStateNormal];
    }
    else
    {
        _viewFrame.frame = CGRectMake(_viewFrame.frame.origin.x, _viewFrame.frame.origin.y, _viewFrame.frame.size.width, _ivPic.frame.size.height + _btnSizeChg.frame.size.height);
        [_btnSizeChg setImage:[UIImage imageNamed:@"botton_pageextend_01@2x.png"] forState:UIControlStateNormal];
    }
    
    _bSmall = !_bSmall;
    
    [UIView commitAnimations];
}
-(void)MakeCall:(NSString *)strPhone
{
    UIWebView* callWebview =[[UIWebView alloc] init];
    
    NSString * strPhoneNo = [NSString stringWithFormat:@"tel://%@",strPhone];
    NSURL *telURL =[NSURL URLWithString:strPhoneNo];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
    
    
}

- (IBAction)OnCall:(id)sender
{
    if (_colleague.strUserAcount.length > 0 && _colleague.strAlternatePhone.length > 0) {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Please select phone No.",@"RPString", g_bundleResorce,nil);
        NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:s cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1) {
                [self MakeCall:_colleague.strUserAcount];
            }
            if (indexButton == 2) {
                [self MakeCall:_colleague.strAlternatePhone];
            }
        } otherButtonTitles:_colleague.strUserAcount,_colleague.strAlternatePhone,nil];
        [alertView show];
        
        return;
    }
    
    if (_colleague.strUserAcount.length > 0)
    {
        [self MakeCall:_colleague.strUserAcount];
        return;
    }
    
    if (_colleague.strAlternatePhone.length > 0) {
        [self MakeCall:_colleague.strAlternatePhone];
        return;
    }
    
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    switch ( result ) {
        case MessageComposeResultCancelled:
        {
            //click cancel button
        }
            break;
        case MessageComposeResultFailed:// send failed
            
            break;
        case MessageComposeResultSent:
        {
            
            //do something
        }
            break;
        default:
            break;
    }
}

-(void)MakeMsg:(NSString *)strPhone
{
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.recipients = [NSArray arrayWithObject:strPhone];
            picker.messageComposeDelegate =self;
            [self.vcFrame presentViewController:picker animated:YES completion:^{
                
            }];
        }
    }
}

- (IBAction)OnMessage:(id)sender
{
    if (_colleague.strUserAcount.length > 0 && _colleague.strAlternatePhone.length > 0) {
        
        NSString *s=NSLocalizedStringFromTableInBundle(@"Please select phone No.",@"RPString", g_bundleResorce,nil);
        NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:s cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1) {
                [self MakeMsg:_colleague.strUserAcount];
            }
            if (indexButton == 2) {
                [self MakeMsg:_colleague.strAlternatePhone];
            }
        } otherButtonTitles:_colleague.strUserAcount,_colleague.strAlternatePhone,nil];
        [alertView show];
        
        return;
    }
    
    if (_colleague.strUserAcount.length > 0)
    {
        [self MakeMsg:_colleague.strUserAcount];
        return;
    }
    
    if (_colleague.strAlternatePhone.length > 0) {
        [self MakeMsg:_colleague.strAlternatePhone];
        return;
    }
    
}

- (IBAction)OnClient:(id)sender {
    [self.delegate OnCustomerlist:_colleague];
}

- (IBAction)OnUserLock:(id)sender {
    
    BOOL bDoLock = YES;
    if (_colleague.status == UserStatus_Locked) {
        bDoLock = NO;
    }
    
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to Lock this user?",@"RPString", g_bundleResorce,nil);
    if (!bDoLock) {
        strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to UNLock this user?",@"RPString", g_bundleResorce,nil);
    }
    
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [SVProgressHUD showWithStatus:@""];
            [[RPSDK defaultInstance] LockUser:_colleague.strUserId Lock:bDoLock Success:^(id idResult) {
                if (bDoLock)
                    _colleague.status = UserStatus_Locked;
                else
                    _colleague.status = UserStatus_Normal;
                
                _bLockStaChg = YES;
                
                _viewLock.hidden = (_colleague.status == UserStatus_Locked ? NO : YES);
                [self UpdateBtnStatus];
                [SVProgressHUD dismiss];
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                
            }];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
}

- (IBAction)OnResetPassword:(id)sender {
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to reset the password of this user?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [SVProgressHUD showWithStatus:@""];
            [[RPSDK defaultInstance] ResetPsw:_colleague.strUserId Success:^(id idResult) {
                NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Reset succesfully",@"RPString", g_bundleResorce,nil);
                [SVProgressHUD showSuccessWithStatus:strDesc];
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                
            }];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
}

- (IBAction)OnUserMng:(id)sender {
    [_delegate OnModifyUserProfile:_colleague];
}

-(void)setColleague:(UserDetailInfo *)colleague
{
    _tvInterest.editable=NO;
    _tvOfficeAddress.editable=NO;
    _colleague = colleague;
    
    _ivSex.hidden = NO;
    switch (colleague.sex) {
        case Sex_Female:
            _ivSex.image = [UIImage imageNamed:@"icon_female_on_card@2x.png"];
            break;
        case Sex_Male:
            _ivSex.image = [UIImage imageNamed:@"icon_male_on_card@2x.png"];
            break;
        default:
            _ivSex.hidden = YES;
            break;
    }
    
    _lbColleagueName.text = [NSString stringWithFormat:@"%@",colleague.strFirstName];
    _lbPhone.text = colleague.strUserAcount;
    _lbRoleDesc.text = colleague.strRoleName;
    _lbStore.text=colleague.strDomainName;
    
    [_ivPic setImageWithURLString:colleague.strPortraitImgBig placeholderImage:[UIImage imageNamed:@"icon_userimage01_224.png"]];
    
    switch (colleague.rank) {
        case Rank_Manager:
            _viewRoleCol.backgroundColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            _ivStore.backgroundColor=[UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _viewRoleCol.backgroundColor =  [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            _ivStore.backgroundColor =  [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _viewRoleCol.backgroundColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            _ivStore.backgroundColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _viewRoleCol.backgroundColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            _ivStore.backgroundColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }
    
    _lbEmail.text=colleague.strUserEmail;
    _lbAlternatePhone.text=colleague.strAlternatePhone;
    _lbReportto.text=colleague.strReportTo;
    _lbBoardDate.text=colleague.strJoinedDate;
    _tvOfficeAddress.text=colleague.strOfficeAddress;
    _lbOfficePhone.text=colleague.strOfficePhoneNumber;
    _tvInterest.text=colleague.strInterest;
    
    _viewLock.hidden = (colleague.status == UserStatus_Locked ? NO : YES);
    [self UpdateBtnStatus];
}

-(void)UpdateBtnStatus
{
    if (_colleague.bCanModify) {
        _btnUserMng.alpha = 1;
        _btnResetPsw.alpha = 1;
        _btnLockUser.alpha = 1;
        _lbUserMng.alpha = 1;
        _lbResetPsw.alpha = 1;
        _lbLockUser.alpha = 1;
        _btnUserMng.userInteractionEnabled = YES;
        _btnResetPsw.userInteractionEnabled = YES;
        _btnLockUser.userInteractionEnabled = YES;
    }
    else
    {
        _btnUserMng.alpha = 0.2;
        _btnResetPsw.alpha = 0.2;
        _btnLockUser.alpha = 0.2;
        _lbUserMng.alpha = 0.2;
        _lbResetPsw.alpha = 0.2;
        _lbLockUser.alpha = 0.2;
        
        _btnUserMng.userInteractionEnabled = NO;
        _btnResetPsw.userInteractionEnabled = NO;
        _btnLockUser.userInteractionEnabled = NO;
    }
    
    if ([_colleague.strUserId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId]) {
        _btnLockUser.alpha = 0.2;
        _lbLockUser.alpha = 0.2;
        _btnLockUser.userInteractionEnabled = NO;
        
        _btnResetPsw.alpha = 0.2;
        _lbResetPsw.alpha = 0.2;
        _btnResetPsw.userInteractionEnabled = NO;
    }
    
    if (_colleague.status == UserStatus_Locked) {
        _lbLockUser.text = NSLocalizedStringFromTableInBundle(@"UNLock User",@"RPString", g_bundleResorce,nil);
        [_btnLockUser setImage:[UIImage imageNamed:@"button__unlock_user.png"] forState:UIControlStateNormal];
    }
    else
    {
        _lbLockUser.text = NSLocalizedStringFromTableInBundle(@"Lock User",@"RPString", g_bundleResorce,nil);
        [_btnLockUser setImage:[UIImage imageNamed:@"button__lock_user.png"] forState:UIControlStateNormal];
    }
}

-(BOOL)OnBack
{
    if (_bLockStaChg) [self.delegate OnModifyUserStatus];
    return YES;
}
@end
