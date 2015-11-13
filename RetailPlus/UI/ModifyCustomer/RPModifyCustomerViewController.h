//
//  RPModifyCustomerViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-8-28.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
#import "RPSwitchView.h"
#import "RPMainViewController.h"
#import "ZSYPopoverListView.h"
#import "RPChildrenCell.h"
#import "RPDatePicker.h"
#import "RPMemorialDaysCell.h"
#import "RPStoreListView.h"
#import "RPStoreCardView.h"
//typedef enum
//{
//    MAINTEN_STOREDETAIL = 0,
//    MAINTEN_SELECTSHOP,
//    MAINTEN_DETAIL,
//}MAINTENSTEP;

@protocol RPModifyCustomerViewControllerDelegate <NSObject>
-(void)OnModifyCustomerEnd;
-(void)OnModifyCustomerBackEnd;
@end
//@protocol RPEditCustomerViewControllerDelegate <NSObject>
//
//-(void)OnEditCustomerEnd;
//
//@end
@interface RPModifyCustomerViewController : RPTaskBaseViewController<RPSwitchViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,RPStoreSelectDelegate>
{
    IBOutlet UIScrollView * _svFrame;
    IBOutlet UIView       * _viewFrame;
    IBOutlet UIView *_viewJobAndFamily;
    IBOutlet UIView       * _viewTable1;
    IBOutlet UIView       * _viewTable2;
    IBOutlet UIView       * _viewTable3;
    IBOutlet UIView *_viewTable4;
    IBOutlet UIView *_viewTable5;
    IBOutlet UIView *_viewTable6;
    IBOutlet UIView *_viewTable7;
    IBOutlet UIView       * _viewPic;
    IBOutlet UIView       * _viewSwitchSex;
    IBOutlet UIView *_viewBGPersonalProfile;
    IBOutlet UIView *_viewBackGround;
    IBOutlet UIView *_viewBGJobAndFamily;
    IBOutlet UIView *_viewSwitchVIP;
    IBOutlet UIButton     * _btnPic;

    IBOutlet UIButton     * _btnVip;
    IBOutlet UILabel      * _lbSex;
//    IBOutlet UILabel      * _lbFemale;
    
    IBOutlet UITextField  * _tfFirstName;
//    IBOutlet UITextField  * _tfSurName;
    IBOutlet UITextField  * _tfPhone1;
    IBOutlet UITextField  * _tfPlace;
    IBOutlet UITextField  * _tfBirthDay;
    IBOutlet UITextField  * _tfBirthYear;
    IBOutlet UITextField  * _tfEmail;
    IBOutlet UITextField  * _tfPhone2;
    IBOutlet UITextView   * _tvAddress;
    IBOutlet UITextView *_tvInterest;
    IBOutlet UITextField *_tfCareer;
    IBOutlet UITextField *_tfTitle;
    
    
    RPSwitchView          * _switchSex;
    RPSwitchView          * _switchVIP;
    UIImage               * _imgCustomer;
    BOOL                  _bVip;
    BOOL                  _bFemale;
    
//    UIDatePicker          * _pickBirthDay;
    RPDatePicker          * _pickDate;
//    UIView                * _viewSelectCale;
//    UIView                * _viewMaskSelectCale;
//    CKCalendarView        * _calendar;
    IBOutlet UILabel *_lbPersonalProfile;
    IBOutlet UILabel *_lbJobAndFamily;
    IBOutlet UIView *_viewChildren;
    IBOutlet UIView *_viewMemorialDays;
    IBOutlet UITextView *_tvChildren;
    IBOutlet UITextView *_tvMemorialDays;
    IBOutlet UITableView *_tbChildren;
    IBOutlet UITableView *_tbMemorialDays;
    int _indexChild;
    int _indexMemorialDay;
    
//    MAINTENSTEP                 _step;
    RPStoreListView             * _viewStoreList;
    BOOL      _bStoreList;

    RPStoreCardView             * _viewStoreCard;
    
    NSInteger                   _nCareerIndex;
    BOOL _bModify;
    BOOL _bQuit;
    
    NSArray *_arrayAllCustomer;
}

@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;
@property (nonatomic,assign) id<RPModifyCustomerViewControllerDelegate> delegateModify;
//@property (nonatomic,assign) id<RPEditCustomerViewControllerDelegate> delegateEdit;

@property(nonatomic,strong)Customer *customer;
@property(nonatomic)BOOL isAdd;
@property (strong, nonatomic) IBOutlet UIImageView *ivVIP;
@property (strong, nonatomic) IBOutlet UIImageView *ivPic;

@property (nonatomic,assign) UIViewController * vcFrame;
@property(nonatomic,strong)NSMutableArray *arrayChildren;
@property(nonatomic,strong)NSMutableArray *arrayMemorialDays;
//@property(nonatomic,strong)RPChildrenCell *customerCell;
@property(nonatomic,strong)ZSYPopoverListView *listViewSex;
@property(nonatomic,strong)ZSYPopoverListView *listViewCareer;
//@property(nonatomic,strong)ZSYPopoverListView *listViewAge;
@property (strong, nonatomic) IBOutlet UIImageView *viewBottom;
@property(nonatomic,strong)NSMutableArray *arraySex;
@property(nonatomic,strong)NSArray *arrayCareer;
-(IBAction)OnSelPicture:(id)sender;
//-(IBAction)OnSelVip:(id)sender;
-(IBAction)OnOK:(id)sender;
- (IBAction)OnPersonalProfile:(id)sender;
- (IBAction)OnJobAndFamily:(id)sender;
//- (IBAction)OnAddChild:(id)sender;
//- (IBAction)OnAddMemorialDay:(id)sender;
-(BOOL)OnBack;
@end
