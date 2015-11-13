//
//  RPCourtesyCallView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-11.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCourtesyCallView.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"
#import "RPBlockUISelectView.h"
#import "UIImageView+WebCache.h"
extern NSBundle * g_bundleResorce;
@implementation RPCourtesyCallView

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
    NSArray *array = [g_bundleResorce loadNibNamed:@"CustomView" owner:self options:nil];
    _viewCustomerList = [array objectAtIndex:3];
    _viewCustomerList.delegate = self;
    _viewCustomerList.bSelfOnly = YES;
    
    _step=CALLSTEP_SELF;
    
    _index = -1;
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
            [self.delegate endCourtesyCall];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
    
}
-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}
-(BOOL)OnBack
{
    //离开前重置check状态
    if (_entrance==2)
    {
        _bCheck=YES;
        [self OnMakePlan:nil];
    }
    switch (_step)
    {
        case CALLSTEP_CUSTOMER:
        {
            [_viewCustomerList dismiss];
            [self dismissView:_viewCustomerList];
            _step=CALLSTEP_SELF;
        }
            break;
        case CALLSTEP_CALLRECORD:
        {
            [_viewCallRecord OnBack];
            [self dismissView:_viewCallRecord];
            _step=CALLSTEP_SELF;
        }
        case CALLSTEP_MAKEPLAN:
        {
            if ([_viewAddCallPlan OnBack])
            {
                [self dismissView:_viewAddCallPlan];
                _step=CALLSTEP_SELF;
            }

        }
            break;
        default:return YES;
            break;
    }
    return NO;
}

- (IBAction)OnCompleteRecord:(id)sender
{
    //离开前重置check状态
    if (_entrance==2)
    {
        _bCheck=YES;
        [self OnMakePlan:nil];
    }
    
    _viewCallRecord.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewCallRecord];
//    _viewCallRecord.delegate=self;
    [UIView beginAnimations:nil context:nil];
    _viewCallRecord.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _viewCallRecord.entrance=_entrance;
    _courtesyCallInfo.bSuccess = YES;
    _viewCallRecord.courtesyCallInfo=_courtesyCallInfo;
    _viewCallRecord.customer=_customer;
    _viewCallRecord.callType=_callType;
    _step=CALLSTEP_CALLRECORD;
}

- (IBAction)OnSelectCustomer:(id)sender
{
    _viewCustomerList.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self insertSubview:_viewCustomerList belowSubview:_viewBottom];
    
    [UIView beginAnimations:nil context:nil];
    _viewCustomerList.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _step=CALLSTEP_CUSTOMER;
    [_viewCustomerList reloadCustomer];
}
-(void)OnSelectedCustomer:(Customer *)customer
{
    [self dismissView:_viewCustomerList];
    _step = CALLSTEP_SELF;
    
    if ([customer.strCustomerId isEqualToString:_customer.strCustomerId]) return;
    _customer=customer;
    _courtesyCallInfo.customer=_customer;
    [self updateUI];
}
- (IBAction)OnMakePlan:(id)sender
{
    if (_entrance==1)
    {
        _viewAddCallPlan.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:_viewAddCallPlan];
        [UIView beginAnimations:nil context:nil];
        _viewAddCallPlan.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _viewAddCallPlan.arrayType=_arrayType;
        _viewAddCallPlan.entrance=2;
        _viewAddCallPlan.courtesyCallInfo=_courtesyCallInfo;
        _viewAddCallPlan.bModify=NO;
        _step=CALLSTEP_MAKEPLAN;
    }
    else if (_entrance==2)
    {
        _bCheck=!_bCheck;
        if (_bCheck)
        {
            _viewBackground.backgroundColor=[UIColor colorWithRed:255.0/255 green:245.0/255 blue:230.0/255 alpha:1];
            _lbTitle1.text=NSLocalizedStringFromTableInBundle(@"PLAN TIME",@"RPString", g_bundleResorce,nil);
            _lbTitle2.text=NSLocalizedStringFromTableInBundle(@"REMARKS",@"RPString", g_bundleResorce,nil);
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy/MM/dd ccc."];
            [_btPurpose setTitle:[dateFormatter stringFromDate:_courtesyCallInfo.datePlan] forState:UIControlStateNormal];
            [_btPurpose setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
//            _btPurpose.userInteractionEnabled=NO;
            
                _tvGuide.text=_courtesyCallInfo.strComment;
            [_btMakePlan setBackgroundImage:[UIImage imageNamed:@"button_viewplan_pressed@2x.png"] forState:UIControlStateNormal];
            
        }
        else
        {
//            _btPurpose.userInteractionEnabled=YES;
            _viewBackground.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
            _lbTitle1.text=NSLocalizedStringFromTableInBundle(@"CALL PURPOSE",@"RPString", g_bundleResorce,nil);
            _lbTitle2.text=NSLocalizedStringFromTableInBundle(@"CALL GUIDE",@"RPString", g_bundleResorce,nil);
            [_btMakePlan setBackgroundImage:[UIImage imageNamed:@"button_viewplan@2x.png"] forState:UIControlStateNormal];
            if (_callType)
            {
                [_btPurpose setTitle:_callType.strCourtesyCallTips forState:UIControlStateNormal];
                [_btPurpose setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
                
                _tvGuide.text=_callType.strDescription;
            }
            else
            {
                [_btPurpose setTitle:NSLocalizedStringFromTableInBundle(@"Select call purpose",@"RPString", g_bundleResorce,nil) forState:UIControlStateNormal];
                [_btPurpose setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
                
            }
        }
    }
}

- (IBAction)OnCall:(id)sender
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    _viewConfirmNumber.delegate=self;
    _viewConfirmNumber.courtesyCallInfo = _courtesyCallInfo;
    _viewConfirmNumber.frame = CGRectMake(0, 0, keywindow.frame.size.width, keywindow.frame.size.height);
    _viewConfirmNumber.customer=_customer;
    _viewConfirmNumber.callType=_callType;
    [keywindow addSubview:_viewConfirmNumber];
    _viewConfirmNumber.customer=_customer;
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
            _courtesyCallInfo.strCourtesyCallTypeId=_callType.strCourtesyCallTypeId;
            [self updateUI];
        
        }
        
    } curIndex:_index  selectTitles:array];
    [selectView show];
}
////退出
//-(void)endCallRecord
//{
//    [self.delegate endCourtesyCall];
//}

-(void)updateUI
{
    if (_entrance==1)
    {
        [_btMakePlan setTitle:NSLocalizedStringFromTableInBundle(@"MAKE   PLAN",@"RPString", g_bundleResorce,nil) forState:UIControlStateNormal];
        _btMakePlan.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
        [_btMakePlan setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    else if(_entrance==2)
    {
        [_btMakePlan setTitle:NSLocalizedStringFromTableInBundle(@"CHECK   PLAN",@"RPString", g_bundleResorce,nil) forState:UIControlStateNormal];
    }
    if (_customer)
    {
        _lbCustomer.text = [NSString stringWithFormat:@"%@",_customer.strFirstName];
        _lbCustomer.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        
        _ivPhone.hidden=NO;
        _lbPhoneNumber.hidden=NO;
        _lbPhoneNumber.text=_customer.strPhone1;
        _ivVip.hidden=!_customer.isVip;
        [_ivHeader setImage:[UIImage imageNamed:@"icon_userimage01_224@2x.png"]];
        if (_customer.strCustImgBig)
        {
            [_ivHeader setImageWithURLString:_customer.strCustImgBig placeholderImage:[UIImage imageNamed:@"icon_userimage01_224@2x.png"]];
        }
    }
    else
    {
        _lbCustomer.text = NSLocalizedStringFromTableInBundle(@"Select customer",@"RPString", g_bundleResorce,nil);
        _lbCustomer.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        
        _ivPhone.hidden=YES;
        _lbPhoneNumber.hidden=YES;
        _ivVip.hidden=YES;
        [_ivHeader setImage:[UIImage imageNamed:@"icon_userimage01_224@2x.png"]];
    }
    if (_callType)
    {
        [_btPurpose setTitle:_callType.strCourtesyCallTips forState:UIControlStateNormal];
        [_btPurpose setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
        _tvGuide.text=_callType.strDescription;
    }
    else
    {
        [_btPurpose setTitle:NSLocalizedStringFromTableInBundle(@"Select call purpose",@"RPString", g_bundleResorce,nil) forState:UIControlStateNormal];
        [_btPurpose setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
        _tvGuide.text = @"";
    }
    
    //设置是否可打电话，记录
    if (_customer&&_callType)
    {
        if (_entrance==1)
        {
            [_btCall setBackgroundImage:[UIImage imageNamed:@"button_ccall_active@2x.png"] forState:UIControlStateNormal];
            _btMakePlan.backgroundColor=[UIColor colorWithRed:80.0f/255 green:150.0f/255 blue:105.0f/255 alpha:1];
            _btGoRecord.backgroundColor=[UIColor colorWithRed:48.0f/255 green:75.0f/255 blue:75.0f/255 alpha:1];
            _btCall.userInteractionEnabled=YES;
            _btGoRecord.userInteractionEnabled=YES;
            _btMakePlan.userInteractionEnabled=YES;
        }
        else if(_entrance==2)
        {
            [_btCall setBackgroundImage:[UIImage imageNamed:@"button_ccall_active@2x.png"] forState:UIControlStateNormal];
            [_btMakePlan setBackgroundImage:[UIImage imageNamed:@"button_viewplan@2x.png"] forState:UIControlStateNormal];
            
            _btGoRecord.backgroundColor=[UIColor colorWithRed:48.0f/255 green:75.0f/255 blue:75.0f/255 alpha:1];
            _btCall.userInteractionEnabled=YES;
            _btGoRecord.userInteractionEnabled=YES;
            _btMakePlan.userInteractionEnabled=YES;
        }
        
    }
    else
    {
        [_btCall setBackgroundImage:[UIImage imageNamed:@"button_ccall_noactive@2x.png"] forState:UIControlStateNormal];
        _btMakePlan.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
        _btGoRecord.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
        _btCall.userInteractionEnabled=NO;
        _btGoRecord.userInteractionEnabled=NO;
        _btMakePlan.userInteractionEnabled=NO;
    }
}
-(void)setArrayType:(NSArray *)arrayType
{
    _arrayType=arrayType;
    _step=CALLSTEP_SELF;
    [self updateUI];
}
-(void)setEntrance:(int)entrance
{
    _entrance=entrance;
    if (entrance==1)
    {
        _btPurpose.userInteractionEnabled=YES;
        _btCustomer.userInteractionEnabled=YES;
    }
    else if (entrance==2)
    {
        _btPurpose.userInteractionEnabled=NO;
        _btCustomer.userInteractionEnabled=NO;
    }
    _callType=nil;
    _customer=nil;
    _courtesyCallInfo=[[CourtesyCallInfo alloc]init];
}
-(void)setCourtesyCallInfo:(CourtesyCallInfo *)courtesyCallInfo
{
    _courtesyCallInfo=courtesyCallInfo;
    _customer=courtesyCallInfo.customer;
    for (int i=0; i<_arrayType.count; i++)
    {
        if ([courtesyCallInfo.strCourtesyCallTypeId isEqualToString:[[_arrayType objectAtIndex:i]strCourtesyCallTypeId]])
        {
            _callType=[_arrayType objectAtIndex:i];
            break;
        }
    }
    [self updateUI];
}
-(void)setCustomer:(Customer *)customer
{
    _customer=customer;
    _courtesyCallInfo.customer=_customer;
    [self updateUI];
}

-(void)OnRPCCCallEnd
{
    [_viewConfirmNumber removeFromSuperview];
    if (_entrance==1)
         [self.delegate completeRecord];
    else
        [self.delegateOK RecordOK];
}
@end
