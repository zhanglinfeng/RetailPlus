//
//  RPUnfinishedReportCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-8-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPUnfinishedReportCell : UITableViewCell
{
    IBOutlet UILabel *_lbReportName;
    IBOutlet UILabel *_lbDate;
    IBOutlet UILabel *_lbAddress;
    
}
@property (strong, nonatomic)IBOutlet UILabel *lbAuthorName;
@property (strong, nonatomic)Document *doc;
@property (strong, nonatomic)BVisitListModel *bVisitModel;
@end
