//
//  RPIOTotalCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPIOTotalCell : UITableViewCell
{
    IBOutlet UILabel *_lbIn;
    
    IBOutlet UILabel *_lbOut;
}
@property(nonatomic,retain)RPDSDetail *dsDetail;
@end
