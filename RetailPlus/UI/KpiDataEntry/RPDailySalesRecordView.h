//
//  RPDailySalesRecordView.h
//  RetailPlus
//
//  Created by zwhe on 14-1-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPDatePicker.h"
#import "ZSYPopoverListView.h"
#import "RPSalesRecordCell.h"
#import "RPBlockUISelectView.h"
@protocol RPDailySalesRecordViewDelegate <NSObject>
-(void)OnChangeSalesRecordEnd;
-(void)OnUpdate;
-(void)OnKPIDataEntryEnd;
@end

@interface RPDailySalesRecordView : UIView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,RPSalesRecordCellDelegate,UITextFieldDelegate>
{
    IBOutlet UIView         * _viewBackground;
    IBOutlet UIView         * _view1;
    IBOutlet UITableView    * _tbSalesRecord;
    IBOutlet UITextField    * _tfDate;
    IBOutlet UITextField    * _tfTxnQty;
    IBOutlet UITextField    * _tfSalesQty;
    IBOutlet UITextField    * _tfSalesAmount;
    IBOutlet UIButton       * _btMode;
    
    ZSYPopoverListView      * _modeList;
    NSArray                 * _arrayMode;
    KPIMode                 _mode;

    RPDatePicker            * _pickDate;
    NSInteger               _nOpenHour;
    NSInteger               _nCloseHour;
    
    NSMutableArray          * _arraySalesDataHour;
    KPISalesData            * _salesDataDay;
    BOOL                    _bAdd;
    
    NSDate                  * _selDate;
    CGRect                  _rcFrameRectOrg;
    BOOL                    _bSaved;
    IBOutlet UIView         *_viewRed;
}

@property(nonatomic,assign)id<RPDailySalesRecordViewDelegate> delegate;
@property(nonatomic,strong)StoreDetailInfo      * storeSelected;
@property(nonatomic,strong)NSMutableArray       * arraySalesData;

- (IBAction)OnMode:(id)sender;
- (IBAction)OnSave:(id)sender;
- (void)SetDate:(NSDate *)date;
-(BOOL)OnBack;
- (IBAction)OnQuit:(id)sender;
- (IBAction)FindEmptyPreDay:(id)sender;
- (IBAction)OnHelp:(id)sender;
@end
