//
//  RPKpiDataEntryViewController.m
//  RetailPlus
//
//  Created by zwhe on 14-1-13.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPKpiDataEntryViewController.h"
#import "SVProgressHUD.h"
extern NSBundle *g_bundleResorce;
@interface RPKpiDataEntryViewController ()

@end

@implementation RPKpiDataEntryViewController

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
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"KPI MANAGEMENT",@"RPString", g_bundleResorce,nil);
    
    NSArray *arrayList = [g_bundleResorce loadNibNamed:@"CustomView" owner:self options:nil];
    _viewStoreList = [arrayList objectAtIndex:1];
    _viewStoreList.delegate = self;
    _viewStoreList.sitType = SituationType_KPIInput;
    
    NSArray* array = [g_bundleResorce loadNibNamed:@"RPStoreCardView" owner:self options:nil];
    _viewStoreCard = [array objectAtIndex:0];
    CGSize szScreen = [[UIScreen mainScreen] bounds].size;
    _viewStoreCard.frame = CGRectMake(8, 15, 304, szScreen.height - 125);
    _viewStoreCard.delegate = self;
    [self.view insertSubview:_viewStoreCard belowSubview:_ivBottom];
    [_viewStoreCard Hide:YES];
    _bViewSales=NO;
    _bViewTraffic=NO;
    
}
-(BOOL)OnBack
{
    if (_bStore)
    {
        [UIView beginAnimations:nil context:nil];
        _viewStoreList.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        _bStore = NO;
        return NO;
    }
    if (_bViewSales)
    {
        if ([_viewSalesData OnBack])
        {
            [UIView beginAnimations:nil context:nil];
            _viewSalesData.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
//            [_viewSalesData removeFromSuperview];
            _bViewSales=NO;
            
        }
        return NO;
    }
    if (_bViewTraffic)
    {
        if ([_viewTrafficData OnBack])
        {
            [UIView beginAnimations:nil context:nil];
            _viewTrafficData.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            _bViewTraffic=NO;
        }
        return NO;
    }
    return YES;
    
}
-(void)OnSelectStore
{
    _bStore=YES;
    _viewStoreList.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    _viewStoreList.tfSearch.text=@"";
    [self.view insertSubview:_viewStoreList belowSubview:_ivBottom];
    
    [UIView beginAnimations:nil context:nil];
    _viewStoreList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    [_viewStoreList reloadStore];
    
  

}
-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}

-(void)OnSelectedStore:(StoreDetailInfo *)store
{
    [self dismissView:_viewStoreList];
    _storeSelected = store;
    _viewStoreCard.store = _storeSelected;
    _bStore = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnSalesData:(id)sender {
    if(_storeSelected==nil)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"First select a store",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
    }
    else
    {
        if ([RPRights hasRightsFunc:_storeSelected.llRights type:RPRightsFuncType_InputKPISales])
        {
            _bViewSales=YES;
            
            _viewSalesData.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:_viewSalesData];
            _viewSalesData.vcFrame=self;
            _viewSalesData.delegate=self;
            _viewSalesData.storeSelected=_storeSelected;
            [UIView beginAnimations:nil context:nil];
            _viewSalesData.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
        }
    }
}

- (IBAction)OnTrafficData:(id)sender {
    if(_storeSelected==nil)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"First select a store",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
    }
    else
    {
        if ([RPRights hasRightsFunc:_storeSelected.llRights type:RPRightsFuncType_InputKPITraffic])
        {
            _bViewTraffic=YES;
            _viewTrafficData.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:_viewTrafficData];
            _viewTrafficData.vcFrame=self;
            _viewTrafficData.delegate=self;
            _viewTrafficData.storeSelected=_storeSelected;
            [UIView beginAnimations:nil context:nil];
            _viewTrafficData.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
        }
    }
}

-(void)OnKPIDataEntryEnd
{
    [self.delegate OnTaskEnd];
}
-(void)OnKPITrafficDataEntryEnd
{
    [self.delegate OnTaskEnd];
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self.view];
}

-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    [self OnSelectedStore:storeSelected];
}
@end
