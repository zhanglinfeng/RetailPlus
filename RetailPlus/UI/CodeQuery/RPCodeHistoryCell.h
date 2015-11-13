//
//  RPCodeHistoryCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-5-5.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPCodeHistoryCell : UITableViewCell
{
    IBOutlet UIImageView *_ivSelected;
    IBOutlet UIView *_viewFrame;
    IBOutlet UILabel *_lbCode;
    IBOutlet UILabel *_lbContent;
    
}
@property(nonatomic,strong)GoodsTrackingInfo *goodsInfo;
@property(nonatomic)BOOL checked;
@property(nonatomic)BOOL bEdit;
@end
