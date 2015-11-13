//
//  RPCtrlConfCell.m
//  RetailPlus
//
//  Created by lin dong on 14-6-23.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCtrlConfCell.h"

extern NSBundle * g_bundleResorce;

@implementation RPCtrlConfCell

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
    _lbGuestName.text = guest.strGuestName;
    if (guest.bMaster)
        _ivHost.image = [UIImage imageNamed:@"icon_host_phone.png"];
    else
        _ivHost.image = [UIImage imageNamed:@"icon_att_phone.png"];
    
    NSString *strConnected = NSLocalizedStringFromTableInBundle(@"Connected",@"RPString", g_bundleResorce,nil);
    
    switch (guest.nCallState) {
        case 0:
            _lbState.text = @"";
            break;
        case 1:
        case 2:
            _lbState.text = strConnected;
            break;
        case 3:
            _lbState.text = @"";
            break;
            
        default:
            break;
    }
    
}

@end
