//
//  RPInspReportsCell.h
//  RetailPlus
//
//  Created by lin dong on 13-9-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPInspReportsCellDelegate <NSObject>
    -(void)OnSelect:(InspReportResult *)report;
@end

@interface RPInspReportsCell : UITableViewCell
{
    IBOutlet UILabel    * _lbReportName;
    IBOutlet UILabel    * _lbReportDetail;
    IBOutlet UIButton   * _btnChecked;
}

@property (nonatomic,assign) id<RPInspReportsCellDelegate> delegate;
@property (nonatomic,assign) InspReportResult * report;
@property (nonatomic)BOOL bChecked;

-(IBAction)OnSelect:(id)sender;

@end
