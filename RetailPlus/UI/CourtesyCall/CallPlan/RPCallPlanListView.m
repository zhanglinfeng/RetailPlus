//
//  RPCallPlanListView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-13.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCallPlanListView.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"
#import "RPBlockUISelectView.h"
#import "UIImageView+WebCache.h"
#import "RPCallPlanCell.h"
extern NSBundle * g_bundleResorce;
@implementation RPCallPlanListView

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
    _viewHead.layer.cornerRadius=10;
    _ivHeader.layer.cornerRadius=6;
    _ivHeader.layer.borderWidth=1;
    _ivHeader.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    [_tbCallPlanList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_ivHeader setImageWithURLString:[RPSDK defaultInstance].userLoginDetail.strPortraitImg placeholderImage:[UIImage imageNamed:@"icon_userimage01_224.png"]];
    _lbName.text = [NSString stringWithFormat:@"%@",[RPSDK defaultInstance].userLoginDetail.strFirstName];
    _lbAddress.text=[RPSDK defaultInstance].userLoginDetail.strOfficeAddress ;
    switch ([[[RPSDK defaultInstance]userLoginDetail]rank]) {
        case Rank_Manager:
            _viewBackground.backgroundColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _viewBackground.backgroundColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _viewBackground.backgroundColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _viewBackground.backgroundColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }
}

-(void)loadData
{
    [SVProgressHUD showWithStatus: NSLocalizedStringFromTableInBundle(@"Loading...",@"RPString", g_bundleResorce,nil)];
    [[RPSDK defaultInstance]GetCourtesyCallInfoList:[RPSDK defaultInstance].userLoginDetail.strUserId isCompleted:NO Success:^(NSMutableArray *array) {
        _arrayPlanList=array;
        [_tbCallPlanList reloadData];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}

-(IBAction)OnQuit:(id)sender
{
    [self endEditing:YES];
    
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to exit?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [self.delegate endCallPlan];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
    
}

- (IBAction)OnAddCallPlan:(id)sender
{
    _viewAddCallPlan.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewAddCallPlan];
    [UIView beginAnimations:nil context:nil];
    _viewAddCallPlan.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _viewAddCallPlan.arrayType=_arrayType;
    _viewAddCallPlan.entrance=1;
    _viewAddCallPlan.bModify=NO;
    _viewAddCallPlan.delegateOK=self;
    _bAddCallPlan=YES;
}
-(void)setArrayType:(NSArray *)arrayType
{
    _bAddCallPlan=NO;
    _bCourtesyCall=NO;
    _arrayType=arrayType;
    [self loadData];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPCallPlanCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPCallPlanCell"];
    if (cell==nil)
    {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPCallPlanCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
    }
    cell.arrayType=_arrayType;
    cell.courtesyCallInfo=[_arrayPlanList objectAtIndex:indexPath.row];
    cell.delegate=self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _viewCourtesyCall.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewCourtesyCall];
    [UIView beginAnimations:nil context:nil];
    _viewCourtesyCall.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _viewCallRecord.delegateOK=self;
    _viewCourtesyCall.entrance=2;
    _viewCourtesyCall.arrayType=_arrayType;
    _viewCourtesyCall.courtesyCallInfo=[_arrayPlanList objectAtIndex:indexPath.row];
    _viewCourtesyCall.delegateOK=self;
    _bCourtesyCall=YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayPlanList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        
        CourtesyCallInfo *callInfo=[_arrayPlanList objectAtIndex:indexPath.row];
        [[RPSDK defaultInstance]DeleteCourtesyCallInfo:callInfo.strID Success:^(id idResult) {
            [self loadData];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
        }];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedStringFromTableInBundle(@"DELETE",@"RPString", g_bundleResorce,nil);
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
    if (_bAddCallPlan)
    {
        if ([_viewAddCallPlan OnBack])
        {
            [self dismissView:_viewAddCallPlan];
            _bAddCallPlan=NO;
        }
        
        return NO;
    }
    if (_bCourtesyCall)
    {
        if ([_viewCourtesyCall OnBack])
        {
            [self dismissView:_viewCourtesyCall];
            _bCourtesyCall=NO;
        }
        return NO;
    }
    return YES;
}
-(void)endAddCallPlanOK
{
//    [UIView beginAnimations:nil context:nil];
//    _viewAddCallPlan.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
//    [UIView commitAnimations];
    [self dismissView:_viewAddCallPlan];
    _bAddCallPlan=NO;
    [self loadData];
}
-(void)editPlan:(CourtesyCallInfo *)courtesyCallInfo
{
    _viewAddCallPlan.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewAddCallPlan];
    [UIView beginAnimations:nil context:nil];
    _viewAddCallPlan.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _viewAddCallPlan.arrayType=_arrayType;
    _viewAddCallPlan.courtesyCallInfo=courtesyCallInfo;
    _viewAddCallPlan.entrance=1;
    _viewAddCallPlan.bModify=YES;
    _viewAddCallPlan.delegateOK=self;
    _bAddCallPlan=YES;
}
-(void)RecordOK
{
    [self dismissView:_viewCourtesyCall];
    _bCourtesyCall=NO;
    [self loadData];
}
-(void)backToStart
{
    
}
@end
