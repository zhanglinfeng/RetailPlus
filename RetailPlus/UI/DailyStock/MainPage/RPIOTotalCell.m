//
//  RPIOTotalCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPIOTotalCell.h"

@implementation RPIOTotalCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDsDetail:(RPDSDetail *)dsDetail
{
    _lbIn.text=[NSString stringWithFormat:@"+%i",dsDetail.nInAmount];
    _lbOut.text=[NSString stringWithFormat:@"-%i",dsDetail.nOutAmount];
}
@end
