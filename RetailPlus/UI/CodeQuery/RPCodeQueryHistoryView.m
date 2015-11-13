//
//  RPCodeQueryHistoryView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-5-5.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCodeQueryHistoryView.h"
#import "RPCodeHistoryCell.h"
#import "RPCodeResultView.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;
@implementation RPCodeQueryHistoryView

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
     
    _viewHeader.layer.cornerRadius=10;
    _viewSearch.layer.cornerRadius=6;
    
    //为了多选
    _tbCodeHistory.allowsSelection=YES;
    _tbCodeHistory.allowsSelectionDuringEditing=YES;
    
    //设置tableView无分割线
    _tbCodeHistory.separatorStyle=UITableViewCellSeparatorStyleNone;
    _arrayDelete=[[NSMutableArray alloc]init];
}

- (IBAction)OnDeleteSearch:(id)sender
{
    _tfSearch.text=@"";
    [self ReloadData];
}

-(void)setArrayHistory:(NSArray *)arrayHistory
{
    _tfSearch.text = @"";
    _arrayHistory=arrayHistory;
    [_tbCodeHistory reloadData];
}

- (IBAction)OnMenu:(id)sender {
    _btMenu.selected=!_btMenu.selected;
    [_arrayDelete removeAllObjects];
    _btSelect.selected=NO;
    if (_btMenu.selected)
    {
        [UIView beginAnimations:nil context:nil];
        _tbCodeHistory.frame=CGRectMake(_tbCodeHistory.frame.origin.x, _tbCodeHistory.frame.origin.y+35, _tbCodeHistory.frame.size.width, _tbCodeHistory.frame.size.height-35);
        [UIView commitAnimations];
        
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        _tbCodeHistory.frame=CGRectMake(_tbCodeHistory.frame.origin.x, _tbCodeHistory.frame.origin.y-35, _tbCodeHistory.frame.size.width, _tbCodeHistory.frame.size.height+35);
        [UIView commitAnimations];
        
    }
    [_tbCodeHistory reloadData];
}

- (IBAction)OnDelete:(id)sender
{
    for (int i = 0; i<_arrayDelete.count; i++)
    {
        [[RPSDK defaultInstance]DeleteGoodsTrackingInfo:[_arrayDelete objectAtIndex:i]];
    }
    _btSelect.selected = NO;
    [self ReloadData];
}

- (IBAction)OnSelected:(id)sender
{
    _btSelect.selected=!_btSelect.selected;
    if (_btSelect.selected)
    {
        for (int i=0; i<_arrayHistory.count; i++)
        {
            for (int j=0; j<((NSArray*)[_arrayHistory objectAtIndex:i]).count; j++)
            {
                GoodsTrackingInfo *goodsInfo=((GoodsTrackingInfo *)[((NSArray*)[_arrayHistory objectAtIndex:i]) objectAtIndex:j]);
                [_arrayDelete addObject:goodsInfo.strID];
            }
        }
        
    }
    else
    {
        [_arrayDelete removeAllObjects];
    }
    [_tbCodeHistory reloadData];
}
-(BOOL)OnBack
{
    [self endEditing:YES];
    
    if (_bResultView)
    {
    
        [UIView beginAnimations:nil context:nil];
        _viewResult.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _bResultView=NO;
        return NO;
        
    }
    return YES;
}
- (IBAction)OnQuit:(id)sender
{
    [self endEditing:YES];
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to exit?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [self.delegate endCodeHistory];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrayHistory.count;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    if (textField == _tfSearch) {
        [self ReloadData];
    }
    return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPCodeHistoryCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPCodeHistoryCell"];
    if (cell==nil)
    {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPCodeHistoryCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
    }
    GoodsTrackingInfo *goodsInfo=((GoodsTrackingInfo *)[((NSArray*)[_arrayHistory objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row]);
    cell.goodsInfo=goodsInfo;
    cell.checked=_btSelect.selected;
    cell.bEdit=_btMenu.selected;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsTrackingInfo *goodsInfo=((GoodsTrackingInfo *)[((NSArray*)[_arrayHistory objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row]);
    if (_btMenu.selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        RPCodeHistoryCell *cell=(RPCodeHistoryCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.checked = !cell.checked;
        
        if (cell.checked)
        {
            [_arrayDelete addObject:goodsInfo.strID];
        }
        else
        {
            [_arrayDelete removeObject:goodsInfo.strID];
        }
        
    }
    else
    {
        _viewResult.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:_viewResult];
        
        _viewResult.result=goodsInfo;
        _viewResult.delegate=self;
        [UIView beginAnimations:nil context:nil];
        _viewResult.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _bResultView=YES;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(5, 0, 294, 20)];
    headerView.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    UILabel *dateLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 20)];
    dateLable.textColor=[UIColor colorWithWhite:0.7 alpha:1];
    dateLable.backgroundColor=[UIColor clearColor];
    dateLable.text=((GoodsTrackingInfo *)[((NSArray*)[_arrayHistory objectAtIndex:section]) objectAtIndex:0]).strDate;
    dateLable.font=[UIFont systemFontOfSize:12];
    [headerView addSubview:dateLable];
    UILabel *lbCount=[[UILabel alloc]initWithFrame:CGRectMake(headerView.frame.size.width-105, 0, 100, 20)];
    lbCount.textColor=[UIColor colorWithWhite:0.7 alpha:1];
    lbCount.textAlignment=NSTextAlignmentRight;
    lbCount.text=[NSString stringWithFormat:@"%d",((NSArray*)[_arrayHistory objectAtIndex:section]).count];
    lbCount.font=[UIFont systemFontOfSize:12];
    [headerView addSubview:lbCount];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

   return ((NSArray*)[_arrayHistory objectAtIndex:section]).count;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //不要显示任何编辑的图标
    return UITableViewCellEditingStyleNone;
}

-(void)OnShowResultEnd
{
    _bResultView = NO;
    [self ReloadData];
}

-(void)ReloadData
{
    _arrayHistory = [[RPSDK defaultInstance] GetGoodsTrackingList:_tfSearch.text];
    [_tbCodeHistory reloadData];
}
@end
