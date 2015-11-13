//
//  RPBookConfDetailView.h
//  RetailPlus
//
//  Created by lin dong on 14-6-19.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPConfDefine.h"
#import "RPMngChnView.h"
#import "RPAddReceiverViewController.h"
#import "RPBookConfNotifyView.h"
#import "RPBookConfEditUserView.h"
#import "RPDatePicker.h"

typedef enum
{
    RPBOOKCONFDETAILSTEP_BEGIN,
    RPBOOKCONFDETAILSTEP_EDITCHN,
    RPBOOKCONFDETAILSTEP_EDITHOST,
    RPBOOKCONFDETAILSTEP_CHOOSEHOST,
    RPBOOKCONFDETAILSTEP_ADDGUESTMANUAL,
    RPBOOKCONFDETAILSTEP_ADDGUESTCHOOSE,
    RPBOOKCONFDETAILSTEP_EDITGUEST,
    RPBOOKCONFDETAILSTEP_SENDNOTIFY,
}RPBOOKCONFDETAILSTEP;

@protocol RPBookConfDetailViewDelegate <NSObject>
    -(void)OnAddBookSuccess;
    -(void)OnCancelAddBook;
@end

@interface RPBookConfDetailView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RPAddReceiverViewControllerDelegate,RPBookConfEditUserViewDelegate,RPBookConfNotifyViewDelegate>
{
    IBOutlet UIView                 * _viewFrame;
    IBOutlet UITextField            * _tfCallTheme;
    IBOutlet UILabel                * _lbHostPhone;
    IBOutlet UILabel                * _lbHostEmail;
    IBOutlet UILabel                * _lbHostName;
    IBOutlet UILabel                * _lbGuestCount;
    IBOutlet UITableView            * _tbGuest;
    IBOutlet UIButton               * _btnSelChn;
    IBOutlet UILabel                * _lbSelChn;
    IBOutlet UITextField            * _tfCallTime;
    
    IBOutlet RPBookConfNotifyView   * _viewNotify;
    IBOutlet RPMngChnView           * _viewMngChn;
    IBOutlet RPBookConfEditUserView * _viewEditUser;
    
    RPDatePicker                    * _pickDate;
    NSDate                          * _dateCallTime;
    
    RPAddReceiverViewController     * _vcAddReceiver;   //选择用户ui
    BOOL                            _bModifyHost;       //选择用户用来添加客户或者修改主持人
    
    RPConfBookMember                * _memberTemp;
    RPBOOKCONFDETAILSTEP            _step;
}

@property (nonatomic,assign) id<RPBookConfDetailViewDelegate> delegate;
@property (nonatomic,retain) RPConfBook * confbook;

-(IBAction)OnConfirm:(id)sender;
-(IBAction)OnQuit:(id)sender;

-(BOOL)OnBack;
@end
