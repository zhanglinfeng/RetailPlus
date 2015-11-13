//
//  RPTaskCell.m
//  RetailPlus
//
//  Created by Brilance on 14-9-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTaskCell.h"
#import "RPAddCalender.h"
extern NSBundle * g_bundleResorce;

@implementation RPTaskCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)setTaskInfo:(TaskInfo *)taskInfo
{
    _taskInfo = taskInfo;
    switch (taskInfo.typeColor) {
        case COLOR_gray:
            _viewColor.backgroundColor = [UIColor colorWithWhite:.7 alpha:1];
            break;
        case COLOR_purple:
            _viewColor.backgroundColor = [UIColor colorWithRed:163.0/255 green:136.0/255 blue:191.0/255 alpha:1];
            break;
        case COLOR_red:
            _viewColor.backgroundColor = [UIColor colorWithRed:255.0/255 green:153.0/255 blue:153.0/255 alpha:1];
            break;
        case COLOR_yellow:
            _viewColor.backgroundColor = [UIColor colorWithRed:255.0/255 green:204.0/255 blue:153.0/255 alpha:1];
            break;
        case COLOR_green:
            _viewColor.backgroundColor = [UIColor colorWithRed:153.0/255 green:204.0/255 blue:153.0/255 alpha:1];
            break;
        case COLOR_bluegreen:
            _viewColor.backgroundColor = [UIColor colorWithRed:153.0/255 green:204.0/255 blue:204.0/255 alpha:1];
        default:
            break;
    }
    _lbTaskCode.text = taskInfo.strCode;
    _lbTaskTitle.text = taskInfo.strTitle;
    _lbSponsor.text = taskInfo.userInitiator.strFirstName;
    _lbOperator.text = taskInfo.userExecutor.strFirstName;
    
    _viewSponsor.layer.cornerRadius = 3;
    _viewOperator.layer.cornerRadius = 3;
    
//判断任务是否为新
    if (taskInfo.isNew) {
        _ivNewMark.hidden = NO;
    }else{
        _ivNewMark.hidden = YES;
    }
   
//发起人/执行人图标颜色 名字颜色
    if ([[RPSDK defaultInstance].userLoginDetail.strUserId isEqualToString:taskInfo.userInitiator.strUserId]) {
        _viewSponsor.backgroundColor = [UIColor whiteColor];
    }else{
        _viewSponsor.layer.borderWidth = 1.0;
        _viewSponsor.layer.borderColor = [UIColor whiteColor].CGColor;
        _viewSponsor.backgroundColor = [UIColor clearColor];
    }
    if ([[RPSDK defaultInstance].userLoginDetail.strUserId isEqualToString:taskInfo.userExecutor.strUserId]) {
        _viewOperator.backgroundColor = [UIColor whiteColor];
    }else{
        _viewOperator.layer.borderWidth = 1.0;
        _viewOperator.layer.borderColor = [UIColor whiteColor].CGColor;
        _viewOperator.backgroundColor = [UIColor clearColor];
    }
    
    switch (taskInfo.userInitiator.rank) {
        case Rank_Manager:
            _lbSponsor.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbSponsor.textColor =  [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            
            break;
        case Rank_Assistant:
            _lbSponsor.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            
            break;
        case Rank_Vendor:
            _lbSponsor.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            
            break;
        default:
            break;
    }
    
    switch (taskInfo.userExecutor.rank) {
        case Rank_Manager:
            _lbOperator.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbOperator.textColor =  [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            
            break;
        case Rank_Assistant:
            _lbOperator.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            
            break;
        case Rank_Vendor:
            _lbOperator.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            
            break;
        default:
            break;
    }
    
//判断是否加入日历
    BOOL isAddToCalendar = [[RPAddCalender defaultInstance] IsCalenderAddToTask:taskInfo];
    if (isAddToCalendar) {
        _ivCalendar.image = [UIImage imageNamed:@"icon_date_deep.png"];
    }else{
        _ivCalendar.image = [UIImage imageNamed:@"icon_date_light.png"];
    }
    
    
//判断任务是否已完成
  
    if (taskInfo.state == TASKSTATE_finished) {
        _ivTaskState.image = [UIImage imageNamed:@"icon_done1.png"];
        _ivCalendar.hidden = YES;
        
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy-MM-dd HH:mm";
        _lbEndDate.text = [df stringFromDate:taskInfo.dateFinish];
        
    }else{
        NSArray* arrStates = [self GetDateStringShow:taskInfo.dateEnd AllDay:taskInfo.bAllDay];
        _lbEndDate.text = arrStates[0];
        _ivCalendar.hidden = NO;
        NSInteger state = [arrStates[1] integerValue];
        switch (state) {
            case -1:
                _ivTaskState.image = [UIImage imageNamed:@"icon_time_red.png"];
                break;
            case 0:
                _ivTaskState.image = [UIImage imageNamed:@"icon_time_orange.png"];
                break;
            case 1:
                _ivTaskState.image = [UIImage imageNamed:@"icon_time_grey.png"];
                break;
            default:
                break;
        }
    }
    
    
    
}

-(NSArray *)GetDateStringShow:(NSDate *)date AllDay:(BOOL)bAllDay
{
    NSDate * dateNow = [NSDate date];
    NSString * strRet;
    NSArray * arrayRet;
    NSString * strToday = NSLocalizedStringFromTableInBundle(@"Today",@"RPString", g_bundleResorce,nil);
    
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy";
    NSInteger nYear = [format stringFromDate:date].integerValue;
    NSInteger nYearNow = [format stringFromDate:dateNow].integerValue;
    format.dateFormat = @"MM";
    NSInteger nMonth = [format stringFromDate:date].integerValue;
    NSInteger nMonthNow = [format stringFromDate:dateNow].integerValue;
    format.dateFormat = @"dd";
    NSInteger nDay = [format stringFromDate:date].integerValue;
    NSInteger nDayNow = [format stringFromDate:dateNow].integerValue;
    
    if (nYear < nYearNow) goto DownEnd;
    if (nYear > nYearNow) goto UpEnd;
    if (nMonth < nMonthNow) goto DownEnd;
    if (nMonth > nMonthNow) goto UpEnd;
    if (nDay < nDayNow) goto DownEnd;
    if (nDay > nDayNow) goto UpEnd;
    goto EqualEnd;
    
DownEnd:
    if (bAllDay)
        format.dateFormat = @"yyyy-MM-dd ccc.";
    else
        format.dateFormat = @"yyyy-MM-dd hh:mm";
    
    strRet = [format stringFromDate:date];
    arrayRet = [NSArray arrayWithObjects:strRet,[NSNumber numberWithInt:-1],nil];
    return arrayRet;
UpEnd:
    if (bAllDay)
        format.dateFormat = @"yyyy-MM-dd ccc.";
    else
        format.dateFormat = @"yyyy-MM-dd hh:mm";
    
    strRet = [format stringFromDate:date];
    arrayRet = [NSArray arrayWithObjects:strRet,[NSNumber numberWithInt:1],nil];
    return arrayRet;
    
EqualEnd:
    
    if (bAllDay)
        strRet = strToday;
    else
    {
        format.dateFormat = @"hh:mm";
        strRet = [NSString stringWithFormat:@"%@ %@",strToday,[format stringFromDate:date]];
    }
    arrayRet = [NSArray arrayWithObjects:strRet,[NSNumber numberWithInt:0],nil];
    return arrayRet;
}



@end
