//
//  RPHorizontalScreenViewController.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-13.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPCompareView.h"
#import "RPTendencyView.h"
@interface RPHorizontalScreenViewController : UIViewController
{
    
    IBOutlet UIButton *_btBack;//返回按钮
//    IBOutlet UIWebView *_webView;
    IBOutlet UIScrollView *_svFrame;//用来放柱状图和趋势图的ScrollView
    IBOutlet UIView *_viewRightBar;//右边放按钮的View
    IBOutlet RPCompareView *_viewCompare;//柱状图表
    IBOutlet RPTendencyView *_viewTendency;//趋势图表
    IBOutlet UILabel *_lbChart;//图表切换按钮下地文字
    IBOutlet UILabel *_lbRefresh;//刷新按钮下地文字
    IBOutlet UILabel *_lbZoomOut;//退出全屏按钮下地文字
    IBOutlet UIButton *_btChart;//图表切换按钮
}
@property(nonatomic,strong) KPIDomainData * domainData;//传入的数据
@property(nonatomic,strong)KPIDateRange *dateRange;//传入的时间
@property (nonatomic,retain) NSString * strUrlTendency;//趋势图url
@property(nonatomic,retain) NSString * strUrlCompare;//柱状图URL
@property(nonatomic,assign)int indexCompare1;//对比时间段对应的index
@property(nonatomic,assign)int indexCompare2;//对比时间段对应的index
@property(nonatomic,assign)int indexTendency;//对比时间段对应的index
@property(nonatomic,retain)NSString *strDate;//显示时间的字符串
@property(nonatomic,retain)NSString *compareDateIndex1;//对比时间段对应的显示字符串
@property(nonatomic,retain)NSString *compareDateIndex2;//对比时间段对应的显示字符串
@property(nonatomic,retain)NSString *tendencyDateIndex;//对比时间段对应的显示字符串
@property(nonatomic,retain)NSString *strLeft;//左上角label要显示的，如转化率、客流。。。
@property(nonatomic,retain)NSString *strRight;//右上角label要显示的，如转化率、客流。。。
@property(nonatomic,assign)int tag;//0代表从柱状图进入横屏，1代表从趋势图进入横屏

- (IBAction)OnBack:(id)sender;
- (IBAction)OnSwitch:(id)sender;
- (IBAction)OnRefresh:(id)sender;

@end
