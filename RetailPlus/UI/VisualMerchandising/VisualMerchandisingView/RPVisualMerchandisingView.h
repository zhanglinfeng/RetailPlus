//
//  RPVisualMerchandisingView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPAddExhibitView.h"
#import "RPVisualMerchandisingDetailView.h"
#import "UIMarqueeLabel.h"
#import "MJRefreshHeaderView.h"
#import "RPVMGuideView.h"
#import "RPStoreInfoView.h"
@protocol RPVisualMerchandisingViewDelegate<NSObject>
-(void)endVisualMerchandising;
@end
@interface RPVisualMerchandisingView : UIView<UITableViewDelegate,UITableViewDataSource,RPAddExhibitViewDelegate>
{
    
    IBOutlet UIView                           *_viewFrame;
    IBOutlet RPAddExhibitView                 *_viewAddExhibit;
    IBOutlet RPVisualMerchandisingDetailView  *_viewVisualDetail;
    IBOutlet UIView                           *_viewLine;
    IBOutlet UIImageView                      *_ivTriange;
    BOOL                                       _bShowMenu;
    BOOL                                       _bAddView;
    BOOL                                       _bVisualDetailView;
    BOOL                                       _bStoreInfoView;
    IBOutlet UIView                           *_viewMenu;
    IBOutlet UITableView *_tbVisual;
    IBOutlet UIMarqueeLabel *_lbBrandName;
    IBOutlet UIMarqueeLabel *_lbStoreName;
    IBOutlet UIButton *_btPass;
    IBOutlet UIButton *_btReject;
    IBOutlet UIButton *_btPending;
    IBOutlet UIView *_viewHead;
   
    IBOutlet UIButton *_btMenu;
    IBOutlet RPVMGuideView *_viewGuide;
    BOOL   _bGuide;
    IBOutlet UILabel *_lbPass;
    IBOutlet UILabel *_lbReject;
    IBOutlet UILabel *_lbpending;
    NSMutableArray *_arrayVisualDisplay;
    NSMutableArray *_arrayShow;
    IBOutlet RPStoreInfoView *_viewStoreInfo;
    UILabel                            *_label;
}
@property(nonatomic,assign)id<RPVisualMerchandisingViewDelegate>delegate;
@property (nonatomic,assign) UIViewController * vcFrame;
@property (nonatomic,strong) FollowStore * followStore;
@property (nonatomic,strong) StoreDetailInfo * storeInfo;
-(BOOL)OnBack;
- (IBAction)OnAddExhibit:(id)sender;
- (IBAction)OnShowMenu:(id)sender;
- (IBAction)OnGuide:(id)sender;
- (IBAction)OnPass:(id)sender;
- (IBAction)OnReject:(id)sender;
- (IBAction)OnPending:(id)sender;
- (IBAction)OnStoreInfo:(id)sender;
- (IBAction)OnHelp:(id)sender;
-(IBAction)OnQuit:(id)sender;

@end
