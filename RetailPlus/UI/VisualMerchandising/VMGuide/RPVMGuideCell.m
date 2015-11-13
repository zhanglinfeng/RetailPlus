//
//  RPVMGuideCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPVMGuideCell.h"

@implementation RPVMGuideCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setGuide:(RPvmGuide *)guide
{
    _lbName.text=guide.strName;
}
@end
