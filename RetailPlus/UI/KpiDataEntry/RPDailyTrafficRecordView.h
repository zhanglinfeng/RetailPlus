//
//  RPDailyTrafficRecordView.h
//  RetailPlus
//
//  Created by zwhe on 14-1-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPDatePicker.h"
#import "ZSYPopoverListView.h"
#import "RPTrafficRecordCell.h"
@protocol RPDailyTrafficRecordViewDelegate <NSObject>
-(void)OnChangeTrafficRecordEnd;
-(void)OnUpdate;
-(void)OnKPIDataEntryEnd;
@end
@interface RPDailyTrafficRecordView : UIView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,RPTrafficRecordCellDelegate>
{
    IBOutlet UIView         * _viewBackground;
    IBOutlet UIView         * _view1;
    IBOutlet UITableView    *_tbTrafficRecord;
    IBOutlet UITextField    * _tfDate;
    IBOutlet UITextField    *_tfTraffic;
    IBOutlet UIButton       * _btMode;
    
    
    ZSYPopoverListView      * _modeList;
    NSArray                 * _arrayMode;
    KPIMode                 _mode;
    
    RPDatePicker            * _pickDate;
    NSInteger               _nOpenHour;
    NSInteger               _nCloseHour;
    
    NSMutableArray          * _arrayTrafficDataHour;
    KPITrafficData            * _TrafficDataDay;
    BOOL                    _bAdd;
    
    NSDate                  * _TrafficDate;
    CGRect                  _rcFrameRectOrg;
    BOOL                    _bSaved;
    IBOutlet UIView         *_viewRed;
}
@property(nonatomic,assign)id<RPDailyTrafficRecordViewDelegate> delegate;
@property(nonatomic,strong)StoreDetailInfo      * storeSelected;
@property(nonatomic,strong)NSMutableArray       * arrayTrafficData;

- (IBAction)OnMode:(id)sender;
- (IBAction)OnSave:(id)sender;
- (void)SetDate:(NSDate *)date;
-(BOOL)OnBack;
- (IBAction)OnQuit:(id)sender;
- (IBAction)FindEmptyPreDay:(id)sender;
- (IBAction)OnHelp:(id)sender;
@end
