//
//  RPBVisitDetailView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPBVisitHeaderView.h"
#import "RPBVisitMarkCell.h"
#import "RPBVisitAddIssueCell.h"
#import "RPBVisitIssueCell.h"
#import "RPBVisitIssueView.h"
#import "RPInspReporterView.h"
#import "RPBVisitCommentsView.h"
@protocol RPBVisitDetailViewDelegate <NSObject>
-(void)OnVisitEnd:(NSString *)reportId;
//-(void)OnGoTask:(NSString*)reportId;//委托模板界面
//-(void)OnTask:(NSString*)reportId;//委托开始界面
@end
@interface RPBVisitDetailView : UIView<UITableViewDelegate,UITableViewDataSource,RPBVisitHeaderViewDelegate,RPBVisitMarkCellDelegate,RPBVisitIssueCellDelegate,RPBVisitIssueViewDelegate,RPBVisitCommentsViewDelegate,RPInspReporterViewDelegate>
{
    IBOutlet UITableView        * _tvDetail;
    IBOutlet UIView             * _viewFrame;
    IBOutlet UIView             * _viewSelVendor;
    IBOutlet UILabel            * _lbCount;
    IBOutlet UILabel            * _lbScore;
    IBOutlet UIView             * _viewCountAll;
    IBOutlet UIView             * _viewCountMark;
    IBOutlet RPBVisitIssueView    * _viewIssue;
    IBOutlet RPInspReporterView * _viewReporter;
    IBOutlet RPBVisitCommentsView * _viewComments;
    IBOutlet UIButton           * _btnVendor;
    IBOutlet UIButton           * _btnOk;
    
    NSInteger                   _nSelVendorIndex;//记录选哪个分类
    NSInteger                   _nSelCataIndex;//记录展开哪个header
    BOOL                        _bShowIssueView;
    BOOL                        _bShowReporterView;
    BOOL                        _bShowComment;
}

@property (nonatomic,assign) id<RPBVisitDetailViewDelegate>   delegate;
@property (nonatomic,assign) UIViewController               * vcFrame;
@property (nonatomic,assign) StoreDetailInfo                * storeSelected;
@property (nonatomic,assign) BVisitData                     * dataVisit;
@property (nonatomic,assign) InspReporters                  * repRectify;
@property (nonatomic,retain) NSString                       * strCacheDataId;

-(BOOL)OnBack;
-(IBAction)OnSelectVendor:(id)sender;
-(IBAction)OnSend:(id)sender;
-(IBAction)OnCache:(id)sender;
- (IBAction)OnHelp:(id)sender;
@end
