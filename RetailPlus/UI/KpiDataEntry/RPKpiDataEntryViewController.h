//
//  RPKpiDataEntryViewController.h
//  RetailPlus
//
//  Created by zwhe on 14-1-13.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTaskBaseViewController.h"
#import "RPStoreCardView.h"
#import "RPStoreListView.h"
#import "RPSalesDataView.h"
#import "RPTrafficDataView.h"
#import "RPMainViewController.h"

@interface RPKpiDataEntryViewController : RPTaskBaseViewController<RPStoreSelectDelegate,RPStoreCardViewDelegate,RPSalesDataViewDelegate,RPTrafficDataViewDelegate>
{
    RPStoreCardView             * _viewStoreCard;
    RPStoreListView             * _viewStoreList;
    IBOutlet  RPSalesDataView      *_viewSalesData;
    IBOutlet  RPTrafficDataView *_viewTrafficData;
    IBOutlet UIImageView *_ivBottom;
    BOOL _bViewSales;
    BOOL _bViewTraffic;
    BOOL _bStore;
    
}
@property (nonatomic,assign) id<RPMainViewControllerDelegate>   delegate;
@property (nonatomic,retain) StoreDetailInfo  * storeSelected;
- (IBAction)OnSalesData:(id)sender;
- (IBAction)OnTrafficData:(id)sender;
@end
