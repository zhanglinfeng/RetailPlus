//
//  RPCacheManagementViewController.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-4-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCacheManagementViewController.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
#import "RPCacheSize.h"
extern NSBundle * g_bundleResorce;
@interface RPCacheManagementViewController ()

@end

@implementation RPCacheManagementViewController

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
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"CACHE MANAGEMENT",@"RPString", g_bundleResorce,nil);
    _viewBackground.layer.cornerRadius = 10;
    _viewClear.layer.cornerRadius = 6;
//    _viewClear.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _viewClear.layer.borderWidth = 1;
    _viewTable.layer.cornerRadius = 6;
    _viewTable.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewTable.layer.borderWidth = 1;
    [self showCacheSize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showCacheSize
{
    _lbDocument.text=[RPCacheSize GetCacheSizeString:[RPCacheSize GetDocumentLiveCacheSize]];
    _lbSystem.text=[RPCacheSize GetCacheSizeString:[RPCacheSize GetSystemCacheSize]];
    _lbTraining.text=[RPCacheSize GetCacheSizeString:[RPCacheSize GetTrainingCacheSize]];
    unsigned long long sum=0;
    if (_btSelectDocument.selected)
    {
        sum=sum+[RPCacheSize GetDocumentLiveCacheSize];
    }
    if (_btSelectSystem.selected)
    {
        sum=sum+[RPCacheSize GetSystemCacheSize];
    }
    if (_btSelectTraining.selected)
    {
        sum=sum+[RPCacheSize GetTrainingCacheSize];
    }
    _lbAll.text=[RPCacheSize GetCacheSizeString:sum];
}
- (IBAction)OnClean:(id)sender
{
    if (!(_btSelectDocument.selected||_btSelectSystem.selected||_btSelectTraining.selected))
    {
        
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"There is no selected cache can clean",@"RPString", g_bundleResorce,nil)];
    }
    else
    {
        NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
        NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to clear selected cache(s)?",@"RPString", g_bundleResorce,nil);
        RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
            if (indexButton==1)
            {
                if (_btSelectDocument.selected)
                {
                    [RPCacheSize ClearDocumentLiveCache];
                }
                if (_btSelectSystem.selected)
                {
                    [RPCacheSize ClearSystemCache];
                }
                if (_btSelectTraining.selected)
                {
                    [RPCacheSize ClearTrainingCache];
                }
                [self showCacheSize];
            }
            
        }otherButtonTitles:strOK, nil];
        [alertView show];
    }
    
}

- (IBAction)OnSelectAll:(id)sender
{
    _btSelectAll.selected=!_btSelectAll.selected;
    _btSelectDocument.selected=_btSelectAll.selected;
    _btSelectSystem.selected=_btSelectAll.selected;
    _btSelectTraining.selected=_btSelectAll.selected;
    if (_btSelectAll.selected)
    {
        _lbAll.textColor=[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
        _lbDocument.textColor=[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
        _lbSystem.textColor=[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
        _lbTraining.textColor=[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
        
        _viewClear.backgroundColor=[UIColor colorWithRed:48.0f/255 green:115.0f/255 blue:119.0f/255 alpha:1];
        _viewClear.layer.shadowOffset = CGSizeMake(2, 2);
        _viewClear.layer.shadowRadius =6.0;
        _viewClear.layer.shadowColor =[UIColor blackColor].CGColor;
        _viewClear.layer.shadowOpacity =0.8;
    }
    else
    {
        _lbAll.textColor=[UIColor colorWithWhite:0.3 alpha:1];
        _lbDocument.textColor=[UIColor colorWithWhite:0.3 alpha:1];
        _lbSystem.textColor=[UIColor colorWithWhite:0.3 alpha:1];
        _lbTraining.textColor=[UIColor colorWithWhite:0.3 alpha:1];
        [_btSelectAll setBackgroundImage:[UIImage imageNamed:@"icon_noselected_setup@2x.png"] forState:UIControlStateNormal];
        
        _lbAll.textColor=[UIColor colorWithWhite:0.8 alpha:1];
        _viewClear.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
        _viewClear.layer.shadowColor=[UIColor clearColor].CGColor;
    }
    [self showCacheSize];
}

- (IBAction)OnSelectTraining:(id)sender
{
    _btSelectTraining.selected=!_btSelectTraining.selected;
    if (_btSelectTraining.selected)
    {
        _lbTraining.textColor=[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
    }
    else
    {
        _lbTraining.textColor=[UIColor colorWithWhite:0.3 alpha:1];
    }
    [self showAllColor];
    [self showCacheSize];
}

- (IBAction)OnSelectDocument:(id)sender
{
    _btSelectDocument.selected=!_btSelectDocument.selected;
    if (_btSelectDocument.selected)
    {
        _lbDocument.textColor=[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
    }
    else
    {
        _lbDocument.textColor=[UIColor colorWithWhite:0.3 alpha:1];
    }
    [self showAllColor];
    [self showCacheSize];
}

- (IBAction)OnSelectSystem:(id)sender
{
    _btSelectSystem.selected=!_btSelectSystem.selected;
    if (_btSelectSystem.selected)
    {
        _lbSystem.textColor=[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
    }
    else
    {
        _lbSystem.textColor=[UIColor colorWithWhite:0.3 alpha:1];
    }
    [self showAllColor];
    [self showCacheSize];
}
-(void)showAllColor
{
    if (_btSelectTraining.selected&&_btSelectDocument.selected&&_btSelectSystem.selected)
    {
        _btSelectAll.selected=YES;
    }
    else if(!_btSelectDocument.selected&&!_btSelectSystem.selected&&!_btSelectTraining.selected)
    {
        _btSelectAll.selected=NO;
        [_btSelectAll setBackgroundImage:[UIImage imageNamed:@"icon_noselected_setup@2x.png"] forState:UIControlStateNormal];
    }
    else
    {
        _btSelectAll.selected=NO;
        [_btSelectAll setBackgroundImage:[UIImage imageNamed:@"icon_part_selected@2x.png"] forState:UIControlStateNormal];
    }
    if (_btSelectTraining.selected||_btSelectDocument.selected||_btSelectSystem.selected)
    {
        _lbAll.textColor=[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
        _viewClear.backgroundColor=[UIColor colorWithRed:48.0f/255 green:115.0f/255 blue:119.0f/255 alpha:1];
        _viewClear.layer.shadowOffset = CGSizeMake(2, 2);
        _viewClear.layer.shadowRadius =6.0;
        _viewClear.layer.shadowColor =[UIColor blackColor].CGColor;
        _viewClear.layer.shadowOpacity =0.8;
    }
    else
    {
        _lbAll.textColor=[UIColor colorWithWhite:0.8 alpha:1];
        _viewClear.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
        _viewClear.layer.shadowColor=[UIColor clearColor].CGColor;
    }
}
@end
