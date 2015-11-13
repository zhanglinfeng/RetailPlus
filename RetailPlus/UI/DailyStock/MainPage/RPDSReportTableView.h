//
//  RPDSReportTableView.h
//  RetailPlus
//
//  Created by lin dong on 14-7-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSDKDSDefine.h"
#import "RPDSReportHeadView.h"

@protocol RPDSReportTableViewDelegate <NSObject>
    -(void)OnScrollReportTable:(BOOL)bUp;
-(void)OnDeleteCurrentCount:(NSString *)strCountId UserId:(NSString *)userId;
-(void)OnDeleteIOCount:(NSString *)strCountId Type:(NSInteger)type UserId:(NSString *)userId;
@end

@interface RPDSReportTableView : UITableView<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,RPDSReportHeadViewDelegate>
{
    RPDSDetail              * _detailSelect;    //当前展开的记录
    RPDSReportExpandType    _typeExpand;        //当前展开记录的类型
    
    RPDSDetail              * _detailGather;    //当前汇总的记录
    NSString                * _strGatherTag;    //汇总的tag名称
    NSInteger               _nLastOffsetY;      //上次滚动条位置
    
    BOOL                    _bDraging;          //正在拖动
    BOOL                    _bReportDraging;    //一次拖动过程 一个方向 只调用一次delegate
    BOOL                    _bReportDragingUp;  //拖动方向
}

@property (nonatomic,assign) id<RPDSReportTableViewDelegate> delegateReport;

@property (nonatomic) BOOL  bShowCurrentStock;
@property (nonatomic) BOOL  bShowLastStock;
@property (nonatomic) BOOL  bShowInOutStock;

@property (nonatomic) BOOL  bOpenReport;        //是否当前点数
@property (nonatomic) BOOL  bHaveDeleteAuth;    //是否有删除别人点数的权限

@property (nonatomic,retain) NSMutableArray * arrayStockDetail;

@end
