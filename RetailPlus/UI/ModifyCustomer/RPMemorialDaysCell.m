//
//  RPMemorialDaysCell.m
//  RetailPlus
//
//  Created by zwhe on 13-12-20.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPMemorialDaysCell.h"

//@implementation RPMemorialDaysCell
//
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//       
//    }
//    return self;
//}
//
//-(void)awakeFromNib
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
//    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
//    NSDate * date = [NSDate dateWithTimeIntervalSince1970:0];
//    _pickDate = [[RPDatePicker alloc] init:_tfDate Format:dateFormatter curDate:date];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped:)];
//    [self addGestureRecognizer:tap];
//
//    
//}
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [_memorialDayDelegate up:YES];
//}
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [_memorialDayDelegate up:NO];
//}

//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//
//    [_memorialDayDelegate contentOffset:_i];
//}
//-(void)saveAge
//{
//    NSLog(@"====%@",_tfMemorialContent.text);
//    
//    _memorial.memorialContent=_tfMemorialContent.text;
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//-(void)setMemorial:(MyMemorialDays *)memorial
//{
//    _memorial=memorial;
//    _tfDate.text=memorial.memorialDate;
//    _tfMemorialContent.text=memorial.memorialContent;
//    [_tfMemorialContent addTarget:self action:@selector(saveAge) forControlEvents:UIControlEventEditingChanged];
//    
//}
//- (IBAction)OnDeleteMemorialDay:(id)sender {
//    [_memorialDayDelegate OnDeleteMemorialDay:_memorial];
//}
//@end
