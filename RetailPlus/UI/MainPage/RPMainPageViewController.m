//
//  RPMainPageViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-9-22.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPMainPageViewController.h"
#import "RPOwnedModel.h"

@interface RPMainPageViewController ()

@end

extern NSBundle * g_bundleResorce;

@implementation RPMainPageViewController

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
    
    _viewframe.layer.cornerRadius = 8;
    _viewframe.layer.shadowOffset = CGSizeMake(0, 1);
    _viewframe.layer.shadowRadius =3.0;
    _viewframe.layer.shadowColor =[UIColor blackColor].CGColor;
    _viewframe.layer.shadowOpacity =0.5;
    
    _viewframe2.layer.cornerRadius = 8;
    _viewframe2.layer.shadowOffset = CGSizeMake(0, 1);
    _viewframe2.layer.shadowRadius =3.0;
    _viewframe2.layer.shadowColor =[UIColor blackColor].CGColor;
    _viewframe2.layer.shadowOpacity =0.5;
    
//    _viewframe3.layer.cornerRadius = 8;
//    _viewframe3.layer.shadowOffset = CGSizeMake(0, 1);
//    _viewframe3.layer.shadowRadius =3.0;
//    _viewframe3.layer.shadowColor =[UIColor blackColor].CGColor;
//    _viewframe3.layer.shadowOpacity =0.5;
//    
//    _svFrame.contentSize = CGSizeMake(320, 10);
//    
//    
//    CGSize sz = [[UIScreen mainScreen] bounds].size;
//    if (sz.height != 568) {
//        _ivFrame3.image = [UIImage imageNamed:@"bg_duculive_35.png"];
//        _ivFrame3.frame = CGRectMake(_ivFrame3.frame.origin.x, _ivFrame3.frame.origin.y, _ivFrame3.frame.size.width, 448);
//    }
    
//    _viewDoc.frame = CGRectMake(0, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
//    _viewDoc.viewController = _vcFrame;
//    _viewDoc.delegate = self.delegate;
//    _viewDoc.delegateStore = self.delegateStore;
//    [_svFrame addSubview:_viewDoc];
    
    _bViewDateSetting=NO;
    _viewDateSetting.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    _viewDateSetting.delegate = self;
    [self.view addSubview:_viewDateSetting];
    _viewTrend.trendDelegate=self;
    _viewColumn.columnDelegate=self;
    
    NSArray *array = [g_bundleResorce loadNibNamed:@"CustomView" owner:self options:nil];
    _viewStoreList = [array objectAtIndex:1];
    _viewStoreList.delegate = self;
    _viewStoreList.sitType = SituationType_NotAssign;
    _viewStoreList.bCanSelDomain = YES;
}


-(void)viewDidAppear:(BOOL)animated
{
///////////////////显示info live////////////////////////////
    _viewInfo.frame=CGRectMake(0, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
    [_svFrame addSubview:_viewInfo];
    _viewTrend.viewController=_vcFrame;
    _viewColumn.viewController=_vcFrame;
    if ([RPRights hasRightsFunc:[RPSDK defaultInstance].llRights type:RPRightsFuncType_InfoLive] && [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_KPI])
    {
        _viewTask.frame = CGRectMake( _svFrame.frame.size.width, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
        _viewDoc.frame = CGRectMake( 2*_svFrame.frame.size.width, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
        _viewInfo.hidden = NO;
        _ivPage1.hidden = NO;
        _ivPage2.hidden = NO;
        _ivPage3.hidden = NO;
        
        _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width*3, _svFrame.frame.size.height);
        
        if (_svFrame.contentOffset.x < _svFrame.frame.size.width)
            _ivShakeTip.hidden = NO;
        else
            _ivShakeTip.hidden = YES;
    }
    else
    {
        _viewTask.frame = CGRectMake(0, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
        _viewDoc.frame = CGRectMake(_svFrame.frame.size.width, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
        
        _viewInfo.hidden = YES;
        _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width * 2, _svFrame.frame.size.height);
        _ivPage1.hidden = YES;
        //_ivPage2.hidden = YES;
        //_ivPage3.hidden = YES;
        _ivShakeTip.hidden = YES;
        
        _lbTitle.text = NSLocalizedStringFromTableInBundle(@"TASK LIVE",@"RPString", g_bundleResorce,nil);
        //_ivPage2.image = [UIImage imageNamed:@"icon_point_active01@2x.png"];
        [self scrollViewDidScroll:_svFrame];
    }
    
    _viewDoc.viewController = _vcFrame;
    _viewDoc.delegate = self.delegate;
    _viewDoc.delegateStore = self.delegateStore;
    _viewDoc.delegateCtrl = self;
    [_svFrame addSubview:_viewDoc];
    
    
    _viewTask.delegate = self;
    [_svFrame addSubview:_viewTask];
/////////////////////////////////////////////////
    
    
    
////////////////////////////////隐藏info life//////////////////
//    _viewDoc.frame = CGRectMake(0, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
//    _viewDoc.viewController = _vcFrame;
//    _viewDoc.delegate = self.delegate;
//    _viewDoc.delegateStore = self.delegateStore;
//    [_svFrame addSubview:_viewDoc];
//    _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width, _svFrame.frame.size.height);
//    ////////////////////////////////////////////////
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)OnChangeChart:(id)sender
{
    static NSInteger bFirst = YES;
    if (bFirst)
        _ivChart.image = [UIImage imageNamed:@"bg_curve_pic.png"];
    else
        _ivChart.image = [UIImage imageNamed:@"bg_column_pic.png"];
    bFirst = !bFirst;
}

//- (IBAction)OnSettingDate:(id)sender {
//    [self.mainPageDelegate showSettingDateViewController];
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
    if ([RPRights hasRightsFunc:[RPSDK defaultInstance].llRights type:RPRightsFuncType_InfoLive] && [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_KPI])
    {
        if (scrollView.contentOffset.x < _svFrame.frame.size.width)
        {
            _lbTitle.text = NSLocalizedStringFromTableInBundle(@"KPI LIVE",@"RPString", g_bundleResorce,nil);
            _ivPage1.image = [UIImage imageNamed:@"icon_point_active01@2x.png"];
            _ivPage2.image = [UIImage imageNamed:@"icon_point_noactive01@2x.png"];
            _ivPage3.image = [UIImage imageNamed:@"icon_point_noactive01@2x.png"];
            _ivShakeTip.hidden = NO;
        }
        else if (scrollView.contentOffset.x < (2 * _svFrame.frame.size.width))
        {
            _lbTitle.text = NSLocalizedStringFromTableInBundle(@"TASK LIVE",@"RPString", g_bundleResorce,nil);
            _ivPage1.image = [UIImage imageNamed:@"icon_point_noactive01@2x.png"];
            _ivPage2.image = [UIImage imageNamed:@"icon_point_active01@2x.png"];
            _ivPage3.image = [UIImage imageNamed:@"icon_point_noactive01@2x.png"];
            _ivShakeTip.hidden = YES;
        }else if (scrollView.contentOffset.x < (3 * _svFrame.frame.size.width))
        {
            _lbTitle.text = NSLocalizedStringFromTableInBundle(@"DOCUMENT LIVE",@"RPString", g_bundleResorce,nil);
            _ivPage1.image = [UIImage imageNamed:@"icon_point_noactive01@2x.png"];
            _ivPage2.image = [UIImage imageNamed:@"icon_point_noactive01@2x.png"];
            _ivPage3.image = [UIImage imageNamed:@"icon_point_active01@2x.png"];
            _ivShakeTip.hidden = YES;
            [_viewDoc OnShowDocView];
        }
        else
        {
            _lbTitle.text = NSLocalizedStringFromTableInBundle(@"KPI LIVE",@"RPString", g_bundleResorce,nil);
            _ivPage1.image = [UIImage imageNamed:@"icon_point_noactive01@2x.png"];
            _ivPage2.image = [UIImage imageNamed:@"icon_point_noactive01@2x.png"];
            _ivPage3.image = [UIImage imageNamed:@"icon_point_active01@2x.png"];
            _ivShakeTip.hidden = NO;
        }
    }
    else
    {
        if (scrollView.contentOffset.x < _svFrame.frame.size.width)
        {
            _lbTitle.text = NSLocalizedStringFromTableInBundle(@"TASK LIVE",@"RPString", g_bundleResorce,nil);
            _ivPage1.image = [UIImage imageNamed:@"icon_point_noactive01@2x.png"];
            _ivPage2.image = [UIImage imageNamed:@"icon_point_active01@2x.png"];
            _ivPage3.image = [UIImage imageNamed:@"icon_point_noactive01@2x.png"];
            _ivShakeTip.hidden = YES;
        }
        else if (scrollView.contentOffset.x < (2 * _svFrame.frame.size.width))
        {
            _lbTitle.text = NSLocalizedStringFromTableInBundle(@"DOCUMENT LIVE",@"RPString", g_bundleResorce,nil);
            _ivPage1.image = [UIImage imageNamed:@"icon_point_noactive01@2x.png"];
            _ivPage2.image = [UIImage imageNamed:@"icon_point_noactive01@2x.png"];
            _ivPage3.image = [UIImage imageNamed:@"icon_point_active01@2x.png"];
            _ivShakeTip.hidden = YES;
            [_viewDoc OnShowDocView];
        }
    }
}
-(void)ShowTitleBar
{
    _ivPage1.alpha = 0;
    _ivPage2.alpha = 0;
    _ivPage3.alpha = 0;
    _lbTitle.alpha = 0;
    _lbTitle.hidden = NO;
    
    if ([RPRights hasRightsFunc:[RPSDK defaultInstance].llRights type:RPRightsFuncType_InfoLive] && [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_KPI])
    {
        _ivPage1.hidden = NO;
        _ivPage2.hidden = NO;
        _ivPage3.hidden = NO;
    }
    else
    {
        _ivPage1.hidden = YES;
        _ivPage2.hidden = NO;
        _ivPage3.hidden = NO;
    }
    
    [UIView beginAnimations:nil context:nil];
    _ivPage1.alpha = 1;
    _ivPage2.alpha = 1;
    _ivPage3.alpha = 1;
    _lbTitle.alpha = 1;
    [UIView commitAnimations];
    
//////////隐藏info life//////////////////
//    _ivPage1.hidden = YES;
//    _ivPage2.hidden = YES;
// ///////////////////////////////////
}

-(void)HideTitleBar
{
    _ivPage1.hidden = YES;
    _ivPage2.hidden = YES;
    _lbTitle.hidden = YES;
}

-(void)Reload
{
    [_viewDoc Reload];
}

-(void)addSubView
{
    _viewDateSetting.range=_viewInfo.dateRange;
    _viewDateSetting.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    _viewDateSetting.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _bViewDateSetting=YES;
    self.strTaskName=NSLocalizedStringFromTableInBundle(@"DATE\nSETTING",@"RPString", g_bundleResorce,nil);
    [self.delegateTask OnSystemTaskViewChanged];
    
}
-(void)addDateSettingView
{
    _viewDateSetting.range=_viewInfo.dateRange;
    _viewDateSetting.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    _viewDateSetting.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _bViewDateSetting=YES;
    self.strTaskName=NSLocalizedStringFromTableInBundle(@"DATE\nSETTING",@"RPString", g_bundleResorce,nil);
    [self.delegateTask OnSystemTaskViewChanged];
}

-(void)DoDomainSelect
{
    _viewStoreList.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height + 44);
    _viewStoreList.tfSearch.text=@"";
    [self.view addSubview:_viewStoreList];

    [UIView beginAnimations:nil context:nil];
    _viewStoreList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 44);
    [UIView commitAnimations];

    if (!_viewDoc.filtDomain && !_viewDoc.filtStore)
        [_viewStoreList ReloadData];
    else
        [_viewStoreList reloadStore];
    
    _bViewDomainSelect = YES;
    self.strTaskName=NSLocalizedStringFromTableInBundle(@"SPECIFY\nRANGE",@"RPString", g_bundleResorce,nil);
    [self.delegateTask OnSystemTaskViewChanged];

}

-(BOOL)OnBack
{
    if (_bViewDateSetting) {
        [_viewDateSetting OnBack];
        
        _viewInfo.dateRange=_viewDateSetting.range;
        [UIView beginAnimations:nil context:nil];
        _viewDateSetting.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        _bViewDateSetting=YES;
        self.strTaskName=nil;
        [self.delegateTask OnSystemTaskViewChanged];
        
        _bViewDateSetting=NO;
    }
    
    if (_bViewDomainSelect) {
        [self DismissDomainSelect];
    }
    return YES;
}

-(BOOL)isLastView
{
    if (_bViewDateSetting)
        return NO;
    if (_bViewDomainSelect)
        return NO;
    
    return YES;
}

-(void)OnSettingDateEnd
{
    _viewInfo.dateRange=_viewDateSetting.range;
    [UIView beginAnimations:nil context:nil];
    _viewDateSetting.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _bViewDateSetting=YES;
    self.strTaskName=nil;
    _bViewDateSetting=NO;
    
    [self.delegateTask OnSystemTaskViewChanged];
}

-(NSInteger)GetPageIndex
{
    if (_svFrame.contentOffset.x == 0)
    {
        if ([RPRights hasRightsFunc:[RPSDK defaultInstance].llRights type:RPRightsFuncType_InfoLive] && [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_KPI])
            return 0;
        return 1;
    }
    return 1;
}

-(void)OnSelectTask:(TaskInfo *)info
{
    [self.delegateMain OnSelectTask:info];
}

-(void)OnSelectDomain:(DomainInfo *)domain
{
    [_viewDoc OnSelectDomain:domain];
    [self DismissDomainSelect];
}

-(void)OnSelectedStore:(StoreDetailInfo *)store
{
    [_viewDoc OnSelectedStore:store];
    [self DismissDomainSelect];
}

-(void)DismissDomainSelect
{
    [UIView beginAnimations:nil context:nil];
    _viewStoreList.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _bViewDomainSelect = NO;
    self.strTaskName = nil;
    [self.delegateTask OnSystemTaskViewChanged];
}

-(void)UpdateTask
{
    [_viewTask OnUpdateTask];
}
@end
