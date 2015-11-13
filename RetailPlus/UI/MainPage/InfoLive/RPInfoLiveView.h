//
//  RPInfoLiveView.h
//  RetailPlus
//
//  Created by zwhe on 14-1-23.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSYPopoverListView.h"
#import "RPTrendView.h"
#import "RPColumnView.h"
//#import "RPDateSettingView.h"
@interface RPInfoLiveView : UIView<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    IBOutlet UIScrollView             *_svFrame;
    IBOutlet RPTrendView              *_view1;
    IBOutlet RPColumnView             *_view2;
    IBOutlet UIView                   *_view3;
    IBOutlet UIView                   *_viewInfo;
    IBOutlet UIView                   *_viewBackground;
    BOOL                              _bBig;
    BOOL                              _bTag;
    IBOutlet UIButton                 *_btSwitch;
    IBOutlet UIImageView              *_ivParent;
    IBOutlet UILabel                  *_lbCity;
    IBOutlet UILabel                  *_lb1;
    IBOutlet UILabel                  *_lb2;
    IBOutlet UIImageView              *_iv1;
    IBOutlet UIImageView              *_iv2;
    IBOutlet UIButton                 *_bt1;
    IBOutlet UIButton                 *_bt2;
    IBOutlet UIButton *_btExpend;
    IBOutlet UIView *_viewLine;
    
    ZSYPopoverListView                *_List1;
    ZSYPopoverListView                *_List2;
    NSMutableArray                    *_array;//所有选择列所在的数组
    NSMutableArray                    *_array1;//第一个长按Button可选择列所在数组
    NSMutableArray                    *_array2;//第二个长按Button可选择列所在数组
    IBOutlet UITableView              *_tbTrafficInfo;
    CGPoint                           _p;
    UIWindow                          *_keywindow;
    NSString                          *_node;//当前节点
    NSString                          *_parentNote;//父节点
    NSString                          *_parentName;//父节点所在的domainName
    NSMutableArray                    *_arrayDomainKPIData;
    NSMutableArray                    *_arrayNode;
    NSMutableArray                    *_arrayName;
    int                               _TagUp1;//0、1、2分别表示排序时灰色，向下，向上
    int                               _TagUp2;//0、1、2分别表示排序时灰色，向下，向上
    int                               _maxTraffic;//各列显示的数据中最大值
    int                               _maxConversion;
    int                               _maxTraQty;
    int                               _maxProQty;
    int                               _maxAmount;
    NSInteger                         _nCellIndex;//选中cell所在行
    NSInteger                         _strIndex1;//第一个长按Button要显示的列在字符串数组里的位置
    NSInteger                         _strIndex2;//第二个长按Button要显示的列在字符串数组里的位置
    NSString                          *_currentString1;//第一个长按Button当前显示的字符串
    NSString                          *_currentString2;//第二个长按Button当前显示的字符串
    NSString                          *_str1;//其他要显示的列表示的字符串
    NSString                          *_str2;
    NSString                          *_str3;
    IBOutlet UIButton *_btNextTrend;
    IBOutlet UIButton *_btPreviousTrend;
    IBOutlet UIButton *_btNextColumn;
    IBOutlet UIButton *_btPreviousColumn;
    NSString *_domainId;//排序，进入下层，返回上层的这些操作之前记录的id
}
@property(nonatomic,strong)UIViewController *viewController;
@property(nonatomic,strong)KPIDateRange *dateRange;
- (IBAction)OnUpOrDown:(id)sender;
- (IBAction)OnSwitch:(id)sender;
- (IBAction)OnButton1:(id)sender;
- (IBAction)OnButton2:(id)sender;
- (IBAction)OnCollect:(id)sender;
- (IBAction)OnParent:(id)sender;
- (IBAction)OnRefresh:(id)sender;
- (IBAction)OnPreviousDate:(id)sender;
- (IBAction)OnNextDate:(id)sender;
-(void)TriangleColor;
@end
