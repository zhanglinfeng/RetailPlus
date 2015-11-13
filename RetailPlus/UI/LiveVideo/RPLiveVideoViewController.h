//
//  RPLiveVideoViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-4-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPMainViewController.h"
#import "RPTaskBaseViewController.h"
#import "RPStoreCardView.h"
#import "RPStoreListView.h"
#import "RPLiveVideoSelCamView.h"

typedef enum
{
    LIVEVIDEOSTEP_STOREDETAIL = 0,
    LIVEVIDEOSTEP_SELECTSHOP,
    LIVEVIDEOSTEP_DETAIL,
}LIVEVIDEOSTEP;

@interface RPLiveVideoViewController : RPTaskBaseViewController<RPStoreCardViewDelegate,RPStoreSelectDelegate,RPLiveVideoSelCamViewDelegate>
{
    IBOutlet UIView                 * _viewBottom;
    IBOutlet RPLiveVideoSelCamView  * _viewDetail;
    
    RPStoreCardView             * _viewStoreCard;
    RPStoreListView             * _viewStoreList;
    BOOL                        _bConfirmQuit;
    LIVEVIDEOSTEP               _step;
}

@property (nonatomic,assign) id<RPMainViewControllerDelegate>   delegate;
@property (nonatomic,assign) StoreDetailInfo * storeSelected;

-(BOOL)OnBack;

@end
