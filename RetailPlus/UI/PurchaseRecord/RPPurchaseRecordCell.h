//
//  RPPurchaseRecordCell.h
//  RetailPlus
//
//  Created by zwhe on 13-12-27.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPPurchaseRecordClass.h"
@interface RPPurchaseRecordCell : UITableViewCell
@property (strong, nonatomic)CustomerPurchase *record;
@property (strong, nonatomic) IBOutlet UILabel *lbProductName;
@property (strong, nonatomic) IBOutlet UILabel *lbAmount;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;
@property (strong, nonatomic) IBOutlet UILabel *lbQty;

@end
