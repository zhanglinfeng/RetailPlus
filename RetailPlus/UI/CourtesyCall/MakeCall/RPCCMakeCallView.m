////zlf
////  RPCCMakeCallView.m
////  RetailPlus
////
////  Created by lin dong on 14-6-3.
////  Copyright (c) 2014年 lin dong. All rights reserved.
////
//
//#import "RPCCMakeCallView.h"
//#import "SVProgressHUD.h"
//
//@implementation RPCCMakeCallView
//#define CCPVOIPADDRESS  @"app.cloopen.com"
//#define CCPVOIPPORT     8883
//
//extern NSBundle * g_bundleResorce;
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//        
//    }
//    return self;
//}
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//}
//*/
//
//-(void)awakeFromNib
//{
//    _callService = [[CCPCallService alloc] initWithDelegate:self];
//    
//    _viewDescFrame.layer.cornerRadius = 6;
//    _viewDescFrame.layer.shadowOffset = CGSizeMake(2, 2);
//    _viewDescFrame.layer.shadowRadius = 6.0;
//    _viewDescFrame.layer.shadowColor =[UIColor blackColor].CGColor;
//    _viewDescFrame.layer.shadowOpacity = 0.8;
//    
//    _arrayDTMF = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"*",@"#",nil];
//    
//    _viewCallFinishFrame = [[UIView alloc] init];
//    _viewCallFinishFrame.backgroundColor = [UIColor clearColor];
//    _viewCallFinishMask = [[UIView alloc] init];
//    _viewCallFinishMask.backgroundColor = [UIColor blackColor];
//    _viewCallFinishMask.alpha = 0.5;
//    [_viewCallFinishFrame addSubview:_viewCallFinishMask];
//    
//    _viewCallFinishOk.layer.cornerRadius = 6;
//    _viewCallFinishCancel.layer.cornerRadius = 6;
//    _viewCallFinishDone.layer.cornerRadius = 6;
//    _viewCallFinishRemarkFrame.layer.cornerRadius = 6;
//    _viewCallFinishRemarkFrame.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _viewCallFinishChoose.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _viewCallFinishRemark.layer.borderColor = [UIColor lightGrayColor].CGColor;
//}
//
//-(void)MakeCall:(NSString *)strPhoneNo withInfo:(CourtesyCallInfo *)info withCallType:(CourtesyCallType *)callType UpdateBeginDate:(BOOL)bUpdateBeginDate
//{
//    _info = info;
//    _strPhoneNo = strPhoneNo;
//    _callType = callType;
//    
//    _bSpeaker = NO;
//    _bMute = NO;
//    _bShowDialPanel = NO;
//    [_btnMute setSelected:NO];
//    [_btnDialPanel setSelected:NO];
//    [_btnSpeaker setSelected:NO];
//    [_callService enableLoudsSpeaker:NO];
//    [_callService setMute:NO];
//    
//    _viewDialPanel.frame = CGRectMake(0, _viewTopFrame.frame.size.height, _viewDialPanel.frame.size.width, _viewDialPanel.frame.size.height);
//    [_viewTopFrame addSubview:_viewDialPanel];
//    
//    _viewRedailPanel.frame = CGRectMake(0, self.frame.size.height, _viewBottomFrame.frame.size.width, _viewBottomFrame.frame.size.height);
//    [self addSubview:_viewRedailPanel];
//    
//    _lbCustomerName.text = info.customer.strFirstName;
//    _lbCustomerPhone.text = strPhoneNo;
//    _tvCallTypeDesc.text = [NSString stringWithFormat:@"%@\r\r%@",callType.strCourtesyCallTips,callType.strDescription];
//    _tvCallFinishRemark.text = @"";
//    _lbCallState.text = NSLocalizedStringFromTableInBundle(@"Connecting...",@"RPString", g_bundleResorce,nil);//@"连接中...";
//    _viewBottomFrame.hidden = NO;
//    
//    _bAnswered = NO;
//    _strCallId = nil;
//    
//    [_viewCallFinishFrame removeFromSuperview];
//    
//    [_callService disConnectToCCP];
//    
//    if (bUpdateBeginDate) _dateBeginCCall = [NSDate date];
//    
//    _accountVoip = nil;
//    
//    [[RPSDK defaultInstance] GetCCPSubAccount:^(CCPSubAccount * account) {
//        [_callService connectToCCP:CCPVOIPADDRESS onPort:CCPVOIPPORT withAccount:account.strVoipAccount withPsw:account.strVoipPwd withAccountSid:account.strSubAccountSid withAuthToken:account.strSubToken];
//        _accountVoip = account;
//    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
//        [self OnCallFailed];
//    }];
//}
//
////与云通讯平台连接成功
//- (void)onConnected
//{
//    _strCallId = [_callService makeCallWithType:EVoipCallType_Voice andCalled:[NSString stringWithFormat:@"0086%@",_strPhoneNo]];
//    if (_strCallId)
//        _lbCallState.text = NSLocalizedStringFromTableInBundle(@"Dialing...",@"RPString", g_bundleResorce,nil);//@"拨号中...";
//    else
//        [self OnCallFailed];
//}
//
////与云通讯平台连接失败或连接断开
//- (void)onConnectError:(NSInteger)reason withReasonMessge:(NSString *)reasonMessage
//{
//    [self OnCallFailed];
//}
//
////注销成功
//- (void)onDisconnect
//{
//    
//}
//
////呼叫处理中
//- (void)onCallProceeding:(NSString *)callid
//{
//    
//}
//
////呼叫振铃
//- (void)onCallAlerting:(NSString*)callid
//{
//    
//}
//
////所有应答
//- (void)onCallAnswered:(NSString *)callid
//{
//    _bAnswered = YES;
//    _timerDura = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCallDuration) userInfo:nil repeats:YES];
//    
//    _dateBeginAnswer = [NSDate date];
//    
//}
//
////外呼失败
//- (void)onMakeCallFailed:(NSString *)callid withReason:(NSInteger)reason
//{
//    [self OnCallFailed];
//}
//
////本地Pause呼叫成功
//- (void)onCallPaused:(NSString *)callid
//{
//    
//}
////呼叫被对端pasue
//- (void)onCallPausedByRemote:(NSString *)callid
//{
//    
//}
//
////本地resume呼叫成功
//- (void)onCallResumed:(NSString *)callid
//{
//    
//}
//
////呼叫被对端resume
//- (void)onCallResumedByRemote:(NSString *)callid
//{
//    
//}
//
////呼叫挂机
//- (void)onCallReleased:(NSString *)callid
//{
//    if (_bAnswered) return [self OnCallSuccess];
//    [self OnCallFailed];
//}
//
////呼叫被转接
//- (void)onCallTransfered:(NSString *)callid transferTo:(NSString *)destination
//{
//    
//}
//
//-(void)OnCallFailed
//{
//    _viewBottomFrame.hidden = YES;
//    
//    [UIView beginAnimations:nil context:nil];
//    _viewRedailPanel.frame = CGRectMake(0, self.frame.size.height - _viewRedailPanel.frame.size.height, _viewRedailPanel.frame.size.width, _viewRedailPanel.frame.size.height);
//    [UIView commitAnimations];
//    
//    _strCallId = nil;
//    [_callService disConnectToCCP];
//    [_timerDura invalidate];
//}
//
//-(void)OnCallSuccess
//{
//    _strCallId = nil;
//    [_callService disConnectToCCP];
////    [self removeFromSuperview];
//    [_timerDura invalidate];
//    
//    _viewCallFinishFrame.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    _viewCallFinishMask.frame = _viewCallFinishFrame.frame;
//    [self addSubview:_viewCallFinishFrame];
//    
//    [_viewCallFinishRemark removeFromSuperview];
//    _viewCallFinishChoose.frame = CGRectMake(0,_viewCallFinishFrame.frame.size.height , _viewCallFinishChoose.frame.size.width, _viewCallFinishChoose.frame.size.height);
//    [_viewCallFinishFrame addSubview:_viewCallFinishChoose];
//    
//    [UIView beginAnimations:nil context:nil];
//    _viewCallFinishChoose.frame = CGRectMake(0,_viewCallFinishFrame.frame.size.height - _viewCallFinishChoose.frame.size.height, _viewCallFinishChoose.frame.size.width, _viewCallFinishChoose.frame.size.height);
//    [UIView commitAnimations];
//}
//
//- (void)updateCallDuration
//{
//    if (_bAnswered) {
//       NSTimeInterval inteval = [_dateBeginAnswer timeIntervalSinceNow];
//       NSInteger nInteval = (NSInteger)(-inteval);
//       NSInteger nMin = nInteval / 60;
//       NSInteger nSec = nInteval % 60;
//       _lbCallState.text = [NSString stringWithFormat:@"%02d'%02d\"",nMin,nSec];
//    }
//}
//
//-(IBAction)OnSpeaker:(id)sender
//{
//    _bSpeaker = !_bSpeaker;
//    [_btnSpeaker setSelected:_bSpeaker];
//    [_callService enableLoudsSpeaker:_bSpeaker];
//}
//
//-(IBAction)OnShowDial:(id)sender
//{
//    _bShowDialPanel = !_bShowDialPanel;
//    [_btnDialPanel setSelected:_bShowDialPanel];
//    
//    [UIView beginAnimations:nil context:nil];
//    if (_bShowDialPanel)
//        _viewDialPanel.frame = CGRectMake(0, _viewTopFrame.frame.size.height - _viewDialPanel.frame.size.height, _viewDialPanel.frame.size.width, _viewDialPanel.frame.size.height);
//    else
//        _viewDialPanel.frame = CGRectMake(0, _viewTopFrame.frame.size.height, _viewDialPanel.frame.size.width, _viewDialPanel.frame.size.height);
//    [UIView commitAnimations];
//}
//
//-(IBAction)OnMute:(id)sender
//{
//    _bMute = !_bMute;
//    [_btnMute setSelected:_bMute];
//    [_callService setMute:_bMute];
//}
//
//-(IBAction)OnDTMF:(id)sender
//{
//    UIButton * btn = (UIButton *)sender;
//    NSString * strDTMF = [_arrayDTMF objectAtIndex:(btn.tag - 1000)];
//    [_callService sendDTMF:_strCallId dtmf:strDTMF];
//}
//
//-(IBAction)OnReleaseCall:(id)sender
//{
//    if (_strCallId == nil)
//    {
//        [self OnCallFailed];
//        return;
//    }
//    [_callService releaseCall:_strCallId];
//}
//
//-(IBAction)OnRedial:(id)sender
//{
//    [self MakeCall:_strPhoneNo withInfo:_info withCallType:_callType UpdateBeginDate:NO];
//}
//
//-(IBAction)OnTryLater:(id)sender
//{
//    //拨打未成功 放弃回访
//    [self SubmitCall:NO withRemark:@""];
//}
//
//-(IBAction)OnCallFinishOk:(id)sender
//{
//    //拨打成功 回访成功
//    _bCCallSuccess = YES;
//    
//    [_viewCallFinishChoose removeFromSuperview];
//    _viewCallFinishRemark.frame = CGRectMake(0,_viewCallFinishFrame.frame.size.height , _viewCallFinishRemark.frame.size.width, _viewCallFinishRemark.frame.size.height);
//    [_viewCallFinishFrame addSubview:_viewCallFinishRemark];
//    
//    [UIView beginAnimations:nil context:nil];
//    _viewCallFinishRemark.frame = CGRectMake(0,_viewCallFinishFrame.frame.size.height - _viewCallFinishRemark.frame.size.height, _viewCallFinishRemark.frame.size.width, _viewCallFinishRemark.frame.size.height);
//    [UIView commitAnimations];
//}
//
//-(IBAction)OnCallFinishCancel:(id)sender
//{
//    //拨打成功 回访不成功
//    _bCCallSuccess = NO;
//    
//    [_viewCallFinishChoose removeFromSuperview];
//    _viewCallFinishRemark.frame = CGRectMake(0,_viewCallFinishFrame.frame.size.height , _viewCallFinishRemark.frame.size.width, _viewCallFinishRemark.frame.size.height);
//    [_viewCallFinishFrame addSubview:_viewCallFinishRemark];
//    
//    [UIView beginAnimations:nil context:nil];
//    _viewCallFinishRemark.frame = CGRectMake(0,_viewCallFinishFrame.frame.size.height - _viewCallFinishRemark.frame.size.height, _viewCallFinishRemark.frame.size.width, _viewCallFinishRemark.frame.size.height);
//    [UIView commitAnimations];
//}
//
//-(IBAction)OnCallFinishDone:(id)sender
//{
//    [self endEditing:YES];
//    [self SubmitCall:_bCCallSuccess withRemark:_tvCallFinishRemark.text];
//}
//
//-(void)SubmitCall:(BOOL)bSuccess withRemark:(NSString *)strRemark
//{
//     [SVProgressHUD showWithStatus:NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil)];
//    
//    CCPVoipCall * call = [[CCPVoipCall alloc] init];
//    if (_info.strID == nil)
//        call.strCourtesyCallId = @"";
//    else
//        call.strCourtesyCallId = _info.strID;
//    
//    if (_accountVoip == nil)
//        call.strVoipToken = @"";
//    else
//        call.strVoipToken = _accountVoip.strVoipToken;
//    
//    call.strCourtesyCallTypeId = _info.strCourtesyCallTypeId;
//    call.strCustomerId = _info.customer.strCustomerId;
//    call.strTelephoneNo = _strPhoneNo;
//    call.strRemark = strRemark;
//    call.typeThrough = CourtesyCallThroughType_CCPVOIP;
//    NSTimeInterval inteval = [_dateBeginCCall timeIntervalSinceNow];
//    call.nDuration = (NSInteger)(-inteval);
//    call.bSuccess = bSuccess;
//    
//    [[RPSDK defaultInstance] CompleteVoipCall:call Success:^(id idResult) {
//        [_viewCallFinishFrame removeFromSuperview];
//        [self.delegate OnRPCCCallEnd];
//        [SVProgressHUD dismiss];
//    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
//        
//    }];
//}
//
//-(void)textViewDidBeginEditing:(UITextView *)textView
//{
//    if (textView == _tvCallFinishRemark) {
//        [UIView beginAnimations:nil context:nil];
//        _viewCallFinishRemark.frame = CGRectMake(0, 0, _viewCallFinishRemark.frame.size.width, _viewCallFinishRemark.frame.size.height);
//        [UIView commitAnimations];
//    }
//}
//
//-(void)textViewDidEndEditing:(UITextView *)textView
//{
//    if (textView == _tvCallFinishRemark) {
//        [UIView beginAnimations:nil context:nil];
//        _viewCallFinishRemark.frame = CGRectMake(0, self.frame.size.height - _viewCallFinishRemark.frame.size.height, _viewCallFinishRemark.frame.size.width, _viewCallFinishRemark.frame.size.height);
//        [UIView commitAnimations];
//    }
//}
//@end
