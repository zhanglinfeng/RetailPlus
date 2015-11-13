//
//  RPCtrlConfCell.h
//  RetailPlus
//
//  Created by lin dong on 14-6-23.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPConfDefine.h"

@interface RPCtrlConfCell : UITableViewCell
{
    IBOutlet UILabel        * _lbGuestPhone;
    IBOutlet UILabel        * _lbGuestEmail;
    IBOutlet UILabel        * _lbGuestName;
    IBOutlet UILabel        * _lbState;
    
    IBOutlet UIImageView    * _ivHost;
}

@property (nonatomic,assign) RPConfGuest * guest;
@end
