//
//  RPCareerView.h
//  RetailPlus
//
//  Created by lin dong on 13-11-18.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSettingViewController.h"
#import "RPDatePicker.h"

@interface RPCareerView : UIView<UITextFieldDelegate,UITextViewDelegate>
{
    IBOutlet UIView  * _viewFrame1;
    IBOutlet UIView  * _viewFrame2;
    IBOutlet UIView  * _viewFrame3;
    
    IBOutlet UIButton   * _btnQuit;
    IBOutlet UIButton   * _btnHide;
    IBOutlet UIView     * _viewCofirmQuit;
    IBOutlet UIView     * _viewConfirmFrame;
    IBOutlet UIButton   * _btnConfirm;
    IBOutlet UITextField * _tfConfirm;
    
    IBOutlet UILabel * _lbEnterprise;
    IBOutlet UILabel * _lbPosition;
    IBOutlet UILabel * _lbJobTitle;
    IBOutlet UILabel * _lbReportTo;
//    IBOutlet UILabel * _lbJoinedAt;
    IBOutlet UITextField * _tfJoinedAt;
//    IBOutlet UILabel * _lbOfficePhone;
//    IBOutlet UILabel * _lbOfficeAddr;
    IBOutlet UITextField * _tfOfficePhone;
    IBOutlet UITextView  * _tvOfficeAddr;
    
    IBOutlet UIView  * _viewBtnFrame;
    IBOutlet UIView  * _viewEditFrame;
    IBOutlet UIScrollView           * _frameScroll;
    
    IBOutlet UIImageView    * _ivReportTo;
    IBOutlet UIButton       * _btnReportTo;
    
    BOOL                    _bHide;
    
    UIView                  * _viewEditing;
    
    RPDatePicker            * _pickDate;
}

@property (nonatomic,assign) id<RPSettingViewControllerDelegate> delegate;
@property (nonatomic,assign) UserDetailInfo * loginProfile;

-(void)setPositionInfo:(UserDetailInfo *)loginProfile;
-(void)setReporter:(UserDetailInfo *)loginProfile;

-(IBAction)OnCancelConfirm:(id)sender;
-(IBAction)OnConfirmQuit:(id)sender;

-(IBAction)OnShowQuit:(id)sender;
-(IBAction)OnQuit:(id)sender;

@end
