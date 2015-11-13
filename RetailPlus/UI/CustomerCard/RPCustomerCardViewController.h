//
//  RPCustomerCardViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-8-28.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
#import "RPMainViewController.h"
#import "RPPurchaseRecordViewController.h"
#import "RPModifyCustomerViewController.h"

@interface RPCustomerCardViewController : RPTaskBaseViewController<MFMessageComposeViewControllerDelegate,RPModifyCustomerViewControllerDelegate>
{
    IBOutlet UIView         * _viewDetail;
    IBOutlet UIImageView    * _ivPic;
    IBOutlet UIButton       * _btnSizeChg;
    IBOutlet UIView         * _viewFrame;
    IBOutlet UIScrollView   * _svDetail;
    IBOutlet UIView         * _viewTask;
    IBOutlet UIView         * _viewTable1;
    IBOutlet UIView         * _viewTable2;
    IBOutlet UIView         * _viewTable3;
    IBOutlet UIView         * _viewTable4;
    IBOutlet UIView         * _viewTable5;
    IBOutlet UIView         * _viewTable6;
    
    IBOutlet UILabel        * _lbCustomName;
    IBOutlet UIImageView    * _ivPicture;
    IBOutlet UILabel        * _lbPhone1;
    IBOutlet UILabel        * _lbLocation;
    IBOutlet UILabel        * _lbBirthDay;
    IBOutlet UILabel        * _lbBirthYear;
    
    IBOutlet UILabel *_lbStore;
    IBOutlet UILabel *_lbRelationUser;
    
    IBOutlet UILabel *_lbCareer;
    IBOutlet UILabel *_lbTitle;
    IBOutlet UILabel        * _lbEmail;
    IBOutlet UILabel        * _lbPhone2;
    IBOutlet UILabel        * _lbAddress;
    IBOutlet UITextView *_tvAddress;
    IBOutlet UITextView *_tvChildren;
    IBOutlet UITextView *_tvMemorialDays;
    IBOutlet UITextView *_tvInterest;
    
    IBOutlet UIImageView    * _ivSex;
    IBOutlet UIImageView    * _ivVip;
    IBOutlet UIImageView    * _ivLink;
    
    BOOL                    _bSmall;
    BOOL                    _bEdit;
    BOOL                    _bPurchaseRecord;
    
    UIViewController        * vcInsp;
    RPPurchaseRecordViewController *vcPurchaseRecord;
    IBOutlet UIButton *_btEdit;
    IBOutlet UILabel *_lbEdit;
    IBOutlet UIButton *_btPurchase;
    IBOutlet UILabel *_lbPurchase;
    IBOutlet UIButton *_btLink;
    IBOutlet UILabel *_lbLink;
    IBOutlet UIButton *_btCourtesyCall;
    IBOutlet UILabel *_lbCourtestCall;
}
@property (nonatomic,assign) id<RPCustomerBusinessDelegate>delegateBusiness;
@property (nonatomic,assign) id<RPMainViewControllerDelegate>delegate;
@property (nonatomic,assign) Customer        * customer;
@property (strong,nonatomic)NSArray *arrayCareer;
@property (nonatomic,assign) UIViewController * vcFrame;
- (IBAction)OnEdit:(id)sender;

-(IBAction)OnSizeChg:(id)sender;
- (IBAction)OnPurchaseRecord:(id)sender;
- (IBAction)OnCall:(id)sender;
- (IBAction)OnMessage:(id)sender;
- (IBAction)OnRemove:(id)sender;
- (IBAction)OnLinkageBreak:(id)sender;
-(IBAction)OnCCall:(id)sender;

@end
