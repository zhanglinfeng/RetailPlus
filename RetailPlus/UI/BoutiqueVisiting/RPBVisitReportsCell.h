//
//  RPBVisitReportsCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RPBVisitReportsCellDelegate <NSObject>
-(void)OnSelect:(InspReportResult *)report;
@end
@interface RPBVisitReportsCell : UITableViewCell
{
    IBOutlet UILabel    * _lbReportName;
    IBOutlet UILabel    * _lbReportDetail;
    IBOutlet UIButton   * _btnChecked;
}
@property (nonatomic,assign) id<RPBVisitReportsCellDelegate> delegate;
@property (nonatomic,assign) InspReportResult * report;
@property (nonatomic)BOOL bChecked;

-(IBAction)OnSelect:(id)sender;
@end
