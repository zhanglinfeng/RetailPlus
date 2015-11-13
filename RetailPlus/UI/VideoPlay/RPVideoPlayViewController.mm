//
//  RPVideoPlayViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-4-1.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPVideoPlayViewController.h"
#import "VideoPlaySDK.h"
#import "VideoPlayInfo.h"
#import "RecordInfo.h"
#import "CaptureInfo.h"
#import "VideoPlayUtility.h"

void StatusCallBack(PLAY_STATE playState, VP_HANDLE hLogin, void *pHandl);
void StatusCallBack(PLAY_STATE playState, VP_HANDLE hLogin, void *pHandl)
{
    NSLog(@"playState is %d", playState);
}

@interface RPVideoPlayViewController ()
{
    VP_HANDLE _vpHandle;
}

@end

@implementation RPVideoPlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize szScreen = [[UIScreen mainScreen] bounds].size;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        _viewBorder.frame = CGRectMake(0, 20, szScreen.width, szScreen.height - 20);

   // [self performSelector:@selector(showVideo) withObject:nil afterDelay:2];
    
    [self performSelectorInBackground:@selector(showVideo) withObject:nil];
}

- (void)showVideo
{
// Do any additional setup after loading the view from its nib.
    VideoPlayInfo *videoInfo = [[VideoPlayInfo alloc] init];
  //  videoInfo.strUser   = @"admin";
  //  videoInfo.strPsw    = @"12345";
    videoInfo.strPlayUrl    = @"rtsp://192.168.1.10:554/hc8://192.168.1.9:8000:0:1:admin:12345:MCU";
    videoInfo.protocalType  = PROTOCAL_UDP;
    videoInfo.playType      = REAL_PLAY;
    videoInfo.streamMethod  = STREAM_METHOD_VTDU;
    videoInfo.streamType    = STREAM_MAIN;
    videoInfo.pPlayHandle   = (id)_viewPlay;
    videoInfo.bSystransform = NO;

    if (_vpHandle != NULL)
    {
        VP_Logout(_vpHandle);
        _vpHandle = NULL;
    }

    // 获取VideoPlaySDK 播放句柄
    if (_vpHandle == NULL)
    {
        _vpHandle = VP_Login(videoInfo);
    }

    // 设置状态回调
    if (_vpHandle != NULL)
    {
        VP_SetStatusCallBack(_vpHandle, StatusCallBack, (__bridge void *)self);
    }

    // 开始实时预览
    if (_vpHandle != NULL)
    {
        if (!VP_RealPlay(_vpHandle))
        {
            NSLog(@"start VP_RealPlay failed");
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OnBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
