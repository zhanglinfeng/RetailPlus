//
//  RPCourtesyCallRecordView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-11.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPDatePicker.h"
#import <MediaPlayer/MediaPlayer.h>

@protocol RPCourtesyCallRecordViewDelegate<NSObject>
-(void)endCallRecord;
-(void)completeRecord;
@end
@protocol RPCallRecordViewFromPlanDelegate<NSObject>
-(void)RecordOK;
@end
@protocol RPCallRecordViewTORecordListDelegate<NSObject>
-(void)RecordOKToRecordList;
@end
@interface RPCourtesyCallRecordView : UIView<UITextViewDelegate,UITextFieldDelegate>
{
    IBOutlet UIView *_viewHead;
    IBOutlet UIView *_viewFrame;
    IBOutlet UILabel *_lbCustomerName;
    
    IBOutlet UILabel *_lbMyName;
    IBOutlet UILabel *_lbCallType;
    IBOutlet UITextView *_tvRemarks;
    IBOutlet UIImageView *_ivVip;
    IBOutlet UILabel *_lbPhoneNumber;
//    UIDatePicker *_datePicker;
    NSDate *_date;
    
    IBOutlet UITextField *_tfDate;
    IBOutlet UIButton *_btPlan;
    IBOutlet UIButton *_btOK;
    IBOutlet UILabel *_lbTitle;
    BOOL _bCheck;
    IBOutlet UIView *_viewBackground;
    
    IBOutlet UIImageView    * _ivVoipCall;
    IBOutlet UILabel        * _lbVoipCallTip;
    IBOutlet UILabel        * _lbDuration;
    IBOutlet UIImageView    * _ivSuccess;
    IBOutlet UILabel        * _lbNoRecord;
    IBOutlet UILabel        * _lbRecordLength;
    IBOutlet UILabel        * _lbRecordCurState;
    
    IBOutlet UIButton       * _btnPlay;
    IBOutlet UIImageView    * _ivRecord;
    IBOutlet UISlider       * _slider;
    NSTimer                 * _timerPlay;
    RPDatePicker            * _pickDate;
    MPMoviePlayerController * _moviePlayer;
    BOOL                      _bPlay;
}

@property(nonatomic,assign)id<RPCourtesyCallRecordViewDelegate>delegate;
@property(nonatomic,assign)id<RPCallRecordViewFromPlanDelegate>delegateOK;
@property(nonatomic,assign)id<RPCallRecordViewTORecordListDelegate>delegateOKToRecordList;
@property(nonatomic,strong)Customer *customer;
@property(nonatomic,strong)CourtesyCallType *callType;
@property(nonatomic,assign)int entrance;//1代表直接进入该界面，2代表从计划列表进入该界面，3代表从自己的记录进入该界面，4代表从别人的记录进入该界面
@property(nonatomic,assign)CourtesyCallInfo *courtesyCallInfo;
//@property(nonatomic,strong)NSArray *arrayType;
- (IBAction)OnHelp:(id)sender;
- (IBAction)OnQuit:(id)sender;
- (IBAction)OnOK:(id)sender;
- (IBAction)OnCheck:(id)sender;
- (IBAction)OnPlay:(id)sender;

- (BOOL)OnBack;
@end
