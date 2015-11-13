//
//  RPMobileVerifyingView.h
//  RetailPlus
//
//  Created by lin dong on 13-11-14.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPAccountSetupViewControllerDelegate.h"

@interface RPMobileVerifyingView : UIView
{
    IBOutlet UIView     * _viewFrame;
    IBOutlet UIView     * _viewCodeFrame;
    IBOutlet UIButton   * _btnSendAgain;
    IBOutlet UITextField * _tfCode;
    NSTimer             * _timer;
    NSInteger           _nRemain;
}

@property (nonatomic,retain) NSString * strEmail;
@property (nonatomic,assign) id<RPAccountSetupViewControllerDelegate> delegate;

-(void)Show;
-(IBAction)OnSend:(id)sender;
-(IBAction)OnVerify:(id)sender;

@end
