//
//  RPCacheManagementViewController.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-4-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
//#import "RPMainViewController.h"
@interface RPCacheManagementViewController :RPTaskBaseViewController
{
    
    IBOutlet UIView *_viewBackground;
    IBOutlet UIView *_viewClear;
    IBOutlet UILabel *_lbAll;
    IBOutlet UILabel *_lbSystem;
    IBOutlet UILabel *_lbDocument;
    IBOutlet UILabel *_lbTraining;
    IBOutlet UIView *_viewTable;
    IBOutlet UIButton *_btSelectAll;
    IBOutlet UIButton *_btSelectTraining;
    IBOutlet UIButton *_btSelectDocument;
    IBOutlet UIButton *_btSelectSystem;
}
//@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;
@property (nonatomic,assign) UIViewController * vcFrame;
- (IBAction)OnClean:(id)sender;
- (IBAction)OnSelectAll:(id)sender;
- (IBAction)OnSelectTraining:(id)sender;
- (IBAction)OnSelectDocument:(id)sender;
- (IBAction)OnSelectSystem:(id)sender;


@end
