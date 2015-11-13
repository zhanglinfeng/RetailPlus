//
//  RPStoreDomainCell.m
//  RetailPlus
//
//  Created by lin dong on 14-9-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPStoreDomainCell.h"

@implementation RPStoreDomainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfo:(DomainInfo *)info
{
    _info = info;
    _lbDomainName.text = info.strDomainName;
}
@end
