//
//  RPInviteCell.m
//  RetailPlus
//
//  Created by lin dong on 13-8-30.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPInviteCell.h"

@implementation RPInviteCell

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

- (void)setRole:(InviteRole *)role
{
    _role = role;
    switch (role.rankRole)
    {
        case Rank_Manager:
            _viewRole.backgroundColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _viewRole.backgroundColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _viewRole.backgroundColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _viewRole.backgroundColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }
    _lbRole.text = role.strRoleName;
}
@end
