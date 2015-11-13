//
//  RPModifyStoreViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-5-5.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPMainViewController.h"
#import "RPTaskBaseViewController.h"
#import "RPBusHourRangeView.h"
#import "RPExBtnTextField.h"

@interface RPModifyStoreViewController : RPTaskBaseViewController<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIView         * _viewTable1;
    IBOutlet UIView         * _viewTable2;
    IBOutlet UIView         * _viewTable3;
    IBOutlet UIView         * _viewFrame;
    IBOutlet UIScrollView   * _svFrame;
    
    IBOutlet UILabel        * _lbTitle;
    IBOutlet UIImageView    * _ivThumb;
    IBOutlet UIButton       * _btnThumb;
    IBOutlet UITextField    * _tfName;
    IBOutlet UITextView     * _tvAddress;
    IBOutlet UITextField    * _tfPostCode;
    IBOutlet UITextField    * _tfPhone;
    IBOutlet UITextField    * _tfFax;
    IBOutlet UITextField    * _tfEmail;
    IBOutlet RPExBtnTextField * _tfBusinessHours;
    IBOutlet UITextField      * _tfArea;
    
    IBOutlet RPBusHourRangeView   * _viewHours;
    BOOL                          _bModified;
    UIImage                       * _imgStore;
}

@property (nonatomic,assign) UIViewController * vcFrame;
@property (nonatomic,assign) id<RPMainViewControllerDelegate>   delegate;
@property (nonatomic,copy) StoreDetailInfo * storeSelected;

-(IBAction)OnStoreThumb:(id)sender;
-(IBAction)OnOk:(id)sender;

@end
