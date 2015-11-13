//
//  RPRelatedTaskView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-9-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPRelatedTaskView.h"
#import "RPTaskCell.h"
@implementation RPRelatedTaskView

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

-(void)setArrayTask:(NSMutableArray *)arrayTask
{
    _arrayTask=arrayTask;
    [_tbTask reloadData];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPTaskCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPTaskCell"];
    if (cell==nil)
    {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPTaskCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
    }
    cell.taskInfo=(TaskInfo *)[_arrayTask objectAtIndex:indexPath.row];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayTask.count;
}
@end
