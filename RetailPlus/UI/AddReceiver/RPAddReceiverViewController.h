//
//  RPAddReceiverViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-9-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPAddReceiverCell.h"
#import "AutocompletionTableView.h"
@protocol RPAddReceiverViewControllerDelegate <NSObject>

@optional
    -(void)AddEmail:(NSString *)strEmail isEnd:(BOOL)bEnd;
    -(void)AddColleague:(NSMutableArray *)arrayColleague;
    -(void)EndAddEmail;

@end

@interface RPAddReceiverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RPAddReceiverCellDelegate>
{
    IBOutlet UIView                                 * _viewFrame;
    IBOutlet UIView                                 * _viewSearchFrame;
    IBOutlet UITextField                            * _tfSearch;
    IBOutlet UITableView                            * _tbAddressBook;
    
    IBOutlet UIView                                 * _viewAddEmail;
    IBOutlet UIView                                 * _viewAddEmailFrame;
    IBOutlet UIView                                 * _viewEmailEditFrame;
    IBOutlet UITextField                            * _tfEmail;
    IBOutlet UIButton                               * _btnEmailOk;
    IBOutlet UIButton                               * _btnEmailMore;
    IBOutlet UIButton                               * _btnSelectAll;
    
    IBOutlet UIButton                               * _btnCount1;
    IBOutlet UIButton                               * _btnCount2;
    IBOutlet UIButton                               * _btnCount3;
    IBOutlet UIButton                               * _btnCount4;
    
    IBOutlet UIButton                               * _btnFiltUser;
    
    NSArray                                         * _arrayLev1;
    NSArray                                         * _arrayLev2;
    NSArray                                         * _arrayLev3;
    NSArray                                         * _arrayLev4;
    NSArray                                         * _arrayCurColleague;
    NSMutableArray                                  * _arrayCurColleagueUnsort;
    NSArray                                         * _arraySec;
    
    NSMutableArray                                  * _arraySelected;
    
    BOOL                                            _bLev1;
    BOOL                                            _bLev2;
    BOOL                                            _bLev3;
    BOOL                                            _bLev4;
    
    NSInteger                                       _nCount1;
    NSInteger                                       _nCount2;
    NSInteger                                       _nCount3;
    NSInteger                                       _nCount4;
    
    NSString                                        * _strCurFiltTag;
}

@property (nonatomic,retain) NSMutableArray * arraySelected;
@property (nonatomic,retain) UIView * viewAddEmail;
@property (nonatomic,retain) UIView * viewAddEmailFrame;
@property (nonatomic,assign) id<RPAddReceiverViewControllerDelegate> delegate;
@property (nonatomic) BOOL  bSingleSelect;

-(void)OnSelectUser:(UserDetailInfo *)colleague bSelected:(BOOL)bSelect;

-(IBAction)OnDeleteSearch:(id)sender;

-(IBAction)OnSelLev1:(id)sender;
-(IBAction)OnSelLev2:(id)sender;
-(IBAction)OnSelLev3:(id)sender;
-(IBAction)OnSelLev4:(id)sender;

-(IBAction)OnEmailOK:(id)sender;
-(IBAction)OnEmailEnd:(id)sender;
-(IBAction)OnEmailMore:(id)sender;

-(IBAction)OnAddColleague:(id)sender;

-(void)UpdateUI;
@end
