//
//  RPDSNewCountViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-7-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskNavViewController.h"
#import "RPCountViewController.h"
#import "RPCountViewController.h"
#import "AutocompletionTableView.h"
@protocol RPDSNewCountViewControllerDelegate <NSObject>
-(void)endCount;
@end
@interface RPDSNewCountViewController : RPTaskNavViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,RPCountViewControllerDelegate>
{
    IBOutlet UIView *_viewFrame;
    IBOutlet UIView *_viewMark;
    IBOutlet UIView *_viewHeader;
    IBOutlet UIView *_viewCurrentMark;
    IBOutlet UITableView *_tbMark;
    IBOutlet UIButton *_btMenu;
//    IBOutlet UIView *_viewBlanket;
    IBOutlet UITextField *_tfMark1;
    IBOutlet UITextField *_tfMark2;
    IBOutlet UITextField *_tfMark3;
    IBOutlet UIImageView *_ivMark1;
    IBOutlet UIImageView *_ivMark2;
    IBOutlet UIImageView *_ivMark3;
    IBOutlet UIView *_viewCount;
    IBOutlet UIButton *_btBlanket;
    IBOutlet UITextField *_tfCount;
    RPCountViewController *_vcCount;
    BOOL _bModify;
    NSMutableArray *_arrayTag;
//    int _mode;
}
@property (nonatomic,weak)id<RPDSNewCountViewControllerDelegate>delegateNewCount;
@property (nonatomic,assign) UIViewController * vcFrame;
@property (nonatomic,assign) StoreDetailInfo * storeSelected;
@property (nonatomic,assign) NSInteger sn;
-(IBAction)OnMenu:(id)sender;
-(IBAction)OnClear:(id)sender;
- (IBAction)OnOK:(id)sender;
@end
