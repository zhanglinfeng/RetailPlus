//
//  RPSignUpVerifyViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-8-13.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPSignUpVerifyViewController : UIViewController
{
    IBOutlet UIView         * _viewPhone;
    IBOutlet UIView         * _viewVerify;
    IBOutlet UIButton       * _btnGetCode;
    IBOutlet UIButton       * _btnVerify;
    IBOutlet UITextField    * _tfCode;
    IBOutlet UITextField    * _tfPhone;
    
    NSTimer                 * _timer;
    NSInteger               _nRemain;
}

@property (nonatomic,retain) id delegate;
@property (nonatomic,assign) UIViewController * vcFrame;
-(IBAction)OnVerify:(id)sender;
@end
