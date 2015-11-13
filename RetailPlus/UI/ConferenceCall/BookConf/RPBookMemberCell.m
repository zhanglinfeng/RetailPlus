//
//  RPBookMemberCell.m
//  RetailPlus
//
//  Created by lin dong on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBookMemberCell.h"

@implementation RPBookMemberCell

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
    _lbGuestPhone.text = member.strMemberPhone;
    _lbGuestEmail.text = member.strMemberEmail;
    _lbGuestName.text = member.strMemberDesc;
}

@end
