//
//  RPSalesDataView.h
//  RetailPlus
//
//  Created by zwhe on 14-1-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPDailySalesRecordView.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"
@protocol RPSalesDataViewDelegate <NSObject>
-(void)OnKPIDataEntryEnd;
@end
@interface RPSalesDataView : UIView<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,RPDailySalesRecordViewDelegate>
{
    IBOutlet UIView *_view1;
    IBOutlet UIImageView *_ivLeft;
    IBOutlet UIImageView *_ivRight;
    IBOutlet UIView *_viewMonth;
    IBOutlet UIView *_viewYear;
    IBOutlet UIImageView *_ivPic;
    IBOutlet UILabel *_lbStore;
    IBOutlet UILabel *_lbPlace;
    IBOutlet UITextField *_tfDate;
    RPDatePicker *_pickDate;
    IBOutlet RPDailySalesRecordView * _viewDailySalesRecord;
    BOOL _bViewDailySalesRecord;
    
    NSMutableArray * _arraySalesData;
    NSMutableArray * _arraySalesDayData;
    IBOutlet UILabel *_lbMSales;
    IBOutlet UILabel *_lbYSales;
    BOOL              _bDatePicker;
    MJRefreshHeaderView     * _headerSales;
}
@property(nonatomic,assign)id<RPSalesDataViewDelegate> delegate;
@property(nonatomic,strong)KPISalesData *salesData;
@property (nonatomic,retain) StoreDetailInfo  *storeSelected;
@property (strong, nonatomic) IBOutlet UIScrollView *svFrame;
@property(nonatomic,strong)UIViewController *vcFrame;
@property (strong, nonatomic) IBOutlet UITableView *tbSalesData;
-(BOOL)OnBack;
- (IBAction)OnAdd:(id)sender;
- (IBAction)OnSelectDate:(id)sender;
- (IBAction)OnQuit:(id)sender;
- (IBAction)OnHelp:(id)sender;
@end
