//
//  RPStockSearchCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPStockSearchCell.h"

@implementation RPStockSearchCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setStoreStockList:(StoreStockList *)storeStockList
{
    _storeStockList=storeStockList;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    _lbDate.text=[formatter stringFromDate:_storeStockList.closeTime];
    _lbCount.text=[NSString stringWithFormat:@"%i",_storeStockList.countAmount];
    NSInteger difference=_storeStockList.countAmount-(_storeStockList.lastAmount+_storeStockList.inAmount-_storeStockList.outAmount);
    _lbDifference.text=[NSString stringWithFormat:@"%i",difference];
    if (difference==0)
    {
        _ivYes.hidden=NO;
        _lbDifference.hidden=YES;
    }
    else
    {
        _ivYes.hidden=YES;
        _lbDifference.hidden=NO;
    }
}
@end
