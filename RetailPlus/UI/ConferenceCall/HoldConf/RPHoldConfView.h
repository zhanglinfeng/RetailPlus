//
//  RPHoldConfView.h
//  RetailPlus
//
//  Created by lin dong on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPConfDefine.h"
#import "RPAddReceiverViewController.h"
#import "RPConfEditUserView.h"
#import "RPMngChnView.h"
#import "RPBookConfDetailView.h"

typedef enum
{
    RPHOLDCONFSTEP_BEGIN,
    RPHOLDCONFSTEP_EDITCHN,
    RPHOLDCONFSTEP_EDITHOST,
    RPHOLDCONFSTEP_CHOOSEHOST,
    RPHOLDCONFSTEP_ADDGUESTMANUAL,
    RPHOLDCONFSTEP_ADDGUESTCHOOSE,
    RPHOLDCONFSTEP_EDITGUEST,
    RPHOLDCONFSTEP_BOOKING,
}RPHOLDCONFSTEP;

@protocol RPHoldConfViewDelegate <NSObject>
    -(void)OnHoldConfEnd;
@end

@interface RPHoldConfView : UIView<UITableViewDataSource,UITableViewDelegate,RPAddReceiverViewControllerDelegate,RPConfEditUserViewDelegate,RPBookConfDetailViewDelegate>
{
    IBOutlet UIView             * _viewFrame;
    IBOutlet UITextField        * _tfCallTheme;
    IBOutlet UILabel            * _lbHostPhone;
    IBOutlet UILabel            * _lbHostEmail;
    IBOutlet UILabel            * _lbHostName;
    IBOutlet UILabel            * _lbGuestCount;
    IBOutlet UITableView        * _tbGuest;
    IBOutlet UIButton           * _btnSelChn;
    IBOutlet UILabel            * _lbSelChn;
    
    IBOutlet RPConfEditUserView         * _viewEditUser;
    IBOutlet RPMngChnView               * _viewMngChn;
    IBOutlet RPBookConfDetailView       * _viewBookConf;

    
    RPAddReceiverViewController         * _vcAddReceiver;   //选择用户ui
    BOOL                                _bModifyHost;       //选择用户用来添加客户或者修改主持人
    
    RPConfGuest                         * _guestTemp;
    RPHOLDCONFSTEP                      _step;
}

@property (nonatomic,assign) id<RPHoldConfViewDelegate> delegate;
@property (nonatomic,retain) RPConf * conf;

-(IBAction)OnHoldConf:(id)sender;
-(IBAction)OnBookConf:(id)sender;
-(IBAction)OnEditChn:(id)sender;
-(IBAction)OnQuit:(id)sender;

-(BOOL)OnBack;
@end
