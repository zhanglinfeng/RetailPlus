//
//  RPConfBookCell.h
//  RetailPlus
//
//  Created by lin dong on 14-6-19.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPConfDefine.h"

@interface RPConfBookCell : UITableViewCell
{
    IBOutlet UILabel * _lbDate;
    IBOutlet UILabel * _lbTime;
    IBOutlet UILabel * _lbTheme;
    IBOutlet UILabel * _lbHostPhone;
    IBOutlet UILabel * _lbMemberCount;
}

@property (nonatomic,retain) RPConfBook * book;
@end
