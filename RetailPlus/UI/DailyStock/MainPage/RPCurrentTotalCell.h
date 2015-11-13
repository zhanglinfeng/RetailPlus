//
//  RPCurrentTotalCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPCurrentTotalCell : UITableViewCell
{
    
    IBOutlet UILabel *_lbCurrentCount;
}
@property(nonatomic,assign)NSInteger type;//type=0表示显示current，type=1表示显示last
@property(nonatomic,retain)RPDSDetail *dsDetail;
@end
