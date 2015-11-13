//
//  RPConfGuestCell.m
//  RetailPlus
//
//  Created by lin dong on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPConfGuestCell.h"

@implementation RPConfGuestCell

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

@end
