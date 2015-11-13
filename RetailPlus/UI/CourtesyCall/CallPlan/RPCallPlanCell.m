//
//  RPCallPlanCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-13.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCallPlanCell.h"

@implementation RPCallPlanCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCourtesyCallInfo:(CourtesyCallInfo *)courtesyCallInfo
{
    _courtesyCallInfo=courtesyCallInfo;
    _lbCustomerName.text=[NSString stringWithFormat:@"%@",_courtesyCallInfo.customer.strFirstName];
    for (int i=0; i<_arrayType.count; i++)
    {
        if ([_courtesyCallInfo.strCourtesyCallTypeId isEqualToString:[[_arrayType objectAtIndex:i]strCourtesyCallTypeId]])
        {
            _lbCallPurpose.text=[[_arrayType objectAtIndex:i]strCourtesyCallTips];
            break;
        }
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd ccc"];
    _lbDate.text=[dateFormatter stringFromDate:_courtesyCallInfo.datePlan];
    _ivVip.hidden=!_courtesyCallInfo.customer.isVip;
    _ivReminder.hidden=!_courtesyCallInfo.bRemind;
    //创建一个日历格式
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //从date中根据日历获取各时间组成部分
    NSDateComponents*components1 =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:[NSDate date]];
   
    NSDateComponents*components2 =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:courtesyCallInfo.datePlan];
    if ([components1 year]>[components2 year])
    {
        _ivTime.image=[UIImage imageNamed:@"icon_time_urgent@2x.png"];
    }
    else if([components1 year]==[components2 year])
    {
        if ([components1 month]>[components2 month])
        {
            _ivTime.image=[UIImage imageNamed:@"icon_time_urgent@2x.png"];
        }
        else if ([components1 month]==[components2 month])
        {
            if ([components1 day]>[components2 day])
            {
                _ivTime.image=[UIImage imageNamed:@"icon_time_urgent@2x.png"];
            }
            else if ([components1 day]==[components2 day])
            {
                _ivTime.image=[UIImage imageNamed:@"icon_time_today@2x.png"];
            }
            else
            {
                _ivTime.image=[UIImage imageNamed:@"icon_time_normal@2x.png"];
            }
        }
        else
        {
            _ivTime.image=[UIImage imageNamed:@"icon_time_normal@2x.png"];
        }
    }
    else if([components1 year]<[components2 year])
    {
        _ivTime.image=[UIImage imageNamed:@"icon_time_normal@2x.png"];
    }
    
}
-(void)setArrayType:(NSArray *)arrayType
{
    _arrayType=arrayType;
}
- (IBAction)OnEdit:(id)sender
{
    [self.delegate editPlan:_courtesyCallInfo];
}
@end
