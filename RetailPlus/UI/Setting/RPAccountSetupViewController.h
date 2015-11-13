//
//  RPAccountSetupViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-10-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
#import "RPChangePswView.h"
#import "RPAccountSecView.h"
#import "RPMainViewController.h"
#import "RPAccountSetupViewControllerDelegate.h"

@interface RPAccountSetupViewController : RPTaskBaseViewController<RPChangePswViewDelegate,RPAccountSetupViewControllerDelegate>
{
    IBOutlet    UIView              * _viewFrame;
    IBOutlet    RPChangePswView     * _viewChangePsw;
    IBOutlet    RPAccountSecView    * _viewAccountSec;
    IBOutlet    UIView              * _viewBtnFrame;
    IBOutlet    UIImageView         * _viewWarning;
    BOOL        _bChangePsw;
    BOOL        _bAccountSec;
}

@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;

-(IBAction)OnAccountSecurity:(id)sender;
-(IBAction)OnChangePsw:(id)sender;

@end
