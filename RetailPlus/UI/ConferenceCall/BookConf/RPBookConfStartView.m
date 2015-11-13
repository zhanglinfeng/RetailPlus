//
//  RPBookConfStartView.m
//  RetailPlus
//
//  Created by lin dong on 14-6-19.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBookConfStartView.h"
#import "RPBookConfStartCell.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
#import "RPConfDBMng.h"

extern NSBundle * g_bundleResorce;

@implementation RPBookConfStartView

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

-(void)setConfbook:(RPConfBook *)confbook
{
    _confbook = confbook;
    
    _lbConfTheme.text = confbook.strCallTheme;
    _lbCount.text = [NSString stringWithFormat:@"%d",confbook.nMemberCount];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd ccc.  HH:mm"];
    _lbDateTime.text = [formatter stringFromDate:confbook.dateBooking];
    
    if (!confbook.arrayMember) {
        [[RPYuanTelApi defaultInstance] GetBookingConferenceDetail:confbook Success:^(id idResult) {
            _confbook = confbook;
            [_tbMember reloadData];
        } failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
    else
        [_tbMember reloadData];
}


-(IBAction)OnStart:(id)sender
{
    NSString *strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    NSString *strStart = NSLocalizedStringFromTableInBundle(@"Start conference immediately?",@"RPString", g_bundleResorce,nil);
    NSString *strYes = NSLocalizedStringFromTableInBundle(@"YES",@"RPString", g_bundleResorce,nil);
    
    [self endEditing:YES];
    
    RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strStart cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            NSMutableArray * arrayGuest = [[NSMutableArray alloc] init];
            for (RPConfBookMember * member in _confbook.arrayMember) {
                if (member.bMaster == NO) {
                    RPConfGuest * guest = [[RPConfGuest alloc] init];
                    guest.strPhone = member.strMemberPhone;
                    guest.strGuestName = member.strMemberDesc;
                    guest.strEmail = member.strMemberEmail;
                    [arrayGuest addObject:guest];
                }
            }
            [SVProgressHUD showWithStatus:@""];
            
            [[RPYuanTelApi defaultInstance] StartConference:_confbook.strCallTheme HostPhone:_confbook.strHostPhone Guests:arrayGuest success:^(id idResult) {
                
                [[RPConfDBMng defaultInstance] SaveConfHistory:_confbook.strCallTheme HostPhone:_confbook.strHostPhone Guests:arrayGuest Date:[NSDate date] LoginUser:[RPSDK defaultInstance].userLoginDetail.strUserId];
                
                [_delegate OnStartBookEnd];
            } failed:^(NSInteger nErrorCode, NSString *strDesc) {
                [SVProgressHUD showErrorWithStatus:strDesc];
            }];
        }
    } otherButtonTitles:strYes, nil];
    [alertView show];
}

-(IBAction)OnDelete:(id)sender
{
    NSString *strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    NSString *strDelete = NSLocalizedStringFromTableInBundle(@"Confirm to delete booking conference?",@"RPString", g_bundleResorce,nil);
    NSString *strYes = NSLocalizedStringFromTableInBundle(@"YES",@"RPString", g_bundleResorce,nil);
    
    [self endEditing:YES];
    RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDelete cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [SVProgressHUD showWithStatus:@""];
            
            [[RPYuanTelApi defaultInstance] DeleteBookingConference:_confbook.strConfRoomId Success:^(id idResult) {
                [_delegate OnStartBookEnd];
                [SVProgressHUD dismiss];
            } failed:^(NSInteger nErrorCode, NSString *strDesc) {
                [SVProgressHUD showErrorWithStatus:strDesc];
            }];
        }
    } otherButtonTitles:strYes, nil];
    [alertView show];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPBookConfStartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPConfBookCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPConfBookCell" owner:self options:nil];
        cell = [array objectAtIndex:1];
    }
    cell.member = [_confbook.arrayMember objectAtIndex:indexPath.row];
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _confbook.arrayMember.count;
}
@end
