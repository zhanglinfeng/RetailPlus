//
//  RPPersonalProfileView.h
//  RetailPlus
//
//  Created by lin dong on 13-11-18.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSwitchView.h"
#import "RPSettingViewController.h"
#import "ZSYPopoverListView.h"
#import "RPPersonalProfileViewController.h"
#import "RPDatePicker.h"
@interface RPPersonalProfileView : UIView<RPSwitchViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIView     * _viewFrame1;
    IBOutlet UIView     * _viewFrame2;
    IBOutlet UIView     * _viewUserImg;
    IBOutlet UIView     * _viewSex;
    IBOutlet UILabel    * _lbMale;
    IBOutlet UILabel    * _lbFemale;

    IBOutlet UITextField            * _tfFirstName;
//    IBOutlet UITextField            * _tfSurName;
//    IBOutlet UITextField            *_tfDisplayName;
    IBOutlet UILabel                * _lbPhone;
    IBOutlet UITextField            * _tfEmail;
    IBOutlet UITextField            * _tfBirthday;
    IBOutlet UITextField            * _tfAlternatePhone;
    IBOutlet UITextField            * _tfInterest;
    IBOutlet UIButton               * _btnPublicAge;
    IBOutlet UIImageView            * _ivPublic;
    IBOutlet UIButton               * _btnUser;
    IBOutlet UIScrollView           * _frameScroll;
    IBOutlet UITextField            * _tfBirthYear;
    
    IBOutlet UIImageView            * _ivPhoneLock;
    IBOutlet UIView                 * _viewEditPhoneFrame;
    IBOutlet UIView                 * _viewEditPhone;
    IBOutlet UIView                 * _viewBtnFrame;
    IBOutlet UIView                 * _viewEditFrame;
    IBOutlet UITextField            * _tfEditPhone;
    
    IBOutlet UITextField            * _tfOnBoard;
    IBOutlet UITextField            * _tfOfficePhone;
    IBOutlet UITextView             * _tvOfficeAddress;
    
    UIView                          * _viewEditing;
    
    UIImage                         * _imgUser;
   // UIDatePicker                    * _dpBirthDay;
    RPSwitchView                    * _switchSex;
    BOOL                            _bFemale;
   // BOOL                            _bPublicAge;
    
    BOOL                            _bConfirmQuit;
    BOOL                            _bImgChanged;
    BOOL                            _bEdited;
    int                             _index;
    
    RPDatePicker                    * _pickDate;
}

@property(nonatomic,strong)ZSYPopoverListView *listViewCareer;
@property (nonatomic,assign) UserDetailInfo     * loginProfile;
@property (nonatomic,assign) UIViewController   * vcFrame;
@property (nonatomic,assign) id<RPSettingViewControllerDelegate> delegate;
@property (nonatomic,strong)NSMutableArray *arrayName;
-(IBAction)OnTakePhoto:(id)sender;
-(IBAction)OnEditPhone:(id)sender;

-(BOOL)OnBack;
-(void)saveOK;
@end
