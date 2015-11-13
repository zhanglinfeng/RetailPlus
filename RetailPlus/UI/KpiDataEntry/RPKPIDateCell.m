//
//  RPKPIDateCell.m
//  RetailPlus
//
//  Created by zwhe on 14-1-14.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPKPIDateCell.h"

@implementation RPKPIDateCell

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

-(void)setSalesData:(KPISalesData *)salesData
{
    _salesData = salesData;
    _lbDate.text = [NSString stringWithFormat:@"%04d-%02d-%02d",salesData.nYear,salesData.nMonth,salesData.nDay];
    _lbTXNQTY.text = [RPSDK numberFormatter:[NSNumber numberWithInteger:salesData.nTraQty]];
    _lbSalesAmount.text = [RPSDK numberFormatter:[NSNumber numberWithInteger:salesData.nAmount]];
    _lbSalesQty.text = [RPSDK numberFormatter:[NSNumber numberWithInteger:salesData.nProQty]];
    if (salesData.mode==KPIMode_Day) {
        _ivMode.hidden=YES;
    }
    else
    {
        _ivMode.hidden=NO;
    }
}
@end
