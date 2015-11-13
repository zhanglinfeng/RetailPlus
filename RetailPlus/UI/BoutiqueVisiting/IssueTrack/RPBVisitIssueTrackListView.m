//
//  RPBVisitIssueTrackListView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-8-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//
#import "RPBVisitIssueTrackListView.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@implementation RPBVisitIssueTrackListView

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
    _viewSearch.layer.cornerRadius=5;
    _viewFrame.layer.cornerRadius=10;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSTimeInterval now=[[NSDate date] timeIntervalSince1970]*1;
    int start=now/1-86400*7;
    NSDate*dateStart = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)start];
    _pickDateStart = [[RPDatePicker alloc] init:_tfStartDate Format:dateFormatter curDate:dateStart canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    _pickDateEnd = [[RPDatePicker alloc] init:_tfEndDate Format:dateFormatter curDate:[NSDate date] canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    _lbStartDate.text=_tfStartDate.text;
    _lbEndDate.text=_tfEndDate.text;
//    _tfStartDate.text=@"";
    
    _issueSearchData=[[BVisitIssueSearchData alloc]init];
    _issueSearchData.arrayIssue=[[NSMutableArray alloc]init];
    _issueSearchData.reporters = [[InspReporters alloc] init];
    
    _issueSearchData.reporters.arraySection = [[NSMutableArray alloc] init];
    InspReporterSection * section = [[InspReporterSection alloc] init];
    
    section.strTitle1 = @"零售巡店问题汇总报告";
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd-MM-yyyy"];
    section.strTitle2 = [NSString stringWithFormat:@"%@,by %@",[dateformatter stringFromDate:[NSDate date]],[RPSDK defaultInstance].userLoginDetail.strFirstName];
    section.arrayUser = [[NSMutableArray alloc] init];
//    InspReporterUser * user = [[InspReporterUser alloc] init];
//    user.bSelected = YES;
//    user.bUserCollegue = YES;
//    user.collegue = [RPSDK defaultInstance].userLoginDetail;
//    [section.arrayUser addObject:user];
    [_issueSearchData.reporters.arraySection addObject:section];
    
    
    _ivTriangle.hidden=YES;
    _viewDateRange.frame=CGRectMake(_viewDateRange.frame.origin.x, _viewHeader.frame.size.height-_viewDateRange.frame.size.height, _viewDateRange.frame.size.width, _viewDateRange.frame.size.height);
    _viewTB.frame=CGRectMake(_viewTB.frame.origin.x, _viewHeader.frame.size.height, _viewTB.frame.size.width, _viewTB.frame.size.height);
    
    NSArray *array = [g_bundleResorce loadNibNamed:@"CustomView" owner:self options:nil];
    _viewStoreList = [array objectAtIndex:1];
    _viewStoreList.delegate = self;
    _viewStoreList.sitType = SituationType_BVisit;
    _viewStoreList.bCanSelDomain=YES;
    
}

-(void)clearUI
{
    _tfSearch.text=@"";
    [self LoadData];
}
-(void)LoadData
{
    [SVProgressHUD showWithStatus:@""];
    NSString *strId=@"";//domainId or storeId
    if (_domain)
    {
        strId=_domain.strDomainID;
    }
    else if(_store)
    {
        strId=_store.strDomainID;
    }
    [[RPSDK defaultInstance]searchBVisitIssue:_tfSearch.text StartDate:_tfStartDate.text EndDate:_tfEndDate.text DomianId:strId ReportId:@"" Success:^(NSMutableArray* arrayResult) {
        [SVProgressHUD dismiss];
        _arraySearch=arrayResult;
        [self screenBNoTask:_btNoTask.selected BInProgress:_btInProgress.selected BDone:_btDone.selected ];
        if (_arrayShow.count==0)
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No issues exist",@"RPString", g_bundleResorce,nil)];
        }
        [_tbSearchIssue reloadData];
        [self updateSelectBT];
        
//        [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil)];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
    }];
}
-(void)screenBNoTask:(BOOL)bNoTask BInProgress:(BOOL)bInProgress BDone:(BOOL)bDone
{
    _arrayShow=[[NSMutableArray alloc]init];
    
    if(_btNoTask.selected||_btInProgress.selected||_btDone.selected)
    {
        
        for (int i=0; i<_arraySearch.count; i++)
        {
            BVisitSearchRetCatagory *bVisitSearchRetCatagory=(BVisitSearchRetCatagory *)[_arraySearch objectAtIndex:i];
            NSMutableArray *arrayIssueSearchRet=[[NSMutableArray alloc]init];
            for (BVisitIssueSearchRet *bVisitIssueSearchRet in bVisitSearchRetCatagory.arrayIssueSearchRet)
            {
                
                
                NSInteger n=0;
                for (int i=0; i<bVisitIssueSearchRet.arrayTask.count; i++)
                {
                    TaskInfo *task=(TaskInfo*)[bVisitIssueSearchRet.arrayTask objectAtIndex:i];
                    if (task.state==TASKSTATE_finished)
                    {
                        n++;
                    }
                }
                if (bVisitIssueSearchRet.arrayTask.count==0)
                {
                    if (_btNoTask.selected)
                    {
                        [arrayIssueSearchRet addObject:bVisitIssueSearchRet];
                    }
                }
                else if(n==bVisitIssueSearchRet.arrayTask.count)
                {
                    if (_btDone.selected)
                    {
                        [arrayIssueSearchRet addObject:bVisitIssueSearchRet];
                    }
                }
                else
                {
                    if (_btInProgress.selected) {
                        [arrayIssueSearchRet addObject:bVisitIssueSearchRet];
                    }
                }
                
                
                
            }
            
            if (arrayIssueSearchRet.count>0)
            {
                BVisitSearchRetCatagory *bvisitSearchRetCatagory=[[BVisitSearchRetCatagory alloc]init];
                bvisitSearchRetCatagory.arrayIssueSearchRet=arrayIssueSearchRet;
                bvisitSearchRetCatagory.storeInfo=bVisitSearchRetCatagory.storeInfo;
                bvisitSearchRetCatagory.bExpend=YES;
                bvisitSearchRetCatagory.bSelected=NO;
                [_arrayShow addObject:bvisitSearchRetCatagory];
            }
            
        }
        
        
    }
    else
    {
        //        _arrayShow=[[NSMutableArray alloc]initWithArray:_arrayVisualDisplay];
        [_arrayShow removeAllObjects];
        
    }
    
    [_tbSearchIssue reloadData];
}

- (IBAction)OnDeleteSearch:(id)sender
{
    _tfSearch.text=@"";

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
    
    if (_bIssueView)
    {
        [self dismissView:_viewIssueTrack];
        _bIssueView=NO;
        return NO;
    }
    
    if (_bShowReporterView)
    {
        if ([_viewReporter OnBack])
        {
            [self dismissView:_viewReporter];
            _bShowReporterView=NO;
        }
        
        return NO;
    }
    if (_bTask) {
        if ([_viewTask OnBack])
        {
            [self dismissView:_viewTask];
            _bTask=NO;
        }
        
        return NO;
    }
    if (_bStoreView) {
        [self dismissView:_viewStoreList];
        _bStoreView=NO;
        return NO;
    }
    return YES;
    
}


- (IBAction)OnSelectAll:(id)sender
{
    if (_selectState==0||_selectState==1)
    {
        _selectState=2;
        
        [_btSelectAll setBackgroundImage:[UIImage imageNamed:@"button_chooseb2@2x.png"] forState:UIControlStateNormal];
    }
    else
    {
         _selectState=0;
        [_btSelectAll setBackgroundImage:[UIImage imageNamed:@"button_chooseb1@2x.png"] forState:UIControlStateNormal];
    }
    if (_selectState==2)
    {
        for (BVisitSearchRetCatagory *catagory in _arrayShow)
        {
            for (BVisitIssueSearchRet *issueSearchRet in catagory.arrayIssueSearchRet)
            {
                issueSearchRet.bSelected=YES;
            }
        }
    }else
    {
        for (BVisitSearchRetCatagory *catagory in _arrayShow)
        {
            for (BVisitIssueSearchRet *issueSearchRet in catagory.arrayIssueSearchRet)
            {
                issueSearchRet.bSelected=NO;
            }
        }
    }
    [self updateSelectBT];
    [_tbSearchIssue reloadData];
}

- (IBAction)OnSearch:(id)sender
{
    [self endEditing:YES];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSTimeInterval now=[[NSDate date] timeIntervalSince1970]*1;
    int start=now/1-86400*7;
    NSDate*dateStart = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)start];
    _pickDateStart = [[RPDatePicker alloc] init:_tfStartDate Format:dateFormatter curDate:dateStart canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    _pickDateEnd = [[RPDatePicker alloc] init:_tfEndDate Format:dateFormatter curDate:[NSDate date] canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    _lbStartDate.text=_tfStartDate.text;
    _lbEndDate.text=_tfEndDate.text;
//    _viewResult.hidden=NO;
//    _tbSearchIssue.hidden=NO;
    [self showIsActive];
    [self LoadData];
}

- (IBAction)OnSend:(id)sender
{
    _btSend.selected=!_btSend.selected;
    _viewSwitch.hidden=!_viewSwitch.hidden;
    
}

- (IBAction)OnTask:(id)sender
{
    
    
    _viewSwitch.hidden=YES;
    [_issueSearchData.arrayIssue removeAllObjects];
    for (BVisitSearchRetCatagory *catagory in _arrayShow)
    {
        for (BVisitIssueSearchRet *issueSearchRet in catagory.arrayIssueSearchRet)
        {
            issueSearchRet.strStoreName = catagory.storeInfo.strStoreName;
            if (issueSearchRet.bSelected)
            {
                [_issueSearchData.arrayIssue addObject:issueSearchRet];
            }
            
        }
    }
    
    if (_issueSearchData.arrayIssue.count<1)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Please Choose at least one issue",@"RPString", g_bundleResorce,nil)];
        return;
    }
    _viewTask.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewTask];
    [UIView beginAnimations:nil context:nil];
    _viewTask.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _viewTask.delegate=self;
    _viewTask.arrayIssue=_issueSearchData.arrayIssue;
    _bTask = YES;
}
-(void)backToTask
{
    [self dismissView:_viewTask];
    _bTask=NO;
    [_issueSearchData.arrayIssue removeAllObjects];
    [self LoadData];
}
- (IBAction)OnReport:(id)sender
{
    _viewSwitch.hidden=YES;
    [_issueSearchData.arrayIssue removeAllObjects];
    for (BVisitSearchRetCatagory *catagory in _arrayShow)
    {
        for (BVisitIssueSearchRet *issueSearchRet in catagory.arrayIssueSearchRet)
        {
            if (issueSearchRet.bSelected)
            {
                [_issueSearchData.arrayIssue addObject:issueSearchRet];
            }
            
        }
    }
    
    if (_issueSearchData.arrayIssue.count<1)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Please Choose at least one issue",@"RPString", g_bundleResorce,nil)];
        return;
    }
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"The choosed reports will be sent.",@"RPString", g_bundleResorce,nil);
    NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    NSString *strCall=NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    //    NSString *strGuide=NSLocalizedStringFromTableInBundle(@"VIEW THE USER GUIDE",@"RPString", g_bundleResorce,nil);
    RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
        if (indexButton==0)
        {
            
        }
        else
        {
            _viewReporter.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [self addSubview:_viewReporter];
            
            _viewReporter.reporters = _issueSearchData.reporters;
            
            NSString * str = NSLocalizedStringFromTableInBundle(@"Report Delivering",@"RPString", g_bundleResorce,nil);
            _viewReporter.strTitle = str;
            _viewReporter.delegate = self;
            _viewReporter.nState=1;
            [UIView beginAnimations:nil context:nil];
            _viewReporter.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _bShowReporterView = YES;
            
        }
    }otherButtonTitles:strCall, nil];
    [alertView show];
}

- (IBAction)OnSelectStore:(id)sender
{
    _viewStoreList.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _viewStoreList.tfSearch.text=@"";
//    [self insertSubview:_viewStoreList belowSubview:_viewBottom];
    [self addSubview:_viewStoreList];
    
    [UIView beginAnimations:nil context:nil];
    _viewStoreList.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    [_viewStoreList reloadStore];
    
    _bStoreView=YES;
}
//判断是否激活
-(void)showIsActive
{
    
    
    NSDate *nowTime =[NSDate date];
    NSTimeInterval now=[[NSDate date] timeIntervalSince1970]*1;
    int start=now/1-86400*7;
    NSDate*dateStart = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)start];
    NSCalendar*calendar=[NSCalendar currentCalendar];

    NSDateComponents*components1 =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:dateStart];
    NSDateComponents*components2 =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:nowTime];
    NSDateComponents*components3 =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:[_pickDateStart GetDate]];
    NSDateComponents*components4 =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:[_pickDateEnd GetDate]];
   
    
    
    if (([components1 year]==[components3 year])&&([components1 month]==[components3 month])&&([components1 day]==[components3 day])&&([components2 year]==[components4 year])&&([components2 month]==[components4 month])&&([components2 day]==[components4 day])&&_btNoTask.selected&&_btInProgress.selected&&_btDone.selected&&!_store&&!_domain)
    {
        _btDateMenu.selected=NO;//默认
    }
    else
    {
        _btDateMenu.selected=YES;
    }
}
- (IBAction)OnNoTask:(id)sender
{
    if (_btInProgress.selected||_btDone.selected)
    {
        _btNoTask.selected=!_btNoTask.selected;
        if (_btNoTask.selected)
        {
            _lbNoTask.textColor=[UIColor colorWithWhite:0.7 alpha:1];
        }
        else
        {
            _lbNoTask.textColor=[UIColor colorWithWhite:0.3 alpha:1];
        }
        [self screenBNoTask:_btNoTask.selected BInProgress:_btInProgress.selected BDone:_btDone.selected ];
        [self showIsActive];
    }
}

- (IBAction)OnInProgress:(id)sender
{
    if (_btNoTask.selected||_btDone.selected)
    {
        _btInProgress.selected=!_btInProgress.selected;
        if (_btInProgress.selected)
        {
            _lbInProgress.textColor=[UIColor colorWithWhite:0.7 alpha:1];
        }
        else
        {
            _lbInProgress.textColor=[UIColor colorWithWhite:0.3 alpha:1];
        }
        [self screenBNoTask:_btNoTask.selected BInProgress:_btInProgress.selected BDone:_btDone.selected ];
        [self showIsActive];
    }
}


- (IBAction)OnTaskDone:(id)sender
{
    if (_btNoTask.selected||_btInProgress.selected)
    {
        _btDone.selected=!_btDone.selected;
        if (_btDone.selected)
        {
            _lbDone.textColor=[UIColor colorWithWhite:0.7 alpha:1];
        }
        else
        {
            _lbDone.textColor=[UIColor colorWithWhite:0.3 alpha:1];
        }
        [self screenBNoTask:_btNoTask.selected BInProgress:_btInProgress.selected BDone:_btDone.selected ];
    }
    [self showIsActive];
}
-(void)OnSelectDomain:(DomainInfo *)domain
{
    [self dismissView:_viewStoreList];
    _bStoreView=NO;
    _store=nil;
    _domain=domain;
    _lbStoreName.text=_domain.strDomainName;
    _lbStoreName.textColor=[UIColor darkGrayColor];
    [self LoadData];
    [self showIsActive];
}
-(void)OnSelectedStore:(StoreDetailInfo *)store
{
    [self dismissView:_viewStoreList];
    _bStoreView=NO;
    _domain=nil;
    _store=store;
    _lbStoreName.text=_store.strStoreName;
    _lbStoreName.textColor=[UIColor darkGrayColor];
    [self LoadData];
    [self showIsActive];
}
-(void)SubmitBVisit
{
    NSString * str = NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showWithStatus:str];
    
    [[RPSDK defaultInstance]SubmitBVisitIssue:_issueSearchData Success:^(id idResult) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil)];
        [self.delegate OnIssueTrackEnd];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
    }];
}
-(void)OnEndAddUser:(InspReporters *)reporters
{
    
    [self dismissView:_viewReporter];
    _bShowReporterView=NO;
    _issueSearchData.reporters = reporters;
    
    NetworkStatus networkStatus=[RPSDK GetConnectionStatus];
    switch (networkStatus)
    {
        case NotReachable:
        {
            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Network not found",@"RPString", g_bundleResorce,nil);
            [SVProgressHUD showErrorWithStatus:strDesc];
            break;
        }
        case ReachableViaWiFi:
        {
            [self SubmitBVisit];
            break;
        }
        case ReachableViaWWAN:
        {
            NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
            NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"No WLAN connection. Confirm to upload now?",@"RPString", g_bundleResorce,nil);
            RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
                if (indexButton==1) {
                    [self SubmitBVisit];
                }
            }otherButtonTitles:strOK, nil];
            [alertView show];
            
            break;
        }
        default:
            break;
    }
}
- (IBAction)OnDateMenu:(id)sender
{
    _bMenu=!_bMenu;
    if (_bMenu)
    {
        _ivTriangle.hidden=NO;
        [UIView beginAnimations:nil context:nil];
        _viewDateRange.frame=CGRectMake(_viewDateRange.frame.origin.x, _viewHeader.frame.size.height, _viewDateRange.frame.size.width, _viewDateRange.frame.size.height);
        _viewTB.frame=CGRectMake(_viewTB.frame.origin.x, _viewHeader.frame.size.height+_viewDateRange.frame.size.height, _viewTB.frame.size.width, _viewTB.frame.size.height-_viewDateRange.frame.size.height);
        [UIView commitAnimations];
    }
    else
    {
        _ivTriangle.hidden=YES;
        [UIView beginAnimations:nil context:nil];
        _viewDateRange.frame=CGRectMake(_viewDateRange.frame.origin.x, _viewHeader.frame.size.height-_viewDateRange.frame.size.height, _viewDateRange.frame.size.width, _viewDateRange.frame.size.height);
        _viewTB.frame=CGRectMake(_viewTB.frame.origin.x, _viewHeader.frame.size.height, _viewTB.frame.size.width, _viewTB.frame.size.height+_viewDateRange.frame.size.height);
        [UIView commitAnimations];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        RPBVisitIssueTrackCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPBVisitIssueTrackCell"];
        if (cell==nil)
        {
            NSArray *arrayNib=[[NSBundle mainBundle] loadNibNamed:@"RPBVisitIssueTrackCell" owner:self options:nil];
            cell=[arrayNib objectAtIndex:0];
        }
    cell.delegate=self;
    cell.issueSearchRet=[((BVisitSearchRetCatagory *)[_arrayShow objectAtIndex:indexPath.section]).arrayIssueSearchRet objectAtIndex:indexPath.row];
    cell.store=((BVisitSearchRetCatagory *)[_arrayShow objectAtIndex:indexPath.section]).storeInfo;
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _viewIssueTrack.frame=CGRectMake(self.frame.size.width, 0, _viewIssueTrack.frame.size.width, _viewIssueTrack.frame.size.height);
    _viewIssueTrack.issue=((BVisitIssueSearchRet*)[((BVisitSearchRetCatagory *)[_arrayShow objectAtIndex:indexPath.section]).arrayIssueSearchRet objectAtIndex:indexPath.row]).issue;
    _viewIssueTrack.arrayTask=((BVisitIssueSearchRet*)[((BVisitSearchRetCatagory *)[_arrayShow objectAtIndex:indexPath.section]).arrayIssueSearchRet objectAtIndex:indexPath.row]).arrayTask;
    [self addSubview:_viewIssueTrack];
    [UIView beginAnimations:nil context:nil];
    _viewIssueTrack.frame=CGRectMake(0, 0, _viewIssueTrack.frame.size.width, _viewIssueTrack.frame.size.height);
    [UIView commitAnimations];
    _bIssueView=YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 56;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 64;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (((BVisitSearchRetCatagory *)[_arrayShow objectAtIndex:section]).bExpend)
    {
        return ((BVisitSearchRetCatagory *)[_arrayShow objectAtIndex:section]).arrayIssueSearchRet.count;
    }
    else
    {
        return 0;
    }
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    RPBVisitIssueTrackHeadView * view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RPBVisitIssueTrackHeadView"];
    if (view == nil) {
        view = [[[NSBundle mainBundle] loadNibNamed:@"RPBVisitIssueTrackHeadView" owner:nil options:nil] objectAtIndex:0];
    }
    view.delegate=self;
    view.issueSearchRetCatagory=[_arrayShow objectAtIndex:section];
    return view;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrayShow.count;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==_tfStartDate)
    {
        _lbStartDate.text=_tfStartDate.text;
    }
    if (textField==_tfEndDate)
    {
        _lbEndDate.text=_tfEndDate.text;
    }
    [self LoadData];
    [self showIsActive];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (sender==_tfStartDate || sender==_tfEndDate)
    {
        return NO;
    }
    return YES;
}
//刷新本界面全选按钮
-(void)updateSelectBT
{
    NSInteger n=0;//选择的个数
    NSInteger m=0;//总数
    for (BVisitSearchRetCatagory *catagory in _arrayShow)
    {
        for (BVisitIssueSearchRet *issueSearchRet in catagory.arrayIssueSearchRet)
        {
            if (issueSearchRet.bSelected)
            {
                n++;
            }
            m++;
        }
    }
    if (n==0)
    {
        _selectState=0;
        [_btSelectAll setBackgroundImage:[UIImage imageNamed:@"button_chooseb1@2x.png"] forState:UIControlStateNormal];
    }
    else if(n<m)
    {
        _selectState=1;
        [_btSelectAll setBackgroundImage:[UIImage imageNamed:@"button_chooseb3@2x.png"] forState:UIControlStateNormal];
    }
    else if(n==m)
    {
        _selectState=2;
        [_btSelectAll setBackgroundImage:[UIImage imageNamed:@"button_chooseb2@2x.png"] forState:UIControlStateNormal];
    }
    _lbCount.text=[NSString stringWithFormat:@"%i/%i",n,m];
}
-(void)endSelectCatagory
{
    [self updateSelectBT];
    [_tbSearchIssue reloadData];
    
}
-(void)endSelectIssue
{
    [self updateSelectBT];
    [_tbSearchIssue reloadData];
}
- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}
- (IBAction)OnQuit:(id)sender
{
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to exit?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [self.delegate OnIssueTrackEnd];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
    
}
@end
