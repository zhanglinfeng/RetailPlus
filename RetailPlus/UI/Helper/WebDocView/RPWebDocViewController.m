//
//  RPWebDocViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-12-10.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPWebDocViewController.h"
#import "RPDLProgressViewController.h"
//#import "SVProgressHUD.h"

@interface RPWebDocViewController ()

@end

@implementation RPWebDocViewController

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
    // Do any additional setup after loading the view from its nib.
}


long long nBytesRecv = 0;

-(void)viewDidAppear:(BOOL)animated
{
    CGSize szScreen = [[UIScreen mainScreen] bounds].size;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        _viewBorder.frame = CGRectMake(0, 20, szScreen.width, szScreen.height - 20);
    
    if (!_strUrl || _strUrl.length <= 3) return;
    
    NSURL * url = nil;
    if (_bLocalFile) {
        url = [NSURL fileURLWithPath:_strUrl];
        NSURLRequest * req = [NSURLRequest requestWithURL:url];
        [_webview loadRequest:req];
        return;
    }
    
    if ([RPSDK defaultInstance].bDemoMode) {
        NSString *fullPath = [NSBundle pathForResource:_strUrl
                                                ofType:nil inDirectory:[[NSBundle mainBundle] bundlePath]];
        url = [NSURL fileURLWithPath:fullPath];
        NSURLRequest * req = [NSURLRequest requestWithURL:url];
        [_webview loadRequest:req];
    }
    else
    {
        url = [NSURL URLWithString:[_strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if (_cache == nil) {
            NSURLRequest * req = [NSURLRequest requestWithURL:url];
            [self.webview loadRequest:req];
        }
        else
        {
            _httpRequest = [ASIHTTPRequest requestWithURL:url];   //根据url创建请求
            nBytesRecv = 0;
            //通过一个block来实现完成功能回调
            [_httpRequest setDownloadCache:_cache];
            //设置缓存数据存储策略，这里采取的是如果无更新或无法联网就读取缓存数据
            [_httpRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            
            __block RPWebDocViewController * ctrl = self;
            
            NSString * strFileType = [_strUrl substringFromIndex:[_strUrl length] - 3];
            _filename = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"show.%@",strFileType]];
            [_httpRequest setTemporaryFileDownloadPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"offline"]];
            [_httpRequest setDownloadDestinationPath:_filename];
            [_httpRequest setAllowResumeForFileDownloads:YES];
            
            [_httpRequest setCompletionBlock:^{
                //  UIImage *downloadedImage = [UIImage imageWithData:[httpRequest responseData]];
                [RPDLProgressViewController dismiss];
                
                NSURL *  url = [NSURL fileURLWithPath:[ctrl.httpRequest downloadDestinationPath]];
                NSURLRequest * req = [NSURLRequest requestWithURL:url];
                [ctrl.webview loadRequest:req];
            }];
            
            [_httpRequest setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
                nBytesRecv += size;
                if (total != 0) {
                    [RPDLProgressViewController showProgress:nBytesRecv TotalSize:total target:ctrl Desc:ctrl.strTitle selector:@selector(OnCancelDownload)];
                }
            }];
            
            [_httpRequest setFailedBlock:^{
                [RPDLProgressViewController dismiss];
            }];
            
            [RPDLProgressViewController showProgress:0 TotalSize:0 target:self Desc:ctrl.strTitle selector:@selector(OnCancelDownload)];
            [_httpRequest startAsynchronous];
        }
    }
}

-(void)OnCancelDownload
{
    [self.httpRequest cancel];
    [RPDLProgressViewController dismiss];
//    [self dismissViewControllerAnimated:YES completion:^{
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager removeItemAtPath:_filename error:nil];
//    }];
//    [self.delegate backDoc];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)locationCanvasTapped:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    _viewToolbar.hidden = !_viewToolbar.hidden;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)OnBack:(id)sender
{
    [self.httpRequest cancel];
    [RPDLProgressViewController dismiss];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:_filename error:nil];
    }];
    [self.delegate backDoc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}
@end
