//
//  RPAccountSecView.h
//  RetailPlus
//
//  Created by lin dong on 13-11-13.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPBindEmailView.h"
#import "RPAccountSetupViewControllerDelegate.h"
#import "RPChangeBindEmailView.h"
#import "RPLoginProtectView.h"
#import "RPLoginAutoView.h"

@interface RPAccountSecView : UIView
{
    IBOutlet UIView                 * _viewFrame;
    
    IBOutlet UIView                 * _viewGroup1;
    IBOutlet UIView                 * _viewGroup2;
    IBOutlet UIImageView            * _viewWarning1;
    IBOutlet UIImageView            * _viewWarning2;
    IBOutlet UIImageView            * _viewNext;
    IBOutlet UIImageView            * _viewRebound;
    
    IBOutlet UILabel                * _lbRpID;
    IBOutlet UILabel                * _lbMobile;
    IBOutlet UILabel                * _lbEmail;
    IBOutlet UILabel                * _lbWarning;
    
    IBOutlet RPChangeBindEmailView  * _viewChgBindEmail;
    IBOutlet RPBindEmailView        * _viewBindEmail;
    IBOutlet RPLoginProtectView     * _viewLoginProtect;
    IBOutlet RPLoginAutoView        * _viewLoginAuto;
    IBOutlet UILabel                * _lbEnableLoginProtect;
    
    IBOutlet UILabel *_lbEnableLoginAuto;
    BOOL                            _bBindEmail;
    BOOL                            _bChangeBindEmail;
    BOOL                            _bLoginProtect;
    BOOL                            _bLoginAuto;
}

@property (nonatomic,assign) id<RPAccountSetupViewControllerDelegate> delegate;

-(IBAction)OnLoginProtect:(id)sender;
- (IBAction)OnLoginAuto:(id)sender;
-(IBAction)OnBindEmail:(id)sender;
-(BOOL)OnBack;

@end
