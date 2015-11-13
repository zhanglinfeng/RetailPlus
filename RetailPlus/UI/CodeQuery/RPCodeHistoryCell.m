//
//  RPCodeHistoryCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-5-5.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCodeHistoryCell.h"

@implementation RPCodeHistoryCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setGoodsInfo:(GoodsTrackingInfo *)goodsInfo
{
    _goodsInfo=goodsInfo;
    _lbCode.text=goodsInfo.strCode;
    _lbContent.text=goodsInfo.strDetail;
}

-(void)updateUI
{
    if (_checked)
    {
        _ivSelected.image=[UIImage imageNamed:@"icon_selected_setup@2x.png"];
        self.backgroundColor=[UIColor colorWithRed:225/255.0 green:250/255.0 blue:193/255.0 alpha:1];
        _viewFrame.backgroundColor=[UIColor colorWithRed:225/255.0 green:250/255.0 blue:193/255.0 alpha:1];
    }
    else
    {
        _ivSelected.image=[UIImage imageNamed:@"icon_noselected_setup@2x.png"];
        self.backgroundColor=[UIColor clearColor];
        _viewFrame.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
    }
}
-(void)setChecked:(BOOL)checked
{
    _checked=checked;
    [self updateUI];
}
-(void)setBEdit:(BOOL)bEdit
{
    if (bEdit)
    {
        _viewFrame.frame=CGRectMake(40, _viewFrame.frame.origin.y, _viewFrame.frame.size.width, _viewFrame.frame.size.height);
    }
    else
    {
        _viewFrame.frame=CGRectMake(0, _viewFrame.frame.origin.y, _viewFrame.frame.size.width, _viewFrame.frame.size.height);
    }
}
@end
