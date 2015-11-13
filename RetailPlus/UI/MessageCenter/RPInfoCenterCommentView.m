//
//  RPInfoCenterCommentView.m
//  RetailPlus
//
//  Created by lin dong on 14-3-12.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPInfoCenterCommentView.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;

@implementation RPInfoCenterCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    _record = [[RPRecord alloc]init];
    _record.delegate = self;
    [_btnBeginRecord addTarget:self action:@selector(beginRecord) forControlEvents:UIControlEventTouchDown];
    [_btnBeginRecord addTarget:self action:@selector(endRecordUpInside) forControlEvents:UIControlEventTouchUpInside];
    [_btnBeginRecord addTarget:self action:@selector(cancelSendRecord) forControlEvents:UIControlEventTouchDragExit];
    [_btnBeginRecord addTarget:self action:@selector(dragInBtn) forControlEvents:UIControlEventTouchDragEnter];
    [_btnBeginRecord addTarget:self action:@selector(endRecordUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [_tfComment addTarget:self action:@selector(btnChangedByMessOrPhoto:) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidChange:) name:UIKeyboardWillShowNotification object:nil];
    
}

-(void)ShowCommentView
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    self.frame = CGRectMake(0, 0, keywindow.frame.size.width, keywindow.frame.size.height);
    [keywindow addSubview:self];
    
    _btnChangeStatus.selected=NO;
    [_tfComment becomeFirstResponder];
    
    _viewKeyboard.frame = CGRectMake(0, self.frame.size.height - _viewKeyboard.frame.size.height, _viewKeyboard.frame.size.width, _viewKeyboard.frame.size.height);
    
    _viewBeginRecord.hidden = YES;
    _viewRecording.hidden = YES;
    _viewCancelRecord.hidden = YES;
    _viewSendRecord.hidden = YES;
    _viewConverter.hidden = YES;
    
    _lbHoldToTalk.text = NSLocalizedStringFromTableInBundle(@"Hold to talk", @"RPString", g_bundleResorce, nil);
    _lbMoveUpToCancel.text = NSLocalizedStringFromTableInBundle(@"Move up to cancel", @"RPString", g_bundleResorce, nil);
    _lbReleaseToCancel.text = NSLocalizedStringFromTableInBundle(@"Release to cancel", @"RPString", g_bundleResorce, nil);
    _lbConverting.text = NSLocalizedStringFromTableInBundle(@"Converting...", @"RPString", g_bundleResorce, nil);
    
    //如果返回主视图时录音还在，再次进入发送界面依然显示存在录音的小红点！
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* mp3RecPath = [ud objectForKey:@"mp3RecPath"];
    NSData* dataRec = [NSData dataWithContentsOfFile:mp3RecPath];
    if (dataRec) {
        _ivTimeMark.hidden = NO;
    }else{
        _ivTimeMark.hidden = YES;
    }
    _viewSendRecord.layer.cornerRadius = 4.0;
    _tfComment.layer.cornerRadius = 4.0;
}

#pragma mark 实现委托方法

-(void)recTimeChanged:(NSTimeInterval)nRecTime
{
    _nRecordTime = nRecTime;
    NSLog(@"录音的时间:%lf",nRecTime);
    _lbRecordTime.text = [NSString stringWithFormat:@"%ld''",(long)nRecTime];
    _lbCancelRecordTime.text = _lbRecordTime.text;
    _lbSendRecTime.text = _lbRecordTime.text;
}

-(void)playTimeChanged:(NSTimeInterval)nPlayTime
{
    //播放录音的时间为avplayer的总时间
    _nRecPlayTime = nPlayTime;
    NSLog(@"播放的时间:%lf",nPlayTime);
    
}

-(void)playRecModel:(BOOL)bPlayModel
{
    _bPlaying = bPlayModel;
}

//被委托方接到通知后就进行转码标记
-(void)OnRecordEnd{
    if (_nRecordTime > 1) {
        //[SVProgressHUD showWithStatus:@"转码中..."];
        _viewConverter.frame = self.frame;
        _viewConverter.hidden = NO;
        [_adIndicator startAnimating];
        [[UIApplication sharedApplication] keyWindow].userInteractionEnabled = NO;
    }
}

//转码结束后取消视图标记，并且发送录音
-(void)OnConvertMp3End:(NSString *)strFilePath
{
    //[SVProgressHUD dismiss];
    _viewConverter.hidden = YES;
    [_adIndicator stopAnimating];
    [[UIApplication sharedApplication] keyWindow].userInteractionEnabled = YES;
    if (strFilePath) {
        _mp3RecPath = strFilePath;
        if (_bSubmitVoiceAfterConvert) {
            [self SubmitVoice];
        }
    }
}

//录音超时通知
-(void)RecordTimeTooLong
{
    [_record endRecord];
    [self showEndStatusByRecordTime];
}

#pragma mark 包装函数

//发送录音函数
-(void)SubmitVoice
{
    [SVProgressHUD showWithStatus:@""];
    NSData* recData = [NSData dataWithContentsOfFile:_mp3RecPath];
    [[RPSDK defaultInstance] PostMessage:ICMsgFormat_Voice Content:recData RecvUser:nil Success:^(id idResult) {
        NSLog(@"发送录音成功");
        //删除录音,返回数据到之前的界面 delegate 方法
        [_record deleteMp3Record];
        
        [[NSUserDefaults standardUserDefaults] setObject:_mp3RecPath forKey:@"mp3RecPath"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.delegate PostCommentEnd];
        
        [self dismissByAnimation];
        [self cleanUpLbTime];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        //发送失败显示结束界面
        [self dismissTip];
        [self showTipWithType:RECTIP_COMPLETE];
        [self cleanUpLbTime];
    }];
}

//显示视图信息函数
-(void)showTipWithType:(RECTIPTYPE)type{
    switch (type) {
        case RECTIP_BEGINRECORD:{
            _viewBeginRecord.hidden = NO;
            _viewSendRecord.hidden = YES;
            _viewRecording.hidden = YES;
        }
            break;
        case RECTIP_RECORDING:{
            _viewRecording.hidden = NO;
            _viewBeginRecord.hidden = YES;
            _viewSendRecord.hidden = YES;//松开手指取消录音，再次点击录音时隐藏该视图
        }
            break;
        case RECTIP_RELEASE:{
            _viewCancelRecord.hidden = NO;
            _viewRecording.hidden = YES;
        }
            break;
        case RECTIP_COMPLETE:{
            _viewSendRecord.hidden = NO;
        }
            break;
        default:
            break;
    }
}

//取消视图的显示函数
-(void)dismissTip
{
    _viewBeginRecord.hidden = YES;
    _viewRecording.hidden = YES;
    _viewCancelRecord.hidden = YES;
}

//根据录音时间长短显示结束界面函数（适用于touchUpOutside）
-(void)showEndStatusByRecordTime
{
    if (_nRecordTime < 1) {
        NSLog(@"小于1秒");
        [_record deleteCafRecord];
        [self showTipWithType:RECTIP_BEGINRECORD];
    }else{
        NSLog(@"大于1秒");
        [self dismissTip];
        [self showTipWithType:RECTIP_COMPLETE];
    }
    _nRecordTime = 0;//计时器每次要清零啊
}

//将计时标签清零函数
-(void)cleanUpLbTime
{
    _lbRecordTime.text = nil;
    _lbCancelRecordTime.text = nil;
}

//发送Msg成功后动画消失界面
-(void)dismissByAnimation
{
    [self endEditing:YES];
    CGRect frameInput = _viewInputBox.frame;
    CGRect frameKeybo = _viewKeyboard.frame;
    frameInput.origin.y = self.frame.size.height - frameInput.size.height;
    frameKeybo.origin.y = self.frame.size.height;
    [UIView animateWithDuration:.25 animations:^{
        _viewInputBox.frame = frameInput;
        _viewKeyboard.frame = frameKeybo;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark Button touch事件

//开始录音 touchDown
-(void)beginRecord
{
    NSLog(@"touchDown");
    _bSubmitVoiceAfterConvert = NO;
    [_record startRecordWithPath:[NSString stringWithFormat:@"%@/Documents/MySound.caf",NSHomeDirectory()] MaxRecordRemain:MAX_FLOAT_RECORD_TIME];
        [self showTipWithType:RECTIP_RECORDING];
}

//结束录音 touchUpInside
-(void)endRecordUpInside
{
    NSLog(@"touchUpInside");
    if (!_viewSendRecord.hidden) {
        [self cleanUpLbTime];
    }else{
        [_record endRecord];
        if (_nRecordTime > 1){
            _bSubmitVoiceAfterConvert = YES;
        }
        else{
            [_record deleteCafRecord];
            [self showTipWithType:RECTIP_BEGINRECORD];
            [self cleanUpLbTime];
        }
    }
    _nRecordTime = 0;
}

/*
 手指上滑:按钮往外拖动事件（从控件窗口内部拖到外部时）
 TouchDragExit
 */
-(void)cancelSendRecord
{
    NSLog(@"dragOut");
    [self showTipWithType:RECTIP_RELEASE];
}

//手指下滑:从按钮（控件窗口）外部拖到内部时 TouchDragEnter
-(void)dragInBtn
{
    NSLog(@"dragIn");
    _viewCancelRecord.hidden = YES;
    _viewRecording.hidden = NO;
}

//在控件外部触摸后抬起事件 touchUpOutside 与 TouchDragExit对应
-(void)endRecordUpOutside
{
    NSLog(@"touchUpOutside");
    if (!_viewSendRecord.hidden){
        [self cleanUpLbTime];
    }else{
        [_record endRecord];
        [self showEndStatusByRecordTime];
        [self cleanUpLbTime];
    }
    
}


#pragma mark IBAction

//播放录音
- (IBAction)playRecord:(UIButton *)sender {
    if (_bPlaying) {
        [_record stopPlay];
        _ivSoundPlay.image = [UIImage imageNamed:@"button_sound3.png"];
        
    }else{
        [_record playRecordWithFilePath:_mp3RecPath];
        _startDate = [NSDate date];
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(soundPlay:) userInfo:nil repeats:YES];
        [timer fire];
        _ivSoundPlay.image = [UIImage animatedImageNamed:@"button_sound" duration:1.0];
    }
}

-(void)soundPlay:(NSTimer*)timer
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:_startDate];
    if (timeInterval >= _nRecPlayTime){
        [timer invalidate];
        _ivSoundPlay.image = [UIImage imageNamed:@"button_sound3.png"];
    }
    
}

//切换录音按钮状态
- (IBAction)changeBtnStatus:(UIButton *)sender {
    NSData* dataRec = [NSData dataWithContentsOfFile:_mp3RecPath];
    if ([_tfComment isFirstResponder]) {
        sender.selected = YES;
        [_tfComment resignFirstResponder];
        if (dataRec) {
            [self showTipWithType:RECTIP_COMPLETE];
        }else{
            [self showTipWithType:RECTIP_BEGINRECORD];
        }
        _ivTimeMark.hidden = YES;
        CGRect frame = _viewInputBox.frame;
        frame.origin.y = self.frame.size.height-frame.size.height-_viewKeyboard.frame.size.height;
        [UIView animateWithDuration:0.25 animations:^{
            _viewInputBox.frame = frame;
        }];
    }else{
        if (dataRec) {
            _ivTimeMark.hidden = NO;
        }
        sender.selected = NO;
        [_tfComment becomeFirstResponder];
        [self dismissTip];
    }
    
}

//点击按钮发送录音
- (IBAction)OnPostRecord:(UIButton *)sender {
    [self SubmitVoice];
}

//根据发送文字内容是否为空来判断发送按钮状态
-(void)btnChangedByMessOrPhoto:(UITextField*)textFiled
{
    if (textFiled.text.length == 0) {
        _btnSendStatus.selected = NO;
        [_btnSendStatus setImage:[UIImage imageNamed:@"button_camera.png"] forState:UIControlStateNormal];
        [_btnSendStatus setImage:[UIImage imageNamed:@"button_camera.png"] forState:UIControlStateSelected];
    }else{
        _btnSendStatus.selected = YES;
        [_btnSendStatus setImage:[UIImage imageNamed:@"button_send1.png"] forState:UIControlStateNormal];
        [_btnSendStatus setImage:[UIImage imageNamed:@"button_send1.png"] forState:UIControlStateSelected];
    }
}

//根据发送按钮状态发送照片或者文字信息
- (IBAction)OnPostMsgOrPhoto:(UIButton *)sender {
    NSString * strSelect = NSLocalizedStringFromTableInBundle(@"Please select the image source type?",@"RPString", g_bundleResorce,nil);
    NSString * strCamera = NSLocalizedStringFromTableInBundle(@"Camera", @"RPString", g_bundleResorce, nil);
    NSString * strPhotoLib = NSLocalizedStringFromTableInBundle(@"Photo Library", @"RPString", g_bundleResorce, nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    if (!sender.selected) {//调用图片
        [_tfComment resignFirstResponder];
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strSelect cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (indexButton == 1) {
                sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            if (indexButton == 2) {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            if (indexButton == 1 || indexButton == 2) {
                [self removeFromSuperview];
                picker.delegate = self;
                picker.allowsEditing = YES;//照片为编辑状态
                picker.sourceType = sourceType;
                picker.view.userInteractionEnabled = YES;
                
                [self.vcFrame presentViewController:picker animated:YES completion:^{
                    
                }];
            }
            if (indexButton==0) {
                [_tfComment becomeFirstResponder];
                if (![_tfComment isFirstResponder]) {
                    return ;
                }
                
            }
            
        } otherButtonTitles:strCamera, strPhotoLib,nil];
        [alertView show];
        
    }else{//发送文字
        [SVProgressHUD showWithStatus:@""];
        [[RPSDK defaultInstance] PostMessage:ICMsgFormat_Text Content:_tfComment.text RecvUser:nil Success:^(id idResult) {
            NSLog(@"发送文字成功");
            //发送成功则收起
            _tfComment.text = nil;
            [[NSUserDefaults standardUserDefaults] setInteger:_tfComment.text.length forKey:@"textFiledLength"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.delegate PostCommentEnd];
            
            _btnSendStatus.selected = NO;
            [_btnSendStatus setImage:[UIImage imageNamed:@"button_camera.png"] forState:UIControlStateNormal];
            [_btnSendStatus setImage:[UIImage imageNamed:@"button_camera.png"] forState:UIControlStateSelected];
            [self dismissByAnimation];
            [SVProgressHUD dismiss];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            //发送失败提示用户，并将文字保留在输入框
        }];
    }
}

//当选中照片会回调此方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //将拍摄照片存入已有相册
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
    }
    //选取完图片就发送图片
    [SVProgressHUD showWithStatus:@""];
    [[RPSDK defaultInstance] PostMessage:ICMsgFormat_Picture Content:image RecvUser:nil Success:^(id idResult) {
        NSLog(@"发送图片成功");
        [self removeFromSuperview];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//点击textField时的回调函数
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _btnChangeStatus.selected = NO;
    NSData* dataRec = [NSData dataWithContentsOfFile:_mp3RecPath];
    if (dataRec) {
        _ivTimeMark.hidden = NO;
    }
}



//返回发送视图
- (IBAction)onBackRec:(UIButton *)sender {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:_mp3RecPath forKey:@"mp3RecPath"];
    [ud setInteger:_tfComment.text.length forKey:@"textFiledLength"];
    [ud synchronize];
    [self.delegate PostCommentEnd];
    [self dismissByAnimation];
}

//删除录音弹出框
- (IBAction)isDeleted:(UIButton *)sender {
    NSString * strDel = NSLocalizedStringFromTableInBundle(@"Delete the record?",@"RPString", g_bundleResorce,nil);
    NSString * strYes = NSLocalizedStringFromTableInBundle(@"Yes",@"RPString", g_bundleResorce,nil);
    NSString * strNo = NSLocalizedStringFromTableInBundle(@"No",@"RPString", g_bundleResorce,nil);
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDel cancelButtonTitle:strNo clickButton:^(NSInteger indexButton){
        NSLog(@"index:%d",indexButton);
        if (indexButton == 1) {
            [_record deleteMp3Record];
            
            [[NSUserDefaults standardUserDefaults] setObject:_mp3RecPath forKey:@"mp3RecPath"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.delegate PostCommentEnd];
            
            [self showTipWithType:RECTIP_BEGINRECORD];
        }
    } otherButtonTitles:strYes,nil];
    [alertView show];
}

#pragma mark 键盘弹起时计算输入框坐标

-(void)handleKeyboardDidChange:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    CGRect keyboardframe = [userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect frame = _viewInputBox.frame;
    frame.origin.y = self.frame.size.height - keyboardframe.size.height - _viewInputBox.frame.size.height;
    UIViewAnimationOptions options = [userInfo [UIKeyboardAnimationCurveUserInfoKey] intValue];
    [UIView animateWithDuration:0.25 delay:0.0 options:options animations:^{
        _viewInputBox.frame = frame;
    } completion:nil];
}

@end
