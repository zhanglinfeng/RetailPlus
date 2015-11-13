//
//  RPTrafficDataCell.h
//  RetailPlus
//
//  Created by zwhe on 14-1-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPTrafficDataCell : UITableViewCell
@property(strong,nonatomic)KPITrafficData *trafficDate;
@property (strong, nonatomic) IBOutlet UIImageView *ivMode;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;
@property (strong, nonatomic) IBOutlet UILabel *lbTraffic;

@end
