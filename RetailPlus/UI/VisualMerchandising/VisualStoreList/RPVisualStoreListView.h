//
//  RPVisualStoreListView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPVisualMerchandisingView.h"
#import "RPStoreListView.h"
#import "MJRefreshHeaderView.h"
@protocol RPVisualStoreListViewDelegate<NSObject>
-(void)endVisualStoreList;
@end
@interface RPVisualStoreListView : UIView<UITableViewDataSource,UITableViewDelegate,RPStoreSelectDelegate,UITextFieldDelegate>
{
    IBOutlet UIButton                  *_btAddStore;
    IBOutlet UIButton                  *_btEdit;
    IBOutlet UIView                    *_viewSearch;
    IBOutlet UIButton                  *_btSelect;
    BOOL                                _bEdit;
    IBOutlet UITableView               *_tbStoreList;
    IBOutlet UIView                    *_viewFrame;
    IBOutlet RPVisualMerchandisingView *_viewVisualMerchandising;
    BOOL                                _bVisualMerchandisingView;
    RPStoreListView                    *_viewStoreList;
    IBOutlet UIImageView               *_ivBottom;
    NSMutableArray                     *_arrayFollowStore;
    NSMutableArray                     *_arraySearch;
    IBOutlet UITextField               *_tfSearch;
    BOOL                                _bStoreList;
    NSMutableArray                     *_arrayAddStore;
    NSMutableArray                     *_arrayDeleteStore;
    MJRefreshHeaderView                *_header;
    UILabel                            *_label;
    StoreDetailInfo                    *_currentStoreInfo;
}
@property(nonatomic,assign)id<RPVisualStoreListViewDelegate>delegate;
@property (nonatomic,assign) UIViewController * vcFrame;
@property (nonatomic,assign) StoreDetailInfo * storeSelected;
- (IBAction)OnAddStore:(id)sender;
- (IBAction)OnSelectAll:(id)sender;
- (IBAction)OnSearch:(id)sender;
- (IBAction)OnDeleteSearch:(id)sender;
-(BOOL)OnBack;
- (IBAction)OnHelp:(id)sender;
-(IBAction)OnQuit:(id)sender;
@end
