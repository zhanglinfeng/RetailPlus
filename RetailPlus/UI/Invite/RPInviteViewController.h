//
//  RPInviteViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-8-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPBLogic.h"
#import "RPTaskBaseViewController.h"
#import "RPInviteRoleVIew.h"
#import "RPInviteRangeView.h"
#import "RPInviteUnitVIew.h"
#import "RPMainViewController.h"

@interface RPInviteViewController : RPTaskBaseViewController<RPInviteRoleViewDelegate,RPInviteUnitViewDelegate>
{
    IBOutlet UIView                 * _viewPhoneFrame;
    IBOutlet UIView                 * _viewUserNameFrame;
    IBOutlet UIButton               * _btnRole;
    IBOutlet UIButton               * _btnRange;
    IBOutlet UIButton               * _btnUnit;
    IBOutlet UIButton               * _btnInvite;
    IBOutlet UITextField            * _tfPhone;
    IBOutlet UITextField            * _tfUserName;
    
    IBOutlet RPInviteRoleVIew       * _viewRole;
    IBOutlet RPInviteRangeView      * _viewRange;
    IBOutlet RPInviteUnitView       * _viewUnit;
    
    UIView                          * _viewShow;
    
    NSMutableArray                  * _arrayRange;
    NSMutableArray                  * _arrayUnit;
    
    InviteRole                      * _roleCurrent;
    InvitePosition                  * _positionCurrent;
}

@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;
@property (nonatomic,assign) UIViewController * vcFrame;

-(IBAction)OnRole:(id)sender;
-(IBAction)OnRange:(id)sender;
-(IBAction)OnUnit:(id)sender;
-(IBAction)OnInvite:(id)sender;

@end
