//
//  RPBlockUISelectBodyCell.m
//  RetailPlus
//
//  Created by lin dong on 14-2-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBlockUISelectBodyCell.h"

@implementation RPBlockUISelectBodyCell

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

-(void)setBSelected:(BOOL)bSelected
{
    _bSelected = bSelected;
    if (bSelected)
    {
        _lbTitle.textColor = [UIColor colorWithRed:44.0f/255 green:96.0f/255 blue:101.0f/255 alpha:1];
        _ivTip.image = [UIImage imageNamed:@"icon_circle_selected.png"];
    }
    else
    {
        _lbTitle.textColor = [UIColor colorWithRed:43.0f/255 green:43.0f/255 blue:43.0f/255 alpha:1];
        _ivTip.image = [UIImage imageNamed:@"icon_circle_noselected.png"];
    }
}

-(void)setStrTitle:(NSString *)strTitle
{
    _strTitle = strTitle;
    _lbTitle.text = strTitle;
    
    CGSize sz = [_lbTitle sizeThatFits:CGSizeMake(_lbTitle.frame.size.width, 10000)];
    _lbTitle.frame = CGRectMake(_lbTitle.frame.origin.x, _lbTitle.frame.origin.y, _lbTitle.frame.size.width, sz.height);
    
    _nHeight = sz.height + 23;
}
@end
