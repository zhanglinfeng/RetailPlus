//
//  RPInspReportsView.h
//  RetailPlus
//
//  Created by lin dong on 13-9-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPInspReportsCell.h"

@protocol RPInspReportsViewDelegate<NSObject>
-(void)OnCombineReportsEnd:(NSArray *)arrayReportsDetail;
@end

@interface RPInspReportsView : UIView<UITableViewDataSource,UITableViewDelegate,RPInspReportsCellDelegate>
{
    IBOutlet UIView         * _viewFrame;
    IBOutlet UIButton       * _btnSelectAll;
    IBOutlet UITableView    * _tbReport;
    NSMutableArray          * _arrayReports;
    BOOL                    _bSelectAll;
}

@property (nonatomic,retain) id<RPInspReportsViewDelegate> delegate;
-(IBAction)OnCombineInsp:(id)sender;
-(void)GetReports:(StoreDetailInfo *)store;
- (IBAction)OnHelp:(id)sender;
@end
