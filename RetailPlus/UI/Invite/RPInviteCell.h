//
//  RPInviteCell.h
//  RetailPlus
//
//  Created by lin dong on 13-8-30.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPInviteCell : UITableViewCell
{
    IBOutlet UIView     * _viewRole;
    IBOutlet UILabel    * _lbRole;
}

@property (nonatomic,assign) InviteRole * role;
@end
