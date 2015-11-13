//
//  RPRetailConsultingViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-6-25.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPRetailConsultingViewController.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

@interface RPRetailConsultingViewController ()

@end

@implementation RPRetailConsultingViewController

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
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"RETAIL CONSULTING",@"RPString", g_bundleResorce,nil);
    _viewFrame.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)InitUI
{
    _tvDesc.text = @"";
    _lbTip.hidden = NO;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _lbTip.hidden = YES;
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0)
        _lbTip.hidden = NO;
    else
        _lbTip.hidden = YES;
}

-(BOOL)OnBack
{
    return YES;
}

-(IBAction)OnConfirm:(id)sender
{
    if (_tvDesc.text.length>0)
    {
        [SVProgressHUD showWithStatus:@""];
        [[RPSDK defaultInstance] UploadRetailConsult:_tvDesc.text Success:^(id idResult) {
            _viewTip.delegate = self;
            CGSize szScreen = [[UIScreen mainScreen] bounds].size;
            _viewTip.frame = CGRectMake(0, 0, szScreen.width, szScreen.height);
            [[[UIApplication sharedApplication] keyWindow] addSubview:_viewTip];
            [SVProgressHUD dismiss];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Content can't be empty",@"RPString", g_bundleResorce,nil)];
    }
    
}

-(IBAction)OnQuit:(id)sender
{
    
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to exit?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
           [self.delegate OnTaskEnd];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
}

-(void)OnConfirmPost
{
    [self InitUI];
}
- (IBAction)OnHelp:(id)sender {
    [RPGuide ShowGuide:self.view];
}
@end
