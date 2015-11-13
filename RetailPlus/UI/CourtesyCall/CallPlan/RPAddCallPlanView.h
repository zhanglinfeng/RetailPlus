//
//  RPAddCallPlanView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-14.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPCustomerListView.h"
#import "RPSwitchView.h"
#import "RPDatePicker.h"
@protocol RPAddCallPlanViewDelegate<NSObject>
-(void)endAddCallPlan;//完全退出该功能
@end
@protocol RPAddCallPlanViewOKDelegate<NSObject>
-(void)endAddCallPlanOK;//添加回访计划后回到计划列表
-(void)backToStart;
@end

@interface RPAddCallPlanView : UIView<UITextViewDelegate,RPCustomerSelectDelegate,RPSwitchViewDelegate,UITextFieldDelegate>
{
    IBOutlet UIView                      *_viewFrame;
    IBOutlet UIImageView                 *_ivHeader;
    RPCustomerListView                   *_viewCustomerList;
    IBOutlet UIImageView                 *_viewBottom;
    NSInteger                            _index;
    IBOutlet UIButton *_btCustomer;
    IBOutlet UILabel  * _lbCustomer;
    
    IBOutlet UIButton *_btPurpose;
    IBOutlet UILabel *_lbPhoneNumber;
    IBOutlet UIImageView *_ivPhone;
    IBOutlet UIImageView *_ivVip;
    CourtesyCallType *_callType;
    IBOutlet UITextView *_tvRemarks;
    IBOutlet UITextField *_tfDate;
    IBOutlet UITextField *_tfTime;
    IBOutlet UIView *_viewSwitch;
    RPDatePicker *_datePicker;
    RPDatePicker *_TimePicker;
    NSDate *_date;
    NSDate *_remindTime;
    BOOL _bCustomerList;
    RPSwitchView          * _switchRemind;
    BOOL _bRemind;
    IBOutlet UIView *_viewBackground;

}
@property(nonatomic,assign)id<RPAddCallPlanViewDelegate>delegate;
@property(nonatomic,assign)id<RPAddCallPlanViewOKDelegate>delegateOK;
@property(nonatomic,strong)Customer *customer;
@property(nonatomic,strong)NSArray *arrayType;
@property(nonatomic,assign)int entrance;//1代表从添加计划进入本界面，2代表从打电话进入本界面
@property(nonatomic,strong)CourtesyCallInfo * courtesyCallInfo;
@property(nonatomic)BOOL bModify;
- (IBAction)OnHelp:(id)sender;
-(IBAction)OnQuit:(id)sender;
-(IBAction)OnOK:(id)sender;
-(BOOL)OnBack;
- (IBAction)OnSelectCustomer:(id)sender;
- (IBAction)OnSelectCallPurpose:(id)sender;
@end
