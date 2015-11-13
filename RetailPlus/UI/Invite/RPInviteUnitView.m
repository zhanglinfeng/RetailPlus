//
//  RPInviteUnitView.m
//  RetailPlus
//
//  Created by lin dong on 13-8-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPInviteUnitView.h"

@implementation RPInviteUnitView

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

-(void)UpdateUI
{
    if (_tfSearch.text == nil || _tfSearch.text.length == 0) {
         _arrayShowPosition = [[NSMutableArray alloc] initWithArray:_arrayPosition];
    }
    else
    {
        _arrayShowPosition = [[NSMutableArray alloc] init];
        for (InvitePosition * position in _arrayPosition) {
            NSRange range = [position.strDomainName rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
            if (range.length == 0) {
                continue;
            }
            [_arrayShowPosition addObject:position];
        }
    }
    [_tbUnit reloadData];
}

-(void)setRoleCurrent:(InviteRole *)roleCurrent
{
    _roleCurrent = roleCurrent;
    
    [[RPSDK defaultInstance] GetInvitePositionListByRole:_roleCurrent.strRoleID Success:^(NSArray * arrayPosition) {
        _arrayPosition = arrayPosition;
        [self UpdateUI];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrayShowPosition == nil) {
        return 0;
    }
    
    return _arrayShowPosition.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    // [cell setBackgroundView: [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableCellBg.png"]]] ;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:17.0]];
    
    cell.textLabel.text = ((InvitePosition *)[_arrayShowPosition objectAtIndex:indexPath.row]).strDomainName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tfSearch.text = @"";
    [_tfSearch resignFirstResponder];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate SelectPosition:[_arrayShowPosition objectAtIndex:indexPath.row]];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self UpdateUI];
    return YES;
}

-(IBAction)OnDeleteSearch:(id)sender
{
    _tfSearch.text = @"";
    [_tfSearch resignFirstResponder];
    [self UpdateUI];
}
@end
