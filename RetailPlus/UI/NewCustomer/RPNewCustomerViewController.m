//
//  RPNewCustomerViewController.m
//  RetailPlus
//
//  Created by zwhe on 13-12-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPNewCustomerViewController.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@interface RPNewCustomerViewController ()

@end

@implementation RPNewCustomerViewController

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
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"NEW CLIENT",@"RPString", g_bundleResorce,nil);
    _svFrame.contentSize=CGSizeMake(_viewBackground.frame.size.width, _viewBackground.frame.size.height);
    [_svFrame addSubview:_viewBackground];
    _viewBackground.layer.cornerRadius=10;
    _view1.layer.cornerRadius=6;
    _view2.layer.cornerRadius=6;
    _view3.layer.cornerRadius=6;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped:)];
    [self.view addGestureRecognizer:tap];
}

- (void)locationTapped:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _svFrame.contentSize=CGSizeMake(_viewBackground.frame.size.width, _viewBackground.frame.size.height+300);
    if (textField==_tfProduct||textField==_tfProductID||textField==_tfUnitPrice||textField==_tfQty||textField==_tfTotal)
    {
        _svFrame.contentOffset=CGPointMake(0, _view3.frame.origin.y-10);
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _svFrame.contentSize=CGSizeMake(_viewBackground.frame.size.width, _viewBackground.frame.size.height);
    _svFrame.contentOffset=CGPointMake(0, 0);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)GenEmptyString:(NSString *)str
{
    if (!str) {
        return @"";
    }
    return str;
}
- (IBAction)OnOK:(id)sender
{
    [SVProgressHUD showWithStatus:@"Submitting..."];
    
    Customer * customer = [[Customer alloc] init];
    customer.strFirstName = [self GenEmptyString:_tfName.text];
    customer.strPhone1 = [self GenEmptyString:_tfPhoneNumber.text];
    
    [[RPSDK defaultInstance] AddCustomer:customer Success:^(id dictResult) {
        [self.delegate OnAddCustomEnd];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:@"添加客户失败"];
    }];

    
}
@end
