//
//  RPAddressBookCustomerCell.h
//  RetailPlus
//
//  Created by lin dong on 13-8-28.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPCustomerCellMaskView.h"
#import "UIMarqueeLabel.h"
@protocol RPAddressBookCustomerCellDelegate <NSObject>
    -(void)OnSearchRelationUser:(Customer *)customer;
    -(void)OnEditCustomer:(Customer *)customer;
    -(void)OnCustomerPurchase:(Customer *)customer;
@end

@interface RPAddressBookCustomerCell : UITableViewCell<RPCustomerCellMaskViewDelegate>
{
    IBOutlet UIButton               * _btnPic;
    IBOutlet UILabel                * _lbName;
    IBOutlet UILabel                * _lbAddress;
    IBOutlet UIImageView            * _ivVip;
    IBOutlet UIImageView            * _ivRelation;
    
    IBOutlet RPCustomerCellMaskView * _viewContact;
    IBOutlet UIView                 * _viewLink;
    IBOutlet UIMarqueeLabel         * _lbRelationUser;
}

@property (nonatomic,assign) id<RPAddressBookCustomerCellDelegate> delegate;
@property (nonatomic,assign) UIViewController   * vcFrame;

@property (nonatomic,assign) Customer * customer;

-(IBAction)OnPic:(id)sender;
-(IBAction)OnRelation:(id)sender;

@end
