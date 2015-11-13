//
//  RPELLearnRecordCell.m
//  RetailPlus
//
//  Created by lin dong on 14-8-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPELLearnRecordCell.h"

@implementation RPELLearnRecordCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRecord:(RPELLearnRecord *)record
{
    _record = record;
    
    _lbCourseWareCode.text = record.strCourseWareCode;
    _lbCourseWareName.text = record.strCourseWareName;
    _lbCourseName.text = record.strCourseName;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    _lbReadDate.text = [formatter stringFromDate:record.dateRead];
}
@end
