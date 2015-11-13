//
//  RPAddressBookCell.h
//  RetailPlus
//
//  Created by lin dong on 13-8-16.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPUserCellMaskView.h"
#import "RPAddressBookEditTagView.h"

@protocol RPAddressBookCellDelegate <NSObject>
    -(void)OnCustomerlist:(UserDetailInfo *)colleague;
    -(void)OnEditTagEnd;
    -(void)OnSetFilt:(NSString *)strFiltTag;
    -(void)OnRemoveFilt;
@end

@interface RPAddressBookCell : UITableViewCell<RPUserCellMaskViewDelegate,RPAddressBookEditTagViewDelegate>
{
    IBOutlet UIButton                   * _btnPic;
//    IBOutlet UIView                   * _viewContact;
    IBOutlet UIView                     * _viewLevel;
    IBOutlet UILabel                    * _lbName;
    IBOutlet UILabel                    * _lbRoleDesc;
    
    IBOutlet UIButton                   * _btnPhone;
    IBOutlet UIButton                   * _btnMessage;
    IBOutlet UIButton                   * _btnTask;
    IBOutlet RPUserCellMaskView         *_viewContact;
    IBOutlet RPAddressBookEditTagView   * _viewEditTag;
    
    IBOutlet UIView                     * _viewTagFrame;
    IBOutlet UILabel                    * _lbTagViewName;
    IBOutlet UIButton                   * _btnTag1;
    IBOutlet UIButton                   * _btnTag2;
    IBOutlet UIButton                   * _btnTag3;
    
    IBOutlet UIImageView                * _ivHasTag;
    IBOutlet UIImageView                * _ivLock;
    
    UILongPressGestureRecognizer        * _longPress1;
    UILongPressGestureRecognizer        * _longPress2;
    UILongPressGestureRecognizer        * _longPress3;
}

@property (nonatomic)BOOL    bShowTag;
@property (nonatomic,retain) NSString * strFiltString;

@property (nonatomic,assign) id<RPAddressBookCellDelegate>  delegate;
@property (nonatomic,assign) UIViewController   * vcFrame;
@property (nonatomic,assign) UserDetailInfo * colleague;
-(IBAction)OnPic:(id)sender;
-(IBAction)OnTag:(id)sender;

@end
