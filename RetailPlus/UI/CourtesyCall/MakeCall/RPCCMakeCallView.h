//
//  RPCCMakeCallView.h
//  RetailPlus
//
//  Created by lin dong on 14-6-3.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CCPCallService.h" zlf
#import "CCPCallEvent.h"

@protocol RPCCMakeCallViewDelegate<NSObject>
    -(void)OnRPCCCallEnd;
@end

@interface RPCCMakeCallView : UIView<CCPCallEventDelegate,UITextViewDelegate>
{
    IBOutlet UIView     * _viewTopFrame;
    IBOutlet UIView     * _viewBottomFrame;
    
    IBOutlet UIView     * _viewDescFrame;
    IBOutlet UITextView * _tvCallTypeDesc;
    IBOutlet UILabel    * _lbCustomerName;
    IBOutlet UILabel    * _lbCustomerPhone;
    IBOutlet UIView     * _viewDial;
    IBOutlet UILabel    * _lbCallState;
    IBOutlet UIView     * _viewDialPanel;
    IBOutlet UIView     * _viewRedailPanel;
    
    IBOutlet UIButton   * _btnSpeaker;
    IBOutlet UIButton   * _btnDialPanel;
    IBOutlet UIButton   * _btnMute;
    
    IBOutlet UIView     * _viewCallFinishChoose;
    IBOutlet UIView     * _viewCallFinishRemark;
    UIView              * _viewCallFinishFrame;
    UIView              * _viewCallFinishMask;
    IBOutlet UIView     * _viewCallFinishOk;
    IBOutlet UIView     * _viewCallFinishCancel;
    IBOutlet UIView     * _viewCallFinishDone;
    IBOutlet UIView     * _viewCallFinishRemarkFrame;
    IBOutlet UITextView * _tvCallFinishRemark;
    
    CCPSubAccount       * _accountVoip;
//    CCPCallService      * _callService;
    NSString            * _strCallId;
    NSArray             * _arrayDTMF;
    BOOL                _bAnswered;
    
    NSTimer             * _timerDura;
    NSDate              * _dateBeginCCall;      //开始本次问候回放拨打的时间，进入拨打电话界面的时间
    NSDate              * _dateBeginAnswer;
    
    CourtesyCallInfo    * _info;
    CourtesyCallType    * _callType;
    NSString            * _strPhoneNo;
    
    BOOL                _bSpeaker;
    BOOL                _bShowDialPanel;
    BOOL                _bMute;
    BOOL                _bCCallSuccess;
    NSInteger           _nCallInteval;
}

@property (nonatomic,assign) id<RPCCMakeCallViewDelegate> delegate;

-(void)MakeCall:(NSString *)strPhoneNo withInfo:(CourtesyCallInfo *)info withCallType:(CourtesyCallType *)callType UpdateBeginDate:(BOOL)bUpdateBeginDate;

-(IBAction)OnSpeaker:(id)sender;
-(IBAction)OnShowDial:(id)sender;
-(IBAction)OnMute:(id)sender;
-(IBAction)OnReleaseCall:(id)sender;
-(IBAction)OnRedial:(id)sender;
-(IBAction)OnTryLater:(id)sender;
-(IBAction)OnDTMF:(id)sender;

-(IBAction)OnCallFinishOk:(id)sender;
-(IBAction)OnCallFinishCancel:(id)sender;
-(IBAction)OnCallFinishDone:(id)sender;
@end
