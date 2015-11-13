//
//  RPBindEmailView.h
//  RetailPlus
//
//  Created by lin dong on 13-11-13.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPAccountSetupViewControllerDelegate.h"

@interface RPBindEmailView : UIView
{
    IBOutlet UIView     * _viewFrame;
    IBOutlet UIView     * _viewTextFrame;
    IBOutlet UIButton   * _btnSend;
    IBOutlet UITextField * _tfEmail;
    
    NSTimer             * _timer;
    NSInteger           _nRemain;
}

@property (nonatomic,assign) id<RPAccountSetupViewControllerDelegate> delegate;

-(void)Show;
-(IBAction)OnSend:(id)sender;
-(IBAction)OnOk:(id)sender;
@end
