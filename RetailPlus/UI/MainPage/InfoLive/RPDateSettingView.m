//
//  RPDateSettingView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPDateSettingView.h"
#import "RPLanguageViewController.h"



extern LangType g_langType;

@implementation RPDateSettingView

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
-(void)awakeFromNib
{
    _backgroundView.layer.cornerRadius=10;
    _btDay.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
    _btDay.layer.borderWidth=1;
    _btDay.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    [_btDay setTitleColor:[UIColor colorWithRed:48.0f/255 green:115.0f/255 blue:119.0f/255 alpha:1] forState:UIControlStateNormal];
    _btDay.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
    
    _btMonth.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btMonth.layer.borderWidth=0;
    [_btMonth setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btMonth.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btQuarter.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btQuarter.layer.borderWidth=0;
    [_btQuarter setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btQuarter.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btWeek.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btWeek.layer.borderWidth=0;
    [_btWeek setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btWeek.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btYear.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btYear.layer.borderWidth=0;
    [_btYear setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btYear.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    [_datePicker addTarget:self action:@selector(datePickerDateChange:) forControlEvents:UIControlEventValueChanged];
    
    [self loadDateSource];
    
    _range = [[KPIDateRange alloc] init];
    _range.type = KPIDateRangeType_Day;
    _datePicker.hidden = NO;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString * strBeginDate = [NSString stringWithFormat:@"%04d-%02d-%02d",[RPSDK DateToYear:[NSDate date]] - YEARCOUNT + 1,1,1];
    _datePicker.minimumDate = [dateFormatter dateFromString:strBeginDate];
    _datePicker.maximumDate = [NSDate date];
    
    _pickerWeek.hidden = YES;
    _pickerMonth.hidden = YES;
    _pickerQuarter.hidden = YES;
    _pickerYear.hidden = YES;
    
    [self selectNow];
}

-(void)selectNow
{
    [_datePicker setDate:[NSDate date] animated:YES];
    [_pickerWeek selectRow:YEARCOUNT - 1 inComponent:0 animated:YES];
    [_pickerMonth selectRow:YEARCOUNT - 1 inComponent:0 animated:YES];
    [_pickerQuarter selectRow:YEARCOUNT - 1 inComponent:0 animated:YES];
    [_pickerYear selectRow:YEARCOUNT - 1 inComponent:0 animated:YES];
    
    [_pickerWeek selectRow:[RPSDK DateToWeek:[NSDate date]] - 1 inComponent:1 animated:NO];
    [_pickerMonth selectRow:[RPSDK DateToMonth:[NSDate date]] - 1 inComponent:1 animated:NO];
    [_pickerQuarter selectRow:[RPSDK DateToQuarter:[NSDate date]] - 1 inComponent:1 animated:NO];
    
    [_pickerWeek reloadAllComponents];
    [_pickerMonth reloadAllComponents];
    [_pickerQuarter reloadAllComponents];
}

//动态获取datepicker时间
-(void)datePickerDateChange:(UIDatePicker *)paramDatePicker
{
    if ([paramDatePicker isEqual:_datePicker])
    {
        NSLog(@"Selected date=%@",paramDatePicker.date);
        //创建一个日历格式
        NSCalendar *calendar = [NSCalendar currentCalendar];
        //从date中根据日历获取各时间组成部分
        NSDateComponents*components =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:paramDatePicker.date];
        //获得时间信息
        
        int nowYear=[components year];
        int nowMonth=[components month];
        int nowDay=[components day];
        NSString *time=[NSString stringWithFormat:@"%i-%i-%i",nowYear,nowMonth,nowDay];
        
        NSLog(@"日期%@",time);
    }
}

-(void)loadDateSource
{
    _arrayMonth=[[NSMutableArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == _pickerYear) return 1;
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return YEARCOUNT;
            break;
        case 1:
        {
            if (pickerView == _pickerWeek)
            {
                if ([_pickerWeek selectedRowInComponent:0] == (YEARCOUNT - 1))
                    return [RPSDK DateToWeek:[NSDate date]];
                else
                    return 53;
            }
            
            if (pickerView == _pickerMonth)
            {
                if ([_pickerMonth selectedRowInComponent:0] == (YEARCOUNT - 1))
                    return [RPSDK DateToMonth:[NSDate date]];
                else
                    return 12;
            }
            
            if (pickerView == _pickerQuarter)
            {
                if ([_pickerQuarter selectedRowInComponent:0] == (YEARCOUNT - 1))
                    return [RPSDK DateToQuarter:[NSDate date]];
                else
                    return 4;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ((pickerView == _pickerWeek) || (pickerView == _pickerMonth) || (pickerView == _pickerQuarter))
    {
        if (component == 0) {
            [pickerView reloadAllComponents];
        }
        return;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    LangType lang = g_langType;
    switch (g_langType) {
        case LangType_Auto:
        {
            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
            NSArray * languages = [defs objectForKey:@"AppleLanguages"];
            NSString * preferredLang = [languages objectAtIndex:0];
            if ([preferredLang isEqualToString:@"zh-Hans"])
            {
                lang = LangType_Hans;
            }
            else
            {
                lang = LangType_English;
            }
        }
            break;
        default:
            break;
    }
    
    switch (component) {
        case 0:
        {
            NSInteger nYear = [RPSDK DateToYear:[NSDate date]] - YEARCOUNT + row + 1;
            switch (lang) {
                case LangType_Hans:
                    return [NSString stringWithFormat:@"%d年",nYear];
                    break;
                default:
                    return [NSString stringWithFormat:@"%d",nYear];
                    break;
            }
           
        }
            break;
        case 1:
        {
            if (pickerView == _pickerWeek) {
                switch (lang) {
                    case LangType_Hans:
                        return [NSString stringWithFormat:@"%d周",row + 1];
                        break;
                    default:
                        return [NSString stringWithFormat:@"W%d",row + 1];
                        break;
                }
            }
            if (pickerView == _pickerMonth) {
                switch (lang) {
                    case LangType_Hans:
                        return [NSString stringWithFormat:@"%d月",row + 1];
                        break;
                    default:
                        return [_arrayMonth objectAtIndex:row];
                        break;
                }
            }
            if (pickerView == _pickerQuarter) {
                switch (lang) {
                    case LangType_Hans:
                        return [NSString stringWithFormat:@"%d季度",row + 1];
                        break;
                    default:
                        return [NSString stringWithFormat:@"Q%d",row + 1];
                        break;
                }
            }
        }
            break;
        default:
            break;
    }
    return @"000";
}

- (IBAction)OnDay:(id)sender
{
    _btDay.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
    _btDay.layer.borderWidth=1;
    _btDay.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    [_btDay setTitleColor:[UIColor colorWithRed:48.0f/255 green:115.0f/255 blue:119.0f/255 alpha:1] forState:UIControlStateNormal];
    _btDay.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
    
    _btMonth.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btMonth.layer.borderWidth=0;
    [_btMonth setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btMonth.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btQuarter.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btQuarter.layer.borderWidth=0;
    [_btQuarter setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btQuarter.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btWeek.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btWeek.layer.borderWidth=0;
    [_btWeek setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btWeek.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btYear.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btYear.layer.borderWidth=0;
    [_btYear setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btYear.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _range.type = KPIDateRangeType_Day;
    
    _datePicker.hidden = NO;
    _pickerWeek.hidden = YES;
    _pickerMonth.hidden = YES;
    _pickerQuarter.hidden = YES;
    _pickerYear.hidden = YES;
}

- (IBAction)OnWeek:(id)sender
{
    _btWeek.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
    _btWeek.layer.borderWidth=1;
    _btWeek.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    [_btWeek setTitleColor:[UIColor colorWithRed:48.0f/255 green:115.0f/255 blue:119.0f/255 alpha:1] forState:UIControlStateNormal];
    _btWeek.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
    
    _btMonth.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btMonth.layer.borderWidth=0;
    [_btMonth setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btMonth.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btQuarter.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btQuarter.layer.borderWidth=0;
    [_btQuarter setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btQuarter.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btDay.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btDay.layer.borderWidth=0;
    [_btDay setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btDay.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btYear.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btYear.layer.borderWidth=0;
    [_btYear setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btYear.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _range.type = KPIDateRangeType_Week;
    
    _datePicker.hidden = YES;
    _pickerWeek.hidden = NO;
    _pickerMonth.hidden = YES;
    _pickerQuarter.hidden = YES;
    _pickerYear.hidden = YES;
}

- (IBAction)OnMonth:(id)sender
{
    _btMonth.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
    _btMonth.layer.borderWidth=1;
    _btMonth.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    [_btMonth setTitleColor:[UIColor colorWithRed:48.0f/255 green:115.0f/255 blue:119.0f/255 alpha:1] forState:UIControlStateNormal];
    _btMonth.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
    
    _btDay.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btDay.layer.borderWidth=0;
    [_btDay setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btDay.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btQuarter.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btQuarter.layer.borderWidth=0;
    [_btQuarter setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btQuarter.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btWeek.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btWeek.layer.borderWidth=0;
    [_btWeek setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btWeek.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btYear.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btYear.layer.borderWidth=0;
    [_btYear setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btYear.titleLabel.font=[UIFont fontWithName:nil size:13];

    _range.type = KPIDateRangeType_Month;
    
    _datePicker.hidden = YES;
    _pickerWeek.hidden = YES;
    _pickerMonth.hidden = NO;
    _pickerQuarter.hidden = YES;
    _pickerYear.hidden = YES;
}

- (IBAction)OnQuarter:(id)sender
{
    _btQuarter.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
    _btQuarter.layer.borderWidth=1;
    _btQuarter.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    [_btQuarter setTitleColor:[UIColor colorWithRed:48.0f/255 green:115.0f/255 blue:119.0f/255 alpha:1] forState:UIControlStateNormal];
    _btQuarter.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
    
    _btMonth.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btMonth.layer.borderWidth=0;
    [_btMonth setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btMonth.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btDay.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btDay.layer.borderWidth=0;
    [_btDay setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btDay.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btWeek.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btWeek.layer.borderWidth=0;
    [_btWeek setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btWeek.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btYear.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btYear.layer.borderWidth=0;
    [_btYear setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btYear.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _range.type = KPIDateRangeType_Quarter;
    
    _datePicker.hidden = YES;
    _pickerWeek.hidden = YES;
    _pickerMonth.hidden = YES;
    _pickerQuarter.hidden = NO;
    _pickerYear.hidden = YES;
}

- (IBAction)OnYear:(id)sender
{
    _btYear.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
    _btYear.layer.borderWidth=1;
    _btYear.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    [_btYear setTitleColor:[UIColor colorWithRed:48.0f/255 green:115.0f/255 blue:119.0f/255 alpha:1] forState:UIControlStateNormal];
    _btYear.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
    
    _btMonth.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btMonth.layer.borderWidth=0;
    [_btMonth setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btMonth.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btQuarter.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btQuarter.layer.borderWidth=0;
    [_btQuarter setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btQuarter.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btWeek.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btWeek.layer.borderWidth=0;
    [_btWeek setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btWeek.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _btDay.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _btDay.layer.borderWidth=0;
    [_btDay setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    _btDay.titleLabel.font=[UIFont fontWithName:nil size:13];
    
    _range.type = KPIDateRangeType_Year;
    
    _datePicker.hidden = YES;
    _pickerWeek.hidden = YES;
    _pickerMonth.hidden = YES;
    _pickerQuarter.hidden = YES;
    _pickerYear.hidden = NO;
}

- (IBAction)OnNow:(id)sender
{
    [self selectNow];
}

-(void)setRange:(KPIDateRange *)range
{
    _range = range;
    switch (range.type) {
        case KPIDateRangeType_Day:
            [_datePicker setDate:range.date animated:YES];
            break;
        case KPIDateRangeType_Year:
        {
            NSInteger nYearRowIndex = YEARCOUNT - ([RPSDK DateToYear:[NSDate date]] - range.nYear) - 1;
            [_pickerYear selectRow:nYearRowIndex inComponent:0 animated:YES];
        }
            break;
        case KPIDateRangeType_Month:
        {
            NSInteger nYearRowIndex = YEARCOUNT - ([RPSDK DateToYear:[NSDate date]] - range.nYear) - 1;
            [_pickerMonth selectRow:nYearRowIndex inComponent:0 animated:YES];
            [_pickerMonth selectRow:range.nIndex - 1 inComponent:1 animated:YES];
        }
            break;
        case KPIDateRangeType_Week:
        {
            NSInteger nYearRowIndex = YEARCOUNT - ([RPSDK DateToYear:[NSDate date]] - range.nYear) - 1;
            [_pickerWeek selectRow:nYearRowIndex inComponent:0 animated:YES];
            [_pickerWeek selectRow:range.nIndex - 1 inComponent:1 animated:YES];
        }
            break;
        case KPIDateRangeType_Quarter:
        {
            NSInteger nYearRowIndex = YEARCOUNT - ([RPSDK DateToYear:[NSDate date]] - range.nYear) - 1;
            [_pickerQuarter selectRow:nYearRowIndex inComponent:0 animated:YES];
            [_pickerQuarter selectRow:range.nIndex -1 inComponent:1 animated:YES];
        }
            break;
        default:
            break;
    }
    
    [_pickerWeek reloadAllComponents];
    [_pickerMonth reloadAllComponents];
    [_pickerQuarter reloadAllComponents];
}

-(BOOL)OnBack
{
    switch (_range.type) {
        case KPIDateRangeType_Day:
            _range.date = _datePicker.date;
            break;
        case KPIDateRangeType_Week:
            _range.nYear = [RPSDK DateToYear:[NSDate date]] - YEARCOUNT + 1 + [_pickerWeek selectedRowInComponent:0];
            _range.nIndex = [_pickerWeek selectedRowInComponent:1] + 1;
            break;
        case KPIDateRangeType_Month:
            _range.nYear = [RPSDK DateToYear:[NSDate date]] - YEARCOUNT + 1 + [_pickerMonth selectedRowInComponent:0];
            _range.nIndex = [_pickerMonth selectedRowInComponent:1] + 1;
            break;
        case KPIDateRangeType_Quarter:
            _range.nYear = [RPSDK DateToYear:[NSDate date]] - YEARCOUNT + 1 + [_pickerQuarter selectedRowInComponent:0];
            _range.nIndex = [_pickerQuarter selectedRowInComponent:1] + 1;
            break;
        case KPIDateRangeType_Year:
            _range.nYear = [RPSDK DateToYear:[NSDate date]] - YEARCOUNT + 1 + [_pickerYear selectedRowInComponent:0];
            break;
        default:
            break;
    }
    return YES;
}

- (IBAction)OnOk:(id)sender
{
    [self OnBack];
    [self.delegate OnSettingDateEnd];
}
@end
