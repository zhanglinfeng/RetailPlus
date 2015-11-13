//
//  RPLogBookViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-3-3.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//
#import "SVProgressHUD.h"
#import "RPLogBookViewController.h"

extern NSBundle * g_bundleResorce;

@interface RPLogBookViewController ()

@end

@implementation RPLogBookViewController

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
    
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"DAILY LOG",@"RPString", g_bundleResorce,nil);
    
    _step = LOGBOOKSTEP_STOREDETAIL;
    
    NSArray *array = [g_bundleResorce loadNibNamed:@"CustomView" owner:self options:nil];
    _viewStoreList = [array objectAtIndex:1];
    _viewStoreList.delegate = self;
    _viewStoreList.sitType = SituationType_LogBook;
    array = [g_bundleResorce loadNibNamed:@"RPStoreCardView" owner:self options:nil];
    _viewStoreCard = [array objectAtIndex:0];
    CGSize szScreen = [[UIScreen mainScreen] bounds].size;
    _viewStoreCard.frame = CGRectMake(8, 15, 304, szScreen.height - 125);
    _viewStoreCard.delegate = self;
    [self.view insertSubview:_viewStoreCard belowSubview:_viewBottom];
    [_viewStoreCard Hide:YES];
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
    
    _step = LOGBOOKSTEP_SELECTSHOP;
}

-(void)OnSelectedStore:(StoreDetailInfo *)store
{
    [self dismissView:_viewStoreList];
    _step = LOGBOOKSTEP_STOREDETAIL;
    
    if ([store.strStoreId isEqualToString:_storeSelected.strStoreId]) return;
    
    _storeSelected = store;
    _viewStoreCard.store = _storeSelected;
}

-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}

-(IBAction)OnLogBookDetail:(id)sender
{
    if (_storeSelected == nil) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No Store Selected",@"RPString", g_bundleResorce,nil)];
        return;
    }
    if (_storeSelected == nil) return;
    
    _viewDetail.storeSelected = _storeSelected;
    _viewDetail.vcFrame=_vcFrame;
    _viewDetail.delegate=self;
    _viewDetail.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:_viewDetail];
    
    [UIView beginAnimations:nil context:nil];
    _viewDetail.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    _step = LOGBOOKSTEP_DETAIL;
}

-(BOOL)OnBack
{
    [SVProgressHUD dismiss];
    if (_bConfirmQuit) {
        return YES;
    }
    
    switch (_step)
    {
        case LOGBOOKSTEP_SELECTSHOP:
            [_viewStoreList dismiss];
            [self dismissView:_viewStoreList];
            _step = LOGBOOKSTEP_STOREDETAIL;
            break;
        case LOGBOOKSTEP_DETAIL:
            if ([_viewDetail OnBack]) {
                [self dismissView:_viewDetail];
                _step = LOGBOOKSTEP_STOREDETAIL;
            }
            break;
        default:
            return YES;
            break;
    };
    return NO;
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self.view];
}


-(void)OnLogBookEnd
{
    [self dismissView:_viewDetail];
    _step = _step = LOGBOOKSTEP_STOREDETAIL;
    _bConfirmQuit = YES;
    [self.delegate OnTaskEnd];
}

-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    [self OnSelectedStore:storeSelected];
}
@end
