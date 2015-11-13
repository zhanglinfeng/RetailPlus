//
//  RPDistributionList.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-9-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPDistributionList.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@implementation RPDistributionList

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
    _issueSearchData=[[BVisitIssueSearchData alloc]init];
    _issueSearchData.arrayIssue=[[NSMutableArray alloc]init];
}
-(void)LoadData
{
    [SVProgressHUD showWithStatus:@""];
    [[RPSDK defaultInstance]searchBVisitIssue:nil StartDate:nil EndDate:nil DomianId:nil ReportId:_reportId Success:^(NSMutableArray* arrayResult) {
        [SVProgressHUD dismiss];
        _arraySearch=arrayResult;
        if (_arraySearch.count==0)
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No issues exist",@"RPString", g_bundleResorce,nil)];
        }
        [_tbIssue reloadData];
        
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
    }];
}
-(void)setReportId:(NSString *)reportId
{
    _reportId=reportId;
    [self LoadData];
    
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
    if (_arraySearch.count>0) {
        cell.issueSearchRet=[((BVisitSearchRetCatagory *)[_arraySearch objectAtIndex:indexPath.section]).arrayIssueSearchRet objectAtIndex:indexPath.row];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _viewIssueTrack.frame=CGRectMake(self.frame.size.width, 0, _viewIssueTrack.frame.size.width, _viewIssueTrack.frame.size.height);
    _viewIssueTrack.issue=((BVisitIssueSearchRet*)[((BVisitSearchRetCatagory *)[_arraySearch objectAtIndex:indexPath.section]).arrayIssueSearchRet objectAtIndex:indexPath.row]).issue;
    _viewIssueTrack.arrayTask = ((BVisitIssueSearchRet*)[((BVisitSearchRetCatagory *)[_arraySearch objectAtIndex:indexPath.section]).arrayIssueSearchRet objectAtIndex:indexPath.row]).arrayTask;
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
    
    return 56;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arraySearch.count<1)
    {
        return 0;
    }
    if (((BVisitSearchRetCatagory *)[_arraySearch objectAtIndex:section]).bExpend)
    {
        return ((BVisitSearchRetCatagory *)[_arraySearch objectAtIndex:section]).arrayIssueSearchRet.count;
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
    if (_arraySearch.count>0)
    {
        view.issueSearchRetCatagory=[_arraySearch objectAtIndex:section];
    }
    
    return view;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arraySearch.count;
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
    
    
    if (_bTask) {
        if ([_viewTask OnBack])
        {
            [self dismissView:_viewTask];
            _bTask=NO;
        }
        return NO;
    }
    return YES;
}
-(void)backToTask
{
    [self dismissView:_viewTask];
    _bTask=NO;
    [_issueSearchData.arrayIssue removeAllObjects];
    [self LoadData];
}
- (IBAction)OnOK:(id)sender
{
    for (BVisitSearchRetCatagory *catagory in _arraySearch)
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
    _viewTask.arrayIssue=_issueSearchData.arrayIssue;
    _viewTask.delegate=self;
    _bTask = YES;
}
-(void)endSelectCatagory
{
    [_tbIssue reloadData];
    
}
-(void)endSelectIssue
{
    [_tbIssue reloadData];
}
@end
