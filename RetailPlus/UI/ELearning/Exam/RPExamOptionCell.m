//
//  RPExamOptionCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-25.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPExamOptionCell.h"

@implementation RPExamOptionCell

- (void)awakeFromNib
{
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOption:(RPELOption *)Option
{
    _Option=Option;
    _lbOption.text=_Option.strOption;
    if (_Option.bSelect)
    {
        _viewBG.hidden=NO;
    }
    else
    {
        _viewBG.hidden=YES;
    }
}
@end
