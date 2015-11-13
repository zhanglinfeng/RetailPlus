//
//  RPInviteViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-8-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPInviteViewController.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

@interface RPInviteViewController ()

@end

@implementation RPInviteViewController

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
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"INVITE NEW COLLEAGUE",@"RPString", g_bundleResorce,nil);
    
    _viewRole.frame = CGRectMake(0, self.view.frame.size.height + 44, self.view.frame.size.width, self.view.frame.size.height);
    _viewRange.frame = CGRectMake(0, self.view.frame.size.height + 44, self.view.frame.size.width, self.view.frame.size.height);
    _viewUnit.frame = CGRectMake(0, self.view.frame.size.height + 44, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:_viewRole];
    [self.view addSubview:_viewRange];
    [self.view addSubview:_viewUnit];
    
    _viewRole.delegate = self;
    _viewUnit.delegate = self;
    
    CALayer *sublayer = _btnInvite.layer;
    sublayer.shadowOffset = CGSizeMake(0, 1);
    sublayer.shadowRadius =3.0;
    sublayer.shadowColor =[UIColor blackColor].CGColor;
    sublayer.shadowOpacity =0.5;
    
    _viewPhoneFrame.layer.cornerRadius = 6;
    _viewUserNameFrame.layer.cornerRadius = 6;
    
    _btnRange.layer.cornerRadius = 6;
    _btnRole.layer.cornerRadius = 6;
    _btnUnit.layer.cornerRadius = 6;
    
    _btnRange.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnRange.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    
    _btnRole.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnRole.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    
    _btnUnit.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnUnit.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)OnRole:(id)sender
{
    [self.view endEditing:YES];
    
    [UIView beginAnimations:nil context:nil];
    _viewRole.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _viewShow = _viewRole;
}

-(IBAction)OnRange:(id)sender
{
    [self.view endEditing:YES];
    
    
    [UIView beginAnimations:nil context:nil];
    _viewRange.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _viewShow = _viewRange;
}

-(IBAction)OnUnit:(id)sender
{
    [self.view endEditing:YES];
    
    if (_roleCurrent) {
        [UIView beginAnimations:nil context:nil];
        _viewUnit.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        _viewUnit.roleCurrent = _roleCurrent;
        _viewShow = _viewUnit;
    }
}

-(BOOL)OnBack
{
    if (_viewShow) {
        [UIView beginAnimations:nil context:nil];
        _viewShow.frame = CGRectMake(0, self.view.frame.size.height + 44, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        _viewShow = nil;
        return NO;
    }
    return YES;
}

-(void)SelectRole:(InviteRole *)role
{
    [UIView beginAnimations:nil context:nil];
    _viewShow.frame = CGRectMake(0, self.view.frame.size.height + 44, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _viewShow = nil;
    
    [_btnRole setTitle:role.strRoleName forState:UIControlStateNormal];
    [_btnRole setTitleColor:[UIColor colorWithWhite:0.3f alpha:1] forState:UIControlStateNormal];
    [_btnRange setTitle:role.strDomainTypeName forState:UIControlStateNormal];
    
    _roleCurrent = role;
    _positionCurrent = nil;
    [_btnUnit setTitle:NSLocalizedStringFromTableInBundle(@"Position",@"RPString", g_bundleResorce,nil) forState:UIControlStateNormal];
    [_btnUnit setTitleColor:[UIColor colorWithWhite:0.7f alpha:1] forState:UIControlStateNormal];
}

-(void)SelectPosition:(InvitePosition *)position
{
    _positionCurrent = position;
    [_btnUnit setTitle:position.strDomainName forState:UIControlStateNormal];
    [_btnUnit setTitleColor:[UIColor colorWithWhite:0.3f alpha:1] forState:UIControlStateNormal];
    
    [UIView beginAnimations:nil context:nil];
    _viewShow.frame = CGRectMake(0, self.view.frame.size.height + 44, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _viewShow = nil;
}

-(IBAction)OnInvite:(id)sender
{
    if (_tfPhone.text.length == 0 || _roleCurrent == nil || _positionCurrent == nil) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Invite Error",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
        return;
    }
    
    NSString * str = NSLocalizedStringFromTableInBundle(@"Inviting...",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showWithStatus:str];
    
    [[RPSDK defaultInstance] InviteUser:_tfPhone.text UserName:_tfUserName.text PositionID:_positionCurrent.strPositionID Success:^(id idResult) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Invite Success",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showSuccessWithStatus:str];
        [self.delegate OnInviteEnd];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {

    }];
}
@end
