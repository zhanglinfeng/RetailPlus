//
//  RPTrafficDataView.h
//  RetailPlus
//
//  Created by zwhe on 14-1-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPDatePicker.h"
#import "RPDailyTrafficRecordView.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"
@protocol RPTrafficDataViewDelegate <NSObject>
-(void)OnKPITrafficDataEntryEnd;
@end
@interface RPTrafficDataView : UIView<UITableViewDataSource,UITableViewDelegate,RPDailyTrafficRecordViewDelegate>
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
    IBOutlet RPDailyTrafficRecordView *_viewDailyTrafficRecord;
    BOOL _bViewDailyTrafficRecord;
    NSMutableArray * _arrayTrafficData;
    NSMutableArray * _arrayTrafficDayData;
    IBOutlet UILabel *_lbMTraffic;
    IBOutlet UILabel *_lbYTraffic;
    MJRefreshHeaderView     * _headerTraffic;
}
@property(nonatomic,assign)id<RPTrafficDataViewDelegate> delegate;
@property(nonatomic,strong)KPITrafficData *TrafficData;
@property (nonatomic,retain) StoreDetailInfo  *storeSelected;
@property (strong, nonatomic) IBOutlet UIScrollView *svFrame;
@property(nonatomic,strong)UIViewController *vcFrame;
@property(nonatomic,strong)IBOutlet UITableView *tbTrafficData;
-(BOOL)OnBack;
- (IBAction)OnAdd:(id)sender;
- (IBAction)OnSelectDate:(id)sender;
- (IBAction)OnQiut:(id)sender;
- (IBAction)OnHelp:(id)sender;
@end
