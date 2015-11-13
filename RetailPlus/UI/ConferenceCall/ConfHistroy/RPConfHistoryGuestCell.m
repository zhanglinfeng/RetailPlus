//
//  RPConfHistoryGuestCell.m
//  RetailPlus
//
//  Created by lin dong on 14-6-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPConfHistoryGuestCell.h"

@implementation RPConfHistoryGuestCell

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

-(void)setGuest:(RPConfGuest *)guest
{
    _lbGuestPhone.text = guest.strPhone;
    _lbGuestEmail.text = guest.strEmail;
    _lbGuestName.text = guest.strGuestName;
}

-(void)setBMaster:(BOOL)bMaster
{
    _bMaster = bMaster;
    if (_bMaster)
        _ivHost.image = [UIImage imageNamed:@"icon_host_phone.png"];
    else
        _ivHost.image = [UIImage imageNamed:@"icon_att_phone.png"];
}
@end
