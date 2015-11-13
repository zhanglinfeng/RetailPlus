//
//  RPBookMemberCell.h
//  RetailPlus
//
//  Created by lin dong on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPConfDefine.h"

@interface RPBookMemberCell : UITableViewCell
{
    IBOutlet UILabel * _lbGuestPhone;
    IBOutlet UILabel * _lbGuestName;
    IBOutlet UILabel * _lbGuestEmail;
}

@property(nonatomic,assign) RPConfBookMember * member;

@end
