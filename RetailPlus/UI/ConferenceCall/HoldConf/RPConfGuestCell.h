//
//  RPConfGuestCell.h
//  RetailPlus
//
//  Created by lin dong on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPConfDefine.h"

@interface RPConfGuestCell : UITableViewCell
{
    IBOutlet UILabel * _lbGuestPhone;
    IBOutlet UILabel * _lbGuestName;
    IBOutlet UILabel * _lbGuestEmail;
}
@property(nonatomic,assign) RPConfGuest * guest;
@end
