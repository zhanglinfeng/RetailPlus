//
//  RPCourtesyCallView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-11.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPCourtesyCallRecordView.h"
#import "RPCustomerListView.h"
#import "RPConfirmPhoneNumberView.h"
#import "RPAddCallPlanView.h"
typedef enum
{
    CALLSTEP_SELF = 0,
    CALLSTEP_CUSTOMER,
    CALLSTEP_CALLRECORD,
    CALLSTEP_MAKEPLAN,
}CALLSTEP;
@protocol RPCourtesyCallViewDelegate<NSObject>
-(void)endCourtesyCall;
-(void)completeRecord;
@end
@interface RPCourtesyCallView : UIView<RPCustomerSelectDelegate,RPConfirmPhoneNumberViewDelegate>

{
    IBOutlet RPCourtesyCallRecordView    *_viewCallRecord;
    IBOutlet UIView                      *_viewFrame;
    IBOutlet UIImageView                 *_ivHeader;
    RPCustomerListView                   *_viewCustomerList;
    IBOutlet UIImageView                 *_viewBottom;
    CALLSTEP                             _step;
    IBOutlet RPConfirmPhoneNumberView    *_viewConfirmNumber;
    NSInteger                            _index;
    IBOutlet UIButton *_btCustomer;
    IBOutlet UILabel  *_lbCustomer;
    
    IBOutlet UIButton *_btPurpose;
    IBOutlet UILabel *_lbPhoneNumber;
    IBOutlet UIImageView *_ivPhone;
    IBOutlet UIButton *_btCall;
    IBOutlet UIButton *_btMakePlan;
    IBOutlet UIButton *_btGoRecord;
    IBOutlet UIImageView *_ivVip;
    CourtesyCallType *_callType;
    IBOutlet UITextView *_tvGuide;
    IBOutlet RPAddCallPlanView *_viewAddCallPlan;
    IBOutlet UILabel *_lbTitle1;
    IBOutlet UILabel *_lbTitle2;
    IBOutlet UIView *_viewBackground;
    BOOL _bCheck;
}
@property(nonatomic,assign)id<RPCourtesyCallViewDelegate>delegate;
@property(nonatomic,assign)id<RPCallRecordViewFromPlanDelegate>delegateOK;

@property(nonatomic,strong)Customer *customer;
@property(nonatomic,strong)NSArray *arrayType;
@property(nonatomic,strong)CourtesyCallInfo * courtesyCallInfo;
@property(nonatomic,assign)int entrance;//1代表直接进入该界面，2代表从计划列表进入该界面
- (IBAction)OnHelp:(id)sender;
-(IBAction)OnQuit:(id)sender;
-(BOOL)OnBack;
- (IBAction)OnCompleteRecord:(id)sender;
- (IBAction)OnSelectCustomer:(id)sender;
- (IBAction)OnMakePlan:(id)sender;
- (IBAction)OnCall:(id)sender;
- (IBAction)OnSelectCallPurpose:(id)sender;
@end
