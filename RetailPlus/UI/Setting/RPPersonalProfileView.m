//
//  RPPersonalProfileView.m
//  RetailPlus
//
//  Created by lin dong on 13-11-18.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPPersonalProfileView.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
#import "UIButton+WebCache.h"
#import "RPBlockUISelectView.h"
extern NSBundle * g_bundleResorce;

@implementation RPPersonalProfileView

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
    CALayer * sublayer = _viewUserImg.layer;
    sublayer.shadowOffset = CGSizeMake(0, 1);
    sublayer.shadowRadius =5.0;
    sublayer.shadowColor =[UIColor blackColor].CGColor;
    sublayer.shadowOpacity = 1;
    sublayer.cornerRadius =6.0;
    _viewUserImg.clipsToBounds = YES;
    
    _viewFrame1.layer.cornerRadius = 6;
    _viewFrame1.layer.borderWidth = 1;
    _viewFrame1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _viewFrame2.layer.cornerRadius = 6;
    _viewFrame2.layer.borderWidth = 1;
    _viewFrame2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _switchSex = [[RPSwitchView alloc] initWithFrame:CGRectMake(0, 0, _viewSex.frame.size.width, _viewSex.frame.size.height)];
    _switchSex.delegate = self;
    [_viewSex addSubview:_switchSex];
    _switchSex.imgBack = [UIImage imageNamed:@"bg_gender_switch01.png"];
    
//    _dpBirthDay = [[UIDatePicker alloc] init];
//    _dpBirthDay.datePickerMode = UIDatePickerModeDate;
//    
//    [_tfBirthday setInputView:_dpBirthDay];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MMM dd"];
    //    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:0];
    _pickDate = [[RPDatePicker alloc] initDay:_tfBirthday Format:dateFormatter curDate:date canDelete:YES];
    _tfBirthday.text = @"";
    
    
    _bConfirmQuit = NO;
    _bImgChanged = NO;
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    _index=[userDefaults integerForKey:@"myTag"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _tfBirthYear.keyboardType=UIKeyboardTypeNumberPad;
    
    //*********************投影专用View********************//
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(_viewUserImg.frame.origin.x, _viewUserImg.frame.origin.y, _viewUserImg.frame.size.width, _viewUserImg.frame.size.height)];
    [self insertSubview:view1 belowSubview:_viewUserImg];
    view1.backgroundColor=[UIColor whiteColor];
    view1.layer.cornerRadius = 6;
    view1.layer.shadowOffset = CGSizeMake(-4, 4);
    view1.layer.shadowRadius =3.0;
    view1.layer.shadowColor =[UIColor blackColor].CGColor;
    view1.layer.shadowOpacity =0.3;
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(_viewUserImg.frame.origin.x, _viewUserImg.frame.origin.y, _viewUserImg.frame.size.width, _viewUserImg.frame.size.height)];
    [self insertSubview:view2 belowSubview:_viewUserImg];
    view2.backgroundColor=[UIColor whiteColor];
    view2.layer.cornerRadius = 6;
    view2.layer.shadowOffset = CGSizeMake(4, -4);
    view2.layer.shadowRadius =3.0;
    view2.layer.shadowColor =[UIColor blackColor].CGColor;
    view2.layer.shadowOpacity =0.3;
    
    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(_viewUserImg.frame.origin.x, _viewUserImg.frame.origin.y, _viewUserImg.frame.size.width, _viewUserImg.frame.size.height)];
    [self insertSubview:view3 belowSubview:_viewUserImg];
    view3.backgroundColor=[UIColor whiteColor];
    view3.layer.cornerRadius = 6;
    view3.layer.shadowOffset = CGSizeMake(4, 4);
    view3.layer.shadowRadius =3.0;
    view3.layer.shadowColor =[UIColor blackColor].CGColor;
    view3.layer.shadowOpacity =0.3;
    
    UIView *view4=[[UIView alloc]initWithFrame:CGRectMake(_viewUserImg.frame.origin.x, _viewUserImg.frame.origin.y, _viewUserImg.frame.size.width, _viewUserImg.frame.size.height)];
    [self insertSubview:view4 belowSubview:_viewUserImg];
    view4.backgroundColor=[UIColor whiteColor];
    view4.layer.cornerRadius = 6;
    view4.layer.shadowOffset = CGSizeMake(-4, -4);
    view4.layer.shadowRadius =3.0;
    view4.layer.shadowColor =[UIColor blackColor].CGColor;
    view4.layer.shadowOpacity =0.3;
    
    _viewBtnFrame.layer.cornerRadius = 6;
    _viewBtnFrame.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewBtnFrame.layer.borderWidth = 1;
    
    _viewEditFrame.layer.cornerRadius = 6;
    _viewEditFrame.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewEditFrame.layer.borderWidth = 1;
    
    _viewEditPhone.layer.cornerRadius = 6;
    _viewEditPhone.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewEditPhone.layer.borderWidth = 1;
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    if (_viewEditing == nil) return;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
#endif
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
#else
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey];
#endif
        CGRect keyboardBounds;
        [keyboardBoundsValue getValue:&keyboardBounds];
//        NSInteger offset =self.frame.size.height-keyboardBounds.origin.y+64.0;
//        CGRect listFrame = CGRectMake(0, -offset, self.frame.size.width,self.frame.size.height);
//        NSLog(@"offset is %d",offset);
        
        CGPoint pt = [_viewEditing convertPoint:CGPointMake(0, 0) toView:[[UIApplication sharedApplication] keyWindow]];
        CGPoint pt2 = [self convertPoint:CGPointMake(0, 0) toView:[[UIApplication sharedApplication] keyWindow]];
        
        CGRect listFrame = CGRectMake(0, -pt.y + _frameScroll.contentOffset.y + pt2.y, self.frame.size.width,self.frame.size.height);
        
        [UIView beginAnimations:nil context:nil];
        //处理移动事件，将各视图设置最终要达到的状态
        self.frame=listFrame;
        [UIView commitAnimations];
        
        
    }
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:nil];
    self.frame=CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
    [UIView commitAnimations];
}

-(void)SelectSwitch:(RPSwitchView *)view isOn:(BOOL)bOn
{
    if (!bOn) {
//        [_lbMale setTextColor:[UIColor colorWithWhite:0.9 alpha:1]];
//        [_lbFemale setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
        _lbMale.text=NSLocalizedStringFromTableInBundle(@"MALE",@"RPString", g_bundleResorce,nil);
    }
    else
    {
//        [_lbMale setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
//        [_lbFemale setTextColor:[UIColor colorWithWhite:0.9 alpha:1]];
        _lbMale.text=NSLocalizedStringFromTableInBundle(@"FEMALE",@"RPString", g_bundleResorce,nil);
    }
    _bFemale = bOn;
    _bEdited = YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if (textField == _tfBirthday || textField == _tfAlternatePhone || textField == _tfInterest) {
//        [UIView beginAnimations:nil context:nil];
//        self.frame = CGRectMake(0, -_viewFrame2.frame.origin.y + 2, self.frame.size.width, self.frame.size.height);
//        [UIView commitAnimations];
//    }
//    
//    if (textField == _tfEmail || textField == _tfFirstName || textField == _tfSurName) {
//        [UIView beginAnimations:nil context:nil];
//        self.frame = CGRectMake(0, -_viewFrame1.frame.origin.y + 2, self.frame.size.width, self.frame.size.height);
//        [UIView commitAnimations];
//    }
    
    _bEdited = YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_tfEditPhone != textField) {
        _viewEditing = textField;
    }
    return YES;
}
//-(void)OnSelectName
//{
//
//    
//    
//    
////    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
////    CGPoint p=[_tfDisplayName.superview convertPoint:_tfDisplayName.frame.origin toView:keywindow];
////    
////    NSInteger nCount = _arrayName.count > 6 ? 6 : _arrayName.count;
////    _listViewCareer = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 186, nCount * 42)];
////    
////    _listViewCareer.datasource = self;
////    _listViewCareer.delegate = self;
////    
////    [_listViewCareer show:CGPointMake(210,p.y+_tfDisplayName.frame.size.height+_listViewCareer.frame.size.height/2)];
//    
//    
//    
//    NSMutableArray *strArray=[[NSMutableArray alloc]init];
//    for (int i=0; i<2;i++)
//    {
//        NSString *strTemp = [_arrayName objectAtIndex:i];
//        [strArray addObject:strTemp];
//    }
//    
//    
//    
//    NSString *mode=NSLocalizedStringFromTableInBundle(@"CAREER",@"RPString", g_bundleResorce,nil);
//    
//    RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:mode clickButton:^(NSInteger indexButton) {
//        _tfDisplayName.text=[_arrayName objectAtIndex:indexButton];
//        
//        _index=indexButton;
//        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
//        [userDefaults setInteger:_index forKey:@"myTag"];
//        [self endEditing:YES];
//    } curIndex:_index  selectTitles:strArray];
//    [selectView show];
//
//}
//- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//    return 2;
//    
//}
//
//- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identifier = @"VendorCellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//   
//    
//    cell.textLabel.text =[_arrayName objectAtIndex:indexPath.row];
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
//    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
//    cell.textLabel.textAlignment=NSTextAlignmentRight;
//    return cell;
//   
//    
//    
//    
//}
//
//-(void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//
//- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
////    _nCareerIndex = indexPath.row;
//    
//    _tfDisplayName.text=[_arrayName objectAtIndex:indexPath.row];
//    
//    _index=indexPath.row;
//    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
//    [userDefaults setInteger:_index forKey:@"myTag"];
//    
//    [tableView dismiss];
//    [self endEditing:YES];
//}

//-(NSString *)stringFromDate:(NSDate *)date
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateFormat:@"MM-dd"];
//    return [formatter stringFromDate:date];
//}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    [UIView beginAnimations:nil context:nil];
//    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    [UIView commitAnimations];
    
//    if (textField == _tfBirthday) {
//        _tfBirthday.text = [self stringFromDate:_dpBirthDay.date];
//    }
    _viewEditing = nil;
}

-(void)setLoginProfile:(UserDetailInfo *)loginProfile
{
//    NSString *s1=[NSString stringWithFormat:@"%@ %@",loginProfile.strFirstName,loginProfile.strSurName];
//    NSString *s2=[NSString stringWithFormat:@"%@ %@",loginProfile.strSurName,loginProfile.strFirstName];
//    _arrayName=[[NSMutableArray alloc]initWithObjects:s1,s2, nil];

    _loginProfile = loginProfile;

    if (![_loginProfile.strUserId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId]) {
        _ivPhoneLock.hidden = YES;
    }
    else
    {
        _ivPhoneLock.hidden = NO;
    }
    
//    _tfSurName.text = loginProfile.strSurName;
    _tfFirstName.text = loginProfile.strFirstName;
//    _tfDisplayName.text=[_arrayName objectAtIndex:_index];
//    _tfDisplayName.adjustsFontSizeToFitWidth=YES;
    _lbPhone.text = loginProfile.strUserAcount;
    _tfEmail.text = loginProfile.strWorkEmail;
    _tfEmail.adjustsFontSizeToFitWidth=YES;
    _tfAlternatePhone.text = loginProfile.strAlternatePhone;
   
    _tfInterest.text = loginProfile.strInterest;
    _tfInterest.font=[UIFont systemFontOfSize:14.0f];
    _tfInterest.adjustsFontSizeToFitWidth=YES;
    _tfInterest.minimumFontSize=5;
//    _dpBirthDay.date = loginProfile.dateBirthday;
    if (loginProfile.nBirthYear==0) {
        _tfBirthYear.text=@"";
    }
    else
    {
        _tfBirthYear.text=[NSString stringWithFormat:@"%d",loginProfile.nBirthYear];
    }
    
    if (loginProfile.strBirthDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"MM-dd"];
        NSDate *date =[dateFormatter dateFromString:loginProfile.strBirthDate];
        _pickDate = [[RPDatePicker alloc] initDay:_tfBirthday Format:dateFormatter curDate:date canDelete:YES];
        //_tfBirthday.text = [self stringFromDate:loginProfile.dateBirthday];
    }
    
    [_btnUser setImageWithURLString:loginProfile.strPortraitImgBig forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Button_photo_01.png"]];
    
    if (loginProfile.sex == Sex_Female)
    {

        //        [_lbMale setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
        //        [_lbFemale setTextColor:[UIColor colorWithWhite:0.9 alpha:1]];
        _lbMale.text=NSLocalizedStringFromTableInBundle(@"FEMALE",@"RPString", g_bundleResorce,nil);
        _bFemale = YES;
    }
    else
    {
        //        [_lbMale setTextColor:[UIColor colorWithWhite:0.9 alpha:1]];
        //        [_lbFemale setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
        _lbMale.text=NSLocalizedStringFromTableInBundle(@"MALE",@"RPString", g_bundleResorce,nil);
        _bFemale = NO;
    }
    
    [_switchSex SetOn:_bFemale];
    
    if (!loginProfile.IsPublicAge) {
        _ivPublic.image = [UIImage imageNamed:@"icon_noselected_setup.png"];
    }
    else
    {
        _ivPublic.image = [UIImage imageNamed:@"icon_selected_setup.png"];
    }
}

-(IBAction)OnEditPhone:(id)sender
{
    if (![_loginProfile.strUserId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId])
    {
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        _tfEditPhone.text = _lbPhone.text;
        _viewEditPhoneFrame.frame = CGRectMake(0, 0, keywindow.frame.size.width, keywindow.frame.size.height);
        [keywindow addSubview:_viewEditPhoneFrame];
    }
}

-(IBAction)OnEditPhoneOK:(id)sender
{
    if (_tfEditPhone.text.length > 0)
    {
        _lbPhone.text = _tfEditPhone.text;
        [_viewEditPhoneFrame removeFromSuperview];
    }
}

-(IBAction)OnEditPhoneCancel:(id)sender
{
    [_viewEditPhoneFrame removeFromSuperview];
}

-(IBAction)OnTakePhoto:(id)sender
{
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Please select the image source type?",@"RPString", g_bundleResorce,nil);
    NSString * strCamera = NSLocalizedStringFromTableInBundle(@"Camera",@"RPString", g_bundleResorce,nil);
    NSString * strPhotoLibrary = NSLocalizedStringFromTableInBundle(@"Photo Library",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
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
    } otherButtonTitles:strCamera,strPhotoLibrary,nil];
    [alertView show];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    UIImage * imgCrop = [RPSDK CropImage:image withSize:CGSizeMake(640, 640)];
    [_btnUser setImage:imgCrop forState:UIControlStateNormal];
    _imgUser = imgCrop;
    _bImgChanged = YES;
    _bEdited = YES;
    [picker dismissModalViewControllerAnimated:NO];
}

-(BOOL)OnBack
{
    [self endEditing:YES];
    if (!_bEdited) {
        return YES;
    }
    else
    {
        if (!_bConfirmQuit) {
            NSString * strSave = NSLocalizedStringFromTableInBundle(@"SAVE",@"RPString", g_bundleResorce,nil);
            NSString * strDont = NSLocalizedStringFromTableInBundle(@"DON'T SAVE",@"RPString", g_bundleResorce,nil);
            NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Save changes before leave?",@"RPString", g_bundleResorce,nil);
            RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
                if (indexButton==2)
                {
                    _bConfirmQuit = YES;
                    [self.delegate OnChangeProfileEnd];
                    [self.delegate OnBackTask];
                }
                else if(indexButton==0)
                {
                    _bConfirmQuit=NO;
                }
                else
                {
                    [self saveOK];
                }
            }otherButtonTitles:strSave,strDont, nil];
            [alertView show];
            
            return NO;
        }
        else
        {
            return YES;
        }
    }
//
//    if (!_bConfirmQuit) {
//
//        NSString * str = NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil);
//        [SVProgressHUD showWithStatus:str];
//        
//        UserProfileUpdate * update = [[UserProfileUpdate alloc] init];
//        update.strUserId = _loginProfile.strUserId;
//        update.strFirstName = _tfFirstName.text;
//        update.strSurName = _tfSurName.text;
//        update.strWorkEmail = _tfEmail.text;
//        update.dateBirthday = _dpBirthDay.date;
//        update.strInterest = _tfInterest.text;
//        update.strAlternatePhone = _tfAlternatePhone.text;
//        if (_bImgChanged)
//           update.imgUser = _imgUser;
//        else
//            update.imgUser = nil;
//        
//        if (_bFemale)
//            update.sex = Sex_Female;
//        else
//            update.sex = Sex_Male;
//        update.IsPublicAge = _bPublicAge;
//        
//        [[RPSDK defaultInstance] UpdateUserProfile:update Success:^(id idResult) {
//            [self.delegate OnChangeProfileEnd];
//            NSString * str = NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil);
//            [SVProgressHUD showSuccessWithStatus:str];
//        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
//            [self.delegate OnChangeProfileEnd];
//        }];
//        _bConfirmQuit = YES;
//        return NO;
//    }
    return NO;
}
-(BOOL)OutofRange
{
    NSDate *nowTime =[NSDate date];
    NSCalendar*calendar=[NSCalendar currentCalendar];
    NSDateComponents*components =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:nowTime];
    int year=[components year];
    if ([_tfBirthYear.text isEqualToString:@""]) {
        return NO;
    }
    else if ([_tfBirthYear.text intValue]<1900||[_tfBirthYear.text intValue]>year-1)
    {
        return YES;
    }
    return NO;
}
-(void)saveOK
{
    if (_tfFirstName.text.length>RPMAX_NAME_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Name length should not exceed 20 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
     if([self OutofRange])
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"The year of birth is out of range",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
    }
    else
    {
        _bConfirmQuit=YES;
            NSString * str = NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil);
            [SVProgressHUD showWithStatus:str];
            
            UserProfileUpdate * update = [[UserProfileUpdate alloc] init];
            update.strUserId = _loginProfile.strUserId;
            update.strFirstName = _tfFirstName.text;
//            update.strSurName = _tfSurName.text;
            update.strWorkEmail = _tfEmail.text;
        
        if (_tfBirthday.text.length == 0) {
            update.strBirthDate = @"";
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat: @"MM-dd"];
            update.strBirthDate = [dateFormatter stringFromDate:[_pickDate GetDay]];
        }
        
        update.strInterest = _tfInterest.text;
        update.strAlternatePhone = _tfAlternatePhone.text;
        update.nBirthYear=[_tfBirthYear.text intValue];
        if (_bImgChanged)
            update.imgUser = _imgUser;
        else
            update.imgUser = nil;
        
        if (_bFemale)
            update.sex = Sex_Female;
        else
            update.sex = Sex_Male;
        
        update.strOnBoard = _tfOnBoard.text;
        update.strOfficePhone = _tfOfficePhone.text;
        update.strOfficeAddress = _tvOfficeAddress.text;
        update.strUserAccount = _lbPhone.text;
        [[RPSDK defaultInstance] UpdateUserProfile:update Success:^(id idResult) {
            NSString * str = NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil);
            [SVProgressHUD showSuccessWithStatus:str];
            [self.delegate OnChangeProfileEnd];
            [self.delegate OnBackTask];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
}

@end
