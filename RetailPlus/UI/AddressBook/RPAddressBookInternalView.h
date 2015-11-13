//
//  RPAddressBookInternalView.h
//  RetailPlus
//
//  Created by lin dong on 13-8-16.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPAddressBookCell.h"
#import "MJRefreshHeaderView.h"
@protocol RPAddressBookInternalViewDelegate <NSObject>
    -(void)OnSelectColleague:(UserDetailInfo *)colleague;
    -(void)OnCustomerlist:(UserDetailInfo *)colleague;
@end

@interface RPAddressBookInternalView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RPAddressBookCellDelegate>
{
    IBOutlet UIView                                 * _viewFrame;
    IBOutlet UIView                                 * _viewSearchFrame;
    IBOutlet UITextField                            * _tfSearch;
    IBOutlet UITableView                            * _tbAddressBook;
    IBOutlet id<RPAddressBookInternalViewDelegate>  _delegate;
    IBOutlet UIButton                               * _btnCount1;
    IBOutlet UIButton                               * _btnCount2;
    IBOutlet UIButton                               * _btnCount3;
    IBOutlet UIButton                               * _btnCount4;
    
    IBOutlet UIButton                               * _btnAddUser;
    IBOutlet UIButton                               * _btnTagMode;
    IBOutlet UIButton                               * _btnFiltUser;
    
    
    UILongPressGestureRecognizer                    * _longPressAddUser;
    UILongPressGestureRecognizer                    * _longPressTagMode;
    UILongPressGestureRecognizer                    * _longPressFiltUser;
    
    IBOutlet UIView                                 * _viewFiltFrame;
    
    NSArray         * _arrayLev1;
    NSArray         * _arrayLev2;
    NSArray         * _arrayLev3;
    NSArray         * _arrayLev4;
    NSArray         * _arrayCurColleague;
    NSMutableArray  * _arrayCurColleagueUnsort;
    NSArray         * _arraySec;
    
    BOOL            _bLev1;
    BOOL            _bLev2;
    BOOL            _bLev3;
    BOOL            _bLev4;
    
    NSInteger       _nCount1;
    NSInteger       _nCount2;
    NSInteger       _nCount3;
    NSInteger       _nCount4;
    MJRefreshHeaderView     * _headerInternal;
    
    NSString                * _strCurFiltTag;
    BOOL                    _bShowTag;
}

@property (nonatomic,assign) UIViewController   * vcFrame;
-(IBAction)OnDeleteSearch:(id)sender;

-(IBAction)OnSelLev1:(id)sender;
-(IBAction)OnSelLev2:(id)sender;
-(IBAction)OnSelLev3:(id)sender;
-(IBAction)OnSelLev4:(id)sender;

-(void)ReloadData;
-(void)OnCustomerlist:(UserDetailInfo *)colleague;
@end
