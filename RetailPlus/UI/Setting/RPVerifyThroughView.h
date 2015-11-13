//
//  RPVerifyThroughView.h
//  RetailPlus
//
//  Created by lin dong on 13-11-14.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPAccountSetupViewControllerDelegate.h"
#import "RPMobileVerifyingView.h"
#import "RPEmailVerifyingView.h"

@interface RPVerifyThroughView : UIView
{
    IBOutlet UIView                * _viewFrame;
    IBOutlet RPMobileVerifyingView * _viewMobileVerify;
    IBOutlet RPEmailVerifyingView  * _viewEmailVerify;
    
    BOOL        _bByMobile;
    BOOL        _bByEmail;
}

@property (nonatomic,retain) NSString * strEmail;
@property (nonatomic,assign) id<RPAccountSetupViewControllerDelegate> delegate;
-(BOOL)OnBack;

-(IBAction)OnByMobile:(id)sender;
-(IBAction)OnByEmail:(id)sender;

@end
