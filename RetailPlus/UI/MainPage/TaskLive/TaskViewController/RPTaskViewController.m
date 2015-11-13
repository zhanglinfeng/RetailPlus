//
//  RPTaskViewController.m
//  RetailPlus
//
//  Created by Brilance on 14-9-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTaskViewController.h"
#import "RPAddCalender.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"

extern NSBundle * g_bundleResorce;

@interface RPTaskViewController ()

@end

@implementation RPTaskViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"TASK INFORMATION",@"RPString", g_bundleResorce,nil);
    _viewTaskDetail.layer.cornerRadius = 10;
    _svTaskInfo.contentSize = CGSizeMake(0, 600);
    _ivSponsor.layer.borderWidth = 1;
    _ivSponsor.layer.cornerRadius = 5.0;
    _ivSponsor.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _ivOperator.layer.borderWidth = 1;
    _ivOperator.layer.cornerRadius = 5.0;
    _ivOperator.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _lbTaskTitle.text = _info.strTitle;
    _lbTaskDesc.text = _info.strDesc;
    _lbSponsorName.text = _info.userInitiator.strFirstName;
    _lbSponsorRoleName.text = _info.userInitiator.strRoleName;
    _lbOperatorName.text = _info.userExecutor.strFirstName;
    _lbOperatorRoleName.text = _info.userExecutor.strRoleName;
    _lbTaskCode.text = _info.strCode;
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    _lbCreateTime.text = [df stringFromDate:_info.dateCreate];
    
    [_ivSponsor setImageWithURLString: _info.userInitiator.strPortraitImg placeholderImage:[UIImage imageNamed:@"icon_userimage01_224.png"]];
    [_ivOperator setImageWithURLString: _info.userExecutor.strPortraitImg placeholderImage:[UIImage imageNamed:@"icon_userimage01_224.png"]];
    
    switch (_info.typeColor) {
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
    

    //判断任务是否已完成

    if (_info.state == TASKSTATE_finished) {
        _ivTaskState.image = [UIImage imageNamed:@"icon_done2.png"];
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy-MM-dd HH:mm";
        _lbEndDate.text = [df stringFromDate:_info.dateFinish];
        for (UIButton* btn in _btnArray) {
            btn.selected = YES;
            btn.enabled = NO;
        }
        for (UILabel* lb in _lbArray) {
            lb.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        }
        
        
    }else{
        NSArray* arrStates = [self GetDateStringShow:_info.dateEnd AllDay:_info.bAllDay];
        _lbEndDate.text = arrStates[0];
        NSInteger state = [(NSNumber*)arrStates[1] integerValue];
        switch (state) {
            case -1:
                _ivTaskState.image = [UIImage imageNamed:@"icon_time_red2.png"];
                break;
            case 0:
                _ivTaskState.image = [UIImage imageNamed:@"icon_time_orange2.png"];
                break;
            case 1:
                _ivTaskState.image = [UIImage imageNamed:@"icon_time_grey2@2x"];
                break;
            default:
                break;
        }
    }

//发起人/执行人 职位 头像 名字颜色
    switch (_info.userInitiator.rank) {
        case Rank_Manager:
            _lbSponsorName.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbSponsorName.textColor =  [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            
            break;
        case Rank_Assistant:
            _lbSponsorName.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            
            break;
        case Rank_Vendor:
            _lbSponsorName.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            
            break;
        default:
            break;
    }
  
    switch (_info.userExecutor.rank) {
        case Rank_Manager:
            _lbOperatorName.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbOperatorName.textColor =  [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            
            break;
        case Rank_Assistant:
            _lbOperatorName.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            
            break;
        case Rank_Vendor:
            _lbOperatorName.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            
            break;
        default:
            break;
    }
    
    _vcAddReceiver = [[RPAddReceiverViewController alloc] initWithNibName:NSStringFromClass([RPAddReceiverViewController class]) bundle:g_bundleResorce];
    _vcAddReceiver.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    _vcAddReceiver.delegate = self;
    _vcAddReceiver.bSingleSelect = YES;
    
//只有发起人才可以删除任务
    if (![[RPSDK defaultInstance].userLoginDetail.strUserId isEqualToString:_info.userInitiator.strUserId]){
        [_btnArray[3] setSelected:NO];
        [_btnArray[3] setEnabled:NO];
        [_lbArray[3] setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    }
}


- (IBAction)OnOperatorChanged:(UIButton *)sender {
    _vcAddReceiver.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_vcAddReceiver.view];
    
    [UIView beginAnimations:nil context:nil];
    _vcAddReceiver.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    [_vcAddReceiver UpdateUI];
    
    _bReceiverList=YES;
    
}

- (IBAction)OnRelatedIssue:(UIButton *)sender
{
    _viewIssue.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewIssue];
    [UIView beginAnimations:nil context:nil];
    _viewIssue.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    _viewIssue.issueId= _info.strOther;
    
    _bViewIssue = YES;
}
-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}
-(BOOL)OnBack
{
    if (_bTask) {
        [self dismissView:_viewEditTask];
        _bTask=NO;
        return NO;
    }
    if (_bViewIssue) {
        [self dismissView:_viewIssue];
        _bViewIssue=NO;
        return NO;
    }
    if (_bReceiverList) {
        [self dismissView:_vcAddReceiver.view];
        _bReceiverList=NO;
        return NO;
    }
    return YES;
}

-(void)backToTaskDetail
{
    [self dismissView:_viewEditTask];
    _bTask=NO;
}
- (IBAction)OnEditTask:(UIButton *)sender {
    _viewEditTask.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewEditTask];
    [UIView beginAnimations:nil context:nil];
    _viewEditTask.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _viewEditTask.delegate=self;
    _viewEditTask.task=_info;
    _bTask = YES;
    _viewEditTask.delegateMain = self.delegate;
   
}

- (IBAction)OnDeleteTask:(UIButton *)sender {
    NSString* strMes = NSLocalizedStringFromTableInBundle(@"Confirm to DELETE the task?",@"RPString", g_bundleResorce,nil);
    NSString* strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString* strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    RPBlockUIAlertView* alertView = [[RPBlockUIAlertView alloc]initWithTitle:nil message:strMes cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
        if (indexButton == 1) {
            [[RPSDK defaultInstance]deleteTask:_info.strTaskId Success:^(id idResult) {
                NSLog(@"s");
                [self.delegate OnUpdateTaskEnd];
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                NSLog(@"f");
            }];
        }
    } otherButtonTitles:strOK, nil];
    [alertView show];
    
}

- (IBAction)OnFinishedTask:(UIButton *)sender {
    [[RPSDK defaultInstance] finishTask:_info.strTaskId Success:^(id idResult) {
        [self.delegate OnUpdateTaskEnd];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        //
    }];
    
}

- (IBAction)OnMoreOperation:(id)sender {
    [UIView beginAnimations:nil context:nil];
    if (_ivArrow.hidden) {
        _ivArrow.hidden = NO;
        _viewFilter.hidden = NO;
         _svTaskInfo.frame = CGRectMake(0, _viewFilter.frame.origin.y+_viewFilter.frame.size.height, _svTaskInfo.frame.size.width, _svTaskInfo.frame.size.height);
        
    }else{
        _ivArrow.hidden = YES;
        _viewFilter.hidden = YES;
        _svTaskInfo.frame = CGRectMake(0, _viewFilter.frame.origin.y+2, _svTaskInfo.frame.size.width, _svTaskInfo.frame.size.height);
    }
    [UIView commitAnimations];
}

- (IBAction)OnAddCalendar:(UIButton *)sender {
    
    RPAddCalender* addCalender = [RPAddCalender defaultInstance];
    [addCalender IsCalenderAddToTask:_info];
    [addCalender AddTaskToCalender:_info];
    addCalender.delegate = self;

}

-(void)OnAddCalenderEnd
{
    [self.delegate OnUpdateTaskAfterAddCalendar];
}

 -(void)AddColleague:(NSMutableArray *)arrayColleague
{
    [self dismissView:_vcAddReceiver.view];
    _bReceiverList=NO;
    
    [SVProgressHUD showWithStatus:@""];
    
    UserDetailInfo * user =(UserDetailInfo*)[arrayColleague objectAtIndex:0];
    [[RPSDK defaultInstance] ForwardTask:_info.strTaskId Executor:user.strUserId Success:^(id idResult) {
        [self.delegate OnUpdateTaskEnd];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}
@end








