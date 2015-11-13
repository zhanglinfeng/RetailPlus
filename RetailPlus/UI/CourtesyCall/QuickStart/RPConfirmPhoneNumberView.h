//
//  RPConfirmPhoneNumberView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-13.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPCCMakeCallView.h"

@protocol RPConfirmPhoneNumberViewDelegate <NSObject>
-(void)OnRPCCCallEnd;
@end

@interface RPConfirmPhoneNumberView : UIView<RPCCMakeCallViewDelegate>
{
    IBOutlet UIView *_viewPutIn;
    IBOutlet UITextField *_tfPhoneNumber;
    IBOutlet RPCCMakeCallView * _viewMakeCall;
}

@property(nonatomic,assign)id<RPConfirmPhoneNumberViewDelegate> delegate;
@property(nonatomic,strong)CourtesyCallInfo *courtesyCallInfo;
@property(nonatomic,strong)Customer *customer;
@property(nonatomic,strong)CourtesyCallType *callType;

- (IBAction)OnCall:(id)sender;
- (IBAction)OnCancel:(id)sender;

@end
