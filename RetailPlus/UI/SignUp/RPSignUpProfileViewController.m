//
//  RPSignUpProfileViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-8-13.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "RPSignUpProfileViewController.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;
@interface RPSignUpProfileViewController ()

@end

@implementation RPSignUpProfileViewController

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
    
    CALayer * sublayer = _viewUserName.layer;
    sublayer.cornerRadius =6.0;
    
    sublayer = _viewSurName.layer;
    sublayer.cornerRadius =6.0;
    
    sublayer = _viewEmail.layer;
    sublayer.cornerRadius =6.0;
    
    sublayer = _btnDone.layer;
    sublayer.shadowOffset = CGSizeMake(0, 1);
    sublayer.shadowRadius =3.0;
    sublayer.shadowColor =[UIColor blackColor].CGColor;
    sublayer.shadowOpacity =0.5;
    
    sublayer = _viewUserImg.layer;
    sublayer.shadowOffset = CGSizeMake(0, 1);
    sublayer.shadowRadius =5.0;
    sublayer.shadowColor =[UIColor blackColor].CGColor;
    sublayer.shadowOpacity = 1;
    sublayer.cornerRadius =6.0;
    
    _viewUserImg.clipsToBounds = YES;
    
    _switchSex = [[RPSwitchView alloc] initWithFrame:CGRectMake(0, 0, _viewSex.frame.size.width, _viewSex.frame.size.height)];
    _switchSex.delegate = self;
    [_viewSex addSubview:_switchSex];
    _switchSex.imgBack = [UIImage imageNamed:@"bg_gender_switch01@2x.png"];
    
    [SVProgressHUD showWithStatus:@""];
    
    [[RPSDK defaultInstance] GetUserDetailInfo:@"" Success:^(UserDetailInfo * userDetail) {
       [RPSDK defaultInstance].userLoginDetail = userDetail;
       [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [RPSDK defaultInstance].userLoginDetail = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)OnTakePhoto:(id)sender
{
    [self.view endEditing:YES];
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTableInBundle(@"Please select the image source type?",@"RPString", g_bundleResorce,nil) cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil) clickButton:^(NSInteger indexButton){
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (indexButton == 1) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
        }
        if (indexButton == 2) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        if (indexButton == 1 || indexButton == 2) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = sourceType;
            picker.allowsEditing = YES;
            picker.view.userInteractionEnabled = YES;
            
            [self.vcFrame presentViewController:picker animated:YES completion:^{
                
            }];
        }
    } otherButtonTitles:NSLocalizedStringFromTableInBundle(@"Camera",@"RPString", g_bundleResorce,nil),NSLocalizedStringFromTableInBundle(@"Photo Library",@"RPString", g_bundleResorce,nil),nil];
    
    [alertView show];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    UIImage * imgCrop = [RPSDK CropImage:image withSize:CGSizeMake(640, 640)];
    [_btnUserImg setImage:imgCrop forState:UIControlStateNormal];
    _imgUser = imgCrop;
    [picker dismissModalViewControllerAnimated:NO];
}
- (BOOL)isValidateEmail:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}
-(IBAction)OnOk:(id)sender
{
    if (![self isValidateEmail:_tfEmail.text]) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Email address format is not correct",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showSuccessWithStatus:str];
        return;
    }
    if  ([RPSDK defaultInstance].userLoginDetail)
    {
        self.view.userInteractionEnabled = NO;
        [SVProgressHUD showWithStatus:@"Setting User Profile..."];
        
        UserProfileUpdate * userUpdate = [[UserProfileUpdate alloc] init];
        userUpdate.strUserId = [RPSDK defaultInstance].userLoginDetail.strUserId;
        userUpdate.sex = Sex_NotAssign;
        if (_bFemale)
            userUpdate.sex = Sex_Female;
        else
            userUpdate.sex = Sex_Male;
        userUpdate.strFirstName = _tfFirstName.text;
//        userUpdate.strSurName = _tfSurName.text;
        userUpdate.strWorkEmail = _tfEmail.text;
        userUpdate.strInterest = @"";
        userUpdate.strBirthDate = @"";
        userUpdate.nBirthYear = 0;
        userUpdate.IsPublicAge = NO;
        userUpdate.strAlternatePhone = @"";
        userUpdate.imgUser = _imgUser;
        [[RPSDK defaultInstance] UpdateUserProfile:userUpdate Success:^(id idResult) {
   //         [SVProgressHUD showWithStatus:@""];
            [[RPSDK defaultInstance] GetUserDetailInfo:@"" Success:^(UserDetailInfo * userDetail) {
                [RPSDK defaultInstance].userLoginDetail = userDetail;
                [SVProgressHUD dismiss];
                [self.delegate OnSignUpSuccess:self.nInvitedStatus Account:_strUserAccount PassWord:_strUserPassword];
                self.view.userInteractionEnabled = YES;
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                [self.navigationController popViewControllerAnimated:YES];
                self.view.userInteractionEnabled = YES;
            }];
            
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            self.view.userInteractionEnabled = YES;
        }];
    }
}

-(void)SelectSwitch:(RPSwitchView *)view isOn:(BOOL)bOn
{
    if (!bOn) {
        [_lbMale setTextColor:[UIColor colorWithWhite:0.9 alpha:1]];
        [_lbFemale setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
    }
    else
    {
        [_lbMale setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
        [_lbFemale setTextColor:[UIColor colorWithWhite:0.9 alpha:1]];
    }
    _bFemale = bOn;
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
