//
//  RPCodeQueryViewController.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-4-29.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCodeQueryViewController.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@interface RPCodeQueryViewController ()

@end

@implementation RPCodeQueryViewController

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
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"QR CODE QUERY",@"RPString", g_bundleResorce,nil);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ScanedCode:(RPBarViewController *)ctrl Code:(NSString *)strCode isCurrentScan:(BOOL)bScaned
{
    [[RPSDK defaultInstance]GetGoodsTrackingInfo:strCode Success:^(GoodsTrackingInfo*  idResult) {
        if (idResult==nil && !bScaned) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"QUERY FAILED",@"RPString", g_bundleResorce,nil)];
            return;
        }
        
        GoodsTrackingInfo * info = idResult;
        if (info == nil) {
            info = [[GoodsTrackingInfo alloc] init];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"yyyy/MM/dd"];
            info.strDate = [dateformatter stringFromDate:[NSDate date]];
            info.strID = [RPSDK genUUID];
            info.strCode = strCode;
            info.strDetail = @"";
        }
        
        _viewCodeResult.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:_viewCodeResult];
        _viewCodeResult.strCode=strCode;
        _viewCodeResult.delegate=self;
        _viewCodeResult.result=info;
        [UIView beginAnimations:nil context:nil];
        _viewCodeResult.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        _bResultView=YES;
        [ctrl dismiss ];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        if (!bScaned) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"QUERY FAILED",@"RPString", g_bundleResorce,nil)];
        }
        else
        {
            GoodsTrackingInfo * info = [[GoodsTrackingInfo alloc] init];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"yyyy/MM/dd"];
            info.strDate = [dateformatter stringFromDate:[NSDate date]];
            info.strID = [RPSDK genUUID];
            info.strCode = strCode;
            info.strDetail = @"";
            
            _viewCodeResult.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:_viewCodeResult];
            _viewCodeResult.strCode=strCode;
            _viewCodeResult.delegate=self;
            _viewCodeResult.result=info;
            [UIView beginAnimations:nil context:nil];
            _viewCodeResult.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            _bResultView=YES;
            [ctrl dismiss ];

        }
    }];
    
    
    
}
- (IBAction)OnNewQuery:(id)sender
{
    RPBarViewController *barViewController=[[RPBarViewController alloc]init];
    barViewController.delegate=self;
    barViewController.vcFrame = self.vcFrame;
    [self.vcFrame presentViewController:barViewController animated:YES completion:^{
        
    }];
}

- (IBAction)OnQueryHistory:(id)sender
{
    _viewHistory.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    _viewHistory.delegate=self;
    [self.view addSubview:_viewHistory];
    [UIView beginAnimations:nil context:nil];
    _viewHistory.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    NSArray * arrayHistory=[[RPSDK defaultInstance]GetGoodsTrackingList:@""];
    _viewHistory.arrayHistory=arrayHistory;
    _bHistory=YES;
    
}
-(BOOL)OnBack
{
    if (_bResultView)
    {
        [UIView beginAnimations:nil context:nil];
        _viewCodeResult.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        _bResultView=NO;
        return NO;
    }
    if (_bHistory)
    {
        if ([_viewHistory OnBack])
        {
            [UIView beginAnimations:nil context:nil];
            _viewHistory.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            _bHistory=NO;
        }
        
        return NO;
    }
    return YES;
}
-(void)endCodeHistory
{
    [self.delegate OnTaskEnd];
}
-(void)OnShowResultEnd
{
    
}
@end
