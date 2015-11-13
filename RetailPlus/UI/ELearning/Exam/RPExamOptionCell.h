//
//  RPExamOptionCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-25.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RPSDKELDefine.h"
@interface RPExamOptionCell : UITableViewCell
{
    IBOutlet UILabel *_lbOption;
    IBOutlet UIView *_viewBG;
    
}
@property(nonatomic,strong)RPELOption *Option;
@property (strong, nonatomic) IBOutlet UIImageView *ivSelect;
@end
