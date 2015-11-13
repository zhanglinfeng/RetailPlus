//
//  RPUserListView.m
//  RetailPlus
//
//  Created by lin dong on 14-3-14.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPUserListView.h"
#import "SVProgressHUD.h"
#import "RPUserListCell.h"

extern NSBundle * g_bundleResorce;

@implementation RPUserListView

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
    CALayer * sublayer = _viewFrame.layer;
    sublayer.cornerRadius = 8;
}

-(void)reloadUser
{
    _arrayUser = nil;
    [_tbUser reloadData];
    
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTableInBundle(@"Please wait...",@"RPString", g_bundleResorce,nil)];
    
    [[RPSDK defaultInstance] GetUserInfoList:Rand_All Success:^(NSMutableArray * array) {
        _arrayUser = array;
        [SVProgressHUD dismiss];
        [_tbUser reloadData];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrayUser) {
        return _arrayUser.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPUserListCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPCustomCell" owner:self options:nil];
        cell = [array objectAtIndex:2];
    }
    
    [cell setUser:(UserDetailInfo *)[_arrayUser objectAtIndex:indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate) {
        [self.delegate OnSelectUser:[_arrayUser objectAtIndex:indexPath.row]];
    }
}

-(void)dismiss
{
    [SVProgressHUD dismiss];
}
@end
