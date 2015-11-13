//
//  RPChangeBindEmailView.h
//  RetailPlus
//
//  Created by lin dong on 13-11-13.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPVerifyThroughView.h"

@interface RPChangeBindEmailView : UIView
{
    IBOutlet UIView              * _viewFrame;
    IBOutlet UIView              * _viewNewEmail;
    IBOutlet UIView              * _viewCode;
    IBOutlet UIButton            * _btnSendCode;
    IBOutlet UITextField         * _tfMail;
    IBOutlet UITextField         * _tfCode;
    
    IBOutlet RPVerifyThroughView * _viewVerifyThrough;
    BOOL                         _bNext;
}

@property (nonatomic,assign) id<RPAccountSetupViewControllerDelegate> delegate;

-(IBAction)OnGetCode:(id)sender;
-(IBAction)OnVerify:(id)sender;
-(BOOL)OnBack;

@end
