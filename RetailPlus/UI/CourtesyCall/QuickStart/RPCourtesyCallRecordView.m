//
//  RPCourtesyCallRecordView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-11.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCourtesyCallRecordView.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;
@implementation RPCourtesyCallRecordView

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
    _viewHead.layer.cornerRadius=10;
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    [self addGestureRecognizer:singleTapGR];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
//    NSDate *nowDate=[NSDate date];
//    _pickDate = [[RPDatePicker alloc] init:_tfDate Format:dateFormatter curDate:nowDate canDelete:NO Mode:UIDatePickerModeDateAndTime canFuture:NO];
    
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
//        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
//        NSString *time=[dateFormatter stringFromDate:_date];
//        [_tfDate setText:time];
//    }
//}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _date=[_pickDate GetDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    _tfDate.text=[dateFormatter stringFromDate:_date];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==_tfDate)
    {
        _date=[_pickDate GetDate];
    }
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}

-(void)OnQuit:(id)sender
{
    [self endEditing:YES];
    
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to exit?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [self.delegate endCallRecord];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
    
}

//- (IBAction)OnSetTime:(id)sender
//{
//    _datePicker.hidden=!_datePicker.hidden;
//}
-(NSString *)changeToString:(NSString *)s
{
    if (s.length==0)
    {
        s=@"";
    }
    return s;
}
- (IBAction)OnOK:(id)sender
{
    [self endEditing:YES];
    //离开前重置check状态
    if (_entrance!=1)
    {
        _bCheck=YES;
        [self OnCheck:nil];
    }
    if (_tvRemarks.text.length>RPMAX_DESC_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Remarks length should not exceed 300 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    CourtesyCallInfo *info=[[CourtesyCallInfo alloc]init];
    info.strComment=[self changeToString:_tvRemarks.text];
    info.customer=_customer;
    info.strCourtesyCallTypeId=_callType.strCourtesyCallTypeId;
    info.strTelephoneNo=_lbPhoneNumber.text;
    info.dateCC=_date;
    info.isCompleted=YES;
    if (_entrance==1)
    {
        if (!info.dateCC)
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Actual finish time can't be empty",@"RPString", g_bundleResorce,nil)];
            return;
        }
        [[RPSDK defaultInstance]AddCourtesyCallInfo:info Success:^(id idResult) {
            [self removeFromSuperview];
            [self.delegate completeRecord];
            
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
        }];
    }
    else if(_entrance==2)
    {
        info.strID = _courtesyCallInfo.strID;
        info.userCaller = _courtesyCallInfo.userCaller;
        info.datePlan = _courtesyCallInfo.datePlan;
        info.dateRemind = _courtesyCallInfo.dateRemind;
        
        if (!info.dateCC)
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Actual finish time can't be empty",@"RPString", g_bundleResorce,nil)];
            return;
        }
        [[RPSDK defaultInstance]EditCourtesyCallInfo:info Success:^(id idResult) {
            [self removeFromSuperview];
            [self.delegateOK RecordOK];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
        }];
    }
    else if(_entrance==3)
    {
        info.strID = _courtesyCallInfo.strID;
        info.userCaller = _courtesyCallInfo.userCaller;
        info.datePlan = _courtesyCallInfo.datePlan;
        info.dateRemind = _courtesyCallInfo.dateRemind;
        
        [[RPSDK defaultInstance]EditCourtesyCallInfo:info Success:^(id idResult) {
            [self.delegateOKToRecordList RecordOKToRecordList];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
        }];
    }
}

- (IBAction)OnCheck:(id)sender
{
    _bCheck=!_bCheck;
    if (_bCheck)
    {
        _lbTitle.text=NSLocalizedStringFromTableInBundle(@"PLAN TO FINISH IN",@"RPString", g_bundleResorce,nil);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd ccc."];
        _tfDate.text=[dateFormatter stringFromDate:_courtesyCallInfo.datePlan];
        _viewBackground.hidden=NO;
        [_btPlan setBackgroundImage:[UIImage imageNamed:@"button_viewplan_pressed@2x.png"] forState:UIControlStateNormal];
        _tfDate.enabled=NO;
    }
    else
    {
        _lbTitle.text=NSLocalizedStringFromTableInBundle(@"START TIME",@"RPString", g_bundleResorce,nil);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        _tfDate.text=[dateFormatter stringFromDate:_date];
//        _date=_courtesyCallInfo.dateCC;
        _viewBackground.hidden=YES;
        [_btPlan setBackgroundImage:[UIImage imageNamed:@"button_viewplan@2x.png"] forState:UIControlStateNormal];
        _tfDate.enabled=YES;
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    _viewFrame.frame=CGRectMake(8, 37, _viewFrame.frame.size.width, _viewFrame.frame.size.height);
    [UIView commitAnimations];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    _viewFrame.frame=CGRectMake(8, 137, _viewFrame.frame.size.width, _viewFrame.frame.size.height);
    [UIView commitAnimations];
}
-(void)setCustomer:(Customer *)customer
{
    _customer=customer;
    _lbCustomerName.text=[NSString stringWithFormat:@"%@",_customer.strFirstName];
    _lbPhoneNumber.text=_customer.strPhone1;
    _lbMyName.text=[NSString stringWithFormat:@"%@",[[[RPSDK defaultInstance]userLoginDetail ]strFirstName ]];
    switch ([[[RPSDK defaultInstance]userLoginDetail]rank]) {
        case Rank_Manager:
            _lbMyName.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbMyName.textColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _lbMyName.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _lbMyName.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }
    _ivVip.hidden=!_customer.isVip;
}
-(void)setCallType:(CourtesyCallType *)callType
{
    _callType=callType;
    _lbCallType.text=_callType.strCourtesyCallTips;
}
-(void)setEntrance:(int)entrance
{
    _entrance=entrance;
    if (entrance==1)
    {
        [_btPlan setTitle:NSLocalizedStringFromTableInBundle(@"NO        PLAN",@"RPString", g_bundleResorce,nil) forState:UIControlStateNormal];
        _btPlan.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
        [_btPlan setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _btPlan.userInteractionEnabled=NO;
        _tfDate.enabled=YES;//可编辑
        _tvRemarks.editable =YES;
        _btOK.userInteractionEnabled=YES;
         _btOK.hidden=NO;
        
//        _date = [NSDate date];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
//        _tfDate.text=[dateFormatter stringFromDate:_date];
    }
    else if(entrance==2)
    {
        [_btPlan setTitle:NSLocalizedStringFromTableInBundle(@"CHECK   PLAN",@"RPString", g_bundleResorce,nil) forState:UIControlStateNormal];
//        _btPlan.backgroundColor=[UIColor colorWithRed:255.0f/255 green:98.0f/255 blue:31.0f/255 alpha:1];
        [_btPlan setBackgroundImage:[UIImage imageNamed:@"button_viewplan@2x.png"] forState:UIControlStateNormal];
        _btPlan.userInteractionEnabled=YES;
        _tfDate.enabled=YES;//可编辑
        _tvRemarks.editable = YES;
        _btOK.userInteractionEnabled=YES;
         _btOK.hidden=NO;
    }
    else if(entrance==3)
    {
        [_btPlan setTitle:NSLocalizedStringFromTableInBundle(@"CHECK   PLAN",@"RPString", g_bundleResorce,nil) forState:UIControlStateNormal];
//        _btPlan.backgroundColor=[UIColor colorWithRed:255.0f/255 green:98.0f/255 blue:31.0f/255 alpha:1];
        [_btPlan setBackgroundImage:[UIImage imageNamed:@"button_viewplan@2x.png"] forState:UIControlStateNormal];
        _btPlan.userInteractionEnabled=YES;
        _tfDate.enabled=NO;//不可编辑
        _tvRemarks.editable = YES;
        _btOK.userInteractionEnabled=YES;
         _btOK.hidden=NO;
    }
    else if(entrance==4)
    {
        [_btPlan setTitle:NSLocalizedStringFromTableInBundle(@"CHECK   PLAN",@"RPString", g_bundleResorce,nil) forState:UIControlStateNormal];
//        _btPlan.backgroundColor=[UIColor colorWithRed:255.0f/255 green:98.0f/255 blue:31.0f/255 alpha:1];
        [_btPlan setBackgroundImage:[UIImage imageNamed:@"button_viewplan@2x.png"] forState:UIControlStateNormal];
        _btPlan.userInteractionEnabled=YES;
        _tfDate.enabled=NO;//不可编辑
        _tvRemarks.editable = NO;
        _btOK.userInteractionEnabled=NO;
        _btOK.hidden=YES;
    }
}
//-(void)setArrayType:(NSArray *)arrayType
//{
//    _arrayType=arrayType;
//}
-(void)setCourtesyCallInfo:(CourtesyCallInfo *)courtesyCallInfo
{
    _courtesyCallInfo=courtesyCallInfo;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    if (_courtesyCallInfo.dateCC) {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        _tfDate.text=[dateFormatter stringFromDate:_courtesyCallInfo.dateCC];
        _date = _courtesyCallInfo.dateCC;
        _pickDate = [[RPDatePicker alloc] init:_tfDate Format:dateFormatter curDate:_courtesyCallInfo.dateCC canDelete:NO Mode:UIDatePickerModeDateAndTime canFuture:NO canPreviously:YES];
    }
    else
    {
        _pickDate = [[RPDatePicker alloc] init:_tfDate Format:dateFormatter curDate:_courtesyCallInfo.dateCC canDelete:NO Mode:UIDatePickerModeDateAndTime canFuture:NO canPreviously:YES];
//        _tfDate.text = @"";
        _date=[_pickDate GetDate];
    }
    
    
    if (_entrance==3||_entrance==4)
    {
        if (_courtesyCallInfo.datePlan)
        {
            [_btPlan setTitle:NSLocalizedStringFromTableInBundle(@"CHECK   PLAN",@"RPString", g_bundleResorce,nil) forState:UIControlStateNormal];
            [_btPlan setBackgroundImage:[UIImage imageNamed:@"button_viewplan@2x.png"] forState:UIControlStateNormal];
            _btPlan.userInteractionEnabled=YES;
        }
        else
        {
            [_btPlan setTitle:NSLocalizedStringFromTableInBundle(@"NO        PLAN",@"RPString", g_bundleResorce,nil) forState:UIControlStateNormal];
            _btPlan.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
            [_btPlan setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            _btPlan.userInteractionEnabled=NO;
        }
    }
    _tvRemarks.text = _courtesyCallInfo.strComment;
    
    if (_courtesyCallInfo.bSuccess) {
        _ivSuccess.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"icon_complete_call@2x" ofType:@"png"]];
    }
    else
    {
        _ivSuccess.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"icon_failed_call@2x" ofType:@"png"]];
    }
    
    _btnPlay.enabled = NO;
    _slider.enabled = NO;
    _slider.value = 0;
    [_btnPlay setImage:[UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"button_play_record@2x" ofType:@"png"]] forState:UIControlStateNormal];
    [_timerPlay invalidate];
    _lbNoRecord.hidden = NO;
    _lbRecordLength.text = @"--'--\"";
    _lbRecordCurState.text = @"--'--\"";
    if (_courtesyCallInfo.typeThrough == CourtesyCallThroughType_PSTN)
        _lbDuration.text = @"--'--\"";
    else
        _lbDuration.text = [NSString stringWithFormat:@"%02d'%02d\"",(NSInteger)_courtesyCallInfo.nDuration / 60,(NSInteger)_courtesyCallInfo.nDuration % 60];
    
    _ivRecord.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"icon_record_noexist@2x" ofType:@"png"]];
    
    if (_courtesyCallInfo.typeThrough == CourtesyCallThroughType_PSTN) {
        _ivVoipCall.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"icon_no_rp_call@2x" ofType:@"png"]];
        _lbVoipCallTip.alpha = 0.2;
    }
    else
    {
        _ivVoipCall.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"icon_rp_call@2x" ofType:@"png"]];
        _lbVoipCallTip.alpha = 1;
    }
    
    [_slider setMinimumTrackImage:[[UIImage imageNamed:@"img_playbar_left_end"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 3, 0, 0)] forState:UIControlStateNormal];
    [_slider setMaximumTrackImage:[[UIImage imageNamed:@"img_playbar_right_end"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 3)] forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"img_play_point"] forState:UIControlStateHighlighted];
    [_slider setThumbImage:[UIImage imageNamed:@"img_play_point"] forState:UIControlStateNormal];
    
    _bPlay = NO;
    
    if (_courtesyCallInfo.strRecordUrl.length > 0) {
        
        NSURL * url = nil;
        if ([RPSDK defaultInstance].bDemoMode) {
            NSString *fullPath = [NSBundle pathForResource:_courtesyCallInfo.strRecordUrl
                                                    ofType:nil inDirectory:[[NSBundle mainBundle] bundlePath]];
            url = [NSURL fileURLWithPath:fullPath];
        }
        else
            url = [NSURL  URLWithString:_courtesyCallInfo.strRecordUrl];
        
        _moviePlayer = [[ MPMoviePlayerController alloc]initWithContentURL:url];//远程
        [_moviePlayer prepareToPlay];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateChanged:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        
        [_slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        
    }
}

- (void)OnPlayChange
{
    _slider.value = _moviePlayer.currentPlaybackTime;
    if ((NSInteger)_slider.value == (NSInteger)_slider.maximumValue) {
        _slider.value = 0;
        _moviePlayer.currentPlaybackTime = 0;
        [_moviePlayer pause];
        _bPlay = NO;
        [_btnPlay setImage:[UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"button_play_record@2x" ofType:@"png"]] forState:UIControlStateNormal];
         [_timerPlay invalidate];
    }
    
    _lbRecordCurState.text = [NSString stringWithFormat:@"%02d'%02d\"",(NSInteger)_slider.value / 60,(NSInteger)_slider.value % 60];
}

- (IBAction)OnPlay:(id)sender
{
    if (!_bPlay)
    {
        [_moviePlayer play];
        [_btnPlay setImage:[UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"button_pause_record@2x" ofType:@"png"]] forState:UIControlStateNormal];
        [_timerPlay invalidate];
        _timerPlay = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(OnPlayChange) userInfo:nil repeats:YES];
    }
    else
    {
        [_moviePlayer pause];
        [_btnPlay setImage:[UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"button_play_record@2x" ofType:@"png"]] forState:UIControlStateNormal];
        [_timerPlay invalidate];
    }
    _bPlay = !_bPlay;
}

-(IBAction)sliderTouchDown:(id)sender
{
    [_moviePlayer pause];
    [_btnPlay setImage:[UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"button_play_record@2x" ofType:@"png"]] forState:UIControlStateNormal];
    [_timerPlay invalidate];
    _bPlay = NO;
}

-(IBAction)updateValue:(id)sender
{
    float f = _slider.value;
    _moviePlayer.currentPlaybackTime = f;
    
    if ((NSInteger)_moviePlayer.currentPlaybackTime == (NSInteger)_moviePlayer.playableDuration) {
        _slider.value = 0;
        _moviePlayer.currentPlaybackTime = 0;
        [_moviePlayer pause];
        _bPlay = NO;
        [_btnPlay setImage:[UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"button_play_record@2x" ofType:@"png"]] forState:UIControlStateNormal];
        [_timerPlay invalidate];
    }
    
    _lbRecordCurState.text = [NSString stringWithFormat:@"%02d'%02d\"",(NSInteger)_slider.value / 60,(NSInteger)_slider.value % 60];
}

- (void) moviePlayerLoadStateChanged:(NSNotification*)notification
{
    NSTimeInterval time = _moviePlayer.duration;
    _slider.minimumValue = 0;
    _slider.maximumValue = time;
    _moviePlayer.currentPlaybackTime = 0;
    [_moviePlayer pause];
    _btnPlay.enabled = YES;
    _slider.enabled = YES;
    _lbNoRecord.hidden = YES;
    _lbRecordLength.text = [NSString stringWithFormat:@"%02d'%02d\"",(NSInteger)time / 60,(NSInteger)time % 60];
    _lbRecordCurState.text = @"00'00\"";
    _ivRecord.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"icon_record_exist@2x" ofType:@"png"]];
}

-(BOOL)OnBack
{
    [_moviePlayer stop];
    [_timerPlay invalidate];
    //离开前重置check状态
    if (_entrance!=1)
    {
        _bCheck=YES;
        [self OnCheck:nil];
    }
    return YES;
}
@end
