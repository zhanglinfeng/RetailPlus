//
//  RPAddressBookCustomerView.h
//  RetailPlus
//
//  Created by lin dong on 13-8-28.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPAddressBookCustomerCell.h"
#import "MJRefreshHeaderView.h"
@protocol RPAddressBookCustomerViewDelegate <NSObject>
    -(void)OnSelectCustomer:(Customer *)customer;
    -(void)OnEditCustomer:(Customer *)customer;
    -(void)OnCustomerPurchase:(Customer *)customer;
@end

@interface RPAddressBookCustomerView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RPAddressBookCustomerCellDelegate>
{
    IBOutlet UIView                                 * _viewFrame;
    IBOutlet UIView                                 * _viewSearchFrame;
    IBOutlet UITextField                            * _tfSearch;
    IBOutlet UITableView                            * _tbAddressBook;
    IBOutlet id<RPAddressBookCustomerViewDelegate>  _delegate;
    
    IBOutlet UIButton                               * _btnVip;
    IBOutlet UIButton                               * _btnRelation;
    IBOutlet UIButton                               * _btnMale;
    IBOutlet UIButton                               * _btnFemale;
    
    NSArray                                         * _arrayAllCustomer;
    NSArray                                         * _arrayCurCustomer;
    NSMutableArray                                  * _arrayCurCustomerUnsort;
    NSArray                                         * _arraySec;
    
    NSInteger                                       _nVipCount;
    NSInteger                                       _nRelationCount;
    NSInteger                                       _nMaleCount;
    NSInteger                                       _nFemaleCount;
    
    BOOL                                            _bShowVip;
    BOOL                                            _bShowRelation;
    BOOL                                            _bShowMale;
    BOOL                                            _bShowFemale;
    MJRefreshHeaderView     * _headerCustomer;
}

@property (nonatomic,assign) UIViewController   * vcFrame;

-(void)InitCustomerList;

-(IBAction)OnDeleteSearch:(id)sender;

-(IBAction)OnVip:(id)sender;
-(IBAction)OnRelation:(id)sender;
-(IBAction)OnMale:(id)sender;
-(IBAction)OnFemale:(id)sender;

-(void)ReloadData;
-(void)SearchRelationUser:(NSString *)strUserName;

@end
