//
//  RPBVisitTemplateCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPBVisitTemplateCell : UITableViewCell
{
    
    IBOutlet UILabel *_name;
    IBOutlet UILabel *_count;
}
@property(nonatomic,strong)BVisitTemplate *visitTemplate;
@end
