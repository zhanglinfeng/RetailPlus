//
//  RPDatePickerDayView.m
//  RetailPlus
//
//  Created by lin dong on 14-2-11.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPDatePickerDayView.h"
#import "RPLanguageViewController.h"

@implementation RPDatePickerDayView

extern LangType g_langType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
    //[_pickerDate setDate:date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM"];
    [_pickDay selectRow:[dateFormatter stringFromDate:date].integerValue - 1 inComponent:0 animated:YES];
    [dateFormatter setDateFormat: @"dd"];
    [_pickDay selectRow:[dateFormatter stringFromDate:date].integerValue - 1 inComponent:1 animated:YES];
    
    [self ShowDateText];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 12;
            break;
        case 1:
        {
            switch ([pickerView selectedRowInComponent:0]) {
                case 0:
                case 2:
                case 4:
                case 6:
                case 7:
                case 9:
                case 11:
                    return 31;
                    break;
                case 1:
                    return 29;
                    break;
                default:
                    break;
            }
            return 30;
        }
        default:
            break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            [dateFormatter setDateStyle:NSDateFormatterFullStyle];
            [dateFormatter setDateFormat:@"MMM"];
            switch (g_langType) {
                case LangType_Auto:
                    
                    break;
                case LangType_English:
                {
                    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                    [dateFormatter setLocale:locale];
                }
                    break;
                case LangType_Hans:
                {
                    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
                    [dateFormatter setLocale:locale];
                }
                    break;
                default:
                    break;
            }
            
            
            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat: @"MM"];
            NSString * str = [dateFormatter stringFromDate:[dateFormatter2 dateFromString:[NSString stringWithFormat:@"%02d",row + 1]]];
            return str;
        }
            break;
        case 1:
            switch (g_langType) {
                case LangType_Auto:
                {
                    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
                    NSArray * languages = [defs objectForKey:@"AppleLanguages"];
                    NSString * preferredLang = [languages objectAtIndex:0];
                    if ([preferredLang isEqualToString:@"zh-Hans"])
                    {
                        return [NSString stringWithFormat:@"%d日",row + 1];
                    }
                    else
                    {
                        return [NSString stringWithFormat:@"%d",row + 1];
                    }
                }
                    break;
                case LangType_English:
                    return [NSString stringWithFormat:@"%d",row + 1];
                    break;
                case LangType_Hans:
                    return [NSString stringWithFormat:@"%d日",row + 1];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        [pickerView reloadComponent:1];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM-dd"];
    _date = [[NSDate alloc] init];
    _date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%02d-%02d",[pickerView selectedRowInComponent:0] + 1,[pickerView selectedRowInComponent:1] + 1]];
    [self ShowDateText];
}

-(void)dateChanged:(id)sender{
    UIDatePicker * control = (UIDatePicker*)sender;
    _date = control.date;
    [self ShowDateText];
}

-(void)ShowDateText
{
    if ([_viewParent isKindOfClass:[UITextField class]])
    {
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setLocale:locale];
        
        switch (g_langType) {
            case LangType_Auto:
            {
                NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
                NSArray * languages = [defs objectForKey:@"AppleLanguages"];
                NSString * preferredLang = [languages objectAtIndex:0];
                if ([preferredLang isEqualToString:@"zh-Hans"])
                {
                    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
                    [formatter setLocale:locale];
                    [formatter setDateFormat:@"MMM dd日"];
                }
                else
                {
                    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                    [formatter setLocale:locale];
                    [formatter setDateFormat:@"MMM, dd"];                }
            }
                break;
            case LangType_English:
            {
                NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                [formatter setLocale:locale];
                [formatter setDateFormat:@"MMM, dd"];
            }
                break;
            case LangType_Hans:
            {
                NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
                [formatter setLocale:locale];
                [formatter setDateFormat:@"MMM dd日"];
            }
                break;
            default:
                break;
        }
        ((UITextField *)_viewParent).text = [formatter stringFromDate:_date];
    }
}

-(IBAction)OnEndEdit:(id)sender
{
    if ([_viewParent isKindOfClass:[UITextField class]]) {
        [(UITextField *)_viewParent endEditing:YES];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM-dd"];
    _date = [[NSDate alloc] init];
    _date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%02d-%02d",[_pickDay selectedRowInComponent:0] + 1,[_pickDay selectedRowInComponent:1] + 1]];
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
@end
