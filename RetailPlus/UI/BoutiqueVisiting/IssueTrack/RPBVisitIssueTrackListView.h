//
//  RPBVisitIssueTrackListView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-8-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPBVisitIssueTrackView.h"
#import "RPBVisitIssueTrackCell.h"
#import "RPBVisitIssueTrackHeadView.h"
#import "RPDatePicker.h"
#import "RPInspReporterView.h"
#import "RPAddTaskView.h"
#import "RPStoreListView.h"
@protocol RPBVisitIssueTrackListViewDelegate <NSObject>
-(void)OnIssueTrackEnd;
@end
@interface RPBVisitIssueTrackListView : UIView<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,RPBVisitIssueTrackHeadViewDelegate,RPBVisitIssueTrackCellDelegate,RPInspReporterViewDelegate,RPStoreSelectDelegate,RPAddTaskViewDelegate>
{
    IBOutlet UIView *_viewSearch;
    IBOutlet UITextField *_tfSearch;
    IBOutlet UIView *_viewFrame;
    IBOutlet UIView *_viewDateRange;
    IBOutlet UITextField *_tfStartDate;
    IBOutlet UITextField *_tfEndDate;
    IBOutlet UIView *_viewTB;
    IBOutlet UIButton *_btSelectAll;
    IBOutlet UIButton *_btDateMenu;
    IBOutlet UIView *_viewHeader;
    IBOutlet RPBVisitIssueTrackView *_viewIssueTrack;
    BOOL _bIssueView;
    BOOL _bShowReporterView;
    BOOL _bStoreView;
    NSMutableArray *_arraySearch;
    IBOutlet UITableView *_tbSearchIssue;
    IBOutlet UIImageView *_ivTriangle;
    NSInteger _selectState;//0全不选，1半选，2全选
    IBOutlet UILabel *_lbCount;
    IBOutlet UILabel *_lbStartDate;
    IBOutlet UILabel *_lbEndDate;
    RPDatePicker            * _pickDateStart;
    RPDatePicker            * _pickDateEnd;
//    IBOutlet UIView *_viewResult;
    BVisitIssueSearchData *_issueSearchData;
    IBOutlet RPInspReporterView * _viewReporter;
    IBOutlet UIView *_viewSwitch;
    IBOutlet UIButton *_btSend;
    IBOutlet RPAddTaskView *_viewTask;
    BOOL _bTask;
    RPStoreListView             * _viewStoreList;
    IBOutlet UIImageView *_viewBottom;
    IBOutlet UILabel *_lbStoreName;
    IBOutlet UIButton *_btNoTask;
    IBOutlet UIButton *_btInProgress;
    IBOutlet UIButton *_btDone;
    NSMutableArray *_arrayShow;//过滤出得数组
    IBOutlet UILabel *_lbNoTask;
    IBOutlet UILabel *_lbInProgress;
    IBOutlet UILabel *_lbDone;
    BOOL _bMenu;//是否展开搜索器
}
@property(nonatomic,weak)id<RPBVisitIssueTrackListViewDelegate>delegate;
@property(nonatomic,retain)StoreDetailInfo * store;
@property(nonatomic,retain)DomainInfo *domain;
- (IBAction)OnDeleteSearch:(id)sender;
- (IBAction)OnDateMenu:(id)sender;
-(BOOL)OnBack;
- (IBAction)OnSelectAll:(id)sender;
- (IBAction)OnSearch:(id)sender;
- (IBAction)OnSend:(id)sender;
- (IBAction)OnTask:(id)sender;
- (IBAction)OnReport:(id)sender;
- (IBAction)OnSelectStore:(id)sender;
- (IBAction)OnNoTask:(id)sender;
- (IBAction)OnInProgress:(id)sender;
- (IBAction)OnTaskDone:(id)sender;
-(void)clearUI;
@end
