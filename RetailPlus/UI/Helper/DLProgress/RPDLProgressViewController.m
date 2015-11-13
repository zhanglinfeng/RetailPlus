//
//  RPDLProgressViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-4-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPDLProgressViewController.h"

@interface RPDLProgressViewController ()

@end

@implementation RPDLProgressViewController

static RPDLProgressViewController * defaultObject;
SEL defaultCancelSelector;
id defaultTarget;

+(void)showProgress:(long long)llCurSize TotalSize:(long long)llTotalSize target:(id)target Desc:(NSString *)strDesc selector:(SEL)aSelector
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    
    if (defaultObject == nil) {
        defaultObject = [[RPDLProgressViewController alloc] init];
        defaultObject.view.frame = CGRectMake(0,0,keywindow.frame.size.width,keywindow.frame.size.height);
        defaultObject.viewEx.layer.cornerRadius = 8;
    }
    
    defaultTarget = target;
    
    [UIView beginAnimations:nil context:nil];
    defaultObject.viewEx.frame = CGRectMake(defaultObject.view.frame.size.width / 2 - defaultObject.viewEx.frame.size.width / 2, defaultObject.view.frame.size.height / 2 - defaultObject.viewEx.frame.size.height / 2 + 42, defaultObject.viewEx.frame.size.width, defaultObject.viewEx.frame.size.height);
    [UIView commitAnimations];
    
    defaultObject.lbDesc.text = strDesc;
    defaultCancelSelector = aSelector;
    [defaultObject setProgressBar:llCurSize TotalSize:llTotalSize];
    
    [keywindow addSubview:defaultObject.view];
}

+(void)dismiss
{
    defaultObject.viewEx.frame = CGRectMake(defaultObject.view.frame.size.width / 2 - defaultObject.viewEx.frame.size.width / 2, defaultObject.view.frame.size.height / 2 - defaultObject.viewEx.frame.size.height / 2, defaultObject.viewEx.frame.size.width, defaultObject.viewEx.frame.size.height);
    
    [defaultObject.view removeFromSuperview];
}

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
    _nTotalWidth = _viewPercent.frame.size.width;
    _nMarkBeginPos = _viewPercent.center.x;
    _nMarkEndPos = _viewPercent.frame.origin.x + _viewPercent.frame.size.width;
    
    _lastPercent = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setProgressBar:(long long)llCurSize TotalSize:(long long)llTotalSize
{
    float fPercent = 0;
    if (llTotalSize > 0) {
        fPercent = (float)llCurSize / llTotalSize;
    }
    
    if (llTotalSize == 0)
        _lbPercent.text = @"";
    else
        _lbPercent.text = [NSString stringWithFormat:@"%d%%",(NSInteger)(fPercent * 100)];
  
    float fMB = (float)llTotalSize / (1024 * 1024);
    
    _lbTotalSize.text = [NSString stringWithFormat:@"%0.2f MB",fMB];
    
    if (_lastPercent < fPercent)
        [UIView beginAnimations:nil context:nil];
    
    _viewPercent.frame = CGRectMake(_viewPercent.frame.origin.x, _viewPercent.frame.origin.y, _nTotalWidth * fPercent, _viewPercent.frame.size.height);
    
    _ivImage.center = CGPointMake(_viewPercent.center.x + (NSInteger)((_nMarkEndPos - _nMarkBeginPos) * fPercent),_ivImage.center.y);
    
    if (_lastPercent < fPercent)
        [UIView commitAnimations];
    
    _lastPercent = fPercent;
}

-(IBAction)OnCancel:(id)sender
{
    [defaultTarget performSelector:defaultCancelSelector withObject:nil afterDelay:0];
}
@end
