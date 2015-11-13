//
//  RPStoreManagerView.h
//  RetailPlus
//
//  Created by lin dong on 14-9-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshHeaderView.h"
#import "RPStoreMngNavView.h"
#import "RPSearch.h"

@protocol RPStoreManagerViewDelegate <NSObject>
    -(void)OnSelectStoreManagerStore:(StoreDetailInfo *)store;
@end

@interface RPStoreManagerView : UIView<UITableViewDataSource,UITableViewDelegate,RPStoreMngNavViewDelegate,RPSearchDelegate>
{
    IBOutlet UIView             * _viewFrame;
    IBOutlet UIView             * _viewSearchFrame;
    IBOutlet UIView             * _viewStoreModeTitle;
    IBOutlet RPStoreMngNavView  * _viewDomainModeTitle;
  //  IBOutlet UITextField        * _tfSearch;
    IBOutlet UIImageView        * _ivOwned;
    IBOutlet UILabel            * _lbOwnedCount;
    IBOutlet UITableView        * _tbContent;
    
    IBOutlet UIButton           * _btnStoreMode;
    IBOutlet UIButton           * _btnDomainMode;
    
    IBOutlet UIView             * _viewStoreModeTitleDomain;
    IBOutlet UIView             * _viewStoreModeTitleSearch;
    IBOutlet UILabel            * _lbStoreModeTitleDomain;
    
    MJRefreshHeaderView         * _headerStoreList;
    RPSearch                    * _search;
    
    BOOL                        _bShowOwnedStore;   //仅显示可操作店铺
    BOOL                        _bStoreMode;        //当前显示模式 店铺／组织
    
    NSArray                     * _arrayDomain;     //组织树
    NSArray                     * _arrayStore;      //店铺列表
    DomainInfo                  * _rootDomain;      //组织树根节点
    DomainInfo                  * _currentDomain;   //当前选中的节点
    NSMutableArray              * _arrayShow;       //显示店铺／组织列表
    NSInteger                   _nOwnedStore;       //可操作店铺数量
}

@property id<RPStoreManagerViewDelegate> delegate;

-(void)ReloadData;
-(void)UpdateStore:(StoreDetailInfo *)store;


@end
