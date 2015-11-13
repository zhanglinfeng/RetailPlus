//
//  RPRelatedTaskCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-9-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPRelatedTaskCell : UITableViewCell
{
    IBOutlet UIView *_viewColor;
    IBOutlet UILabel *_lbCode;
    
    IBOutlet UILabel *_lbTitle;
    IBOutlet UILabel *_lbDate;
    IBOutlet UILabel *_lbExe;
    IBOutlet UILabel *_lbPoster;
    IBOutlet UILabel *_lbIsCalendar;
}
@property(nonatomic,retain)TaskInfo *task;
@end
