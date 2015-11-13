//
//  RPTrafficDataCell.m
//  RetailPlus
//
//  Created by zwhe on 14-1-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTrafficDataCell.h"

@implementation RPTrafficDataCell

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

-(void)setTrafficDate:(KPITrafficData *)trafficDate
{
    _trafficDate=trafficDate;
    _lbDate.text=[NSString stringWithFormat:@"%04d-%02d-%02d",trafficDate.nYear,trafficDate.nMonth,trafficDate.nDay];
    _lbTraffic.text=[RPSDK numberFormatter:[NSNumber numberWithInteger:trafficDate.nTraffic]];
    if (trafficDate.mode==KPIMode_Day) {
        _ivMode.hidden=YES;
    }
    else
    {
        _ivMode.hidden=NO;
    }
}

@end
