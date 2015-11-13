//
//  TRRecord.h
//  RecordTestForWeiXin
//
//  Created by RVision on 14-8-15.
//  Copyright (c) 2014年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//定义委托协议和方法
@protocol RPRecordDelegate <NSObject>
-(void)OnRecordEnd;//不传参数的方法相当于发送通知
-(void)OnConvertMp3End:(NSString *)strFilePath;
-(void)recTimeChanged:(NSTimeInterval)nRecTime;
-(void)playTimeChanged:(NSTimeInterval)nPlayTime;
-(void)playRecModel:(BOOL)bPlayModel;
-(void)RecordTimeTooLong;

@end

@interface RPRecord : NSObject<AVAudioPlayerDelegate>
{
    NSInteger _nMaxRecRemain;
}

//定义公开的delegate属性
@property (nonatomic,assign) id<RPRecordDelegate> delegate;
@property(nonatomic,strong)AVAudioRecorder* avRecorder;
@property(nonatomic,strong)AVAudioPlayer* avPlayer;
@property(nonatomic,strong)NSTimer* timer;
@property(nonatomic,strong)NSString* recordPath;
@property(nonatomic,strong)NSString* mp3FilePath;
@property(nonatomic,strong)NSMutableDictionary* recordSetting;

-(void)startRecordWithPath:(NSString*)strRecPath MaxRecordRemain:(NSInteger)nMaxRecRemain;
-(void)endRecord;
-(void)playRecordWithFilePath:(NSString*)filePath;
-(void)deleteCafRecord;
-(void)deleteMp3Record;
-(void)stopPlay;

@end
