//
//  RPBVisitReportsView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPInspReportsCell.h"
@protocol RPBVisitReportsViewDelegate<NSObject>
-(void)OnCombineReportsEnd:(NSArray *)arrayReportsDetail;
@end
@interface RPBVisitReportsView : UIView<UITableViewDataSource,UITableViewDelegate,RPInspReportsCellDelegate>
{
    IBOutlet UIView         * _viewFrame;
    IBOutlet UIButton       * _btnSelectAll;
    IBOutlet UITableView    * _tbReport;
    NSMutableArray          * _arrayReports;
    BOOL                    _bSelectAll;
}

@property (nonatomic,retain) id<RPBVisitReportsViewDelegate> delegate;
-(IBAction)OnCombineInsp:(id)sender;
-(void)GetReports:(StoreDetailInfo *)store;
- (IBAction)OnHelp:(id)sender;
@end
