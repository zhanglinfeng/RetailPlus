//
//  RPAddTaskView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-9-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPAddTaskView.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;
@implementation RPAddTaskView

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
    _viewFrame.layer.cornerRadius=10;
    _view1.layer.cornerRadius=6;
    _view1.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _view1.layer.borderWidth=1;
    _view2.layer.cornerRadius=6;
    _view2.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _view2.layer.borderWidth=1;
    _view3.layer.cornerRadius=6;
    _view3.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _view3.layer.borderWidth=1;
    _view4.layer.cornerRadius=6;
    _view4.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _view4.layer.borderWidth=1;
    
    
    _vcAddReceiver = [[RPAddReceiverViewController alloc] initWithNibName:NSStringFromClass([RPAddReceiverViewController class]) bundle:g_bundleResorce];
    _vcAddReceiver.view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _vcAddReceiver.delegate = self;
    _vcAddReceiver.bSingleSelect = YES;
    
    _svFrame.contentSize=CGSizeMake(_svFrame.frame.size.width, 477);
}
-(void)setArrayIssue:(NSMutableArray *)arrayIssue
{
    _arrayIssue=arrayIssue;
    _arrayTask=[[NSMutableArray alloc]init];
    if (_arrayIssue.count>1) {
        NSString *s=NSLocalizedStringFromTableInBundle(@"New tasks",@"RPString", g_bundleResorce,nil);
        _lbTitle.text=[NSString stringWithFormat:@"%i%@",_arrayIssue.count,s];
        _view1.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
        _tfTaskTitle.enabled=NO;
        
        _view2.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
        _tvTaskDesc.editable=NO;
        
        _tfTaskTitle.text=NSLocalizedStringFromTableInBundle(@"Duplicated from issues",@"RPString", g_bundleResorce,nil);
        _tvTaskDesc.text=NSLocalizedStringFromTableInBundle(@"Duplicated from issues",@"RPString", g_bundleResorce,nil);
    }
    else
    {
         NSString *s=NSLocalizedStringFromTableInBundle(@"New task",@"RPString", g_bundleResorce,nil);
        _lbTitle.text=s;
        _view1.backgroundColor=[UIColor whiteColor];
        _tfTaskTitle.enabled=YES;
        _view2.backgroundColor=[UIColor whiteColor];
        _tvTaskDesc.editable=YES;
        for (BVisitIssueSearchRet *issueRet in _arrayIssue)
        {
            _tfTaskTitle.text=[NSString stringWithFormat:@"[%@] %@",issueRet.strStoreName,issueRet.issue.strIssueTitle];;
            _tvTaskDesc.text=issueRet.issue.strIssueDesc;
        }
        
    }
    
    for (BVisitIssueSearchRet *issueRet in _arrayIssue)
    {
        TaskInfo *task=[[TaskInfo alloc]init];
        task.typeTask=4;
        task.strOther=issueRet.issue.strIssueID;
        task.strTitle=[NSString stringWithFormat:@"[%@] %@",issueRet.strStoreName,issueRet.issue.strIssueTitle];
        task.strDesc=issueRet.issue.strIssueDesc;
        task.userInitiator=[[RPSDK defaultInstance]userLoginDetail];
        task.state=TASKSTATE_unfinished;
        task.typeColor=COLOR_gray;
        [_arrayTask addObject:task];
    }
    _lbExe.text= NSLocalizedStringFromTableInBundle(@"Please select performer",@"RPString", g_bundleResorce,nil);
    _lbExe.textColor=[UIColor darkGrayColor];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy/MM/dd HH:mm"];
    _pickDate = [[RPDatePicker alloc] init:_tfDate Format:dateFormatter curDate:[NSDate date] canDelete:NO Mode:UIDatePickerModeDateAndTime canFuture:YES canPreviously:NO];
    _tfDate.text=NSLocalizedStringFromTableInBundle(@"Please select deadline",@"RPString", g_bundleResorce,nil);
}
- (IBAction)OnGray:(id)sender
{
    _viewColor.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
    [UIView beginAnimations:nil context:nil];
    _viewTag.frame=CGRectMake(_btGray.frame.origin.x+_btGray.frame.size.width/2-_viewTag.frame.size.width/2, _viewTag.frame.origin.y, _viewTag.frame.size.width, _viewTag.frame.size.height);
    [UIView commitAnimations];
    
    _btGray.selected=!_btGray.selected;
    _btYellow.selected=NO;
    _btBlueGreen.selected=NO;
    _btGreen.selected=NO;
    _btPurple.selected=NO;
    _btRed.selected=NO;
    for (TaskInfo *task in _arrayTask)
    {
        task.typeColor=COLOR_gray;
    }
}

- (IBAction)OnPurple:(id)sender
{
    _viewColor.backgroundColor=[UIColor colorWithRed:163.0/255 green:136.0/255 blue:189.0/255 alpha:1];
    [UIView beginAnimations:nil context:nil];
    _viewTag.frame=CGRectMake(_btPurple.frame.origin.x+_btPurple.frame.size.width/2-_viewTag.frame.size.width/2, _viewTag.frame.origin.y, _viewTag.frame.size.width, _viewTag.frame.size.height);
    [UIView commitAnimations];
    _btPurple.selected=!_btPurple.selected;
    _btYellow.selected=NO;
    _btBlueGreen.selected=NO;
    _btGreen.selected=NO;
    _btGray.selected=NO;
    _btRed.selected=NO;
    for (TaskInfo *task in _arrayTask)
    {
        task.typeColor=COLOR_purple;
    }
}


- (IBAction)OnRed:(id)sender
{
    _viewColor.backgroundColor=[UIColor colorWithRed:255.0/255 green:151.0/255 blue:154.0/255 alpha:1];
    [UIView beginAnimations:nil context:nil];
    _viewTag.frame=CGRectMake(_btRed.frame.origin.x+_btRed.frame.size.width/2-_viewTag.frame.size.width/2, _viewTag.frame.origin.y, _viewTag.frame.size.width, _viewTag.frame.size.height);
    [UIView commitAnimations];
    _btRed.selected=!_btRed.selected;
    _btYellow.selected=NO;
    _btBlueGreen.selected=NO;
    _btGreen.selected=NO;
    _btPurple.selected=NO;
    _btGray.selected=NO;
    for (TaskInfo *task in _arrayTask)
    {
        task.typeColor=COLOR_red;
    }
}

- (IBAction)OnYellow:(id)sender
{
    _viewColor.backgroundColor=[UIColor colorWithRed:255.0/255 green:203.0/255 blue:157.0/255 alpha:1];
    [UIView beginAnimations:nil context:nil];
    _viewTag.frame=CGRectMake(_btYellow.frame.origin.x+_btYellow.frame.size.width/2-_viewTag.frame.size.width/2, _viewTag.frame.origin.y, _viewTag.frame.size.width, _viewTag.frame.size.height);
    [UIView commitAnimations];
    _btYellow.selected=!_btYellow.selected;
    _btGray.selected=NO;
    _btBlueGreen.selected=NO;
    _btGreen.selected=NO;
    _btPurple.selected=NO;
    _btRed.selected=NO;
    for (TaskInfo *task in _arrayTask)
    {
        task.typeColor=COLOR_yellow;
    }
}

- (IBAction)OnGreen:(id)sender
{
    _viewColor.backgroundColor=[UIColor colorWithRed:151.0/255 green:204.0/255 blue:155.0/255 alpha:1];
    [UIView beginAnimations:nil context:nil];
    _viewTag.frame=CGRectMake(_btGreen.frame.origin.x+_btGreen.frame.size.width/2-_viewTag.frame.size.width/2, _viewTag.frame.origin.y, _viewTag.frame.size.width, _viewTag.frame.size.height);
    [UIView commitAnimations];
    _btGreen.selected=!_btGreen.selected;
    _btYellow.selected=NO;
    _btBlueGreen.selected=NO;
    _btGray.selected=NO;
    _btPurple.selected=NO;
    _btRed.selected=NO;
    for (TaskInfo *task in _arrayTask)
    {
        task.typeColor=COLOR_green;
    }
}

- (IBAction)OnBlueGreen:(id)sender
{
    _viewColor.backgroundColor=[UIColor colorWithRed:149.0/255 green:204.0/255 blue:204.0/255 alpha:1];
    [UIView beginAnimations:nil context:nil];
    _viewTag.frame=CGRectMake(_btBlueGreen.frame.origin.x+_btBlueGreen.frame.size.width/2-_viewTag.frame.size.width/2, _viewTag.frame.origin.y, _viewTag.frame.size.width, _viewTag.frame.size.height);
    [UIView commitAnimations];
    _btBlueGreen.selected=!_btBlueGreen.selected;
    _btYellow.selected=NO;
    _btGray.selected=NO;
    _btGreen.selected=NO;
    _btPurple.selected=NO;
    _btRed.selected=NO;
    for (TaskInfo *task in _arrayTask)
    {
        task.typeColor=COLOR_bluegreen;
    }
}

- (IBAction)OnAllDay:(id)sender
{
    _btAllDay.selected=!_btAllDay.selected;
    if (_btAllDay.selected) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy/MM/dd ccc"];
        _pickDate = [[RPDatePicker alloc] init:_tfDate Format:dateFormatter curDate:[_pickDate GetDate] canDelete:NO Mode:UIDatePickerModeDate canFuture:YES canPreviously:NO];
        for (TaskInfo *task in _arrayTask)
        {
            task.bAllDay=YES;
            task.dateEnd=[_pickDate GetDate];
        }
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy/MM/dd HH:mm"];
        _pickDate = [[RPDatePicker alloc] init:_tfDate Format:dateFormatter curDate:[_pickDate GetDate] canDelete:NO Mode:UIDatePickerModeDateAndTime canFuture:YES canPreviously:NO];
        for (TaskInfo *task in _arrayTask)
        {
            task.bAllDay=NO;
            task.dateEnd=[_pickDate GetDate];
        }
    }
    
}

- (IBAction)OnSelectCustomer:(id)sender
{
    _vcAddReceiver.view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self addSubview:_vcAddReceiver.view];
    
    [UIView beginAnimations:nil context:nil];
    _vcAddReceiver.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    [_vcAddReceiver UpdateUI];
    
    _bReceiverList=YES;
}
-(void)AddColleague:(NSMutableArray *)arrayColleague
{
    
    for (TaskInfo *task in _arrayTask)
    {
        task.typeColor=COLOR_bluegreen;
        task.userExecutor=(UserDetailInfo*)[arrayColleague objectAtIndex:0];
    }
    _lbExe.text=((UserDetailInfo *)[arrayColleague objectAtIndex:0]).strFirstName;
    switch (((UserDetailInfo *)[arrayColleague objectAtIndex:0]).rank) {
        case Rank_Manager:
            _lbExe.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbExe.textColor =  [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            
            break;
        case Rank_Assistant:
            _lbExe.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            
            break;
        case Rank_Vendor:
            _lbExe.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            
            break;
        default:
            break;
    }
    [self dismissView:_vcAddReceiver.view];
    _bReceiverList=NO;
}
-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}

-(BOOL)OnBack
{
    if (_bReceiverList)
    {
        [self dismissView:_vcAddReceiver.view];
        _bReceiverList=NO;
        return NO;
    }
    
    
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to give up the task and go back?",@"RPString", g_bundleResorce,nil);
    RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
        if (indexButton==1) {
            [self.delegate backToTask];
        }
    }otherButtonTitles:strOK, nil];
    [alertView show];
   return NO;
}

- (IBAction)OnOK:(id)sender
{
    for (TaskInfo *task in _arrayTask)
    {
        if (!task.userExecutor)
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Please select performer",@"RPString", g_bundleResorce,nil)];
            return;
        }
        if (!task.dateEnd)
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Please select deadline",@"RPString", g_bundleResorce,nil)];
            return;
        }
    }
    [[RPSDK defaultInstance]AddTask:_arrayTask Success:^(id idResult) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showSuccessWithStatus:str];
        [self.delegate backToTask];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    for (TaskInfo *task in _arrayTask)
    {
        task.dateEnd=[_pickDate GetDate];
    }
    if (_arrayIssue.count==1)
    {
        for (TaskInfo *task in _arrayTask)
        {
            task.strTitle=_tfTaskTitle.text;
        }
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (_arrayIssue.count==1)
    {
        for (TaskInfo *task in _arrayTask)
        {
            task.strDesc=_tvTaskDesc.text;
        }
    }
}
@end
