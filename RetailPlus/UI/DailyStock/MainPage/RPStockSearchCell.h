//
//  RPStockSearchCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPStockSearchCell : UITableViewCell
{
    IBOutlet UILabel *_lbDate;
    
    IBOutlet UILabel *_lbCount;
    IBOutlet UILabel *_lbDifference;
    IBOutlet UIImageView *_ivYes;
}
@property (nonatomic,strong)StoreStockList *storeStockList;
@end
