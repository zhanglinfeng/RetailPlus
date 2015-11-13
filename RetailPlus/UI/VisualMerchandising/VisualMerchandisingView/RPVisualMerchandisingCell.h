//
//  RPVisualMerchandisingCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributedLabel.h"
@interface RPVisualMerchandisingCell : UITableViewCell
{
    IBOutlet UIView *_viewFrame;
    
    IBOutlet UIImageView *_ivPic;
    IBOutlet UILabel *_lbTitle;
    IBOutlet AttributedLabel *_lbComments;
    IBOutlet UIView *_viewColor;
    IBOutlet UIImageView *_ivState;
}
@property(nonatomic,strong)VisualDisplay *visualDisplay;
@end
