//
//  RPLiveVideoView.m
//  RetailPlus
//
//  Created by lin dong on 14-4-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPLiveVideoView.h"
#import "VideoPlaySDK.h"
#import "VideoPlayInfo.h"
#import "RecordInfo.h"
#import "CaptureInfo.h"
#import "VideoPlayUtility.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

void LVStatusCallBack(PLAY_STATE playState, VP_HANDLE hLogin, void *pHandl);
void LVStatusCallBack(PLAY_STATE playState, VP_HANDLE hLogin, void *pHandl)
{
    NSLog(@"playState is %d", playState);
}

@implementation RPLiveVideoView

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
    CGAffineTransform at = CGAffineTransformMakeRotation(M_PI/2);
    [self setTransform:at];
    
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToShowMenu:)];
    [self addGestureRecognizer:singleTapGR];
    
    _lbCamera.adjustsFontSizeToFitWidth = YES;
    _lbStoreName.adjustsFontSizeToFitWidth = YES;
    
    _btBef.alpha=0.4;
}

- (void)tapAnywhereToShowMenu:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    _viewMenu.hidden = !_viewMenu.hidden;
}

-(void)HideFrameAnimationStopped
{
    [self removeFromSuperview];
 
    if (_vpHandle != NULL)
    {
        VP_Logout(_vpHandle);
        _vpHandle = NULL;
    }
}

-(IBAction)OnClose:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [SVProgressHUD dismiss];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDidStopSelector:@selector(HideFrameAnimationStopped)];
    self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}

- (void)showVideo:(NSMutableArray *)arrayCamera index:(NSInteger)nIndex storeName:(NSString *)strStoreName
{
    _arrayCamera = arrayCamera;
    if (nIndex>=_arrayCamera.count-1) {
        _btNext.alpha=0.4;
    }
    else
    {
        _btNext.alpha=1;
    }
    if (nIndex<1)
    {
        _btBef.alpha=0.4;
    }
    else
    {
        _btBef.alpha=1;
    }

    _nIndex = nIndex;
    _strStoreName = strStoreName;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    _viewPlay.hidden = YES;
    _lbCamera.text = ((LiveCamera *)[_arrayCamera objectAtIndex:_nIndex]).strCameraName;
    _lbStoreName.text = _strStoreName;
    
    if (_networkRequestThread)
    {
        [_networkRequestThread cancel];
    }
    
    [SVProgressHUD showWithStatus:nil];
    
    _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(show) object:nil];
    [_networkRequestThread start];
    
    //[self performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

- (void)show
{
    VideoPlayInfo *videoInfo = [[VideoPlayInfo alloc] init];
    videoInfo.strPlayUrl    = ((LiveCamera *)[_arrayCamera objectAtIndex:_nIndex]).strLiveURL;
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
        VP_SetStatusCallBack(_vpHandle, LVStatusCallBack, (__bridge void *)self);
    }
    
    // 开始实时预览
    if (_vpHandle != NULL)
    {
        if (!VP_RealPlay(_vpHandle))
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Start Live Video Failed",@"RPString", g_bundleResorce,nil)];
        }
        else
        {
            _viewPlay.hidden = NO;
            [SVProgressHUD dismiss];
        }
    }
}

- (IBAction)OnBef:(id)sender
{
//    if (!VP_AudioCtrl(_vpHandle, true))
//    {
//        NSLog(@"VP_AudioCtrl failed");
//    }
    if (_nIndex > 0) {
        _nIndex --;
        [self showVideo:_arrayCamera index:_nIndex storeName:_strStoreName];
    }
}

- (IBAction)OnNext:(id)sender
{
    if (_nIndex < (_arrayCamera.count - 1)) {
        _nIndex ++;
        [self showVideo:_arrayCamera index:_nIndex storeName:_strStoreName];
    }
}
@end
