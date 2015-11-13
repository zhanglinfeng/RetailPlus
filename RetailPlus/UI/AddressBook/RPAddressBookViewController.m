//
//  RPAddressBookViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-8-16.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPAddressBookViewController.h"
#import "RPModifyCustomerViewController.h"
#import "SVProgressHUD.h"

@interface RPAddressBookViewController ()

@end
extern NSBundle * g_bundleResorce;

@implementation RPAddressBookViewController

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
    
    _lbTitle.text = NSLocalizedStringFromTableInBundle(@"INTERNAL CONTACTS",@"RPString", g_bundleResorce,nil);
}

-(void)viewWillAppear:(BOOL)animated
{
    if (_bViewInited == NO) {
        _viewInternal.frame = CGRectMake(0, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
        _viewInternal.vcFrame = self.vcFrame;
        [_svFrame addSubview:_viewInternal];
        
        _viewCustomer.frame = CGRectMake(_svFrame.frame.size.width, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
        _viewCustomer.vcFrame = self.vcFrame;
        [_svFrame addSubview:_viewCustomer];
        
//        _viewInvite.frame = CGRectMake(0, self.view.frame.size.height + 100, self.view.frame.size.width, self.view.frame.size.height + 42);
//        [self.view addSubview:_viewInvite];
        
        _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width * 2, _svFrame.frame.size.height);
        _svFrame.pagingEnabled = YES;
        _svFrame.showsHorizontalScrollIndicator = NO;
        
    }
    _bViewInited = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OnSelectColleague:(UserDetailInfo *)colleague
{
    [self.delegate OnSelectColleague:colleague];
}

-(void)OnSelectCustomer:(Customer *)customer
{
    [self.delegate OnSelectCustomer:customer];
}

-(IBAction)OnInvite:(id)sender
{
//    [[RPSDK defaultInstance] CheckAuthActionSta:@"MU0001" Success:^(id idResult) {
//        [self.view endEditing:YES];
//        [self.delegate OnInvite];
//    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
//        
//    }];
    [self.view endEditing:YES];
    if ([RPRights hasRightsFunc:[RPSDK defaultInstance].llRights type:RPRightsFuncType_InviteUser]) {
        [self.delegate OnInvite];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
    }
}

-(IBAction)OnNewCustomer:(id)sender
{
    [self.view endEditing:YES];

    if ([RPRights hasRightsFunc:[RPSDK defaultInstance].llRights type:RPRightsFuncType_Customer]) {
        [self.delegate OnAddCustomer];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
    }
}

-(void)OnEditCustomer:(Customer *)customer
{
    [self.view endEditing:YES];
    [self.delegate OnEditCustomer:customer];
}

-(void)OnCustomerPurchase:(Customer *)customer
{
    [self.view endEditing:YES];
    [self.delegate OnCustomerPurchase:customer];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < _svFrame.frame.size.width)
    {
        _lbTitle.text = NSLocalizedStringFromTableInBundle(@"INTERNAL CONTACTS",@"RPString", g_bundleResorce,nil);
        _ivPage1.image = [UIImage imageNamed:@"icon_point_active01@2x.png"];
        _ivPage2.image = [UIImage imageNamed:@"icon_point_noactive01@2x.png"];
    }
    else
    {
        _lbTitle.text = NSLocalizedStringFromTableInBundle(@"CUSTOMER LIST",@"RPString", g_bundleResorce,nil);
        _ivPage1.image = [UIImage imageNamed:@"icon_point_noactive01@2x.png"];
        _ivPage2.image = [UIImage imageNamed:@"icon_point_active01@2x.png"];
        
        [_viewCustomer InitCustomerList];
    }
}

-(void)ShowTitleBar
{
    _ivPage1.alpha = 0;
    _ivPage2.alpha = 0;
    _lbTitle.alpha = 0;
    _lbTitle.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    _ivPage1.alpha = 1;
    _ivPage2.alpha = 1;
    _lbTitle.alpha = 1;
    [UIView commitAnimations];
}

-(void)HideTitleBar
{
//    _ivPage1.hidden = YES;
//    _ivPage2.hidden = YES;
//    _lbTitle.hidden = YES;
}

-(void)ReloadData
{
    [_viewInternal ReloadData];
    [_viewCustomer ReloadData];
}

-(void)OnCustomerlist:(UserDetailInfo *)colleague
{
    [_viewCustomer SearchRelationUser:[NSString stringWithFormat:@"%@",colleague.strFirstName]];
    [_svFrame setContentOffset:CGPointMake(_svFrame.frame.size.width, 0) animated:YES];
}
@end
