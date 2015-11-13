//
//  RPInspReportsCell.m
//  RetailPlus
//
//  Created by lin dong on 13-9-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPInspReportsCell.h"

@implementation RPInspReportsCell

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
