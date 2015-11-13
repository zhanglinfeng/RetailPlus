//
//  RPBookConfStartCell.m
//  RetailPlus
//
//  Created by lin dong on 14-6-19.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBookConfStartCell.h"

@implementation RPBookConfStartCell

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

-(void)setMember:(RPConfBookMember *)member
{
    _member = member;
    _lbDesc.text = member.strMemberDesc;
    _lbPhone.text = member.strMemberPhone;
    if (member.bMaster)
        _ivHost.image = [UIImage imageNamed:@"icon_host_phone.png"];
    else
        _ivHost.image = [UIImage imageNamed:@"icon_att_phone.png"];
}
@end
