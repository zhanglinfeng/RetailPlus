//
//  RPAddTaskView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-9-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPDatePicker.h"
#import "RPAddReceiverViewController.h"
@protocol RPAddTaskViewDelegate <NSObject>
-(void)backToTask;
@end
@interface RPAddTaskView : UIView<RPAddReceiverViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    IBOutlet UIView *_viewFrame;
    IBOutlet UILabel *_lbTitle;
   
    IBOutlet UITextField *_tfTaskTitle;
    IBOutlet UITextView *_tvTaskDesc;
    IBOutlet UIButton *_btExecutor;//执行人员
    IBOutlet UIButton *_btEndDate;
    IBOutlet UIButton *_btGreen;
    IBOutlet UIButton *_btGray;
    IBOutlet UIButton *_btPurple;
    IBOutlet UIButton *_btRed;
    IBOutlet UIButton *_btYellow;
    IBOutlet UIButton *_btBlueGreen;
    IBOutlet UIView *_view1;
    IBOutlet UIView *_view2;
    IBOutlet UIView *_view3;
    IBOutlet UIView *_view4;
    NSMutableArray *_arrayTask;
    IBOutlet UIView *_viewColor;
    IBOutlet UIView *_viewTag;
    IBOutlet UITextField *_tfDate;
    IBOutlet UIButton *_btAllDay;
    RPDatePicker *_pickDate;
    
    BOOL _bReceiverList;
    IBOutlet UIImageView *_viewBottom;
    RPAddReceiverViewController              * _vcAddReceiver;
    IBOutlet UILabel *_lbExe;
    IBOutlet UIScrollView *_svFrame;
}
@property(nonatomic,weak)id<RPAddTaskViewDelegate> delegate;
@property(nonatomic,retain)NSMutableArray * arrayIssue;
@property(nonatomic,retain)TaskInfo *task;
- (IBAction)OnGray:(id)sender;
- (IBAction)OnPurple:(id)sender;
- (IBAction)OnRed:(id)sender;
- (IBAction)OnYellow:(id)sender;
- (IBAction)OnGreen:(id)sender;
- (IBAction)OnBlueGreen:(id)sender;
- (IBAction)OnAllDay:(id)sender;
- (IBAction)OnSelectCustomer:(id)sender;
-(BOOL)OnBack;
- (IBAction)OnOK:(id)sender;
@end
