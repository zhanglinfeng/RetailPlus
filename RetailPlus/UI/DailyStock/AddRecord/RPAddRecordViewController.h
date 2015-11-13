//
//  RPAddRecordViewController.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTaskNavViewController.h"
#import "RPCountViewController.h"
#import "RPCountViewController.h"
#import "AutocompletionTableView.h"
@protocol RPAddRecordViewControllerDelegate <NSObject>
-(void)endAddRecord;
@end
@interface RPAddRecordViewController : RPTaskNavViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RPCountViewControllerDelegate,UITextViewDelegate>
{
    IBOutlet UIView *_viewFrame;
    IBOutlet UIView *_viewMark;
    IBOutlet UIView *_viewHeader;
    IBOutlet UIView *_viewWhite;
    IBOutlet UIView *_viewCurrentMark;
    IBOutlet UITableView *_tbMark;
    IBOutlet UIButton *_btMenu;
    IBOutlet UITextField *_tfMark1;
    IBOutlet UITextField *_tfMark2;
    IBOutlet UITextField *_tfMark3;
    IBOutlet UIImageView *_ivMark1;
    IBOutlet UIImageView *_ivMark2;
    IBOutlet UIImageView *_ivMark3;
    IBOutlet UIView *_viewCount;
    IBOutlet UIButton *_btBlanket;
    
    IBOutlet UIView *_viewInOut;
    IBOutlet UIView *_viewEnter;
    IBOutlet UIView *_viewDeliver;
    IBOutlet UILabel *_lbEnter;
    IBOutlet UILabel *_lbDeliver;
    IBOutlet UIImageView *_ivEnter;
    IBOutlet UIImageView *_ivDeliver;
    IBOutlet UIImageView *_ivIO;
    IBOutlet UITextField *_tfCount;
    
    IBOutlet UIView *_viewReason;
    IBOutlet UITextView *_tvReason;
    
    RPCountViewController *_vcCount;
    NSInteger _type;
    
    NSMutableArray *_arrayTag;
    BOOL _bModify;
}
@property (nonatomic,weak)id<RPAddRecordViewControllerDelegate>delegateAddRecord;
@property (nonatomic,assign) UIViewController * vcFrame;
@property (nonatomic,assign) StoreDetailInfo * storeSelected;
@property (nonatomic,assign) NSInteger sn;
-(IBAction)OnMenu:(id)sender;
-(IBAction)OnClear:(id)sender;
-(IBAction)OnEnter:(id)sender;
-(IBAction)OnDeliver:(id)sender;
- (IBAction)OnOK:(id)sender;
@end
