//
//  RPSignUpProfileViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-8-13.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSignUpViewController.h"
#import "RPSwitchView.h"

@interface RPSignUpProfileViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,RPSwitchViewDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIView * _viewUserName;
    IBOutlet UIView * _viewSurName;
    IBOutlet UIView * _viewEmail;
    IBOutlet UIButton * _btnDone;
    IBOutlet UIView   * _viewUserImg;
    IBOutlet UIButton * _btnUserImg;
    
    IBOutlet UITextField    * _tfFirstName;
//    IBOutlet UITextField    * _tfSurName;
    IBOutlet UITextField    * _tfEmail;
    
    IBOutlet UIView         * _viewSex;
    IBOutlet UILabel        * _lbMale;
    IBOutlet UILabel        * _lbFemale;
    
    RPSwitchView            * _switchSex;
    UIImage                 * _imgUser;
    BOOL                    _bFemale;
}

@property (nonatomic,retain) NSString * strUserAccount;
@property (nonatomic,retain) NSString * strUserPassword;

@property (nonatomic,retain) id<RPSignUpViewControllerDelgate> delegate;
@property (nonatomic,assign) UIViewController * vcFrame;
@property (nonatomic) NSInteger nInvitedStatus;

-(IBAction)OnTakePhoto:(id)sender;
-(IBAction)OnOk:(id)sender;
@end
