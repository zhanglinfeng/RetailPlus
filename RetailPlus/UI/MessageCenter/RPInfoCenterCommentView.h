//
//  RPInfoCenterCommentView.h
//  RetailPlus
//
//  Created by lin dong on 14-3-12.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

//最长录音时间
#define MAX_FLOAT_RECORD_TIME  180

#import <UIKit/UIKit.h>
#import "RPRecord.h"
#import "RPExBtnTextField.h"
typedef enum
{
    RECTIP_BEGINRECORD = 1,
    RECTIP_RECORDING,
    RECTIP_RELEASE,
    RECTIP_COMPLETE,
    
}RECTIPTYPE;

@protocol RPInfoCenterCommentViewDelegate<NSObject>
-(void)PostCommentEnd;


@end

@interface RPInfoCenterCommentView : UIView<RPRecordDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIView       *  _viewBackGroud;
    
    IBOutlet RPExBtnTextField *_tfComment;
    
    IBOutlet UIView       *  _viewBeginRecord;
    
    IBOutlet UIView       *  _viewRecording;
    
    IBOutlet UIView       *  _viewCancelRecord;
    
    IBOutlet UIView       *  _viewSendRecord;
    
    IBOutlet UIView       *  _viewInputBox;
    
    IBOutlet UIView       *  _viewKeyboard;
    
    IBOutlet UIView       *  _viewConverter;
    
    IBOutlet UIButton     *  _btnBeginRecord;
    
    IBOutlet UIButton     *  _btnChangeStatus;
    
    IBOutlet UIButton     *  _btnSendStatus;
    
    IBOutlet UILabel      *  _lbRecordTime;
    
    IBOutlet UILabel      *  _lbCancelRecordTime;
    
    IBOutlet UILabel      *  _lbSendRecTime;
    
//多语言
    
    IBOutlet UILabel      *  _lbHoldToTalk;
    
    IBOutlet UILabel      *  _lbMoveUpToCancel;
    
    IBOutlet UILabel      *  _lbReleaseToCancel;
    
    IBOutlet UILabel      *  _lbConverting;
    
    
     IBOutlet UIImageView  *  _ivTimeMark;
    
    IBOutlet UIImageView  *  _ivSoundPlay;
    
    IBOutlet UIActivityIndicatorView *_adIndicator;
    
    
    RPRecord              *  _record;
    NSString              *  _mp3RecPath;
    NSTimeInterval           _nRecordTime;
    NSTimeInterval           _nRecPlayTime;
    NSDate                *  _startDate;
    BOOL                     _bSubmitVoiceAfterConvert;
    BOOL                     _bPlaying;
}

@property (nonatomic,assign) id<RPInfoCenterCommentViewDelegate> delegate;
@property (nonatomic,strong) UIViewController* vcFrame;


-(void)ShowCommentView;

@end
