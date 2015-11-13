//
//  RPDateSettingViewController.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPDateSettingViewController.h"

@interface RPDateSettingViewController ()

@end

@implementation RPDateSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
}

- (IBAction)OnNow:(id)sender
{
    
}

- (IBAction)OnOk:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
