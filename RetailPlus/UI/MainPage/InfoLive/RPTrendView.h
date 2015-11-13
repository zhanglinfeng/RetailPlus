//
//  RPTrendView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPHorizontalScreenViewController.h"
#define YEARCOUNT       20

@protocol TrendViewDelegate <NSObject>

-(void)addSubView;


@end

@interface RPTrendView : UIView
{
    
    IBOutlet UIView              *_view1;
    IBOutlet UIView              *_view2;
    IBOutlet UIButton            *_btDate;
    IBOutlet UILabel             *_lb1;
    IBOutlet UILabel             *_lb2;
    
    NSMutableArray               *_arrayMonth;
    IBOutlet UIView *_viewTag;
    IBOutlet UIView *_viewTagGray;
    IBOutlet UIView *_viewTagBlue;
   
    NSString                     *_strDay1;
    NSString                     *_strDay2;
    NSString                     *_strDay3;
    NSString                     *_strDay4;
    NSString                     *_strDay5;
    NSString                     *_strDay6;
    NSString                     *_strDay7;
    NSString                     *_strWeek1;
    NSString                     *_strWeek2;
    NSString                     *_strWeek3;
    NSString                     *_strMonth1;
    NSString                     *_strMonth2;
    NSString                     *_strMonth3;
    NSString                     *_strSeason1;
    NSString                     *_strSeason2;
    NSString                     *_strSeason3;
    NSString                     *_strYear1;
    NSString                     *_strYear2;
    
    IBOutlet UIWebView           *_myWebView;
    
    int                          _index1;//对比时间段
    int                          _index2;//对比时间段
    NSMutableArray               *_arrayStrDay;
    NSMutableArray               *_arrayStrWeek;
    NSMutableArray               *_arrayStrMonth;
    NSMutableArray               *_arrayStrSeason;
    NSMutableArray               *_arrayStrYear;
    RPHorizontalScreenViewController * _vcWeb;
}

@property(nonatomic,strong) KPIDomainData * domainData;
@property(nonatomic,retain) NSString * strUrl;
@property(nonatomic,strong)UIViewController *viewController;
@property(nonatomic,weak)id<TrendViewDelegate>trendDelegate;
@property(nonatomic,strong)IBOutlet UILabel *lbLeft;
@property(nonatomic,strong)IBOutlet UILabel *lbRight;
@property(nonatomic,strong)KPIDateRange *dateRange;

- (IBAction)OnSettingDate:(id)sender;
//- (IBAction)OnSettingDate2:(id)sender;
- (IBAction)OnSelect1:(id)sender;
- (IBAction)OnSelect2:(id)sender;
-(IBAction)OnPreviousDate:(id)sender;
-(IBAction)OnNextDate:(id)sender;
- (IBAction)OnGotoHorizontalScreen:(id)sender;

-(void)ReloadChart;
@end
