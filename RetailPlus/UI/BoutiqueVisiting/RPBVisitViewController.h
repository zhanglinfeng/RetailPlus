//
//  RPBVisitViewController.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTaskBaseViewController.h"
#import <UIKit/UIKit.h>
#import "RPStoreListView.h"
#import "RPBVisitDetailView.h"
//#import "RPBVisitReportsView.h"
#import "RPMainViewController.h"
#import "RPStoreCardView.h"
#import "RPBVisitTemplateView.h"
#import "RPBVisitSelHistoryView.h"
#import "RPBVisitIssueTrackListView.h"
#import "RPDistributionList.h"
typedef enum
{
    BVISITSTEP_STOREDETAIL = 0,
    BVISITSTEP_SELECTSHOP,
    BVISITSTEP_TEMPLATE,
    BVISITSTEP_DETAIL,
    BVISITSTEP_HISTORY,
    BVISITSTEP_ISSUETRACK,
    BVISITSTEP_TASK,
}BVISITSTEP;

@interface RPBVisitViewController : RPTaskBaseViewController<RPStoreSelectDelegate,RPStoreCardViewDelegate,RPBVisitTemplateViewDelegate,RPBVisitDetailViewDelegate,RPBVisitSelHistoryViewDelegate,RPBVisitIssueTrackListViewDelegate>
{
    IBOutlet UIView             * _viewBottom;
//    IBOutlet RPBVisitReportsView  * _viewReports;
    
    IBOutlet RPBVisitTemplateView *_viewTemplate;
    IBOutlet RPBVisitDetailView *_viewDetail;
    IBOutlet RPBVisitSelHistoryView * _viewHistory;
    IBOutlet RPBVisitIssueTrackListView *_viewIssueTrack;
    IBOutlet RPDistributionList *_viewDistributionList;
//    IBOutlet UIButton           * _btnSelectStore;
//    IBOutlet UIView             * _viewFrame;
//    IBOutlet UIButton           * _btnGo;
//    IBOutlet UIButton           * _btnHistory;
//    IBOutlet UIButton           * _btnRectify;
//    
//    IBOutlet UIImageView        * _imgStore;
//    IBOutlet UILabel            * _lbAddress;
    
    RPStoreCardView             * _viewStoreCard;
    
    RPStoreListView             * _viewStoreList;
    BVISITSTEP                    _step;
    
    StoreDetailInfo             * _storeSelected;
    BVisitData                    * _dataVisit;
    BOOL                        _bConfirmQuit;
    
    InspReporters               * _repRectify;
    BOOL                        _bModified;
    
    IBOutlet UILabel *_lbNew;
    
}
@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;
@property (nonatomic,assign) UIViewController * vcFrame;
@property (nonatomic,retain) StoreDetailInfo  * storeSelected;
//@property (nonatomic,retain)BVisitListModel *bVisitListModel;
-(IBAction)OnInspDetail:(id)sender;
- (IBAction)OnHelp:(id)sender;
- (IBAction)OnContinue:(id)sender;
- (IBAction)OnIssueTrack:(id)sender;

-(void)continueVisit:(NSString *)strCacheDataId;
-(void)OnEditOtherReport:(BVisitListModel *)bVisitModel Store:(StoreDetailInfo *)storeInfo;
@end
