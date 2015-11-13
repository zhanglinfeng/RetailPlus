//
//  RPTrafficViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-8-14.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPTrafficViewController.h"

@interface RPTrafficViewController ()

@end

@implementation RPTrafficViewController

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
    NSInteger nHeight = (_viewFrame.frame.size.height - _viewGap.frame.origin.y + _viewGap.frame.size.height - 60) / 2;
    _rcGraph = CGRectMake(0, _viewGap.frame.origin.y + _viewGap.frame.size.height, _viewFrame.frame.size.width, nHeight);
    _rcTable = CGRectMake(0, _rcGraph.origin.y + _rcGraph.size.height, _viewFrame.frame.size.width, nHeight);
    _tableView.frame = _rcTable;
    _graphView.frame = _rcGraph;
    
    [_viewFrame addSubview:_tableView];
    [_viewFrame addSubview:_graphView];
    
    _viewFrame.layer.cornerRadius =6.0;
    
    _bGraphViewHide = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)OnShowHideGraph:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    
    if (_bGraphViewHide) {
        _tableView.frame = _rcTable;
        _graphView.frame = _rcGraph;
    }
    else
    {
        _graphView.frame = CGRectMake(0, _graphView.frame.origin.y, _graphView.frame.size.width, 0);
        
        _tableView.frame = CGRectMake(0, _viewGap.frame.origin.y + _viewGap.frame.size.height, _viewFrame.frame.size.width, (_viewFrame.frame.size.height - _viewGap.frame.origin.y + _viewGap.frame.size.height));
    }
    _bGraphViewHide = !_bGraphViewHide;
    [UIView commitAnimations];
}
@end
