//
//  RPGuideViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-5-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPGuideViewController.h"
extern NSBundle * g_bundleResorce;

@interface RPGuideViewController ()

@end

@implementation RPGuideViewController

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
    _arrayArrow =[NSArray arrayWithObjects:_arraw1, _arraw2,_arraw3,_arraw4,_arraw5,_arraw6,nil];
    _arrayBtn = [NSArray arrayWithObjects:_btn1, _btn2,_btn3,_btn4,_btn5,_btn6,nil];
    _arrayViewBody = [NSArray arrayWithObjects:_viewBody1, _viewBody2,_viewBody3,_viewBody4,_viewBody5,_viewBody6,nil];
    [self ReloadUI:0];
    
    _ivDetail1.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"gmenu@2x" ofType:@"png"]];
    _ivDetail2.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"gmsgcenter@2x" ofType:@"png"]];
    _ivDetail3.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"gmain@2x" ofType:@"png"]];
    _ivDetail4.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"gaddbook@2x" ofType:@"png"]];
    _ivDetail5.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"gstorelist@2x" ofType:@"png"]];
    _ivDetail6.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"gsetting@2x" ofType:@"png"]];
    
    
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    //设置滑动方向
    [leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftSwipeRecognizer];
    
    // 滑动的 Recognizer
    UISwipeGestureRecognizer *RightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    //设置滑动方向
    [RightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:RightSwipeRecognizer];
    
    _nCurBtnIndex = 0;
}

-(void)handleLeftSwipe:(UISwipeGestureRecognizer*)recognizer
{
    if (_nCurBtnIndex < (_arrayBtn.count - 1)) {
        _nCurBtnIndex ++;
        UIButton * btn = [_arrayBtn objectAtIndex:_nCurBtnIndex];
        [self OnTask:btn];
    }
    else
        [self.view removeFromSuperview];
}

-(void)handleRightSwipe:(UISwipeGestureRecognizer*)recognizer
{
    if (_nCurBtnIndex > 0) {
        _nCurBtnIndex --;
        UIButton * btn = [_arrayBtn objectAtIndex:_nCurBtnIndex];
        [self OnTask:btn];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OnTask:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    for (NSInteger n = 0; n < _arrayBtn.count; n ++) {
        UIButton * btnGet = [_arrayBtn objectAtIndex:n];
        if (btnGet == btn) {
            [self ReloadUI:n];
            _nCurBtnIndex = n;
            _pageCtrl.currentPage = _nCurBtnIndex;
            break;
        }
    }
}

-(void)OnClose:(id)sender
{
    [self.view removeFromSuperview];
}

-(void)ReloadUI:(NSInteger)nCurSelIndex
{
    NSInteger n = 0;
    for (UIButton * btn in _arrayBtn) {
        if (n != nCurSelIndex)
            [btn setSelected:NO];
        else
            [btn setSelected:YES];
        
        n++;
    }
    
    n = 0;
    for (UIView * view in _arrayArrow) {
        if (n != nCurSelIndex)
            view.hidden = YES;
        else
            view.hidden = NO;
        n++;
    }
    
    n = 0;
    for (UIView * view in _arrayViewBody) {
        if (n != nCurSelIndex)
            view.hidden = YES;
        else
            view.hidden = NO;
        n++;
    }
}

-(void)Reload
{
    _nCurBtnIndex = 0;
    UIButton * btn = [_arrayBtn objectAtIndex:_nCurBtnIndex];
    [self OnTask:btn];
}
@end
