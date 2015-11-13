//
//  RPLoginDeviceCell.h
//  RetailPlus
//
//  Created by lin dong on 13-11-20.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPLoginDeviceCell : UITableViewCell
{
    IBOutlet UILabel    * _lbDeviceName;
    IBOutlet UILabel    * _lbDeviceType;
}
@property (nonatomic,assign) LoginDevice * device;
@end
