//
//  RPBVisitCategoryDescCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBVisitCategoryDescCell.h"

@implementation RPBVisitCategoryDescCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
+(NSInteger)calcLabelHeight:(NSString *)strText
{
    NSInteger nLableHeight = 20;
    
    CGSize size = [strText sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(281, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    if (size.height >20) {
        nLableHeight = size.height+20;
    }
    else
    {
        nLableHeight = 20+20;
    }
    
    return nLableHeight+30;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//-(void)setCategory:(BVisitCategory *)category
//{
//    _category = category;
////    _lbDesc.text = category.strCatagoryDesc;
//    _lbTitle.text = category.strCategoryName;
//}
-(void)setVisitItem:(BVisitItem *)visitItem
{
    _visitItem=visitItem;
    _lbDesc.text=visitItem.strItemDesc;
    _lbTitle.text=visitItem.strItemTitle;
    CGSize size = [visitItem.strItemDesc sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(281, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    _lbDesc.frame=CGRectMake(_lbDesc.frame.origin.x, _lbDesc.frame.origin.y, _lbDesc.frame.size.width, size.height+20);
}
@end
