//
//  RPAddCallPlanView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-14.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPAddCallPlanView.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"
#import "RPBlockUISelectView.h"
#import "UIImageView+WebCache.h"
extern NSBundle * g_bundleResorce;
@implementation RPAddCallPlanView

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
    _viewFrame.layer.cornerRadius=10;
    _ivHeader.layer.cornerRadius=6;
    _ivHeader.layer.borderWidth=1;
    _ivHeader.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    [_viewFrame addGestureRecognizer:singleTapGR];

//    _datePicker=[[UIDatePicker alloc]init];
//    _datePicker.datePickerMode=UIDatePickerModeDate;
//    _tfDate.inputView=_datePicker;
//    [_datePicker addTarget:self action:@selector(datePickerDateChange:) forControlEvents:UIControlEventValueChanged];
    
//    _TimePicker=[[UIDatePicker alloc]init];
//    _TimePicker.datePickerMode=UIDatePickerModeTime;
//    _tfTime.inputView=_TimePicker;
//    [_TimePicker addTarget:self action:@selector(timePickerDateChange:) forControlEvents:UIControlEventValueChanged];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"yyyy/MM/dd ccc."];
    NSDate *nowDate=[NSDate date];
    _datePicker = [[RPDatePicker alloc] init:_tfDate Format:dateFormatter1 curDate:nowDate canDelete:NO Mode:UIDatePickerModeDate canFuture:YES canPreviously:NO];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    _TimePicker = [[RPDatePicker alloc] init:_tfTime Format:dateFormatter2 curDate:nowDate canDelete:NO Mode:UIDatePickerModeTime canFuture:YES canPreviously:NO];
    
    NSArray *array = [g_bundleResorce loadNibNamed:@"CustomView" owner:self options:nil];
    _viewCustomerList = [array objectAtIndex:3];
     _viewCustomerList.delegate = self;
    _viewCustomerList.bSelfOnly = YES;
    
    _switchRemind=[[RPSwitchView alloc]initWithFrame:CGRectMake(0, 0, _viewSwitch.frame.size.width, _viewSwitch.frame.size.height)];
    _switchRemind.delegate=self;
    [_viewSwitch addSubview:_switchRemind];
    _switchRemind.imgBack=[UIImage imageNamed:@"image_switcher_reminder@2x.png"];
    [_switchRemind SetOn:NO];
    _bRemind=NO;
    _index = -1;
}
- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self endEditing:YES];
}
//-(void)datePickerDateChange:(UIDatePicker *)paramDatePicker
//{
//    if ([paramDatePicker isEqual:_datePicker]) {
//        _date=paramDatePicker.date;
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"yyyy/MM/dd ccc."];
//        [_tfDate setText:[dateFormatter stringFromDate:paramDatePicker.date]];
//    }
//}
//-(void)timePickerDateChange:(UIDatePicker *)paramDatePicker
//{
//    if ([paramDatePicker isEqual:_TimePicker]) {
//        _remindTime=paramDatePicker.date;
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"HH:mm"];
//        NSString *time=[dateFormatter stringFromDate:paramDatePicker.date];
//        [_tfTime setText:time];
//    }
//}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==_tfDate)
    {
        _date=[_datePicker GetDate];
    }
    if (textField==_tfTime)
    {
        _remindTime=[_datePicker GetDate];
    }
}
-(void)SelectSwitch:(RPSwitchView *)view isOn:(BOOL)bOn
{
    if (view==_switchRemind)
    {
        _bRemind=bOn;
        if (bOn)
        {
            _tfTime.textColor=[UIColor colorWithRed:48.0/255 green:115.0/255 blue:119.0/255 alpha:1];
        }
        else
        {
            _tfTime.textColor=[UIColor colorWithWhite:0.7 alpha:1];
        }
    }
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    _viewBackground.frame=CGRectMake(_viewBackground.frame.origin.x, _viewBackground.frame.origin.y-100, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    _viewBackground.frame=CGRectMake(_viewBackground.frame.origin.x, _viewBackground.frame.origin.y+100, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}
-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}
-(void)updateUI
{
    if (_customer)
    {
        _lbCustomer.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        _lbCustomer.text = [NSString stringWithFormat:@"%@",_customer.strFirstName];
        _ivPhone.hidden=NO;
        _lbPhoneNumber.hidden=NO;
        _lbPhoneNumber.text=_customer.strPhone1;
        _ivVip.hidden=!_customer.isVip;
        
         [_ivHeader setImage:[UIImage imageNamed:@"icon_userimage01_224@2x.png"]];
        if (_customer.strCustImgBig) {
            [_ivHeader setImageWithURLString:_customer.strCustImgBig placeholderImage:[UIImage imageNamed:@"icon_userimage01_224@2x.png"]];
        }
    }
    else
    {
        _lbCustomer.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        _lbCustomer.text = NSLocalizedStringFromTableInBundle(@"Select customer",@"RPString", g_bundleResorce,nil);
        
   //     [_btCustomer setTitle:NSLocalizedStringFromTableInBundle(@"Select customer",@"RPString", g_bundleResorce,nil) forState:UIControlStateNormal];
   //     [_btCustomer setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
        _ivPhone.hidden=YES;
        _lbPhoneNumber.hidden=YES;
        _ivVip.hidden=YES;
        [_ivHeader setImage:[UIImage imageNamed:@"icon_userimage01_224@2x.png"]];
    }
    if (_callType)
    {
        [_btPurpose setTitle:_callType.strCourtesyCallTips forState:UIControlStateNormal];
        [_btPurpose setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    }
    else
    {
        [_btPurpose setTitle:NSLocalizedStringFromTableInBundle(@"Select call purpose",@"RPString", g_bundleResorce,nil) forState:UIControlStateNormal];
        [_btPurpose setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
    
    }
//    [self SelectSwitch:_switchRemind isOn:_bRemind];
}
- (IBAction)OnSelectCustomer:(id)sender
{
    _viewCustomerList.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self insertSubview:_viewCustomerList belowSubview:_viewBottom];
    
    [UIView beginAnimations:nil context:nil];
    _viewCustomerList.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bCustomerList=YES;
    [_viewCustomerList reloadCustomer];
}
-(void)OnSelectedCustomer:(Customer *)customer
{
    [self dismissView:_viewCustomerList];
    _bCustomerList=NO;
    
    if ([customer.strCustomerId isEqualToString:_customer.strCustomerId]) return;
    _customer=customer;
    [self updateUI];
}
- (IBAction)OnSelectCallPurpose:(id)sender
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    for (int i=0; i<_arrayType.count; i++)
    {
        [array addObject:[[_arrayType objectAtIndex:i]strCourtesyCallTips]];
    }
    
    NSString *mode=NSLocalizedStringFromTableInBundle(@"Select call purpose",@"RPString", g_bundleResorce,nil);
    
    RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:mode clickButton:^(NSInteger indexButton) {
        if (indexButton>-1) {
            _index=indexButton;
            _callType=[_arrayType objectAtIndex:indexButton];
            [self updateUI];
            
        }
        
    } curIndex:_index  selectTitles:array];
    [selectView show];
}
-(void)setArrayType:(NSArray *)arrayType{
    _tvRemarks.text=@"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd ccc."];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    _tfDate.text=[dateFormatter stringFromDate:[NSDate date]];
    _tfTime.text=[dateFormatter2 stringFromDate:[NSDate date]];
    _date=[NSDate date];
    
    _arrayType=arrayType;
    _callType=nil;
    _customer=nil;
    [self updateUI];
}
-(void)setCourtesyCallInfo:(CourtesyCallInfo *)courtesyCallInfo
{
    _courtesyCallInfo=courtesyCallInfo;
    _customer=_courtesyCallInfo.customer;
    for (int i=0; i<_arrayType.count; i++)
    {
        if ([courtesyCallInfo.strCourtesyCallTypeId isEqualToString:[[_arrayType objectAtIndex:i]strCourtesyCallTypeId]])
        {
            _callType=[_arrayType objectAtIndex:i];
            break;
        }
    }
    _bRemind=courtesyCallInfo.bRemind;
    [_switchRemind SetOn:_bRemind];
    if (_bRemind)
    {
        _tfTime.textColor=[UIColor colorWithRed:48.0/255 green:115.0/255 blue:119.0/255 alpha:1];
    }
    else
    {
        _tfTime.textColor=[UIColor colorWithWhite:0.7 alpha:1];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd ccc."];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    if (courtesyCallInfo.datePlan)
    {
        _tfDate.text=[dateFormatter stringFromDate:courtesyCallInfo.datePlan];
        _date=courtesyCallInfo.datePlan;
    }
    else
    {
        _tfDate.text=[dateFormatter stringFromDate:[NSDate date]];
    }
    if (courtesyCallInfo.dateRemind)
    {
        _tfTime.text=[dateFormatter2 stringFromDate:courtesyCallInfo.dateRemind];
        _remindTime=courtesyCallInfo.dateRemind;
    }
    else
    {
        _tfTime.text=[dateFormatter2 stringFromDate:[NSDate date]];
    }
    _tvRemarks.text=courtesyCallInfo.strComment;
    
    [self updateUI];
}
-(void)setCustomer:(Customer *)customer
{
    _customer=customer;
    [self updateUI];
}
-(BOOL)OnBack
{
    if (_bCustomerList)
    {
        [self dismissView:_viewCustomerList];
        _bCustomerList=NO;
        return NO;
    }
    return YES;
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}

-(IBAction)OnQuit:(id)sender
{
    [self endEditing:YES];
    
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to exit?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [self.delegate endAddCallPlan];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
    
}
-(NSString *)changeToString:(NSString *)s
{
    if (s.length==0)
    {
        s=@"";
    }
    return s;
}
-(void)OnOK:(id)sender
{
    if (!_customer||!_callType)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Customer or call purpose can't be empty",@"RPString", g_bundleResorce,nil)];
        return;
    }
    if (_tvRemarks.text.length>RPMAX_DESC_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Remarks length should not exceed 300 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    CourtesyCallInfo * info=[[CourtesyCallInfo alloc]init];
    info.customer=_customer;
    info.strComment=[self changeToString:_tvRemarks.text];
    info.strCourtesyCallTypeId=_callType.strCourtesyCallTypeId;
    info.strTelephoneNo=_lbPhoneNumber.text;
    info.datePlan=_date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    if (_bRemind) {
       // NSString * strRemind = [NSString stringWithFormat:@"%@ %@",_tfDate.text,_tfTime.text];
       // info.dateRemind=[dateFormatter dateFromString:strRemind];
        NSString * str = [NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:_date],_tfTime.text];
        info.dateRemind = [dateFormatter2 dateFromString:str];
        
    }
    info.isCompleted=NO;
    info.bRemind=_bRemind;
    if (_bModify)
    {
        info.strID = _courtesyCallInfo.strID;
        [[RPSDK defaultInstance]EditCourtesyCallInfo:info Success:^(id idResult) {
            [self.delegateOK endAddCallPlanOK];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
        }];
    }
    else
    {
        [[RPSDK defaultInstance]AddCourtesyCallInfo:info Success:^(id idResult) {
            if (_entrance==1)//1代表从添加计划进入本界面，2代表从打电话进入本界面

            {
                [self.delegateOK endAddCallPlanOK];
            }
            else if(_entrance==2)
            {
                
                [self.delegateOK backToStart];
                [self removeFromSuperview];
                
            }
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
        }];
    }
}
@end
