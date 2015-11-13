//
//  RPEmailVerifyingView.h
//  RetailPlus
//
//  Created by lin dong on 13-11-14.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPAccountSetupViewControllerDelegate.h"

@interface RPEmailVerifyingView : UIView
{
    IBOutlet UIView     * _viewFrame;
    IBOutlet UIButton   * _btnSend;
    NSTimer             * _timer;
    NSInteger           _nRemain;
}
@property (nonatomic,assign) id<RPAccountSetupViewControllerDelegate> delegate;
@property (nonatomic,retain) NSString * strEmail;

-(void)Show;
-(IBAction)OnSend:(id)sender;
-(IBAction)OnOK:(id)sender;

@end
