//
//  RPDSMainViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-7-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskNavViewController.h"
#import "RPDSNewCountViewController.h"
#import "RPAddRecordViewController.h"
#import "RPDSReportTableView.h"
#import "RPFinishView.h"
#import "RPDSReasonView.h"
#import "RPStoreListView.h"
#import "RPDatePicker.h"
@interface RPDSMainViewController : RPTaskNavViewController<RPDSReportTableViewDelegate,RPStoreSelectDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RPAddRecordViewControllerDelegate,RPDSNewCountViewControllerDelegate,RPFinishViewDelegate>
{
    RPDSNewCountViewController * _vcNewCount;
    RPAddRecordViewController *_vcAddRecord;
    
    IBOutlet UIView   *_viewThumbFrame;
    IBOutlet UIView   *_viewReportFrame;
    
    IBOutlet UIButton *_btShowButton;
    IBOutlet RPDSReportTableView * _tbReport;
    IBOutlet UIView *_viewMenu;
    IBOutlet RPFinishView *_viewFinish;
    BOOL _bf;
    IBOutlet UIButton *_btLast;
    IBOutlet UIButton *_btInOut;
    IBOutlet UIButton *_btCurrent;
    IBOutlet UIButton *_btShowHide;
    
    IBOutlet UIImageView *_ivIn;
    IBOutlet UIImageView *_ivOut;
    IBOutlet UILabel *_lbIn;
    IBOutlet UILabel *_lbOut;
    IBOutlet UILabel *_lbLast;
    IBOutlet UILabel *_lbCurrent;
    IBOutlet UILabel *_lbDifference;
    IBOutlet UILabel *_lbBrandName;
    IBOutlet UILabel *_lbStoreName;
    
    BOOL        _bHideMode;//是／否显示全部缩略信息
    NSTimer     * _timerShowHide;
    
    RPStoreListView   *_viewStoreList;
    BOOL               _bStoreList;
    StoreStockList *_storeStockList;
    IBOutlet UIView *_viewFrame;
    
    NSInteger _sn;//当前期数
    NSInteger _snSum;//总期数
    BOOL _isLatest;//是否最近期数
    BOOL _isQuery;
    IBOutlet UITextField *_tfSearch;
    IBOutlet UIButton *_btSelectStore;
    
    NSMutableArray *_arrayDSDetail;
    IBOutlet UIView *_viewLeft;
    IBOutlet UIButton *_btShowSearch;
    IBOutlet UIView *_viewSearch;
    IBOutlet UITableView *_tbSearch;
    
    RPDatePicker            * _pickDate;
    
    NSMutableArray *_arrayStoreStock;//滑出的右边列表数据
    
    IBOutlet UIView *_viewBGFinish;
    IBOutlet UIView *_viewBG;
    IBOutlet UIImageView *_ivTag;
    IBOutlet UIImageView *_ivWarn;
    IBOutlet UILabel *_lbFinishName;
    IBOutlet UIView *_viewLine;
    IBOutlet UILabel *_lbCurrentDate;
    IBOutlet UILabel *_lbCurrentCount;
    IBOutlet UILabel *_lbCurrentDif;
    IBOutlet UIImageView *_ivYes;
    IBOutlet UIImageView *_ivLeft;
    IBOutlet UIImageView *_ivRight;
    IBOutlet RPDSReasonView *_viewReason;
    BOOL _bInAppear;//yes表示进入该界面，no表示返回到该界面
    IBOutlet UILabel *_lbPrevious;
    IBOutlet UILabel *_lbInOut;
    
    IBOutlet UILabel *_lbCurrentStock;
}
@property (nonatomic,assign) StoreDetailInfo * storeSelected;
@property(nonatomic,assign)NSInteger tag;//为-1表示从店铺进入
- (IBAction)OnCurrentCounting:(id)sender;
- (IBAction)OnIO:(id)sender;
- (IBAction)OnLastTime:(id)sender;
- (IBAction)OnShowButton:(id)sender;
- (IBAction)OnAddRecord:(id)sender;
- (IBAction)OnFinish:(id)sender;
- (IBAction)OnQuit:(id)sender;
- (IBAction)OnSelectStore:(id)sender;
@property (nonatomic,assign) UIViewController * vcFrame;
-(BOOL)OnBack;
- (IBAction)OnShowSearchView:(id)sender;
- (IBAction)OnDeleteSearch:(id)sender;
- (IBAction)OnCurrent:(id)sender;
@end
