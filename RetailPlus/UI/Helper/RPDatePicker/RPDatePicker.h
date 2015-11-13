//
//  RPDatePicker.h
//  RetailPlus
//
//  Created by zwhe on 13-12-21.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPDatePicerView.h"
#import "RPDatePickerAccView.h"
#import "RPDatePickerDayView.h"

@interface RPDatePicker : NSObject
{
    RPDatePicerView         * _datePicker;
    RPDatePickerAccView     * _datePickerAcc;
    RPDatePickerDayView     * _dayPicker;
}

-(id)init:(UIView *)view Format:(NSDateFormatter *)format curDate:(NSDate *)date canDelete:(BOOL)bCanDelete Mode:(UIDatePickerMode)mode canFuture:(BOOL)bCanFuture canPreviously:(BOOL)bPreviously;
-(NSDate *)GetDate;

-(id)initDay:(UIView *)view Format:(NSDateFormatter *)format curDate:(NSDate *)date canDelete:(BOOL)bCanDelete;
-(NSDate *)GetDay;
@end
