//
//  RPRelatedTaskCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-9-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPRelatedTaskCell.h"

@implementation RPRelatedTaskCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setTask:(TaskInfo *)task
{
    _lbCode.text=task.strOther;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    _lbDate.text=[dateFormatter stringFromDate:task.dateEnd];
    _lbExe.text=task.userExecutor.strFirstName;
    _lbPoster.text=task.userInitiator.strFirstName;
    _lbTitle.text=task.strTitle;
}
@end
