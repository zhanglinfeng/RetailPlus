//
//  RPSignUpChgPswViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-8-13.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSignUpViewController.h"

@interface RPSignUpChgPswViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
{
    IBOutlet UIView         * _viewChgPsw;
    IBOutlet UIButton       * _btnChgPsw;
    
    IBOutlet UITextField    * _tfPsw;
    IBOutlet UITextField    * _tfPswConfirm;
    
    IBOutlet UIImageView    * _ivYes;
    IBOutlet UIImageView    * _ivNo;
}
@property (nonatomic,retain) NSString * strUserAccount;

@property (nonatomic,retain) id<RPSignUpViewControllerDelgate> delegate;
@property (nonatomic,assign) UIViewController * vcFrame;
@property (nonatomic,retain) NSString * strPhoneNo;
@property (nonatomic) NSInteger nInvitedStatus;
-(IBAction)OnOk:(id)sender;
@end
