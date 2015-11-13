//
//  RPCourtesyCallViewController.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-11.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCourtesyCallViewController.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@interface RPCourtesyCallViewController ()

@end

@implementation RPCourtesyCallViewController

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
    _step=COURTESYSTEP_FIRST;
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"COURTESY CALL",@"RPString", g_bundleResorce,nil);
    _viewBackground.layer.cornerRadius=10;
    [[RPSDK defaultInstance]GetCourtesyCallTypeSuccess:^(NSArray *array) {
        _arrayCallType=array;
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
    
    NSArray *array = [g_bundleResorce loadNibNamed:@"CustomView" owner:self options:nil];
    _viewSelectUser = [array objectAtIndex:4];
    _viewSelectUser.delegate = self;
    
    _viewStoreList = [array objectAtIndex:1];
    _viewStoreList.delegate = self;
    _viewStoreList.sitType = SituationType_CourtesyCall;
    
    _viewCallRecord.delegate=self;
    _viewAddCallPlan.delegate=self;
    _viewAddCallPlan.delegateOK=self;
    _viewCourtesyCall.delegate=self;
    
    //允许摇动手势
//    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
//    [self becomeFirstResponder];
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"began");
}
-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"cancel");
}
//-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
//    NSLog(@"end");
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"检测到晃动");
    }
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self.view];
}

-(void)OnCallWithCustomer:(Customer*)customer
{
    [[RPSDK defaultInstance]GetCourtesyCallTypeSuccess:^(NSArray *array) {
        _arrayCallType=array;
        
        _viewCourtesyCall.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:_viewCourtesyCall];
        _viewCourtesyCall.delegate=self;
        [UIView beginAnimations:nil context:nil];
        _viewCourtesyCall.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        _step=COURTESYSTEP_QUICKSTART;
        _viewCourtesyCall.entrance=1;
        _viewCourtesyCall.customer=customer;
        _viewCourtesyCall.arrayType=_arrayCallType;
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}

- (IBAction)OnQuickStart:(id)sender
{
    _viewCourtesyCall.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewCourtesyCall];
    _viewCourtesyCall.delegate=self;
    _viewAddCallPlan.delegate=self;
    _viewAddCallPlan.delegateOK=self;
    [UIView beginAnimations:nil context:nil];
    _viewCourtesyCall.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _step=COURTESYSTEP_QUICKSTART;
    _viewCourtesyCall.entrance=1;
    _viewCourtesyCall.arrayType=_arrayCallType;
    
}

- (IBAction)OnCallPlan:(id)sender
{
    _viewCallPlanList.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewCallPlanList];
    _viewCallPlanList.delegate=self;
    [UIView beginAnimations:nil context:nil];
    _viewCallPlanList.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _step=COURTESYSTEP_CALLPLAN;
    _viewCallPlanList.arrayType=_arrayCallType;
}

- (IBAction)OnCallRecord:(id)sender
{
    _viewStoreList.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    _viewStoreList.tfSearch.text=@"";
//    [self.view insertSubview:_viewStoreList belowSubview:_viewBottom];
    [self.view addSubview:_viewStoreList];
    [UIView beginAnimations:nil context:nil];
    _viewStoreList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    [_viewStoreList reloadStore];
    
    _step = COURTESYSTEP_SELSTORE;
    
    
}
-(void)OnSelectedStore:(StoreDetailInfo *)store
{
    [self dismissView:_viewStoreList];
    _step=COURTESYSTEP_FIRST;
//    if ([store.strStoreId isEqualToString:_storeSelected.strStoreId]) return;
    _storeSelected = store;
    
    [self OnSelectUser:[RPSDK defaultInstance].userLoginDetail];
    
}
-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}
-(BOOL)OnBack
{
    switch (_step)
    {
        case COURTESYSTEP_QUICKSTART:
        {
            if ([_viewCourtesyCall OnBack])
            {
                [self dismissView:_viewCourtesyCall];
                _step=COURTESYSTEP_FIRST;
            }
        }
            break;
        case COURTESYSTEP_CALLPLAN:
        {
            if ([_viewCallPlanList OnBack])
            {
                [self dismissView:_viewCallPlanList];
                _step=COURTESYSTEP_FIRST;
            }
        }
            break;
        case COURTESYSTEP_CALLRECORD:
        {
            if ([_viewRecord OnBack]) {
                [self dismissView:_viewRecord];
                _step=COURTESYSTEP_FIRST;
            }
        }
            break;
        case COURTESYSTEP_SELUSER:
        {
            [self dismissView:_viewSelectUser];
            _step = COURTESYSTEP_FIRST;
        }
            break;
        case COURTESYSTEP_SELSTORE:
        {
            [self dismissView:_viewStoreList];
            _step = COURTESYSTEP_FIRST;
        }
            break;
        default:return YES;
            break;
    }
    return NO;
}

-(void)endCourtesyCall
{
    [self dismissView:_viewCourtesyCall];
    _step = COURTESYSTEP_FIRST;
    [self.delegate OnTaskEnd];
}

-(void)endCallRecord
{
    [self dismissView:_viewCourtesyCall];
    _step = COURTESYSTEP_FIRST;
    [self.delegate OnTaskEnd];
}

-(void)endCallPlan
{
    [self dismissView:_viewCallPlanList];
    _step = COURTESYSTEP_FIRST;
    [self.delegate OnTaskEnd];
    
}

-(void)endAddCallPlan
{
    _step = COURTESYSTEP_FIRST;
    [self.delegate OnTaskEnd];
}

-(void)endCallRecordList
{
    _step = COURTESYSTEP_FIRST;
    [self.delegate OnTaskEnd];
}

-(void)backToStart
{
    [self dismissView:_viewCourtesyCall];
    _step = COURTESYSTEP_FIRST;
}

-(void)completeRecord
{
    [self dismissView:_viewCourtesyCall];
    _step = COURTESYSTEP_FIRST;
}

-(void)OnSelectUser:(UserDetailInfo *)user
{
    [self dismissView:_viewSelectUser];
    
    _viewRecord.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewRecord];
    //_viewRecord.delegate=self;
    [UIView beginAnimations:nil context:nil];
    _viewRecord.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _viewRecord.entrance=4;//3代表从自己记录进入，4代表从别人记录进入该界面
    _viewRecord.storeSelected=_storeSelected;
    _viewRecord.delegate=self;
    _viewRecord.arrayType=_arrayCallType;
    _viewRecord.user = user;
    _step=COURTESYSTEP_CALLRECORD;
    [_viewRecord ReloadData];
}
-(void)endAddCallPlanOK
{
    
}
@end
