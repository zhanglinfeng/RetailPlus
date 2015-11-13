//
//  RPDatePicker.m
//  RetailPlus
//
//  Created by zwhe on 13-12-21.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPDatePicker.h"

@implementation RPDatePicker

-(id)init:(UIView *)view Format:(NSDateFormatter *)format curDate:(NSDate *)date canDelete:(BOOL)bCanDelete Mode:(UIDatePickerMode)mode canFuture:(BOOL)bCanFuture canPreviously:(BOOL)bPreviously
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPDatePickerView" owner:self options:nil];
        _datePicker = [array objectAtIndex:0];
        _datePickerAcc = [array objectAtIndex:1];
        
        _datePicker.bCanDelete = bCanDelete;
        _datePicker.formatter = format;
        _datePicker.mode=mode;
        _datePicker.viewParent = view;
        _datePickerAcc.viewParent = view;
        _datePicker.date = date;
        _datePicker.bCanFuture = bCanFuture;
        _datePicker.bCanPreviously=bPreviously;
        if ([view isKindOfClass:[UITextField class]]) {
            [(UITextField *)view setInputView:_datePicker];
            _datePicker.superview.backgroundColor  = [UIColor clearColor];
       //     [(UITextField *)view setInputAccessoryView:_datePickerAcc];
        }
        return self;
    }
    return nil;
}

-(NSDate *)GetDate
{
    return _datePicker.date;
}

-(id)initDay:(UIView *)view Format:(NSDateFormatter *)format curDate:(NSDate *)date canDelete:(BOOL)bCanDelete
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPDatePickerView" owner:self options:nil];
        _dayPicker = [array objectAtIndex:2];
        
        _dayPicker.bCanDelete = bCanDelete;
        _dayPicker.formatter = format;
        _dayPicker.viewParent = view;
        _dayPicker.date = date;
        if ([view isKindOfClass:[UITextField class]]) {
            [(UITextField *)view setInputView:_dayPicker];
            _dayPicker.superview.backgroundColor  = [UIColor clearColor];
            //     [(UITextField *)view setInputAccessoryView:_datePickerAcc];
        }
        return self;
    }
    return nil;
}

-(NSDate *)GetDay
{
    return _dayPicker.date;
}
@end
