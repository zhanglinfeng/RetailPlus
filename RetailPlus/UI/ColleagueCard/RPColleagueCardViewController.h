//
//  RPColleagueCardViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-8-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
#import <MessageUI/MessageUI.h>

@protocol RPColleagueCardViewControllerDelegate <NSObject>
    -(void)OnCustomerlist:(UserDetailInfo *)colleague;
    -(void)OnModifyUserProfile:(UserDetailInfo *)colleague;
    -(void)OnModifyUserStatus;
@end

@interface RPColleagueCardViewController : RPTaskBaseViewController<MFMessageComposeViewControllerDelegate>
{
    IBOutlet UIView         * _viewFrame;
    IBOutlet UIView         *_viewTask;
    IBOutlet UIView *_view1;
    IBOutlet UIView *_view2;
    IBOutlet UIView *_view3;
    IBOutlet UIView *_view4;
    IBOutlet UIButton       * _btnSizeChg;
    IBOutlet UIView         * _viewRoleCol;
    IBOutlet UIButton       * _btnStore;
    IBOutlet UILabel *_lbStore;
    
    IBOutlet UILabel        * _lbColleagueName;
    IBOutlet UILabel        * _lbRoleDesc;
    IBOutlet UILabel        * _lbPhone;
    IBOutlet UIImageView    * _ivSex;
    IBOutlet UIImageView    * _ivPic;
    IBOutlet UIImageView *_ivStore;
    
    IBOutlet UIScrollView *_svFrame;
    IBOutlet UIView *_viewInfo;
    
    IBOutlet UILabel *_lbEmail;
    IBOutlet UILabel *_lbAlternatePhone;
    IBOutlet UILabel *_lbReportto;
    IBOutlet UILabel *_lbBoardDate;
    IBOutlet UITextView *_tvOfficeAddress;
    IBOutlet UILabel *_lbOfficePhone;
    IBOutlet UILabel *_lbStore1;
    IBOutlet UILabel *_lbRoleDesc1;
    IBOutlet UILabel *_lbStore2;
    IBOutlet UILabel *_lbRoleDesc2;
    IBOutlet UITextView *_tvInterest;
    
    IBOutlet UIButton   * _btnUserMng;
    IBOutlet UIButton   * _btnResetPsw;
    IBOutlet UIButton   * _btnLockUser;
    IBOutlet UILabel    * _lbUserMng;
    IBOutlet UILabel    * _lbResetPsw;
    IBOutlet UILabel    * _lbLockUser;
    IBOutlet UIView     * _viewLock;
    
    BOOL                    _bSmall;
    BOOL                    _bLockStaChg;
}

@property (nonatomic,assign) id<RPColleagueCardViewControllerDelegate> delegate;
@property (nonatomic,assign) UserDetailInfo     * colleague;
@property (nonatomic,assign) UIViewController   * vcFrame;

- (IBAction)OnSizeChg:(id)sender;
- (IBAction)OnCall:(id)sender;
- (IBAction)OnMessage:(id)sender;
- (IBAction)OnClient:(id)sender;
- (IBAction)OnUserLock:(id)sender;
- (IBAction)OnResetPassword:(id)sender;
- (IBAction)OnUserMng:(id)sender;

@end
