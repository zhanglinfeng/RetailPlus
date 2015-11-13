//
//  RPMngChnView.m
//  RetailPlus
//
//  Created by lin dong on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPMngChnView.h"
#import "RPMngChnTableViewCell.h"
#import "RPConfDBMng.h"
#import "RPMngChnDetailView.h"
#import "RPYuanTelApi.h"
#import "SVProgressHUD.h"



@implementation RPMngChnView

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
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 33;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _arrayChn.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPMngChnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPMngChnTableViewCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPMngChnTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.delegate = self;
    }
    cell.account = [_arrayChn objectAtIndex:indexPath.row];
    return cell;
}

-(void)OnLogin:(NSInteger)nIndex
{
    
}

-(void)OnShowChnDetail:(NSInteger)nIndex
{
    ((RPMngChnDetailView *)_viewDetail).delegate = self;
    ((RPMngChnDetailView *)_viewDetail).account = [_arrayChn objectAtIndex:nIndex];
    
    _viewDetail.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewDetail];
    
    [UIView beginAnimations:nil context:nil];
    _viewDetail.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _bShowDetail = YES;
}

-(void)LoginEnd:(NSInteger)nIndex Success:(BOOL)bSuccess ChangeChecked:(BOOL)bChangeCheck
{
    RPConfAccount * account = [_arrayChn objectAtIndex:nIndex];
    
    if (bChangeCheck) {
        for(RPConfAccount * account in _arrayChn)
        {
            account.bChecked = NO;
        }
        account.bChecked = YES;
    }
    account.bLogined = bSuccess;
    
    [UIView beginAnimations:nil context:nil];
    _viewDetail.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [_tbAccount reloadData];
    _bShowDetail = NO;
    
    [[RPConfDBMng defaultInstance] SaveConfAccounts:_arrayChn LoginUser:[RPSDK defaultInstance].userLoginDetail.strUserId];
}

-(void)DeleteEnd:(NSInteger)nIndex
{
    [UIView beginAnimations:nil context:nil];
    _viewDetail.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [_tbAccount reloadData];
    _bShowDetail = NO;
    
    [[RPConfDBMng defaultInstance] SaveConfAccounts:_arrayChn LoginUser:[RPSDK defaultInstance].userLoginDetail.strUserId];
}

-(void)LoadSavedAccount
{
    _arrayChn = [[RPConfDBMng defaultInstance] LoadConfAccounts:MAX_CONFACCOUNTCOUNT LoginUser:[RPSDK defaultInstance].userLoginDetail.strUserId];
    for(RPConfAccount * account in _arrayChn)
    {
        if (account.bChecked) {
            [SVProgressHUD showWithStatus:@""];
            [[RPYuanTelApi defaultInstance] LoginConf:account.strUserName PassWord:account.strPassWord success:^(id idResult) {
                account.bLogined = YES;
                [_tbAccount reloadData];
                [SVProgressHUD dismiss];
            } failed:^(NSInteger nErrorCode, NSString *strDesc) {
                 [SVProgressHUD showErrorWithStatus:strDesc];
            }];
            break;
        }
    }
    [_tbAccount reloadData];
}

-(BOOL)OnBack
{
    if (_bShowDetail) {
        [UIView beginAnimations:nil context:nil];
        _viewDetail.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        [_tbAccount reloadData];
        _bShowDetail = NO;
        return NO;
    }
    return YES;
}
@end
