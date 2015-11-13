//
//  RPHorizontalScreenViewController.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-13.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPHorizontalScreenViewController.h"
extern NSBundle * g_bundleResorce;
@interface RPHorizontalScreenViewController ()

@end

@implementation RPHorizontalScreenViewController

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
//    NSString * strUrl = [NSString stringWithFormat:@"%@&w=%d&h=%d",_strUrl,(NSInteger)_webView.frame.size.width * 2,(NSInteger)_webView.frame.size.height * 2];
//    
//    NSURL *url=[[NSURL alloc]initWithString:strUrl];
//    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
//    [_webView loadRequest:request];
//    NSString * str = NSLocalizedStringFromTableInBundle(@"Back",@"RPString", g_bundleResorce,nil);
//    [_btBack setTitle:str forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
    CGAffineTransform at = CGAffineTransformMakeRotation(M_PI/2);
    [self.view setTransform:at];
    
    CGRect rcScreen = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, 0,rcScreen.size.width , rcScreen.size.height);
}

-(void)viewDidAppear:(BOOL)animated
{
    
//    CGAffineTransform at = CGAffineTransformMakeRotation(M_PI/2);
//    [self.view setTransform:at];
    CGRect rcScreen = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, 0,rcScreen.size.width , rcScreen.size.height);
    _viewRightBar.layer.shadowOffset = CGSizeMake(-3, 0);
//    _viewRightBar.layer.shadowRadius =3.0;
    _viewRightBar.layer.shadowColor =[UIColor blackColor].CGColor;
    _viewRightBar.layer.shadowOpacity =0.5;
//    NSString * strUrl = [NSString stringWithFormat:@"%@&w=%d&h=%d",_strUrl,(NSInteger)_webView.frame.size.width * 2,(NSInteger)_webView.frame.size.height * 2];
//    
//    NSURL *url=[[NSURL alloc]initWithString:strUrl];
//    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
//    [_webView loadRequest:request];
    
//    NSString * str = NSLocalizedStringFromTableInBundle(@"Back",@"RPString", g_bundleResorce,nil);
//    _webView.scalesPageToFit = YES;
//    [_btBack setTitle:str forState:UIControlStateNormal];
//    _lbChart.text=NSLocalizedStringFromTableInBundle(@"Tendency Chart",@"RPString", g_bundleResorce,nil);
    _lbRefresh.text=NSLocalizedStringFromTableInBundle(@"Refresh",@"RPString", g_bundleResorce,nil);
    _lbZoomOut.text=NSLocalizedStringFromTableInBundle(@"Zoom Out",@"RPString", g_bundleResorce,nil);
    [UIApplication sharedApplication].statusBarHidden=YES;
    _viewCompare.frame=CGRectMake(0, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
    [_svFrame addSubview:_viewCompare];
    _viewTendency.frame=CGRectMake(_svFrame.frame.size.width, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
    [_svFrame addSubview:_viewTendency];
    _svFrame.contentSize=CGSizeMake(_svFrame.frame.size.width, _svFrame.frame.size.height);
    _svFrame.pagingEnabled=YES;
    //不显示水平滑动条
    _svFrame.showsVerticalScrollIndicator=NO;
    
    [self ReloadWebView];
    
}
-(void)ReloadWebView
{
    [_svFrame setContentOffset:CGPointMake(_svFrame.frame.size.width*_tag, 0)];
    if (_tag==1) {
        _btChart.selected=YES;
        _lbChart.text=NSLocalizedStringFromTableInBundle(@"Compare Chart",@"RPString", g_bundleResorce,nil);
    }
    else
    {
        
        
        _btChart.selected=NO;
        _lbChart.text=NSLocalizedStringFromTableInBundle(@"Tendency Chart",@"RPString", g_bundleResorce,nil);
    }
    NSString *Traffic=NSLocalizedStringFromTableInBundle(@"Traffic",@"RPString", g_bundleResorce,nil);
    NSString *Conversion=NSLocalizedStringFromTableInBundle(@"Conversion Rate",@"RPString", g_bundleResorce,nil);
    NSString * TraQty= NSLocalizedStringFromTableInBundle(@"TraQty",@"RPString", g_bundleResorce,nil);
    NSString *ProQty=NSLocalizedStringFromTableInBundle(@"ProQty",@"RPString", g_bundleResorce,nil);
    NSString *Amount=NSLocalizedStringFromTableInBundle(@"Amount",@"RPString", g_bundleResorce,nil);
    
    NSInteger nOt1 = 0;
    NSInteger nOt2 = 0;
    if ([_strLeft isEqualToString:Traffic])
        nOt1 = 0;
    if ([_strLeft isEqualToString:Conversion])
        nOt1 = 4;
    if ([_strLeft isEqualToString:TraQty])
        nOt1 = 1;
    if ([_strLeft isEqualToString:ProQty])
        nOt1 = 2;
    if ([_strLeft isEqualToString:Amount])
        nOt1 = 3;
    
    if ([_strRight isEqualToString:Traffic])
        nOt2 = 0;
    if ([_strRight isEqualToString:Conversion])
        nOt2 = 4;
    if ([_strRight isEqualToString:TraQty])
        nOt2 = 1;
    if ([_strRight isEqualToString:ProQty])
        nOt2 = 2;
    if ([_strRight isEqualToString:Amount])
        nOt2 = 3;

//    _viewCompare.lbLeft.adjustsFontSizeToFitWidth = YES;
//    _viewCompare.lbRight.adjustsFontSizeToFitWidth = YES;
//    _viewCompare.lbStoreName.adjustsFontSizeToFitWidth = YES;
//    _viewCompare.lbStoreName2.adjustsFontSizeToFitWidth = YES;
//    _viewTendency.lbLeft.adjustsFontSizeToFitWidth=YES;
//    _viewTendency.lbRight.adjustsFontSizeToFitWidth=YES;
//    _viewTendency.lbStoreName.adjustsFontSizeToFitWidth=YES;
//    _viewTendency.lbStoreName2.adjustsFontSizeToFitWidth=YES;
    
    _viewCompare.lbLeft.text=_strLeft;
    _viewCompare.lbRight.text=_strRight;
    _viewTendency.lbLeft.text=_strLeft;
    _viewTendency.lbRight.text=_strRight;
    _viewCompare.lbStoreName.text=_domainData.strDomainName;
    _viewCompare.lbStoreName2.text=_domainData.strDomainName;
    _viewTendency.lbStoreName.text=_domainData.strDomainName;
    _viewTendency.lbStoreName2.text=_domainData.strDomainName;
    _viewCompare.lbDate.text=_strDate;
    _viewTendency.lbDate.text=_strDate;
    _viewCompare.lbDateSelect1.text=_compareDateIndex1;
    _viewCompare.lbDateSelect2.text=_compareDateIndex2;
    _viewTendency.lbDateSelect.text=_tendencyDateIndex;
    
    
    NSInteger nYear = _dateRange.nYear;
    NSString *currentDateStr;
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    if (_dateRange.type == KPIDateRangeType_Day)
    {
        [dateFormat setDateFormat:@"yyyy"];
        currentDateStr=[dateFormat stringFromDate:_dateRange.date];
        nYear = currentDateStr.integerValue;
    }
    
    [dateFormat setDateFormat:@"MM"];
    currentDateStr=[dateFormat stringFromDate:_dateRange.date];
    NSInteger nMonth = currentDateStr.integerValue;
    
    [dateFormat setDateFormat:@"dd"];
    currentDateStr=[dateFormat stringFromDate:_dateRange.date];
    NSInteger nDay = currentDateStr.integerValue;
    
    switch(_dateRange.type)
    {
        case KPIDateRangeType_Year:
            nMonth = 0;
            nDay = 0;
            _dateRange.nIndex = 0;
            break;
        case KPIDateRangeType_Quarter:
            nMonth = 0;
            nDay = 0;
            break;
        case KPIDateRangeType_Week:
            nMonth = 0;
            nDay = 0;
            break;
        case KPIDateRangeType_Month:
            nMonth = _dateRange.nIndex;
            nDay = 0;
            break;
        case KPIDateRangeType_Day:
            _dateRange.nIndex = 0;
            break;
    }
    
     NSString * strUrlCompare = nil;
     NSString * strUrlTendency = nil;
    if ([RPSDK defaultInstance].bDemoMode) {
        NSString * filePath1 = [[NSBundle mainBundle] pathForResource:@"comparison" ofType:@"html"];
        strUrlCompare = [NSString stringWithFormat:@"file://%@?se=%@&doid=%@&w=%d&h=%d&rt=%d&ry=%d&rm=%d&rd=%d&ri=%d&ct1=%d&ct2=%d&ot1=%d&ot2=%d",filePath1,[RPSDK defaultInstance].strToken,_domainData.strDomainID,(NSInteger)_viewCompare.webView.frame.size.width * 2,(NSInteger)_viewCompare.webView.frame.size.height * 2,_dateRange.type,nYear,nMonth,nDay,_dateRange.nIndex,_indexCompare1,_indexCompare2,nOt1,nOt2];
        strUrlCompare= [strUrlCompare stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString * filePath2 = [[NSBundle mainBundle] pathForResource:@"combining" ofType:@"html"];
        strUrlTendency = [NSString stringWithFormat:@"file://%@?se=%@&doid=%@&w=%d&h=%d&rt=%d&ry=%d&rm=%d&rd=%d&ri=%d&ct1=%d&ot1=%d&ot2=%d",filePath2,[RPSDK defaultInstance].strToken,_domainData.strDomainID,(NSInteger)_viewTendency.webView.frame.size.width * 2,(NSInteger)_viewTendency.webView.frame.size.height * 2,_dateRange.type,nYear,nMonth,nDay,_dateRange.nIndex,_indexTendency,nOt1,nOt2];
        strUrlTendency= [strUrlTendency stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        strUrlCompare = [NSString stringWithFormat:@"%@/chart/comparison.html?sid=%@&se=%@&doid=%@&w=%d&h=%d&rt=%d&ry=%d&rm=%d&rd=%d&ri=%d&ct1=%d&ct2=%d&ot1=%d&ot2=%d",[RPSDK defaultInstance].strApiBaseUrl,[[RPSDK defaultInstance] GetSid],[RPSDK defaultInstance].strToken,_domainData.strDomainID,(NSInteger)_viewCompare.webView.frame.size.width * 2,(NSInteger)_viewCompare.webView.frame.size.height * 2,_dateRange.type,nYear,nMonth,nDay,_dateRange.nIndex,_indexCompare1,_indexCompare2,nOt1,nOt2];
        
        strUrlTendency = [NSString stringWithFormat:@"%@/chart/combining.html?sid=%@&se=%@&doid=%@&w=%d&h=%d&rt=%d&ry=%d&rm=%d&rd=%d&ri=%d&ct1=%d&ot1=%d&ot2=%d",[RPSDK defaultInstance].strApiBaseUrl,[[RPSDK defaultInstance] GetSid],[RPSDK defaultInstance].strToken,_domainData.strDomainID,(NSInteger)_viewCompare.webView.frame.size.width * 2,(NSInteger)_viewCompare.webView.frame.size.height * 2,_dateRange.type,nYear,nMonth,nDay,_dateRange.nIndex,_indexTendency,nOt1,nOt2];
        
    }
    NSURL * urlCompare = [NSURL URLWithString:strUrlCompare];
    NSURLRequest *requestCompare=[[NSURLRequest alloc]initWithURL:urlCompare];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _viewCompare.webView.scalesPageToFit = YES;
    [_viewCompare.webView loadRequest:requestCompare];
    
    NSURL * urlTendency = [NSURL URLWithString:strUrlTendency];
    NSURLRequest *requestTendency=[[NSURLRequest alloc]initWithURL:urlTendency];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _viewTendency.webView.scalesPageToFit = YES;
    [_viewTendency.webView loadRequest:requestTendency];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
//}
//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscapeRight;
//}
-(void)setCompareDateIndex1:(NSString *)compareDateIndex1
{
    _compareDateIndex1=compareDateIndex1;
   
    
}
-(void)setCompareDateIndex2:(NSString *)compareDateIndex2
{
    _compareDateIndex2=compareDateIndex2;
    
}
-(void)setStrDate:(NSString *)strDate
{
    _strDate=strDate;
    
}
-(void)setTendencyDateIndex:(NSString *)tendencyDateIndex
{
    _tendencyDateIndex=tendencyDateIndex;
    
}
-(void)setDateRange:(KPIDateRange *)dateRange
{
    _dateRange=dateRange;
}
-(void)setDomainData:(KPIDomainData *)domainData
{
    _domainData=domainData;
    
    
}
- (IBAction)OnBack:(id)sender
{
    [UIApplication sharedApplication].statusBarHidden=NO;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)OnSwitch:(id)sender
{
    if (_tag==0)
    {
        [_svFrame setContentOffset:CGPointMake(_svFrame.frame.size.width, 0)];
        _tag=1;
    }
    else if(_tag==1)
    {
        [_svFrame setContentOffset:CGPointMake(0, 0)];
        _tag=0;
    }
    if (_tag==1) {
        _btChart.selected=YES;
        _lbChart.text=NSLocalizedStringFromTableInBundle(@"Compare Chart",@"RPString", g_bundleResorce,nil);
    }
    else
    {
        _btChart.selected=NO;
        _lbChart.text=NSLocalizedStringFromTableInBundle(@"Tendency Chart",@"RPString", g_bundleResorce,nil);
    }
}

- (IBAction)OnRefresh:(id)sender
{
    [self ReloadWebView];
}
@end
