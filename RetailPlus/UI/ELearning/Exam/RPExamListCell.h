//
//  RPExamListCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RPSDKELDefine.h"
@interface RPExamListCell : UITableViewCell

{
    
    IBOutlet UILabel *_lbNumber;
    IBOutlet UILabel *_lbTitle;
    IBOutlet UILabel *_lbScore;
    IBOutlet UILabel *_lbLastScore;
}
@property(nonatomic,strong)RPELPaper *paper;
@end
