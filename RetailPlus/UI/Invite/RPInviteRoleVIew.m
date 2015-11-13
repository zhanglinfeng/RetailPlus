//
//  RPInviteRoleVIew.m
//  RetailPlus
//
//  Created by lin dong on 13-8-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPInviteRoleVIew.h"
#import "RPInviteCell.h"

@implementation RPInviteRoleVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    _viewFrame.layer.cornerRadius = 8;
    
    [[RPSDK defaultInstance] GetInviteRoleList:^(NSArray * arrayRole) {
        self.arrayRole = arrayRole;
        [_tbRole reloadData];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.arrayRole == nil) {
        return 0;
    }
    
    return self.arrayRole.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPInviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPInviteCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPInviteCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    cell.role = [self.arrayRole objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate SelectRole:[self.arrayRole objectAtIndex:indexPath.row]];
}
@end
