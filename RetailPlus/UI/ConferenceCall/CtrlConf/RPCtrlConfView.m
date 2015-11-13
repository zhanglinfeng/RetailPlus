//
//  RPCtrlConfView.m
//  RetailPlus
//
//  Created by lin dong on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCtrlConfView.h"
#import "RPBlockUIAlertView.h"
#import "RPYuanTelApi.h"
#import "SVProgressHUD.h"
#import "RPConfDBMng.h"
#import "RPCtrlConfCell.h"

extern NSBundle * g_bundleResorce;

@implementation RPCtrlConfView

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
    _btnEditChn.layer.borderWidth = 1;
    _btnEditChn.layer.cornerRadius = 6;
    _btnEditChn.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
    _bCloseConfNext = NO;
}

-(void)UpdateChnTip
{
    [_ivSelChn setImage:[UIImage imageNamed:@"button_no_channel1_no.png"]];
    _lbSelChn.hidden = YES;
    
    NSArray * arrayChn = [[RPConfDBMng defaultInstance] LoadConfAccounts:MAX_CONFACCOUNTCOUNT LoginUser:[RPSDK defaultInstance].userLoginDetail.strUserId];
    for (RPConfAccount * account in arrayChn) {
        if (account.bInited && account.bChecked) {
            _lbSelChn.hidden = NO;
            _lbSelChn.text = [NSString stringWithFormat:@"#%@",account.strID];
            
            [SVProgressHUD showWithStatus:@""];
            [_ivSelChn setImage:[UIImage imageNamed:@"button_no_channel1.png"]];
            
            [[RPYuanTelApi defaultInstance] LoginConf:account.strUserName PassWord:account.strPassWord success:^(id idResult) {
                account.bLogined = YES;
                [_ivSelChn setImage:[UIImage imageNamed:@"button_channel1.png"]];
                [SVProgressHUD dismiss];
                [self ReloadData];
            } failed:^(NSInteger nErrorCode, NSString *strDesc) {
                account.bLogined = NO;
                [SVProgressHUD showErrorWithStatus:strDesc];
                [self ReloadData];
            }];
        }
    }
}

-(void)ReloadData
{
    _lbTheme.text = @"";
    _lbGuestCount.text = @"0";
    _lbDate.text = @"";
    _lbConfDuration.text = @"";
    _conf = nil;
    [_tbGuest reloadData];
    
    [[RPYuanTelApi defaultInstance] InitConferenceControl:self];
}

-(BOOL)OnBack
{
    if (_step == RPCTRLCONFVIEWSTEP_EDITCHN) {
        if ([_viewMngChn OnBack])
        {
            [UIView beginAnimations:nil context:nil];
            _viewMngChn.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _step = RPCTRLCONFVIEWSTEP_BEGIN;
            [self UpdateChnTip];
        }
        return NO;
    }
    return YES;
}

-(IBAction)OnCloseConf:(id)sender
{
    NSString * strTitle = NSLocalizedStringFromTableInBundle(@"Confirm to close conference?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strTitle cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
        if (indexButton == 1) {
            _bCloseConfNext = YES;
            [[RPYuanTelApi defaultInstance] InitConferenceControl:self];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
   
}

-(IBAction)OnEditChn:(id)sender
{
    _viewMngChn.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewMngChn];
    
    [UIView beginAnimations:nil context:nil];
    _viewMngChn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    [_viewMngChn LoadSavedAccount];
    _step = RPCTRLCONFVIEWSTEP_EDITCHN;
}

-(IBAction)OnQuit:(id)sender
{
    [[RPYuanTelApi defaultInstance] CloseConferenceControl];
    [_delegate OnCtrlConfEnd];
    [_timer invalidate];
}

//ctrl delegate
-(void)OnCtrlConfDisconnected
{
   
}

-(void)OnCtrlConfLoginEnd:(BOOL)bSuccess
{
    if (bSuccess)
    {
        if (_bCloseConfNext)
            [[RPYuanTelApi defaultInstance] CloseMyConference];
        else
            [[RPYuanTelApi defaultInstance] GetMyConferenceRoom];
    }
    _bCloseConfNext = NO;
}

-(void)OnGetConfEnd:(RPConf *)conf
{
    _conf = conf;
    
    if (conf) {
        _lbTheme.text = conf.strCallTheme;
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd ccc. HH:mm"];
        _lbDate.text = [formatter stringFromDate:conf.dateCallHistory];
        _lbGuestCount.text = @"0";
        
        [[RPYuanTelApi defaultInstance] GetMyConferenceMember];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(OnTimeChange) userInfo:nil repeats:YES];
    }
    else
    {
        NSString *strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
        NSString *strTitle = NSLocalizedStringFromTableInBundle(@"There is no holding conference exist",@"RPString", g_bundleResorce,nil);
        
        [self endEditing:YES];
        
        RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strTitle cancelButtonTitle:strOK clickButton:^(NSInteger indexButton) {
            [[RPYuanTelApi defaultInstance] CloseConferenceControl];
            [_delegate OnCtrlConfEnd];
            [_timer invalidate];
        } otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)OnTimeChange
{
    if (_conf) {
        NSTimeInterval intval = [[NSDate date] timeIntervalSinceDate:_conf.dateCallHistory];
        NSInteger nHour = (NSInteger)intval / 3600;
        NSInteger nMin = ((NSInteger)intval % 3600) / 60;
        NSInteger nSec = ((NSInteger)intval % 3600) % 60;
        
        _lbConfDuration.text = [NSString stringWithFormat:@"%d:%02d'%02d\"",nHour,nMin,nSec];
    }
}

-(void)OnGetConfMemberEnd:(NSMutableArray *)arrayMember
{
    _conf.arrayGuest = arrayMember;
    
    _lbGuestCount.text = [NSString stringWithFormat:@"%d",arrayMember.count];
    
    [_tbGuest reloadData];
}

-(void)OnCloseConfEnd
{
    NSString *strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString *strTitle = NSLocalizedStringFromTableInBundle(@"Conference is closed",@"RPString", g_bundleResorce,nil);
    
    [self endEditing:YES];
    
    RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strTitle cancelButtonTitle:strOK clickButton:^(NSInteger indexButton) {
        [[RPYuanTelApi defaultInstance] CloseConferenceControl];
        [_delegate OnCtrlConfEnd];
        [_timer invalidate];
    } otherButtonTitles:nil];
    [alertView show];
}

-(void)OnConfMemberStateChange:(NSString *)strMemberID state:(NSInteger)nState
{
    for (RPConfGuest * guest in _conf.arrayGuest) {
        if ([guest.strGuestId isEqualToString:strMemberID]) {
            guest.nCallState = nState;
            [_tbGuest reloadData];
            break;
        }
    }
}

-(void)OnAddMember:(RPConfGuest *)guest
{
    for (RPConfGuest * guestGet in _conf.arrayGuest) {
        if ([guestGet.strGuestId isEqualToString:guest.strGuestId])
        {
            guestGet.nCallState = guest.nCallState;
            [_tbGuest reloadData];
            return;
        }
    }
    
    [_conf.arrayGuest addObject:guest];
    [_tbGuest reloadData];
}

-(void)OnCloseConference:(NSString *)strConfID
{
    if ([_conf.strID isEqualToString:strConfID]) {
        NSString *strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
        NSString *strTitle = NSLocalizedStringFromTableInBundle(@"Conference is closed",@"RPString", g_bundleResorce,nil);
        
        [self endEditing:YES];
        
        RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strTitle cancelButtonTitle:strOK clickButton:^(NSInteger indexButton) {
            [[RPYuanTelApi defaultInstance] CloseConferenceControl];
            [_delegate OnCtrlConfEnd];
            [_timer invalidate];
        } otherButtonTitles:nil];
        [alertView show];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_conf)
        return _conf.arrayGuest.count;
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPCtrlConfCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPCtrlConfCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPCtrlConfCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    cell.guest = [_conf.arrayGuest objectAtIndex:indexPath.row];
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
