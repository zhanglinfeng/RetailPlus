//
//  RPinspCategoryDescCell.m
//  RetailPlus
//
//  Created by lin dong on 13-9-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPinspCategoryDescCell.h"

@implementation RPinspCategoryDescCell

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

-(void)setCategory:(InspCatagory *)category
{
    _category = category;
    _lbDesc.text = category.strCatagoryDesc;
    _lbTitle.text = category.strCatagoryName;
}
@end
