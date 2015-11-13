//
//  RPLogBookViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-3-3.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPMainViewController.h"
#import "RPTaskBaseViewController.h"
#import "RPStoreCardView.h"
#import "RPStoreListView.h"
#import "RPLogBookDetailView.h"

typedef enum
{
    LOGBOOKSTEP_STOREDETAIL = 0,
    LOGBOOKSTEP_SELECTSHOP,
    LOGBOOKSTEP_DETAIL,
}LOGBOOKSTEP;

@interface RPLogBookViewController : RPTaskBaseViewController<RPStoreCardViewDelegate,RPStoreSelectDelegate,RPLogBookDetailViewDelegate>
{
    IBOutlet UIView               * _viewBottom;
    IBOutlet RPLogBookDetailView  * _viewDetail;
    
    LOGBOOKSTEP                 _step;
    BOOL                        _bConfirmQuit;
    
    RPStoreCardView             * _viewStoreCard;
//    StoreDetailInfo             * _storeSelected;
    RPStoreListView             * _viewStoreList;
}

@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;
@property (nonatomic,assign) UIViewController * vcFrame;
@property (nonatomic,assign) StoreDetailInfo * storeSelected;

- (IBAction)OnHelp:(id)sender;
@end
