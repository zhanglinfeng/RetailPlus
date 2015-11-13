//
//  RPDatePicerView.m
//  InputTable
//
//  Created by lin dong on 13-12-21.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPDatePicerView.h"

@implementation RPDatePicerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [_pickerDate addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    //_pickerDate.maximumDate = [NSDate date];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setDate:(NSDate *)date
{
    _date = date;
    if (date) {
        _date = date;
    }
    else
    {
        _date=[NSDate date];
    }
    [_pickerDate setDate:_date];
    [self ShowDateText];
}
-(void)setMode:(UIDatePickerMode)mode
{
    _pickerDate.datePickerMode=mode;
}
-(void)dateChanged:(id)sender{
    UIDatePicker * control = (UIDatePicker*)sender;
    _date = control.date;
    [self ShowDateText];
}

-(void)ShowDateText
{
    if ([_viewParent isKindOfClass:[UITextField class]])
        ((UITextField *)_viewParent).text = [_formatter stringFromDate:_date];
}

-(IBAction)OnEndEdit:(id)sender
{
    if ([_viewParent isKindOfClass:[UITextField class]]) {
        [(UITextField *)_viewParent endEditing:YES];
    }
    [self ShowDateText];
}

-(IBAction)OnDelete:(id)sender
{
    if ([_viewParent isKindOfClass:[UITextField class]]) {
        ((UITextField *)_viewParent).text = @"";
        [(UITextField *)_viewParent endEditing:YES];
    }
}

-(void)setBCanDelete:(BOOL)bCanDelete
{
    _bCanDelete = bCanDelete;
    if (bCanDelete)
    {
        _ivCanDelete.hidden = NO;
        _ivNoDelete.hidden = YES;
        
        _btnHide.hidden = YES;
        _btnCofirm.hidden = NO;
        _btnDelete.hidden = NO;
    }
    else
    {
        _ivCanDelete.hidden = YES;
        _ivNoDelete.hidden = NO;
        
        _btnHide.hidden = NO;
        _btnCofirm.hidden = YES;
        _btnDelete.hidden = YES;
    }
}

-(void)setBCanFuture:(BOOL)bCanFuture
{
    _bCanFuture = bCanFuture;
    if (bCanFuture)
        _pickerDate.maximumDate = nil;
    else
        _pickerDate.maximumDate = [NSDate date];
    
}

-(void)setBCanPreviously:(BOOL)bCanPreviously
{
    _bCanPreviously=bCanPreviously;
    if (!_bCanPreviously)
    {
        _pickerDate.minimumDate = [NSDate date];
    }
}
@end
