//
//  RPBarViewController.m
//  TestBarCode
//
//  Created by lin dong on 14-4-30.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBarViewController.h"

@interface RPBarViewController ()

@end

extern NSBundle * g_bundleResorce;

@implementation RPBarViewController

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
    [ZBarReaderView class];
    _lbTip.text = NSLocalizedStringFromTableInBundle(@"Align the QR Code within the frame to scan",@"RPString", g_bundleResorce,nil);
    
    CGRect f = [[UIScreen mainScreen] applicationFrame];
    
    if (f.size.height < 480) {
        _ivMask.image = [UIImage imageNamed:@"bg_scanscreen_35.png"];
        _nBeginPos = 130;
    }
    else
    {
        _ivMask.image = [UIImage imageNamed:@"bg_scanscreen_40.png"];
        _nBeginPos = 174;
    }
    
    _nLineWidth = 220;
    
    _nEndPos = _nBeginPos + _nLineWidth;
    _nLeft = (_viewReader.frame.size.width - _nLineWidth) / 2;
    
    
    _viewMask.frame = _viewReader.frame;
    [self.view addSubview:_viewMask];
    
    _viewReader.readerDelegate = self;
 //   _viewReader.scanCrop = CGRectMake((float)_nLeft / f.size.width, (float)_nBeginPos / f.size.height, (float)_nLineWidth / f.size.width, (float)_nLineWidth / f.size.height);
    _viewReader.torchMode = 0;
    [_viewReader start];
    
    
    _ivLine = [[UIImageView alloc] initWithFrame:CGRectMake(_nLeft, _nBeginPos, _nLineWidth, 2)];
    _ivLine.image = [UIImage imageNamed:@"line.png"];
    [_viewMask addSubview:_ivLine];
    
   // _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    _bDismissed = NO;
    [self doAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)doAnimation
{
    if (_upOrdown)
        _ivLine.frame = CGRectMake(_nLeft, _nBeginPos, _nLineWidth, 2);
    else
        _ivLine.frame = CGRectMake(_nLeft, _nBeginPos + _nLineWidth, _nLineWidth, 2);
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    if (_upOrdown)
        _ivLine.frame = CGRectMake(_nLeft, _nBeginPos + _nLineWidth, _nLineWidth, 2);
    else
        _ivLine.frame = CGRectMake(_nLeft, _nBeginPos, _nLineWidth, 2);
    
    [UIView commitAnimations];
}


- (void)animationDidStop:(NSString*)str finished:(NSNumber*)flag context:(void*)context {
    if (_bDismissed) return;
    
    _upOrdown = !_upOrdown;
     [self doAnimation];
}

-(void)animation1
{
    if (_upOrdown == NO) {
        _num ++;
        _ivLine.frame = CGRectMake(_nLeft, _nBeginPos+2*_num, _nLineWidth, 2);
        if (2*_num >= _nLineWidth) {
            _upOrdown = YES;
        }
    }
    else {
        _num --;
        _ivLine.frame = CGRectMake(_nLeft, _nBeginPos+2*_num, _nLineWidth, 2);
        if (_num <= 0) {
            _upOrdown = NO;
        }
    }
}

-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    NSString *result = nil;
    //遍历符号集合，获得符号
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"%@", symbol.data);
        result = symbol.data;
        break;
    }
    [self.delegate ScanedCode:self Code:result isCurrentScan:YES];
}

-(IBAction)OnBack:(id)sender
{
    [_viewReader removeFromSuperview];
    _bDismissed = YES;
    [_timer invalidate];
    [_viewReader stop];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(IBAction)OnPic:(id)sender
{
    ZBarReaderController *reader = [ZBarReaderController new];
    reader.readerDelegate = self;
    reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    reader.showsHelpOnFail = NO;
    [self presentViewController:reader animated:YES completion:^{
    }];
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry
{
    [reader dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    NSLog(@"===%@",symbol.data);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }
        [self.delegate ScanedCode:self Code:symbol.data isCurrentScan:NO];
    }];
}

-(IBAction)OnInput:(id)sender
{
    [_viewInput ShowCommentView];
}

-(IBAction)OnTorch:(id)sender
{
    _btLight.selected=!_btLight.selected;
    if (_bTorchOn)
        _viewReader.torchMode = 0;
    else
        _viewReader.torchMode = 1;
    
    _bTorchOn = !_bTorchOn;
}

-(void)SearchEnd:(NSString *)strCode
{
    if (strCode.length > 0) {
        [self.delegate ScanedCode:self Code:strCode isCurrentScan:NO];
    }
}

-(void)dismiss
{
    [_viewReader removeFromSuperview];
    _bDismissed = YES;
    [_timer invalidate];
    [_viewReader stop];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
