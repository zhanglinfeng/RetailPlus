//
//  RPMainViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-8-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
#import "RPMenuView.h"
#import "RPLoginViewController.h"
#import "RPAddressBookViewController.h"
#import "RPStoreManagerViewController.h"
#import "RPMCViewController.h"
#import "RPSettingViewController.h"
#import "RPMainPageViewController.h"
#import "RPStoreCardViewController.h"
#import "RPLanguageViewController.h"
#import "RPStoreBusinessDelegate.h"
#import "RPCustomerBusinessDelegate.h"
#import "RPWakeUpView.h"
#import "RPColleagueCardViewController.h"
#import "RPNewMenuView.h"
#import "RPGuideViewController.h"
#import "RPShakeNotify.h"

@protocol RPMainViewControllerDelegate <NSObject>
    -(void)OnInviteEnd;
    -(void)OnAddCustomEnd;
    -(void)OnTaskEnd;
    -(void)OnReloadTitle;
    -(void)OnFeedback;
    -(void)OnUpdateStoreEnd:(StoreDetailInfo *)store;
    -(void)OnShowGuide;
    -(void)OnUpdateTaskEnd;
    -(void)OnUpdateTaskAfterAddCalendar;
//    -(void)OnPurchaseRecord;
@end

@interface RPMainViewController : UIViewController<RPLoginViewControllerDelegate,RPMenuViewDelegate,RPNewMenuViewDelegate,RPAddressBookViewControllerDelegate,RPStoreManagerViewControllerDelegate,RPMainViewControllerDelegate,RPSettingViewControllerDelegate,RPStoreBusinessDelegate,RPLanguageViewControllerDelegate,RPDocLiveDelegate,RPColleagueCardViewControllerDelegate,RPSystemTaskBaseViewControllerDelegate,RPMCViewControllerDelegate,RPCustomerBusinessDelegate,RPShakeNotifyDelegate,RPSettingViewControllerDelegate,RPMainPageViewControllerDelegate,RPWakeUpViewDelegate>
{
    IBOutlet UIView                 * _viewToolbar;
    IBOutlet UIView                 * _viewTopBar;
    IBOutlet RPMenuView             * _viewMenu;
//    IBOutlet RPNewMenuView          * _viewMenu;
    IBOutlet UIButton               * _btnMenu;
    IBOutlet UIButton               * _btnBack;
    IBOutlet UILabel                * _lbTask;
    IBOutlet UILabel                * _lbInfoCount;
    IBOutlet UIImageView            * _ivOffline;
    
    IBOutlet RPWakeUpView           *_wakeUpView;
    RPAddressBookViewController     * _vcAddress;
    RPStoreManagerViewController    * _vcStoreMng;
    RPMCViewController              * _vcMessageCenter;
    RPSettingViewController         * _vcSetting;
    RPMainPageViewController        * _vcMain;
    
    RPWakeUpView                    * _viewWakeUp;
    
    CGRect                          _rcTaskArea;
    CGRect                          _rcSystemTaskArea;
    BOOL                            _bMenuHide;
    BOOL                            _bNewMenuHide;
    BOOL                            _bFirstAppear;
    
    RPTaskBaseViewController        * _vcCurTask;
    RPSystemTaskBaseViewController  * _vcCurSystemTask;
    RPGuideViewController           * _vcGuide;
    
    IBOutlet UIButton               * _btnSysMenuHome;
    IBOutlet UIButton               * _btnSysMenuAddress;
    IBOutlet UIButton               * _btnSysMenuStore;
    IBOutlet UIButton               * _btnSysMenuConfig;
}

-(IBAction)OnMessageCenter:(id)sender;

-(IBAction)OnBackBtnClick:(id)sender;
-(IBAction)OnMenuBtnClick:(id)sender;

-(IBAction)OnHome:(id)sender;
-(IBAction)OnAddressBook:(id)sender;
-(IBAction)OnStoreManager:(id)sender;
-(IBAction)OnSetting:(id)sender;

-(IBAction)OnInspection:(id)sender;
-(IBAction)OnTrafficData:(id)sender;

@end
