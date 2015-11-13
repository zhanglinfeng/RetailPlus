//
//  RPFeedbackViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-10-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "RPTaskBaseViewController.h"
#import "RPMainViewController.h"

@interface RPFeedbackViewController : RPTaskBaseViewController<MFMailComposeViewControllerDelegate>
{
    IBOutlet    UIView      * _viewFrame;
    IBOutlet    UITextView  * _tvFeedback;
    IBOutlet    UIButton    * _btnSubmit;
    
    MFMailComposeViewController * _mailPicker;
}

@property (nonatomic,assign) UIViewController * vcFrame;
@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;

-(IBAction)OnOk:(id)sender;
@end
