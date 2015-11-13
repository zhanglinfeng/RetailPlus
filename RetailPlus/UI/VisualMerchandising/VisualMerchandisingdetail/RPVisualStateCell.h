//
//  RPVisualStateCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPVisualStateCell : UITableViewCell
{
    
    IBOutlet UIView *_viewFrame;
    IBOutlet UILabel *_lbName;
    IBOutlet UILabel *_lbState;
    IBOutlet UIImageView *_ivState;
    IBOutlet UILabel *_lbDate;
    
}
@property(nonatomic,strong)VMReply *vmReply;
@end
