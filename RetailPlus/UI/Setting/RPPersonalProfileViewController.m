//
//  RPPersonalProfileViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-10-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPPersonalProfileViewController.h"
#import "RPPersonalProfileView.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface RPPersonalProfileViewController ()

@end

@implementation RPPersonalProfileViewController

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
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"USER PROFILE",@"RPString", g_bundleResorce,nil);
    
    _viewFrame.layer.cornerRadius = 8;
    _lbTab1.backgroundColor = [UIColor clearColor];
    _lbTab2.backgroundColor = [UIColor darkGrayColor];
    
    [_viewContainer addSubview:_viewCareer];
    [_viewContainer addSubview:_viewPersonalProfile];
    _viewCareer.hidden = YES;
    [_viewContainer setContentSize:CGSizeMake(_viewContainer.frame.size.width, _viewPersonalProfile.frame.size.height)];
    _viewCareer.delegate = self.delegate;
    _viewPersonalProfile.loginProfile = self.loginProfile;
    _viewPersonalProfile.delegate = self.delegate;
    
    _viewCareer.loginProfile = self.loginProfile;
    _viewPersonalProfile.vcFrame = self.vcFrame;
    
//    UITapGestureRecognizer *singleTapGR =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(tapAnywhereToDismissKeyboard:)];
//    [self.view addGestureRecognizer:singleTapGR];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)OnTab1:(id)sender
{
    _lbTab1.backgroundColor = [UIColor clearColor];
    _lbTab2.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    _lbTab1.textColor= [UIColor colorWithWhite:0.3 alpha:1];
    _lbTab2.textColor= [UIColor colorWithWhite:0.2 alpha:1];

    _viewCareer.hidden = YES;
    _viewPersonalProfile.hidden = NO;
    
    [_viewContainer setContentSize:CGSizeMake(_viewContainer.frame.size.width, _viewPersonalProfile.frame.size.height)];
}

-(IBAction)OnTab2:(id)sender
{
    _lbTab2.backgroundColor = [UIColor clearColor];
    _lbTab1.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    _lbTab1.textColor= [UIColor colorWithWhite:0.2 alpha:1];
    _lbTab2.textColor= [UIColor colorWithWhite:0.3 alpha:1];
    
    _viewCareer.hidden = NO;
    _viewPersonalProfile.hidden = YES;
    [_viewContainer setContentSize:CGSizeMake(_viewContainer.frame.size.width, _viewCareer.frame.size.height)];
}

- (IBAction)OnOK:(id)sender {
//    [self.personalProfileDelegate saveOK];
    [_viewPersonalProfile saveOK];
}

-(IBAction)OnSelectReporter:(id)sender
{
    _vcAddReceiver = [[RPAddReceiverViewController alloc] initWithNibName:NSStringFromClass([RPAddReceiverViewController class]) bundle:g_bundleResorce];
    _vcAddReceiver.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    _vcAddReceiver.delegate = self;
    _vcAddReceiver.bSingleSelect = YES;
    
    _vcAddReceiver.arraySelected = [[NSMutableArray alloc] init];
    UserDetailInfo * colleague = [[UserDetailInfo alloc] init];
    colleague.strUserId = _loginProfile.strReportToUserId;
    colleague.strFirstName = _loginProfile.strReportTo;
    [_vcAddReceiver.arraySelected addObject:colleague];
    
    _vcAddReceiver.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_vcAddReceiver.view];
    
    [UIView beginAnimations:nil context:nil];
    _vcAddReceiver.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    [_vcAddReceiver UpdateUI];
    
    _bShowSelectReporter = YES;
}

-(IBAction)OnPosMng:(id)sender
{
    _viewPosMng.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewPosMng];
    
    _viewPosMng.loginProfile = _loginProfile;
    
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"POSITION MANAGEMENT",@"RPString", g_bundleResorce,nil);
    [self.delegateMain OnReloadTitle];
    [UIView beginAnimations:nil context:nil];
    _viewPosMng.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    _bShowPosMng = YES;
    _bMngPosition = YES;
}

-(void)AddColleague:(NSMutableArray *)arrayColleague
{
    if (arrayColleague.count == 1) {
        UserDetailInfo * info = [arrayColleague objectAtIndex:0];
        
        [SVProgressHUD showWithStatus:@""];
        [[RPSDK defaultInstance] SetUserReportTo:_loginProfile.strUserId ReportTo:info.strUserId Success:^(id idResult) {
            [UIView beginAnimations:nil context:nil];
            _vcAddReceiver.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            _bShowSelectReporter = NO;
            
            _loginProfile.strReportToUserId = info.strUserId;
            _loginProfile.strReportTo = info.strFirstName;
            [_viewCareer setReporter:_loginProfile];
            
            [SVProgressHUD dismiss];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
}

-(BOOL)OnBack
{
    if (_bShowSelectReporter) {
        [UIView beginAnimations:nil context:nil];
        _vcAddReceiver.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        _bShowSelectReporter = NO;
        return NO;
    }
    
    if (_bShowPosMng) {
        if ([_viewPosMng OnBack])
        {
            [UIView beginAnimations:nil context:nil];
            _viewPosMng.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            [_viewCareer setPositionInfo:_loginProfile];
            
            self.strTaskName = NSLocalizedStringFromTableInBundle(@"USER PROFILE",@"RPString", g_bundleResorce,nil);
            [self.delegateMain OnReloadTitle];
            _bShowPosMng = NO;
        }
        return NO;
    }
    
    BOOL bRet = [_viewPersonalProfile OnBack];
    if (bRet) {
        if (_bMngPosition) {
            [self.delegate OnChangeProfileEnd];
        }
    }
    return bRet;
}
@end
