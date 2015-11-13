//
//  RPStoreManagerListView.h
//  RetailPlus
//
//  Created by lin dong on 13-9-3.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshHeaderView.h"
@protocol RPStoreManagerListViewDelegate <NSObject>
    -(void)OnSelectStoreManagerStore:(StoreDetailInfo *)store;
@end

@interface RPStoreManagerListView : UIView
{
    IBOutlet UITableView    * _tbStore;
    IBOutlet UIView         * _viewFrame;
    IBOutlet UIView         * _viewSearchFrame;
    IBOutlet UITextField    * _tfSearch;
    IBOutlet UIButton       * _btnShowComplete;
    IBOutlet UIButton       * _btnShowStoreUser;
    
    NSMutableArray          * _arrayStoreAll;
    NSMutableArray          * _arrayStoreShow;
    
    BOOL                    _bShowComplete;
    BOOL                    _bShowStoreUser;
    MJRefreshHeaderView     * _headerStoreList;
}

@property id<RPStoreManagerListViewDelegate> delegate;

-(IBAction)OnDeleteSearch:(id)sender;

-(IBAction)OnShowComplete:(id)sender;
-(IBAction)OnShowStoreUser:(id)sender;

-(void)ReloadData;
-(void)UpdateStore:(StoreDetailInfo *)store;
@end
