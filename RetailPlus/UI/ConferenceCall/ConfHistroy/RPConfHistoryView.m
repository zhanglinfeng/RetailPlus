//
//  RPConfHistoryView.m
//  RetailPlus
//
//  Created by lin dong on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPConfHistoryView.h"
#import "RPConfDBMng.h"
#import "RPConfHistoryCell.h"

extern NSBundle * g_bundleResorce;

@implementation RPConfHistoryView

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
    _viewFrame.layer.cornerRadius = 8;
    _viewSearchFrame.layer.cornerRadius = 6;
}

-(void)ReloadData
{
    _tfSearch.text = @"";
    _arrayConf = [[RPConfDBMng defaultInstance] GetConfHistory:[RPSDK defaultInstance].userLoginDetail.strUserId];
    [self UpdateUI];
}

-(void)UpdateUI
{
    _arrayConfShow = _arrayConf;
    [_tbConfHistory reloadData];
    
    if (_tfSearch.text.length > 0) {
        _arrayConfShow = [[NSMutableArray alloc] init];
        for (RPConf * conf in _arrayConf) {
            NSRange range = [conf.strCallTheme rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                [_arrayConfShow addObject:conf];
                continue;
            }
            if (conf.strHostPhone) {
                NSRange range = [conf.strHostPhone rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
                if (range.location != NSNotFound) {
                    [_arrayConfShow addObject:conf];
                    continue;
                }
            }
        }
    }
    else
        _arrayConfShow = _arrayConf;
    
    [_tbConfHistory reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPConfHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPConfHistoryCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPConfHistoryCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.conf = [_arrayConfShow objectAtIndex:indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayConfShow.count;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 52;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _viewHistoryDetail.delegate = self;
    
    _viewHistoryDetail.conf = [_arrayConfShow objectAtIndex:indexPath.row];
    //_viewConfStart.delegate = self;
    
    _viewHistoryDetail.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewHistoryDetail];
    
    [UIView beginAnimations:nil context:nil];
    _viewHistoryDetail.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _bShowDetail = YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * s=NSLocalizedStringFromTableInBundle(@"DELETE",@"RPString", g_bundleResorce,nil);
    return s;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        RPConf * conf =  [_arrayConfShow objectAtIndex:indexPath.row];
        [[RPConfDBMng defaultInstance] DeleteConfHistory:conf.strID];
        [self ReloadData];
    }
}

-(void)OnQuit
{
    [UIView beginAnimations:nil context:nil];
    _viewHistoryDetail.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _bShowDetail = NO;
    
    [_delegate OnHistoryEnd];
}

-(void)OnRepeat:(RPConf *)conf
{
    [UIView beginAnimations:nil context:nil];
    _viewHistoryDetail.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bShowDetail = NO;
    
    [_delegate OnRepeatConf:conf];
}

-(BOOL)OnBack
{
    if (_bShowDetail) {
        [UIView beginAnimations:nil context:nil];
        _viewHistoryDetail.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _bShowDetail = NO;
        return NO;
    }
    return YES;
}

-(IBAction)OnClearSearch:(id)sender
{
    _tfSearch.text = @"";
    [self UpdateUI];
}

-(IBAction)OnQuit:(id)sender
{
    [_delegate OnHistoryEnd];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self UpdateUI];
    return YES;
}
@end
