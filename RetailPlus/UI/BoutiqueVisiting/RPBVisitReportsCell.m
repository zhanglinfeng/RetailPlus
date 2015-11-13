//
//  RPBVisitReportsCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBVisitReportsCell.h"

@implementation RPBVisitReportsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setReport:(InspReportResult *)report
{
    _report = report;
    
    _lbReportName.text = [NSString stringWithFormat:@"%@ %@ Report",report.strStoreName,report.strBrandName];
    
    _lbReportDetail.text = [NSString stringWithFormat:@"%@, by %@",report.strInspectionDate,report.strInspctor];
    
    [_btnChecked setSelected:report.bSelected];
}

-(IBAction)OnSelect:(id)sender
{
    self.report.bSelected = !self.report.bSelected;
    [_btnChecked setSelected:self.report.bSelected];
    
    [self.delegate OnSelect:self.report];
}
@end
