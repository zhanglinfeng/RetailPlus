//
//  RPStoreManagerViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-9-3.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPStoreManagerViewController.h"

@interface RPStoreManagerViewController ()

@end

@implementation RPStoreManagerViewController

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
    
    _bViewInited = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (_bViewInited == NO) {
        _viewlist.frame = CGRectMake(0, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
        [_svFrame addSubview:_viewlist];
        
        _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width, _svFrame.frame.size.height);
        _svFrame.pagingEnabled = YES;
        _svFrame.showsHorizontalScrollIndicator = NO;
        
        _viewlist.delegate = self;
    }
    _bViewInited = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OnSelectStoreManagerStore:(StoreDetailInfo *)store
{
    [self.delegate OnSelectStoreManagerStore:store];
}

-(void)ReloadData
{
    [_viewlist ReloadData];
}

-(void)UpdateStore:(StoreDetailInfo *)store
{
    [_viewlist UpdateStore:store];
}

-(void)ShowTitleBar
{
    _lbTitle.alpha = 0;
    _lbTitle.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    _lbTitle.alpha = 1;
    [UIView commitAnimations];
}

-(void)HideTitleBar
{
    _lbTitle.hidden = YES;
}

@end
