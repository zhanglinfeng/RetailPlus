//
//  RPLoginDeviceCell.m
//  RetailPlus
//
//  Created by lin dong on 13-11-20.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPLoginDeviceCell.h"

@implementation RPLoginDeviceCell

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

-(void)setDevice:(LoginDevice *)device
{
    _device = device;
    _lbDeviceName.text = device.strDeviceName;
    _lbDeviceType.text = [NSString stringWithFormat:@"%@ (%@)",device.strDeviceType,device.strLastLoginDate];
}

@end
