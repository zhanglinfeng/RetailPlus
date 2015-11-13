//
//  RPSettingViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-9-18.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSystemTaskBaseViewController.h"

@protocol RPSettingViewControllerDelegate <NSObject>
@optional
-(void)OnAccountSetup;
-(void)OnPersonalProfile;
-(void)OnChgLang;
//-(void)OnFeedback;
-(void)OnAbout;
-(void)OnLogout;
-(void)OnChangeProfileEnd;
-(void)OnBackTask;
-(void)OnCacheManagement;
-(void)OnDeleteUser;
@end

@interface RPSettingViewController : RPSystemTaskBaseViewController
{
    IBOutlet UIView * _viewFrame;
    IBOutlet UILabel * _lbAccount;
    IBOutlet UILabel * _lbRp;
    IBOutlet UIImageView * _ivPic;
    IBOutlet UILabel * _lbUserName;
    IBOutlet UILabel * _lbJobTitle;
    IBOutlet UILabel * _lbLangCode;
    IBOutlet UIImageView * _ivLang;
    IBOutlet UILabel *_lbTitle;
}

@property (nonatomic,assign) id<RPSettingViewControllerDelegate> delegate;

-(IBAction)OnLogout:(id)sender;
-(IBAction)OnAccountSetup:(id)sender;
-(IBAction)OnPersonalProfile:(id)sender;
-(IBAction)OnIntenational:(id)sender;
//-(IBAction)OnFeedback:(id)sender;
-(IBAction)OnAbout:(id)sender;
- (IBAction)OnContactUs:(id)sender;
- (IBAction)OnCacheManagement:(id)sender;

-(void)OnChangeProfileEnd;
-(void)Reload;
@end
