//
//  RPCareerView.m
//  RetailPlus
//
//  Created by lin dong on 13-11-18.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPCareerView.h"
#import "SVProgressHUD.h"


extern NSBundle * g_bundleResorce;
@implementation RPCareerView

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
    [self OnShowQuit:nil];
    _viewFrame1.layer.cornerRadius = 8;
    _viewFrame1.layer.borderWidth = 1;
    _viewFrame1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _viewFrame2.layer.cornerRadius = 8;
    _viewFrame2.layer.borderWidth = 1;
    _viewFrame2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _viewFrame3.layer.cornerRadius = 8;
    _viewFrame3.layer.borderWidth = 1;
    _viewFrame3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _btnQuit.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    _btnQuit.layer.borderWidth = 1;
    _btnQuit.layer.cornerRadius = 6;
    
    _viewBtnFrame.layer.cornerRadius = 6;
    _viewBtnFrame.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewBtnFrame.layer.borderWidth = 1;
    
    _viewEditFrame.layer.cornerRadius = 6;
    _viewEditFrame.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewEditFrame.layer.borderWidth = 1;
    
    _lbJobTitle.layer.cornerRadius = 3;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(IBAction)OnShowQuit:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    if (_bHide) {
        _viewFrame1.frame = CGRectMake(_viewFrame1.frame.origin.x, _viewFrame1.frame.origin.y, _viewFrame1.frame.size.width, 229);
        [_btnHide setImage:[UIImage imageNamed:@"botton_pagerollup_01.png"] forState:UIControlStateNormal];
    }
    else
    {
        _viewFrame1.frame = CGRectMake(_viewFrame1.frame.origin.x, _viewFrame1.frame.origin.y, _viewFrame1.frame.size.width, 170);
        [_btnHide setImage:[UIImage imageNamed:@"botton_pageextend_01.png"] forState:UIControlStateNormal];
    }
    [UIView commitAnimations];
    
    _bHide = !_bHide;
}

-(IBAction)OnQuit:(id)sender
{
    if (_loginProfile.bCanDelete == NO)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
        return;
    }
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    _viewCofirmQuit.frame = CGRectMake(0, 0, keywindow.frame.size.width, keywindow.frame.size.height);
    _tfConfirm.text = @"";
    [keywindow addSubview:_viewCofirmQuit];
    [_btnConfirm setEnabled:NO];
}

-(IBAction)OnCancelConfirm:(id)sender
{
    [_viewCofirmQuit removeFromSuperview];
}

-(IBAction)OnConfirmQuit:(id)sender
{
    [_viewCofirmQuit endEditing:NO];
    
    NSString * str = NSLocalizedStringFromTableInBundle(@"Quit...",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showWithStatus:str];
    
    [[RPSDK defaultInstance] Quit:_loginProfile.strUserId Success:^(id dictResult) {
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        _viewCofirmQuit.frame = CGRectMake(0, keywindow.frame.size.height, keywindow.frame.size.width, keywindow.frame.size.height);
        
        NSString * str = NSLocalizedStringFromTableInBundle(@"Quit Success",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showSuccessWithStatus:str];
        
        if ([_loginProfile.strUserId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId])
            [self.delegate OnLogout];
        else
            [self.delegate OnDeleteUser];
        
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {

    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    _viewConfirmFrame.frame = CGRectMake(0, 0, _viewConfirmFrame.frame.size.width, _viewConfirmFrame.frame.size.height);
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _viewEditing = nil;
    
    [UIView beginAnimations:nil context:nil];
     _viewConfirmFrame.frame = CGRectMake(0, _viewCofirmQuit.frame.size.height - _viewConfirmFrame.frame.size.height, _viewConfirmFrame.frame.size.width, _viewConfirmFrame.frame.size.height);
    [UIView commitAnimations];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = nil;
	if (range.length == 0) {
		newString = [textField.text stringByAppendingString:string];
	} else {
		NSString *headPart = [textField.text substringToIndex:range.location];
		NSString *tailPart = [textField.text substringFromIndex:range.location+range.length];
		newString = [NSString stringWithFormat:@"%@%@",headPart,tailPart];
	}
    
    if ([newString isEqualToString:@"DELETE"]) {
        [_btnConfirm setEnabled:YES];
    }
    else
    {
        [_btnConfirm setEnabled:NO];
    }
    
    return YES;
}

-(void)setPositionInfo:(UserDetailInfo *)loginProfile
{
    _lbPosition.text = loginProfile.strDomainName;
    //_lbPosition.adjustsFontSizeToFitWidth=YES;
    
    CGSize size = [loginProfile.strRoleName sizeWithFont:_lbJobTitle.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    NSInteger nWidth = size.width + 10;
    if (size.width < 10) nWidth = 10;
    if (size.width > 175) nWidth = 175;
    
    _lbJobTitle.frame = CGRectMake(_lbJobTitle.frame.origin.x + _lbJobTitle.frame.size.width - nWidth, _lbJobTitle.frame.origin.y, nWidth, _lbJobTitle.frame.size.height);
    
    _lbJobTitle.text = loginProfile.strRoleName;
    
    switch (loginProfile.rank) {
        case Rank_Manager:
            _lbJobTitle.backgroundColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbJobTitle.backgroundColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _lbJobTitle.backgroundColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _lbJobTitle.backgroundColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
            
        default:
            break;
    }
}

-(void)setReporter:(UserDetailInfo *)loginProfile
{
    _lbReportTo.text = loginProfile.strReportTo;
}

-(void)setLoginProfile:(UserDetailInfo *)loginProfile
{
    _loginProfile = loginProfile;
    
    _lbEnterprise.text = loginProfile.strEnterpise;
    _lbPosition.text = loginProfile.strDomainName;
    //_lbPosition.adjustsFontSizeToFitWidth=YES;
    
    CGSize size = [loginProfile.strRoleName sizeWithFont:_lbJobTitle.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    NSInteger nWidth = size.width + 10;
    if (size.width < 10) nWidth = 10;
    if (size.width > 175) nWidth = 175;
    
    _lbJobTitle.frame = CGRectMake(_lbJobTitle.frame.origin.x + _lbJobTitle.frame.size.width - nWidth, _lbJobTitle.frame.origin.y, nWidth, _lbJobTitle.frame.size.height);
    
    _lbJobTitle.text = loginProfile.strRoleName;
    _lbReportTo.text = loginProfile.strReportTo;
    //_lbReportTo.adjustsFontSizeToFitWidth=YES;
    //_lbJoinedAt.text = loginProfile.strJoinedDate;
    _tfJoinedAt.text = loginProfile.strJoinedDate;
    _tfOfficePhone.text = loginProfile.strOfficePhoneNumber;
    _tvOfficeAddr.text = loginProfile.strOfficeAddress;
    
    switch (loginProfile.rank) {
        case Rank_Manager:
            _lbJobTitle.backgroundColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbJobTitle.backgroundColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _lbJobTitle.backgroundColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _lbJobTitle.backgroundColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
            
        default:
            break;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date =[dateFormatter dateFromString:loginProfile.strJoinedDate];
    _pickDate = [[RPDatePicker alloc] init:_tfJoinedAt Format:dateFormatter curDate:date canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    
    if (_loginProfile.bCanModify && ![_loginProfile.strUserId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId]) {
        _ivReportTo.hidden = YES;
        _btnReportTo.userInteractionEnabled = YES;
    }
    else
    {
        _ivReportTo.hidden = NO;
        _btnReportTo.userInteractionEnabled = NO;
    }
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _viewEditing = textField;
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _viewEditing = textView;
    return YES;
}


@end
