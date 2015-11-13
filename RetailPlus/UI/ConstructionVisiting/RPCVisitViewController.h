//
//  RPCVisitViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-9-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
#import "RPTaskBaseViewController.h"
#import "RPStoreListView.h"
#import "RPMainViewController.h"
#import "RPVisitDetailView.h"
#import "RPStoreCardView.h"

typedef enum
{
    VISITSTEP_STOREDETAIL = 0,
    VISITSTEP_SELECTSHOP,
    VISITSTEP_DETAIL,
}VISITSTEP;

@interface RPCVisitViewController : RPTaskBaseViewController<RPStoreSelectDelegate,RPVisitDetailViewDelegate,RPStoreCardViewDelegate>
{
    IBOutlet UIView                * _viewBottom;
    IBOutlet RPVisitDetailView     * _viewDetail;
    
    IBOutlet UIButton           * _btnSelectStore;
    IBOutlet UIView             * _viewFrame;
    IBOutlet UIButton           * _btnGo;
    IBOutlet UIButton           * _btnHistory;
    
    IBOutlet UIImageView        * _imgStore;
    IBOutlet UILabel            * _lbAddress;
    IBOutlet UILabel            * _lbIssueCount;
    
    RPStoreCardView             * _viewStoreCard;
    
    VISITSTEP                   _step;
    StoreDetailInfo             * _storeSelected;
    RPStoreListView             * _viewStoreList;
    
    CVisitData                  * _dataVisit;
    BOOL                        _bConfirmQuit;
    BOOL                        _bModified;
}

@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;
@property (nonatomic,assign) UIViewController * vcFrame;
@property (nonatomic,retain) StoreDetailInfo  * storeSelected;

-(IBAction)OnSelectStore:(id)sender;
- (IBAction)OnHelp:(id)sender;
- (IBAction)OnContinue:(id)sender;
@end
