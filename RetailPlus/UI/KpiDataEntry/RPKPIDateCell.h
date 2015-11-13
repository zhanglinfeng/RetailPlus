//
//  RPKPIDateCell.h
//  RetailPlus
//
//  Created by zwhe on 14-1-14.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPKPIDateCell : UITableViewCell
{
    
}
@property(nonatomic,strong)KPISalesData *salesData;
@property(nonatomic,strong) IBOutlet UIImageView *ivMode;
@property(nonatomic,strong)IBOutlet UILabel *lbDate;
@property(nonatomic,strong)IBOutlet UILabel *lbTXNQTY;
@property(nonatomic,strong)IBOutlet UILabel *lbSalesQty;
@property(nonatomic,strong)IBOutlet UILabel *lbSalesAmount;
@end
