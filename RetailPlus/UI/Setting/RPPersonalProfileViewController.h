//
//  RPPersonalProfileViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-10-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
#import "RPSwitchView.h"
//#import "RPPersonalProfileView.h"
#import "RPCareerView.h"
#import "RPAddReceiverViewController.h"
#import "RPPositionMngView.h"
#import "RPMaintenViewController.h"

@class RPPersonalProfileView;
//@protocol RPPersonalProfileViewControllerDelegate <NSObject>
//-(void)saveOK;
//@end
@interface RPPersonalProfileViewController : RPTaskBaseViewController<RPAddReceiverViewControllerDelegate>
{
    IBOutlet UIView                 * _viewFrame;
    IBOutlet UILabel                * _lbTab1;
    IBOutlet UILabel                * _lbTab2;
    IBOutlet UIScrollView           * _viewContainer;
    IBOutlet RPPersonalProfileView  * _viewPersonalProfile;
    IBOutlet RPCareerView           * _viewCareer;
    IBOutlet RPPositionMngView      * _viewPosMng;
    
    RPAddReceiverViewController     * _vcAddReceiver;
    BOOL                            _bShowSelectReporter;
    BOOL                            _bShowPosMng;
    BOOL                            _bMngPosition;
}

@property (nonatomic,assign) UIViewController   * vcFrame;
@property (nonatomic,assign) UserDetailInfo * loginProfile;
@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegateMain;
@property (nonatomic,assign) id<RPSettingViewControllerDelegate> delegate;
//@property(nonatomic,assign)id<RPPersonalProfileViewControllerDelegate>personalProfileDelegate;
-(IBAction)OnTab1:(id)sender;
-(IBAction)OnTab2:(id)sender;
- (IBAction)OnOK:(id)sender;

@end
