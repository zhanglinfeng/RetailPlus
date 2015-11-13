//
//  RPCodeQueryViewController.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-4-29.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTaskBaseViewController.h"
#import "RPMainViewController.h"
#import "RPCodeResultView.h"
#import "RPBarViewController.h"
#import "RPCodeQueryHistoryView.h"
@interface RPCodeQueryViewController : RPTaskBaseViewController<RPBarViewControllerDelegate,RPCodeQueryHistoryViewDelegate,RPCodeResultViewDelegate>
{
    
    IBOutlet RPCodeResultView *_viewCodeResult;
    IBOutlet RPCodeQueryHistoryView *_viewHistory;
    BOOL                      _bResultView;
    BOOL                      _bHistory;
}
@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;
@property (nonatomic,assign) UIViewController * vcFrame;
- (IBAction)OnNewQuery:(id)sender;
- (IBAction)OnQueryHistory:(id)sender;
@end
