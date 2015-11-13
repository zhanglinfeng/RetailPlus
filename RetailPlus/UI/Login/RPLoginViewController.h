//
//  RPLoginViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-8-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "RPSignUpViewController.h"
#import "RPForgetPswViewController.h"

@protocol RPLoginViewControllerDelegate <NSObject>
    -(void)OnSignUpSuccess:(NSInteger)nInviteStatus;
    -(void)OnLoginSuccess;
@end

@interface RPLoginViewController : UIViewController<UITextFieldDelegate,RPSignUpViewControllerDelgate>
{
    IBOutlet UIImageView    * _ivBack;
    IBOutlet UIButton       * _btnLogin;
    IBOutlet UIButton       * _btnSignUp;
    IBOutlet UIButton       * _btnHelp;
    IBOutlet UIView         * _viewFrame;
    
    IBOutlet UITextField    * _textUserName;
    IBOutlet UITextField    * _textPassWord;
    
    IBOutlet UIView         * _viewThrough;
    IBOutlet UIView         * _viewVerify;
    IBOutlet UIView         * _viewVerifyFrame;
    IBOutlet UITextField    * _tfVerify;
    IBOutlet UILabel        * _lbVerifyDesc;
    IBOutlet UIButton       * _btnGetCode;
    IBOutlet UIImageView    * _ivAutoLogin;
    
    IBOutlet UITextField    * _tfUrl;
    
    IBOutlet UIView         * _viewSignUpAgree;
    IBOutlet UIView         * _viewSignUpBorder;
    IBOutlet UIWebView      * _webSignUpAgree;
    
    IBOutlet UILabel        * _lbLabel;
    
    CertDevice              _deviceCert;
    NSInteger               _nRemain;
    NSTimer                 * _timer;
    BOOL                    _bAutoLogin;
    int                     loginCount;
   // BOOL                    _bServerAvailable;
    
    NSString                * _strUserName;
    int                     _pingCount;//ping通其他网站次数
    int                     _pingSuccessCount;//ping通其他网站次数
}

@property (nonatomic,assign) id<RPLoginViewControllerDelegate> delegate;

-(IBAction)OnLogin:(id)sender;
-(IBAction)OnSignUp:(id)sender;
-(IBAction)OnSignUpAgree:(id)sender;
-(IBAction)OnFindPsw:(id)sender;

-(IBAction)OnByPhone:(id)sender;
-(IBAction)OnByEmail:(id)sender;
-(IBAction)OnGetCode:(id)sender;
-(IBAction)OnVerify:(id)sender;

-(IBAction)OnThroughBack:(id)sender;
-(IBAction)OnVerifyBack:(id)sender;
-(IBAction)OnSignUpAgreeBack:(id)sender;

-(IBAction)OnAutoLogin:(id)sender;

@end
