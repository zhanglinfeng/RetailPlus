//
//  RPELExamRecordCell.m
//  RetailPlus
//
//  Created by lin dong on 14-8-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPELExamRecordCell.h"

@implementation RPELExamRecordCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRecord:(RPELExamRecord *)record
{
    _record = record;
    
    _lbPapaerCode.text = record.strNo;
    _lbPaperName.text = record.strTitle;
    if (fabs(((int)_record.fScore - _record.fScore)) > 0.01)
        _lbScore.text = [NSString stringWithFormat:@"%0.1f",_record.fScore];
    else
        _lbScore.text = [NSString stringWithFormat:@"%0.0f",_record.fScore];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    _lbExamDate.text = [formatter stringFromDate:record.dateExam];
}
@end
