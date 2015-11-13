//
//  RPConfHistoryGuestCell.h
//  RetailPlus
//
//  Created by lin dong on 14-6-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPConfDefine.h"

@interface RPConfHistoryGuestCell : UITableViewCell
{
    IBOutlet UILabel        * _lbGuestPhone;
    IBOutlet UILabel        * _lbGuestEmail;
    IBOutlet UILabel        * _lbGuestName;
    IBOutlet UIImageView    * _ivHost;
}

@property(nonatomic,assign) BOOL        bMaster;
@property(nonatomic,assign) RPConfGuest * guest;

@end
