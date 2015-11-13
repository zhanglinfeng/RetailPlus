//
//  RPColumnView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPColumnView.h"
#import "RPLanguageViewController.h"
#import "RPBlockUIAlertView.h"
#import "RPBlockUISelectView.h"
#import "RPHorizontalScreenViewController.h"
extern NSBundle * g_bundleResorce;
extern LangType g_langType;
@implementation RPColumnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)awakeFromNib
{
    _view.layer.cornerRadius=6;
    _view.layer.borderWidth=1;
    _view.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    _viewTagBlue.layer.cornerRadius=1;
    _viewTaglightBlue.layer.cornerRadius=1;
    _viewTagRed.layer.cornerRadius=1;
    _viewTagViolet.layer.cornerRadius=1;
    _arrayMonth=[[NSMutableArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    
    [self loadOptions];
    
//    _strUrl=@"http://www.baidu.com/index.php?tn=10018801_hao";
//    NSURL *url=[[NSURL alloc]initWithString:_strUrl];
//    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
//    [_myWebView loadRequest:request];
    _vcWeb= [[RPHorizontalScreenViewController alloc] initWithNibName:NSStringFromClass([RPHorizontalScreenViewController class]) bundle:nil];
    _vcWeb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
}
- (IBAction)OnChooseDate:(id)sender
{
    [self.columnDelegate addDateSettingView];
}
-(void)setDateRange:(KPIDateRange *)dateRange
{
    [self loadOptions];
    LangType lang = g_langType;
    switch (g_langType) {
        case LangType_Auto:
        {
            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
            NSArray * languages = [defs objectForKey:@"AppleLanguages"];
            NSString * preferredLang = [languages objectAtIndex:0];
            if ([preferredLang isEqualToString:@"zh-Hans"])
            {
                lang = LangType_Hans;
            }
            else
            {
                lang = LangType_English;
            }
        }
            break;
        default:
            break;
    }
    
    _dateRange=dateRange;
    
    NSDate *currentDate=dateRange.date;
    switch (dateRange.type)
    {
        case KPIDateRangeType_Day:
        {
            
            NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"yyyy/MM/dd"];
            NSString *currentDateStr=[dateFormat stringFromDate:currentDate];
            
            //_btDate.titleLabel.text=currentDateStr;
            [_btDate setTitle:currentDateStr forState:UIControlStateNormal];
            _label.text=_strDay1;
            _index=0;
            
            
        }
            break;
        case KPIDateRangeType_Month:
        {
            NSString *currentDateStr=[[NSString alloc]init];
            switch (lang) {
                case LangType_Hans:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/%d月",dateRange.nYear,dateRange.nIndex];
                }
                    break;
                default:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/%@",dateRange.nYear,[_arrayMonth objectAtIndex:_dateRange.nIndex-1]];
                }
                    break;
            }
            
            [_btDate setTitle:currentDateStr forState:UIControlStateNormal];
            _label.text=_strMonth1;
            _index=0;
            
            
        }
            break;
        case KPIDateRangeType_Quarter:
        {
            NSString *currentDateStr=[[NSString alloc]init];
            switch (lang) {
                case LangType_Hans:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/%d季度",dateRange.nYear,dateRange.nIndex];
                }
                    break;
                default:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/Q%d",dateRange.nYear,dateRange.nIndex];
                }
                    break;
            }
            
            [_btDate setTitle:currentDateStr forState:UIControlStateNormal];
            _label.text=_strSeason1;
            _index=0;
        }
            break;
        case KPIDateRangeType_Week:
        {
            NSString *currentDateStr=[[NSString alloc]init];
            switch (lang) {
                case LangType_Hans:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/%d周",dateRange.nYear,dateRange.nIndex];
                }
                    break;
                default:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/w%d",dateRange.nYear,dateRange.nIndex];
                }
                    break;
            }
            
            [_btDate setTitle:currentDateStr forState:UIControlStateNormal];
            _label.text=_strWeek1;
            _index=0;
        }
            break;
        case KPIDateRangeType_Year:
        {
            NSString *currentDateStr=[NSString stringWithFormat:@"%d",dateRange.nYear];
            [_btDate setTitle:currentDateStr forState:UIControlStateNormal];
            _label.text=_strYear1;
            _index=0;
        }
            break;
        default:
            break;
    }
    [self ReloadChart];
    
    
}

-(void)OnPreviousDate:(id)sender
{
    
    LangType lang = g_langType;
    switch (g_langType) {
        case LangType_Auto:
        {
            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
            NSArray * languages = [defs objectForKey:@"AppleLanguages"];
            NSString * preferredLang = [languages objectAtIndex:0];
            if ([preferredLang isEqualToString:@"zh-Hans"])
            {
                lang = LangType_Hans;
            }
            else
            {
                lang = LangType_English;
            }
        }
            break;
        default:
            break;
    }
    
    
    switch (_dateRange.type)
    {
        case KPIDateRangeType_Day:
        {
            NSTimeInterval now=[_dateRange.date timeIntervalSince1970]*1;
            int  p=now/1 -86400;
            NSDate*pDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)p];
            
            NSDate *currentDate=[NSDate date];
            NSTimeInterval current=[currentDate timeIntervalSince1970]*1;
            if(now<current-86400*365*(YEARCOUNT-1)) return;
            
            NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"yyyy/MM/dd"];
            NSString *currentDateStr=[dateFormat stringFromDate:pDate];
            [_btDate setTitle:currentDateStr forState:UIControlStateNormal];
            
            _dateRange.date=pDate;
            
            
        }
            break;
        case KPIDateRangeType_Month:
        {
            _dateRange.nIndex--;
            if (_dateRange.nIndex<1)
            {
                _dateRange.nYear--;
                _dateRange.nIndex=12;
                if (_dateRange.nYear<[RPSDK DateToYear:[NSDate date]]-YEARCOUNT+1)
                {
                    _dateRange.nYear++;
                    _dateRange.nIndex=1;
                    return;
                }
                
                
            }
            NSString *currentDateStr=[[NSString alloc]init];
            switch (lang) {
                case LangType_Hans:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/%d月",_dateRange.nYear,_dateRange.nIndex];
                }
                    break;
                default:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/%@",_dateRange.nYear,[_arrayMonth objectAtIndex:_dateRange.nIndex-1]];
                }
                    break;
            }
            
            [_btDate setTitle:currentDateStr forState:UIControlStateNormal];
            
        }
            break;
        case KPIDateRangeType_Quarter:
        {
            _dateRange.nIndex--;
            if (_dateRange.nIndex<1)
            {
                _dateRange.nYear--;
                _dateRange.nIndex=4;
                if (_dateRange.nYear<[RPSDK DateToYear:[NSDate date]]-YEARCOUNT+1)
                {
                    _dateRange.nYear++;
                    _dateRange.nIndex=1;
                    return;
                }
            }
            NSString *currentDateStr=[[NSString alloc]init];
            switch (lang) {
                case LangType_Hans:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/%d季度",_dateRange.nYear,_dateRange.nIndex];
                }
                    break;
                default:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/Q%d",_dateRange.nYear,_dateRange.nIndex];
                }
                    break;
            }
            
            [_btDate setTitle:currentDateStr forState:UIControlStateNormal];
            
        }
            break;
        case KPIDateRangeType_Week:
        {
            _dateRange.nIndex--;
            if (_dateRange.nIndex<1) {
                _dateRange.nYear--;
                _dateRange.nIndex=53;
                if (_dateRange.nYear<[RPSDK DateToYear:[NSDate date]]-YEARCOUNT+1)
                {
                    _dateRange.nYear++;
                    _dateRange.nIndex=1;
                    return;
                }
            }
            NSString *currentDateStr=[[NSString alloc]init];
            switch (lang) {
                case LangType_Hans:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/%d周",_dateRange.nYear,_dateRange.nIndex];
                }
                    break;
                default:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/w%d",_dateRange.nYear,_dateRange.nIndex];
                }
                    break;
            }
            
            [_btDate setTitle:currentDateStr forState:UIControlStateNormal];
        }
            break;
        case KPIDateRangeType_Year:
        {
            _dateRange.nYear--;
            if (_dateRange.nYear<[RPSDK DateToYear:[NSDate date]]-YEARCOUNT+1)
            {
                _dateRange.nYear++;
                return;
            }
            NSString *currentDateStr=[NSString stringWithFormat:@"%d",_dateRange.nYear];
            [_btDate setTitle:currentDateStr forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
}
-(void)OnNextDate:(id)sender
{
    LangType lang = g_langType;
    switch (g_langType) {
        case LangType_Auto:
        {
            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
            NSArray * languages = [defs objectForKey:@"AppleLanguages"];
            NSString * preferredLang = [languages objectAtIndex:0];
            if ([preferredLang isEqualToString:@"zh-Hans"])
            {
                lang = LangType_Hans;
            }
            else
            {
                lang = LangType_English;
            }
        }
            break;
        default:
            break;
    }
    
    
    
    
    switch (_dateRange.type)
    {
        case KPIDateRangeType_Day:
        {
            NSTimeInterval now=[_dateRange.date timeIntervalSince1970]*1;
            int  p=now/1 +86400;
            NSDate*pDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)p];
            
            NSDate *currentDate=[NSDate date];
            NSTimeInterval current=[currentDate timeIntervalSince1970]*1;
            if(p>current) return;
            
            NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"yyyy/MM/dd"];
            NSString *currentDateStr=[dateFormat stringFromDate:pDate];
            [_btDate setTitle:currentDateStr forState:UIControlStateNormal];
            
            _dateRange.date=pDate;
            
        }
            break;
        case KPIDateRangeType_Month:
        {
            if (_dateRange.nYear==[RPSDK DateToYear:[NSDate date]])
            {
                if (_dateRange.nIndex>=[RPSDK DateToMonth:[NSDate date]])
                {
                    return;
                }
            }
            _dateRange.nIndex++;
            if (_dateRange.nIndex>12)
            {
                _dateRange.nYear++;
                _dateRange.nIndex=1;
                if (_dateRange.nYear>[RPSDK DateToYear:[NSDate date]])
                {
                    _dateRange.nYear--;
                    _dateRange.nIndex=12;
                    return;
                }
            }
            NSString *currentDateStr=[[NSString alloc]init];
            switch (lang) {
                case LangType_Hans:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/%d月",_dateRange.nYear,_dateRange.nIndex];
                }
                    break;
                default:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/%@",_dateRange.nYear,[_arrayMonth objectAtIndex:_dateRange.nIndex-1]];
                }
                    break;
            }
            
            [_btDate setTitle:currentDateStr forState:UIControlStateNormal];
        }
            break;
        case KPIDateRangeType_Quarter:
        {
            if (_dateRange.nYear==[RPSDK DateToYear:[NSDate date]])
            {
                if (_dateRange.nIndex>=[RPSDK DateToQuarter:[NSDate date]])
                {
                    return;
                }
            }
            _dateRange.nIndex++;
            if (_dateRange.nIndex>4) {
                _dateRange.nYear++;
                _dateRange.nIndex=1;
                if (_dateRange.nYear>[RPSDK DateToYear:[NSDate date]])
                {
                    _dateRange.nYear--;
                    _dateRange.nIndex=4;
                    return;
                }
            }
            NSString *currentDateStr=[[NSString alloc]init];
            switch (lang) {
                case LangType_Hans:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/%d季度",_dateRange.nYear,_dateRange.nIndex];
                }
                    break;
                default:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/Q%d",_dateRange.nYear,_dateRange.nIndex];
                }
                    break;
            }
            
            [_btDate setTitle:currentDateStr forState:UIControlStateNormal];
        }
            break;
        case KPIDateRangeType_Week:
        {
            if (_dateRange.nYear==[RPSDK DateToYear:[NSDate date]])
            {
                if (_dateRange.nIndex>=[RPSDK DateToWeek:[NSDate date]])
                {
                    return;
                }
            }
            _dateRange.nIndex++;
            if (_dateRange.nIndex>53) {
                _dateRange.nYear++;
                _dateRange.nIndex=1;
                if (_dateRange.nYear>[RPSDK DateToYear:[NSDate date]])
                {
                    _dateRange.nYear--;
                    _dateRange.nIndex=53;
                    return;
                }
            }
            NSString *currentDateStr=[[NSString alloc]init];
            switch (lang) {
                case LangType_Hans:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/%d周",_dateRange.nYear,_dateRange.nIndex];
                }
                    break;
                default:
                {
                    currentDateStr=[NSString stringWithFormat:@"%d/w%d",_dateRange.nYear,_dateRange.nIndex];
                }
                    break;
            }
            
            [_btDate setTitle:currentDateStr forState:UIControlStateNormal];
            
        }
            break;
        case KPIDateRangeType_Year:
        {
            _dateRange.nYear++;
            if (_dateRange.nYear>[RPSDK DateToYear:[NSDate date]])
            {
                _dateRange.nYear--;
                return;
            }
            NSString *currentDateStr=[NSString stringWithFormat:@"%d",_dateRange.nYear];
            [_btDate setTitle:currentDateStr forState:UIControlStateNormal];
            
        }
            break;
        default:
            break;
    }
    
}

- (IBAction)OnGotoHorizontalScreen:(id)sender
{
    _vcWeb.strDate=_btDate.titleLabel.text;
    _vcWeb.dateRange=_dateRange;
     _vcWeb.domainData=_domainData;
    _vcWeb.indexTendency=_index;
    _vcWeb.tendencyDateIndex=_label.text;
    _vcWeb.strLeft=_lbLeft.text;
    _vcWeb.strRight=_lbRight.text;
    _vcWeb.tag=1;
    
    switch (_dateRange.type)
    {
        case KPIDateRangeType_Day:
        {
            _vcWeb.indexCompare1=0;
            _vcWeb.indexCompare2=1;
            _vcWeb.compareDateIndex1=_strDay1;
            _vcWeb.compareDateIndex2=_strDay2;
        }
            break;
        case KPIDateRangeType_Month:
        {
            _vcWeb.indexCompare1=0;
            _vcWeb.indexCompare2=1;
            _vcWeb.compareDateIndex1=_strMonth1;
            _vcWeb.compareDateIndex2=_strMonth2;
        }
            break;
        case KPIDateRangeType_Quarter:
        {
            _vcWeb.indexCompare1=0;
            _vcWeb.indexCompare2=1;
            _vcWeb.compareDateIndex1=_strSeason1;
            _vcWeb.compareDateIndex2=_strSeason2;
        }
            break;
        case KPIDateRangeType_Week:
        {
            _vcWeb.indexCompare1=0;
            _vcWeb.indexCompare2=1;
            _vcWeb.compareDateIndex1=_strWeek1;
            _vcWeb.compareDateIndex2=_strWeek2;
        }
            break;
        case KPIDateRangeType_Year:
        {
            _vcWeb.indexCompare1=0;
            _vcWeb.indexCompare2=1;
            _vcWeb.compareDateIndex1=_strYear1;
            _vcWeb.compareDateIndex2=_strYear2;
        }
            break;
        default:
            break;
    }
    
    [_viewController presentViewController:_vcWeb animated:YES completion:^{
        
    }];
}
-(void)loadOptions
{
    _strDay1=NSLocalizedStringFromTableInBundle(@"the day before",@"RPString", g_bundleResorce,nil);
    _strDay2=NSLocalizedStringFromTableInBundle(@"The Same Day in Last Week",@"RPString", g_bundleResorce,nil);
    _strDay3=NSLocalizedStringFromTableInBundle(@"The Same Day in Last Month",@"RPString", g_bundleResorce,nil);
    _strDay4=NSLocalizedStringFromTableInBundle(@"The Same Day in Last Year",@"RPString", g_bundleResorce,nil);
    _strDay5=NSLocalizedStringFromTableInBundle(@"Daily Average in Last Week",@"RPString", g_bundleResorce,nil);
    _strDay6=NSLocalizedStringFromTableInBundle(@"Daily Average in Last Month",@"RPString", g_bundleResorce,nil);
    _strDay7=NSLocalizedStringFromTableInBundle(@"Daily Average in Last Year",@"RPString", g_bundleResorce,nil);
    _strWeek1=NSLocalizedStringFromTableInBundle(@"Last Week",@"RPString", g_bundleResorce,nil);
    _strWeek2=NSLocalizedStringFromTableInBundle(@"The Same Week in Last Year",@"RPString", g_bundleResorce,nil);
    _strWeek3=NSLocalizedStringFromTableInBundle(@"Weekly Average in Last Year",@"RPString", g_bundleResorce,nil);
    _strMonth1=NSLocalizedStringFromTableInBundle(@"Last Month",@"RPString", g_bundleResorce,nil);
    _strMonth2=NSLocalizedStringFromTableInBundle(@"The Same Month in Last Year",@"RPString", g_bundleResorce,nil);
    _strMonth3=NSLocalizedStringFromTableInBundle(@"Monthly Average in Last Year",@"RPString", g_bundleResorce,nil);
    _strSeason1=NSLocalizedStringFromTableInBundle(@"Last Season",@"RPString", g_bundleResorce,nil);
    _strSeason2=NSLocalizedStringFromTableInBundle(@"The Same Season in Last Year",@"RPString", g_bundleResorce,nil);
    _strSeason3=NSLocalizedStringFromTableInBundle(@"Seasonly Average in Last Year",@"RPString", g_bundleResorce,nil);
    _strYear1=NSLocalizedStringFromTableInBundle(@"Last Year",@"RPString", g_bundleResorce,nil);
    _strYear2=NSLocalizedStringFromTableInBundle(@"Annual Average in History",@"RPString", g_bundleResorce,nil);
    
    _arrayStrDay=[[NSMutableArray alloc]initWithObjects:_strDay1,_strDay2,_strDay3,_strDay4, nil];
    _arrayStrMonth=[[NSMutableArray alloc]initWithObjects:_strMonth1,_strMonth2, nil];
    _arrayStrSeason=[[NSMutableArray alloc]initWithObjects:_strSeason1, _strSeason2,nil];
    _arrayStrWeek=[[NSMutableArray alloc]initWithObjects:_strWeek1, _strWeek2,nil];
    _arrayStrYear=[[NSMutableArray alloc]initWithObjects:_strYear1, nil];
}
-(void)OnSelect:(id)sender
{
    switch (_dateRange.type)
    {
        case KPIDateRangeType_Day:
        {
//            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Select the column you want to display",@"RPString", g_bundleResorce,nil);
//            NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
//            RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
//                if (indexButton==0)
//                {
//                    
//                }
//                else if(indexButton==1)
//                {
//                    _label.text=_strDay1;
//                    _strUrl=@"http://a.hiphotos.bdimg.com/album/s%3D1100%3Bq%3D90/sign=f348c502014f78f0840b9ef249013124/4a36acaf2edda3cc747ce37603e93901203f92cf.jpg";
//                    NSURL *url=[[NSURL alloc]initWithString:_strUrl];
//                    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
//                    [_myWebView loadRequest:request];
//                }
//                else if(indexButton==2)
//                {
//                    _label.text=_strDay2;
//                    
//                    _strUrl=@"http://c.hiphotos.bdimg.com/album/s%3D740%3Bq%3D90/sign=f7347a0f4610b912bbc1f4faf3c68d3e/0df3d7ca7bcb0a46c83ab68d6a63f6246b60af6d.jpg";
//                    NSURL *url=[[NSURL alloc]initWithString:_strUrl];
//                    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
//                    [_myWebView loadRequest:request];
//                }
//                else if(indexButton==3)
//                {
//                    _label.text=_strDay3;
//                    
//                    _strUrl=@"http://f.hiphotos.bdimg.com/album/s%3D1100%3Bq%3D90/sign=1cb7a0576f061d95794633394bc431a0/ca1349540923dd54e3f87e07d009b3de9d8248d2.jpg";
//                    NSURL *url=[[NSURL alloc]initWithString:_strUrl];
//                    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
//                    [_myWebView loadRequest:request];
//                }
//                else if(indexButton==4)
//                {
//                    _label.text=_strDay4;
//                    _strUrl=@"http://g.hiphotos.bdimg.com/album/s%3D1100%3Bq%3D90/sign=ad61f2566a600c33f479dac92a7c6a7e/b812c8fcc3cec3fd3a019637d788d43f879427b0.jpg";
//                    NSURL *url=[[NSURL alloc]initWithString:_strUrl];
//                    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
//                    [_myWebView loadRequest:request];
//                }
//                else if(indexButton==5)
//                {
//                    _label.text=_strDay5;
//                    _strUrl=@"http://b.hiphotos.bdimg.com/album/s%3D1100%3Bq%3D90/sign=660cb4d4472309f7e36fa913423e3782/c8177f3e6709c93d5989afb79e3df8dcd1005472.jpg";
//                    NSURL *url=[[NSURL alloc]initWithString:_strUrl];
//                    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
//                    [_myWebView loadRequest:request];
//                }
//                else if(indexButton==6)
//                {
//                    _label.text=_strDay6;
//                    _strUrl=@"http://d.hiphotos.bdimg.com/album/s%3D1100%3Bq%3D90/sign=f769ff4b00e939015202893f4bdc6f96/b219ebc4b74543a90996bda71f178a82b80114cf.jpg";
//                    NSURL *url=[[NSURL alloc]initWithString:_strUrl];
//                    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
//                    [_myWebView loadRequest:request];
//                }
//                else
//                {
//                    _label.text=_strDay7;
//                    _strUrl=@"http://e.hiphotos.bdimg.com/album/s%3D1100%3Bq%3D90/sign=1f06b1a6fd039245a5b5e50eb7a49fb3/1b4c510fd9f9d72abc915776d52a2834359bbbe0.jpg";
//                    NSURL *url=[[NSURL alloc]initWithString:_strUrl];
//                    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
//                    [_myWebView loadRequest:request];
//                }
//                
//            }otherButtonTitles:_strDay1,_strDay2,_strDay3,_strDay4,_strDay5,_strDay6,_strDay7, nil];
//            [alertView show];
            
            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Select the column you want to display",@"RPString", g_bundleResorce,nil);
            
            RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:strDesc clickButton:^(NSInteger indexButton) {
                _index=indexButton;
                _label.text=[_arrayStrDay objectAtIndex:indexButton];
                [self ReloadChart];
            } curIndex:_index  selectTitles:_arrayStrDay];
            [selectView show];
            
        }
            break;
        case KPIDateRangeType_Month:
        {
//            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Select the column you want to display",@"RPString", g_bundleResorce,nil);
//            NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
//            RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
//                if (indexButton==0)
//                {
//                    
//                }
//                else if(indexButton==1)
//                {
//                    _label.text=_strMonth1;
//                }
//                else if(indexButton==2)
//                {
//                    _label.text=_strMonth2;
//                }
//                else
//                {
//                    _label.text=_strMonth3;
//                }
//                
//                
//            }otherButtonTitles:_strMonth1,_strMonth2,_strMonth3, nil];
//            [alertView show];
            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Select the column you want to display",@"RPString", g_bundleResorce,nil);
            
            RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:strDesc clickButton:^(NSInteger indexButton) {
                _index=indexButton;
                _label.text=[_arrayStrMonth objectAtIndex:indexButton];
                [self ReloadChart];
            } curIndex:_index  selectTitles:_arrayStrMonth];
            [selectView show];
            
        }
            break;
        case KPIDateRangeType_Quarter:
        {
//            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Select the column you want to display",@"RPString", g_bundleResorce,nil);
//            NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
//            RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
//                if (indexButton==0)
//                {
//                    
//                }
//                else if(indexButton==1)
//                {
//                    _label.text=_strSeason1;
//                }
//                else if(indexButton==2)
//                {
//                    _label.text=_strSeason2;
//                }
//                else
//                {
//                    _label.text=_strSeason3;
//                }
//                
//                
//            }otherButtonTitles:_strSeason1,_strSeason2,_strSeason3, nil];
//            [alertView show];
            
            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Select the column you want to display",@"RPString", g_bundleResorce,nil);
            
            RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:strDesc clickButton:^(NSInteger indexButton) {
                _index=indexButton;
                _label.text=[_arrayStrSeason objectAtIndex:indexButton];
                [self ReloadChart];
            } curIndex:_index  selectTitles:_arrayStrSeason];
            [selectView show];
            
        }
            break;
        case KPIDateRangeType_Week:
        {
//            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Select the column you want to display",@"RPString", g_bundleResorce,nil);
//            NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
//            RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
//                if (indexButton==0)
//                {
//                    
//                }
//                else if(indexButton==1)
//                {
//                    _label.text=_strWeek1;
//                }
//                else if(indexButton==2)
//                {
//                    _label.text=_strWeek2;
//                }
//                else
//                {
//                    _label.text=_strWeek3;
//                }
//            }otherButtonTitles:_strWeek1,_strWeek2,_strWeek3, nil];
//            [alertView show];
            
            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Select the column you want to display",@"RPString", g_bundleResorce,nil);
            
            RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:strDesc clickButton:^(NSInteger indexButton) {
                _index=indexButton;
                _label.text=[_arrayStrWeek objectAtIndex:indexButton];
                [self ReloadChart];
            } curIndex:_index  selectTitles:_arrayStrWeek];
            [selectView show];
        }
            break;
        case KPIDateRangeType_Year:
        {
//            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Select the column you want to display",@"RPString", g_bundleResorce,nil);
//            NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
//            RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
//                if (indexButton==0)
//                {
//                    
//                }
//                else if(indexButton==1)
//                {
//                    _label.text=_strYear1;
//                }
//                else
//                {
//                    _label.text=_strYear2;
//                }
//                
//            }otherButtonTitles:_strYear1,_strYear2, nil];
//            [alertView show];
            
            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Select the column you want to display",@"RPString", g_bundleResorce,nil);
            
            RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:strDesc clickButton:^(NSInteger indexButton) {
                _index=indexButton;
                _label.text=[_arrayStrYear objectAtIndex:indexButton];
                [self ReloadChart];
            } curIndex:_index  selectTitles:_arrayStrYear];
            [selectView show];
        }
            break;
        default:
            break;
    }
}

-(void)ReloadChart
{
    NSString *Traffic=NSLocalizedStringFromTableInBundle(@"Traffic",@"RPString", g_bundleResorce,nil);
    NSString *Conversion=NSLocalizedStringFromTableInBundle(@"Conversion Rate",@"RPString", g_bundleResorce,nil);
    NSString * TraQty= NSLocalizedStringFromTableInBundle(@"TraQty",@"RPString", g_bundleResorce,nil);
    NSString *ProQty=NSLocalizedStringFromTableInBundle(@"ProQty",@"RPString", g_bundleResorce,nil);
    NSString *Amount=NSLocalizedStringFromTableInBundle(@"Amount",@"RPString", g_bundleResorce,nil);
    
    NSInteger nOt1 = 0;
    NSInteger nOt2 = 0;
    if ([_lbLeft.text isEqualToString:Traffic])
        nOt1 = 0;
    if ([_lbLeft.text isEqualToString:Conversion])
        nOt1 = 4;
    if ([_lbLeft.text isEqualToString:TraQty])
        nOt1 = 1;
    if ([_lbLeft.text isEqualToString:ProQty])
        nOt1 = 2;
    if ([_lbLeft.text isEqualToString:Amount])
        nOt1 = 3;
    
    if ([_lbRight.text isEqualToString:Traffic])
        nOt2 = 0;
    if ([_lbRight.text isEqualToString:Conversion])
        nOt2 = 4;
    if ([_lbRight.text isEqualToString:TraQty])
        nOt2 = 1;
    if ([_lbRight.text isEqualToString:ProQty])
        nOt2 = 2;
    if ([_lbRight.text isEqualToString:Amount])
        nOt2 = 3;
    
    
    
    
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
    
    NSString * strUrl = nil;
    if ([RPSDK defaultInstance].bDemoMode) {
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"combining" ofType:@"html"];
        strUrl = [NSString stringWithFormat:@"file://%@?se=%@&doid=%@&w=%d&h=%d&rt=%d&ry=%d&rm=%d&rd=%d&ri=%d&ct1=%d&ot1=%d&ot2=%d",filePath,[RPSDK defaultInstance].strToken,_domainData.strDomainID,(NSInteger)_myWebView.frame.size.width * 2,(NSInteger)_myWebView.frame.size.height * 2,_dateRange.type,nYear,nMonth,nDay,_dateRange.nIndex,_index,nOt1,nOt2];
        strUrl= [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        strUrl = [NSString stringWithFormat:@"%@/chart/combining.html?sid=%@&se=%@&doid=%@&w=%d&h=%d&rt=%d&ry=%d&rm=%d&rd=%d&ri=%d&ct1=%d&ot1=%d&ot2=%d",[RPSDK defaultInstance].strApiBaseUrl,[[RPSDK defaultInstance] GetSid],[RPSDK defaultInstance].strToken,_domainData.strDomainID,(NSInteger)_myWebView.frame.size.width * 2,(NSInteger)_myWebView.frame.size.height * 2,_dateRange.type,nYear,nMonth,nDay,_dateRange.nIndex,_index,nOt1,nOt2];
    }
    
    NSLog(@"%@",strUrl);
    _myWebView.scalesPageToFit = YES;
    NSURL *url=[NSURL URLWithString:strUrl];
    _strUrl=strUrl;
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [_myWebView loadRequest:request];
}

-(void)setDomainData:(KPIDomainData *)domainData
{
    _domainData = domainData;
   
    [self ReloadChart];
}
@end
