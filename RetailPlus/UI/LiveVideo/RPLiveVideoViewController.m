//
//  RPLiveVideoViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-4-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPLiveVideoViewController.h"
#import "SVProgressHUD.h"

#import "RPELWebCache.h"

extern NSBundle * g_bundleResorce;

@interface RPLiveVideoViewController ()

@end

@implementation RPLiveVideoViewController

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
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"LIVE VIDEO",@"RPString", g_bundleResorce,nil);
    
    NSArray *array = [g_bundleResorce loadNibNamed:@"CustomView" owner:self options:nil];
    _viewStoreList = [array objectAtIndex:1];
    _viewStoreList.delegate = self;
    _viewStoreList.sitType = SituationType_LiveVideo;
    
    array = [g_bundleResorce loadNibNamed:@"RPStoreCardView" owner:self options:nil];
    _viewStoreCard = [array objectAtIndex:0];
    CGSize szScreen = [[UIScreen mainScreen] bounds].size;
    _viewStoreCard.frame = CGRectMake(8, 15, 304, szScreen.height - 125);
    _viewStoreCard.delegate = self;
    [self.view insertSubview:_viewStoreCard belowSubview:_viewBottom];
    [_viewStoreCard Hide:YES];
    
    _viewDetail.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OnSelectStore
{
    _viewStoreList.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    _viewStoreList.tfSearch.text=@"";
    [self.view insertSubview:_viewStoreList belowSubview:_viewBottom];
    
    [UIView beginAnimations:nil context:nil];
    _viewStoreList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    [_viewStoreList reloadStore];
    
    _step = LIVEVIDEOSTEP_SELECTSHOP;
}

-(void)OnSelectedStore:(StoreDetailInfo *)store
{
    [self dismissView:_viewStoreList];
    _step = LIVEVIDEOSTEP_STOREDETAIL;
    
    if ([store.strStoreId isEqualToString:_storeSelected.strStoreId]) return;
    
    _storeSelected = store;
    _viewStoreCard.store = _storeSelected;
}

-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _storeSelected = storeSelected;
    _viewStoreCard.store = _storeSelected;
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
    [SVProgressHUD dismiss];
    if (_bConfirmQuit) {
        return YES;
    }
    
    switch (_step)
    {
        case LIVEVIDEOSTEP_SELECTSHOP:
            [_viewStoreList dismiss];
            [self dismissView:_viewStoreList];
            _step = LIVEVIDEOSTEP_STOREDETAIL;
            break;
        case LIVEVIDEOSTEP_DETAIL:
            if ([_viewDetail OnBack]) {
                [self dismissView:_viewDetail];
                _step = LIVEVIDEOSTEP_STOREDETAIL;
            }
            break;
        default:
            return YES;
            break;
    };
    return NO;
}

-(IBAction)OnLogBookDetail:(id)sender
{
    if (_storeSelected == nil) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No Store Selected",@"RPString", g_bundleResorce,nil)];
        return;
    }
    if (_storeSelected == nil) return;
    
    
//    _viewDetail.vcFrame=_vcFrame;
//    _viewDetail.delegate=self;
    _viewDetail.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:_viewDetail];
    _viewDetail.storeSelected = _storeSelected;
    
    [UIView beginAnimations:nil context:nil];
    _viewDetail.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    _step = LIVEVIDEOSTEP_DETAIL;
}

-(void)OnLiveVideoEnd
{
    [self dismissView:_viewDetail];
    _step = LIVEVIDEOSTEP_STOREDETAIL;
    _bConfirmQuit = YES;
    [self.delegate OnTaskEnd];
}
@end
