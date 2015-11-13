//
//  RPLogBookSearchCell.h
//  RetailPlus
//
//  Created by lin dong on 14-3-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"
@interface RPLogBookSearchCell : UITableViewCell
{
    
    IBOutlet UILabel *_lbDesc;
    IBOutlet UILabel *_lbTime;
    IBOutlet UILabel *_lbTitle;
    IBOutlet UILabel *_lbStoreName;
    IBOutlet UILabel *_lbTagDesc;
    IBOutlet UILabel *_lbPost;
    
}
@property(nonatomic,assign) LogBookDetail * searchDetail;
@property(nonatomic,strong)IBOutlet UILabel *lbName;
@end
