//
//  RPPositionMngView.m
//  RetailPlus
//
//  Created by lin dong on 14-9-2.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPPositionMngView.h"
#import "SVProgressHUD.h"
#import "RPPositionTableViewCell.h"
extern NSBundle * g_bundleResorce;

@implementation RPPositionMngView

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

-(IBAction)OnAddPosition:(id)sender
{
    [_addPosition ClearData];
    _addPosition.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _addPosition.delegate = self;
    _addPosition.loginProfile = _loginProfile;
    [self addSubview:_addPosition];
    
    [UIView beginAnimations:nil context:nil];
    _addPosition.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _bShowAddPos = YES;
}

-(void)setLoginProfile:(UserDetailInfo *)loginProfile
{
    _loginProfile = loginProfile;
    [self UpdateUI];
}

-(void)UpdateUI
{
    _lbUserName.text = _loginProfile.strFirstName;
    switch (_loginProfile.rank) {
        case Rank_Manager:
            _lbUserName.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbUserName.textColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _lbUserName.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _lbUserName.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }
    [_tbPosition reloadData];
}

-(BOOL)OnBack
{
    if (_bShowAddPos) {
        if ([_addPosition OnBack]) {
            [UIView beginAnimations:nil context:nil];
            _addPosition.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _bShowAddPos = NO;
        }
        return NO;
    }
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _loginProfile.arrayPosition.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RPPosition * pos = [_loginProfile.arrayPosition objectAtIndex:indexPath.row];
    if (![pos.strPositionId isEqualToString:_loginProfile.strDefaultPosId])
    {
        [SVProgressHUD showWithStatus:@""];
        [[RPSDK defaultInstance] SetDefaultPosition:_loginProfile.strUserId Position:pos.strPositionId Success:^(id idResult) {
            _loginProfile.strDefaultPosId = pos.strPositionId;
            _loginProfile.strRoleName = pos.strRoleName;
            _loginProfile.strDomainName = pos.strPositionName;
            [_tbPosition reloadData];
            [SVProgressHUD dismiss];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPPosition * pos = [_loginProfile.arrayPosition objectAtIndex:indexPath.row];
    if ([pos.strPositionId isEqualToString:_loginProfile.strDefaultPosId])
        return UITableViewCellEditingStyleNone;
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedStringFromTableInBundle(@"DELETE",@"RPString", g_bundleResorce,nil);
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        [SVProgressHUD showWithStatus:@""];
        RPPosition * pos = [_loginProfile.arrayPosition objectAtIndex:indexPath.row];
        [[RPSDK defaultInstance] RemoveUserPosition:_loginProfile.strUserId Position:pos.strPositionId Success:^(id idResult) {
            [_loginProfile.arrayPosition removeObjectAtIndex:indexPath.row];
            [_tbPosition reloadData];
            [self UpdateRank];
            [SVProgressHUD dismiss];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];

    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPPositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPPositionTableViewCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPPositionTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.strDefaultPostionId = _loginProfile.strDefaultPosId;
    cell.position = [_loginProfile.arrayPosition objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)OnAddPositionEnd
{
    [UIView beginAnimations:nil context:nil];
    _addPosition.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bShowAddPos = NO;
    [_tbPosition reloadData];
    [self UpdateRank];
}

-(void)UpdateRank
{
    [SVProgressHUD showWithStatus:@""];
    [[RPSDK defaultInstance] GetUserDetailInfo:_loginProfile.strUserId Success:^(UserDetailInfo * detailResult) {
        _loginProfile.rank = detailResult.rank;
        [self UpdateUI];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}
@end
