//
//  RPBookConfStartCell.h
//  RetailPlus
//
//  Created by lin dong on 14-6-19.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPConfDefine.h"

@interface RPBookConfStartCell : UITableViewCell
{
    IBOutlet UIImageView * _ivHost;
    IBOutlet UILabel     * _lbPhone;
    IBOutlet UILabel     * _lbDesc;
}

@property(nonatomic,retain) RPConfBookMember * member;
@end
