//
//  RPInspViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-8-19.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
#import "RPStoreListView.h"
#import "RPInspDetailView.h"
#import "RPInspReportsView.h"
#import "RPMainViewController.h"
#import "RPStoreCardView.h"

typedef enum
{
    INSPSTEP_STOREDETAIL = 0,
    INSPSTEP_SELECTSHOP,
    INSPSTEP_DETAIL,
    INSPSTEP_REPORTS,
}INSPSTEP;

@interface RPInspViewController : RPTaskBaseViewController<RPStoreSelectDelegate,RPInspReportsViewDelegate,RPInspDetailViewDelegate,RPStoreCardViewDelegate>
{
    IBOutlet UIView             * _viewBottom;
    IBOutlet RPInspDetailView   * _viewDetail;
    IBOutlet RPInspReportsView  * _viewReports;
    
    IBOutlet UIButton           * _btnSelectStore;
    IBOutlet UIView             * _viewFrame;
    IBOutlet UIButton           * _btnGo;
    IBOutlet UIButton           * _btnHistory;
    IBOutlet UIButton           * _btnRectify;
    
    IBOutlet UIImageView        * _imgStore;
    IBOutlet UILabel            * _lbAddress;

    RPStoreCardView             * _viewStoreCard;
    
    RPStoreListView             * _viewStoreList;
    INSPSTEP                    _step;
    
    StoreDetailInfo             * _storeSelected;
    InspData                    * _dataInsp;
    BOOL                        _bConfirmQuit;
    
    InspReporters               * _repRectify;
    BOOL                        _bModified;
}

@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;

@property (nonatomic,assign) UIViewController * vcFrame;
@property (nonatomic,retain) StoreDetailInfo  * storeSelected;

-(IBAction)OnSelectStore:(id)sender;
-(IBAction)OnInspDetail:(id)sender;
-(IBAction)OnInspReports:(id)sender;
- (IBAction)OnHelp:(id)sender;
- (IBAction)OnContinue:(id)sender;
@end
