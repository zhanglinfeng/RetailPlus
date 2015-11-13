//
//  RPBlockUISelectBodyView.m
//  RetailPlus
//
//  Created by lin dong on 14-2-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBlockUISelectBodyView.h"
#import "RPBlockUISelectBodyCell.h"

@implementation RPBlockUISelectBodyView

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
    _tbBody.layer.cornerRadius = 6;
    _tbBody.layer.borderWidth = 1;
    _tbBody.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:1].CGColor;
}

-(void)AddSelTitle:(NSString *)strSelTitle
{
    if (_arraySelTitle == nil) _arraySelTitle = [[NSMutableArray alloc] init];
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPBlockUISelectBodyCell" owner:self options:nil];
    RPBlockUISelectBodyCell *cell = [array objectAtIndex:0];
    cell.nWidth = _tbBody.frame.size.width;
    cell.strTitle = strSelTitle;
    [_arraySelTitle addObject:cell];
    
    NSInteger nTableHeight = 0;
    for (RPBlockUISelectBodyCell * cell in _arraySelTitle) {
        nTableHeight += cell.nHeight;
    }
    
    _nViewHeight = _svBody.frame.origin.y + nTableHeight + _tbBody.frame.origin.y * 2 + 26;
    if (_nViewHeight > _nMaxHeight) _nViewHeight = _nMaxHeight;
    
    _tbBody.frame = CGRectMake(_tbBody.frame.origin.x, _tbBody.frame.origin.y, _tbBody.frame.size.width, nTableHeight);
    
    _svBody.frame = CGRectMake(_svBody.frame.origin.x, _svBody.frame.origin.y, _svBody.frame.size.width, _nViewHeight - _svBody.frame.origin.y);
    [_svBody setContentSize:CGSizeMake(_svBody.frame.size.width, _tbBody.frame.size.height + _tbBody.frame.origin.y * 2)];
}

-(void)setStrTitle:(NSString *)strTitle
{
    _strTitle = strTitle;
    _lbTitle.text = strTitle;
}

-(void)setNCurSel:(NSInteger)nCurSel
{
    _nCurSel = nCurSel;
    [_tbBody reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arraySelTitle.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPBlockUISelectBodyCell *cell= [_arraySelTitle objectAtIndex:indexPath.row];
    return cell.nHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPBlockUISelectBodyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPBlockUISelectBodyCell"];
    if (cell == nil)
    {
        cell = [_arraySelTitle objectAtIndex:indexPath.row];
    }
    cell.bSelected = (indexPath.row == _nCurSel) ? YES : NO;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_delegate OnSelect:indexPath.row];
}
@end
