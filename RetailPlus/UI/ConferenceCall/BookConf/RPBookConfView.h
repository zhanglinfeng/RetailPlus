//
//  RPBookConfView.h
//  RetailPlus
//
//  Created by lin dong on 14-6-19.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPBookConfStartView.h"
#import "RPBookConfDetailView.h"
#import "RPMngChnView.h"
#import "RPBookConfDetailView.h"

typedef enum
{
    RPBOOKCONFSTEP_BEGIN,
    RPBOOKCONFSTEP_EDITCHN,
    RPBOOKCONFSTEP_ADDBOOK,
    RPBOOKCONFSTEP_STARTBOOK,
}RPBOOKCONFSTEP;

@protocol RPBookConfViewDelegate <NSObject>
    -(void)OnBookConfEnd;
@end

@interface RPBookConfView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RPBookConfStartViewDelegate,RPBookConfDetailViewDelegate>
{
    IBOutlet UIView                 * _viewFrame;
    IBOutlet UIView                 * _viewSearchFrame;
    IBOutlet UIButton               * _btnEditChn;
    IBOutlet UITableView            * _tbBookList;
    IBOutlet UITextField            * _tfSearch;
    IBOutlet UIImageView            * _ivSelChn;
    IBOutlet UILabel                * _lbSelChn;
    
    IBOutlet RPBookConfStartView    * _viewConfStart;
    IBOutlet RPBookConfDetailView   * _viewConfBookDetail;
    IBOutlet RPMngChnView           * _viewMngChn;
    
    NSMutableArray                  * _arrayBook;
    NSMutableArray                  * _arrayBookShow;
    RPBOOKCONFSTEP                  _step;
}

@property (nonatomic,assign) id<RPBookConfViewDelegate> delegate;

-(void)ReloadData;
-(void)UpdateChnTip;
-(BOOL)OnBack;

-(IBAction)OnAddBook:(id)sender;
-(IBAction)OnEditChn:(id)sender;
-(IBAction)OnClearSearch:(id)sender;

@end
