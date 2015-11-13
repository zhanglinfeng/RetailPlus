//
//  RPDSReportHeadView.h
//  RetailPlus
//
//  Created by lin dong on 14-7-9.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSDKDSDefine.h"

typedef enum
{
    RPDSReportExpandType_NONE = 0,
    RPDSReportExpandType_IO,
    RPDSReportExpandType_Current,
    RPDSReportExpandType_Last,
}RPDSReportExpandType;

@protocol RPDSReportHeadViewDelegate
    -(void)OnSelectCurrentStock:(RPDSDetail *)detail;
    -(void)OnSelectIOStock:(RPDSDetail *)detail;
    -(void)OnSelectLastStock:(RPDSDetail *)detail;
    -(void)OnSelectTag:(NSString *)strTag;
@end

@interface RPDSReportHeadView : UITableViewHeaderFooterView
{
    IBOutlet UIView         * _viewTagFrame;
    IBOutlet UIButton       * _btnTag1;
    IBOutlet UIButton       * _btnTag2;
    IBOutlet UIButton       * _btnTag3;
    
//Last Stock Btn
    IBOutlet UIView         * _viewLastStockFrame;
    IBOutlet UILabel        * _lbLastStockCount;
    IBOutlet UILabel        * _lbLastStockNA;
    IBOutlet UIImageView    * _ivLastExpandTip;
    
//Current Stock Btn
    IBOutlet UIView         * _viewCurrentStockFrame;
    IBOutlet UILabel        * _lbCurrentStockCount;
    IBOutlet UILabel        * _lbCurrentStockNA;
    IBOutlet UIImageView    * _ivCurrentExpandTip;
    
//In Out Btn
    IBOutlet UIView         * _viewInOutFrame;
    IBOutlet UIView         * _viewInFrame;
    IBOutlet UIView         * _viewOutFrame;
    IBOutlet UILabel        * _lbInSymb;
    IBOutlet UILabel        * _lbInCount;
    IBOutlet UILabel        * _lbOutSymb;
    IBOutlet UILabel        * _lbOutCount;
    IBOutlet UILabel        * _lbInOutNA;
    IBOutlet UIImageView    * _ivIOExpandTip;
    
//窗口位置信息
    NSInteger               _nGatherWidth; //右侧三种指标宽度
    NSInteger               _nGatherHeight; //右侧三种指标高度
    NSInteger               _nGap;//各种指标间隙
    
    CGRect                  _rcGather[3];   //右侧指标3个位置
    CGRect                  _rcTag[4];      //标签窗口4种长度
}

@property (nonatomic,assign) id<RPDSReportHeadViewDelegate> delegate;
@property (nonatomic,retain) RPDSDetail   * detail;

@property (nonatomic,retain) NSString     * strGatherTag;
@property (nonatomic) BOOL                  bShowCurrentStock;
@property (nonatomic) BOOL                  bShowLastStock;
@property (nonatomic) BOOL                  bShowInOutStock;
@property (nonatomic) BOOL                  bGatherMode;
@property (nonatomic) BOOL                  bOpenReport;

@property (nonatomic) RPDSReportExpandType  typeExpand; //当前子项目展开状态
@end
