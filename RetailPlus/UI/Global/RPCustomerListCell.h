//
//  RPCustomerListCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-13.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPCustomerListCell : UITableViewCell
{
    IBOutlet UIImageView * _ivThumb;
    IBOutlet UILabel     * _lbName;
    IBOutlet UILabel     * _lbAddress;
}
-(void)setCustomer:(Customer *)customer;
@end
