//
//  RPAccountSetupViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-10-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPAccountSetupViewController.h"
extern NSBundle * g_bundleResorce;

@interface RPAccountSetupViewController ()

@end

@implementation RPAccountSetupViewController

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
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"ACCOUNT MANAGEMENT",@"RPString", g_bundleResorce,nil);
    _viewFrame.layer.cornerRadius = 10;
    _viewChangePsw.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    _viewChangePsw.delegate = self;
    
    [self.view addSubview:_viewChangePsw];
    
    _viewBtnFrame.layer.cornerRadius = 5;
    _viewBtnFrame.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewBtnFrame.layer.borderWidth = 1;
    
    if ([RPSDK defaultInstance].userLoginDetail.strUserEmail.length > 0) {
         _viewWarning.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OnSetTitle:(NSString *)strTitle
{
    self.strTaskName = strTitle;
    [self.delegate OnReloadTitle];
}

-(IBAction)OnAccountSecurity:(id)sender
{
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"ACCOUNT SECURITY",@"RPString", g_bundleResorce,nil);
    [self.delegate OnReloadTitle];
    
    _viewAccountSec.delegate = self;
    _viewAccountSec.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewAccountSec];
    
    [UIView beginAnimations:nil context:nil];
    _viewAccountSec.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    _bAccountSec = YES;
}

-(IBAction)OnChangePsw:(id)sender
{
    _bChangePsw = YES;
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"CHANGE PASSWORD",@"RPString", g_bundleResorce,nil);
    [self.delegate OnReloadTitle];

    [_viewChangePsw clear];
    
    _viewChangePsw.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView beginAnimations:nil context:nil];
    _viewChangePsw.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(BOOL)OnBack
{
    if (_bChangePsw) {
        
        [UIView beginAnimations:nil context:nil];
        _viewChangePsw.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        [self.view endEditing:YES];
        
        self.strTaskName = NSLocalizedStringFromTableInBundle(@"ACCOUNT MANAGEMENT",@"RPString", g_bundleResorce,nil);
        [self.delegate OnReloadTitle];
        
        _bChangePsw = NO;
        return  NO;
    }
    
    if (_bAccountSec) {
        _bAccountSec = ![_viewAccountSec OnBack];
        if (!_bAccountSec) {
            [UIView beginAnimations:nil context:nil];
            _viewAccountSec.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            self.strTaskName = NSLocalizedStringFromTableInBundle(@"ACCOUNT MANAGEMENT",@"RPString", g_bundleResorce,nil);
            [self.delegate OnReloadTitle];
        }
        return NO;
    }
    return YES;
}

-(void)OnChangePswEnd
{
    [UIView beginAnimations:nil context:nil];
    _viewChangePsw.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"CHANGE PASSWORD",@"RPString", g_bundleResorce,nil);
    [self.delegate OnReloadTitle];
    _bChangePsw = NO;
}

-(void)OnEnd
{
    [self.delegate OnTaskEnd];
}
@end
