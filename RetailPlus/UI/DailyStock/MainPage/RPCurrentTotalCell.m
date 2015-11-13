//
//  RPCurrentTotalCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCurrentTotalCell.h"

@implementation RPCurrentTotalCell

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
    if (_type==0)
    {
        _lbCurrentCount.text=[NSString stringWithFormat:@"%i",dsDetail.nCurrentAmount];
    }
    else
    {
        _lbCurrentCount.text=[NSString stringWithFormat:@"%i",dsDetail.nLastAmount];
    }
    
}
@end
