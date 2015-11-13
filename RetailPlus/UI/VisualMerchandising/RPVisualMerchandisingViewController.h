//
//  RPVisualMerchandisingViewController.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTaskBaseViewController.h"
#import "RPMainViewController.h"
#import "RPVisualStoreListView.h"
#import "RPVMGuideView.h"
#import "RPVisualMerchandisingView.h"
#import "RPVisualMerchandisingDetailView.h"
@interface RPVisualMerchandisingViewController : RPTaskBaseViewController<RPVisualStoreListViewDelegate,RPVisualMerchandisingViewDelegate,RPVisualMerchandisingDetailViewDelegate,RPVMGuideViewDelegate>
{
    IBOutlet RPVisualStoreListView    *_viewVisualStoreList;
    IBOutlet RPVMGuideView *_viewGuide;
    BOOL                               _bProject;
    BOOL                               _bGuide;
    IBOutlet RPVisualMerchandisingView *_viewVisualMerchandising;
    IBOutlet RPVisualMerchandisingDetailView *_viewVisualDetail;
}
@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;
@property (nonatomic,assign) UIViewController * vcFrame;
- (IBAction)OnVMProjects:(id)sender;
- (IBAction)OnVMGuide:(id)sender;
- (IBAction)OnHelp:(id)sender;
@end
