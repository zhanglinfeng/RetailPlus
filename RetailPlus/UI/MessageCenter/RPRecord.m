//
//  TRRecord.m
//  RecordTestForWeiXin
//
//  Created by RVision on 14-8-15.
//  Copyright (c) 2014年 Tarena. All rights reserved.
//

#import "RPRecord.h"
#import "lame.h"

@implementation RPRecord


//设置录音
-(void)setAudio
{
    //在PlayAndRecord这个category下，听筒会成为默认的输出设备。
    //Options:DefaultToSpeaker设置为扬声器播放
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [audioSession setActive:YES error:nil];
    self.recordSetting = [NSMutableDictionary dictionary];
    //设置录音格式 AVFormatIDKey==kAudioFormatLinearPCM
    [self.recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [self.recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数 1或2
    [self.recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //线性采样位数 18、16、24、32
    [self.recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [self.recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    
}

//转化成MP3格式
-(void)audio_PCMtoMP3
{
    NSString* cafFilePath = _recordPath;
    _mp3FilePath = [cafFilePath stringByDeletingLastPathComponent];
    _mp3FilePath = [_mp3FilePath stringByAppendingPathComponent:@"record.mp3"];
    
        @try {
            int read, write;
            
            FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source
            fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
            FILE *mp3 = fopen([_mp3FilePath cStringUsingEncoding:1], "wb");  //output
            
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init();
            lame_set_in_samplerate(lame, 44100);
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            
            do {
                read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
                if (read == 0)
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                else
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                
                fwrite(mp3_buffer, write, 1, mp3);
                
            } while (read != 0);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
        @catch (NSException *exception) {
            NSLog(@"%@",[exception description]);
            [self.delegate OnConvertMp3End:nil];
        }
        @finally{
            //转码成功后把之前的caf文件删除
            [self deleteCafRecord];
            [self.delegate OnConvertMp3End:_mp3FilePath];
        }
    
}


//开始录音
-(void)startRecordWithPath:(NSString*)strRecPath MaxRecordRemain:(NSInteger)nMaxRecRemain
{
    [self setAudio];
    self.recordPath = strRecPath;
    NSURL* recordUrl = [NSURL fileURLWithPath:self.recordPath];
    //初始化录音机
    self.avRecorder = [[AVAudioRecorder alloc]initWithURL:recordUrl settings:self.recordSetting error:nil];
    //开启音量检测
    self.avRecorder.meteringEnabled = YES;
    //开始录音
    [self.avRecorder prepareToRecord];
    [self.avRecorder record];
    //开启定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(OnTimer:)
                                                userInfo:nil
                                                 repeats:(YES
                                                          )];
    
    _nMaxRecRemain = nMaxRecRemain;
    
}


-(void)OnTimer:(NSTimer*)timer
{
    //刷新音量数据
    [self.avRecorder updateMeters];
    //给delegate对象发送消息，传出当前录音时间
    [self.delegate recTimeChanged:self.avRecorder.currentTime];
    //录音超时
    if (self.avRecorder.currentTime >= _nMaxRecRemain) {
        [self.delegate RecordTimeTooLong];
    }
    
}

//删除caf录音文件
-(void)deleteCafRecord
{
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:_recordPath]) {
        [fm removeItemAtPath:_recordPath error:nil];
    }
}

//删除MP3录音文件
-(void)deleteMp3Record
{
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:_mp3FilePath]) {
        [fm removeItemAtPath:_mp3FilePath error:nil];
    }
    [self.avPlayer stop];
}

//结束录音
-(void)endRecord
{
    NSTimeInterval recTime = self.avRecorder.currentTime;
    [self.avRecorder stop];
    [self.timer invalidate];
    //通知被委托方录音结束
    [self.delegate OnRecordEnd];
    //开启子线程进行转码
    if (recTime > 1) {
        [NSThread detachNewThreadSelector:@selector(audio_PCMtoMP3) toTarget:self withObject:nil];
    }
    
}

//播放录音
-(void)playRecordWithFilePath:(NSString*)filePath
{
    NSData* recData = [NSData dataWithContentsOfFile:filePath];
    self.avPlayer = [[AVAudioPlayer alloc]initWithData:recData error:nil];
    self.avPlayer.volume = 1.0;
    self.avPlayer.meteringEnabled = YES;
    self.avPlayer.delegate=self;
    [self.avPlayer play];
    //传出当前播放录音的总时间duration
    [self.delegate playTimeChanged:self.avPlayer.duration];
    [self.delegate playRecModel:self.avPlayer.isPlaying];
}

//播放完成后回调,isPlaying = NO;
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.delegate playRecModel:player.isPlaying];
}

//停止播放
-(void)stopPlay
{
    [self.avPlayer stop];
    [self.delegate playRecModel:self.avPlayer.isPlaying];
}

@end
