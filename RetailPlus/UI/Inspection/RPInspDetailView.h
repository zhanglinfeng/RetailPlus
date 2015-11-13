//
//  RPInspDetailView.h
//  RetailPlus
//
//  Created by lin dong on 13-8-19.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSYPopoverListView.h"
#import "RPInspHeaderView.h"
#import "RPInspMarkCell.h"
#import "RPInspAddIssueCell.h"
#import "RPInspIssueCell.h"
#import "RPInspIssueView.h"
#import "RPInspReporterView.h"
#import "RPInspCommentsView.h"

@protocol RPInspDetailViewDelegate <NSObject>
-(void)OnInspEnd;
-(void)OnRectifyEnd;
@end

@interface RPInspDetailView : UIView<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,RPInspHeaderViewDelegate,RPInspMarkCellDelegate,RPInspAddIssueCellDelegate,RPInspIssueCellDelegate,RPInspIssueViewDelegate,RPInspReporterViewDelegate,RPInspCommentsViewDelegate>
{
    IBOutlet UITableView        * _tvDetail;
    IBOutlet UIView             * _viewFrame;
    IBOutlet UIView             * _viewSelVendor;
    IBOutlet UIPickerView       * _pickVendor;
    IBOutlet UILabel            * _lbCount;
    IBOutlet UIView             * _viewCountAll;
    IBOutlet UIView             * _viewCountMark;
    IBOutlet RPInspIssueView    * _viewIssue;
    IBOutlet RPInspReporterView * _viewReporter;
    IBOutlet RPInspCommentsView * _viewComments;
    IBOutlet UIButton           * _btnVendor;
    IBOutlet UIButton           * _btnOk;
    
    NSInteger                   _nSelVendorIndex;
    NSInteger                   _nSelCataIndex;
    BOOL                        _bShowIssueView;
    BOOL                        _bShowReporterView;
    BOOL                        _bShowComment;
}

@property (nonatomic,assign) id<RPInspDetailViewDelegate>   delegate;
@property (nonatomic)        BOOL                           bInspectReport;
@property (nonatomic,assign) UIViewController               * vcFrame;
@property (nonatomic,assign) StoreDetailInfo                * storeSelected;
@property (nonatomic,assign) InspData                       * dataInsp;
@property (nonatomic,assign) InspReporters                  * repRectify;

-(BOOL)OnBack;
-(IBAction)OnSelectVendor:(id)sender;
-(IBAction)OnSend:(id)sender;
-(IBAction)OnCache:(id)sender;
- (IBAction)OnHelp:(id)sender;
@end
