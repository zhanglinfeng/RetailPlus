//
//  RPAddressBookViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-8-16.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSystemTaskBaseViewController.h"
#import "RPAddressBookInternalView.h"
#import "RPAddressBookCustomerView.h"

@protocol RPAddressBookViewControllerDelegate <NSObject>
    -(void)OnInvite;
    -(void)OnAddCustomer;
    -(void)OnEditCustomer:(Customer *)customer;
    -(void)OnCustomerPurchase:(Customer *)customer;
    -(void)OnSelectColleague:(UserDetailInfo *)colleague;
    -(void)OnSelectCustomer:(Customer *)customer;
@end

@interface RPAddressBookViewController : RPSystemTaskBaseViewController<RPAddressBookInternalViewDelegate,RPAddressBookCustomerViewDelegate, UIScrollViewDelegate>
{
    IBOutlet RPAddressBookInternalView      * _viewInternal;
    IBOutlet RPAddressBookCustomerView      * _viewCustomer;
    IBOutlet UIScrollView                   * _svFrame;
    
    IBOutlet UILabel                        * _lbTitle;
    IBOutlet UIImageView                    * _ivPage1;
    IBOutlet UIImageView                    * _ivPage2;
    
    BOOL                                    _bViewInited;

}

@property (nonatomic,assign) id<RPAddressBookViewControllerDelegate> delegate;
@property (nonatomic,assign) UIViewController   * vcFrame;

-(IBAction)OnInvite:(id)sender;
-(IBAction)OnNewCustomer:(id)sender;
-(void)ReloadData;
@end
