//
//  RPHoldConfView.m
//  RetailPlus
//
//  Created by lin dong on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPHoldConfView.h"
#import "SVProgressHUD.h"
#import "RPConfDBMng.h"
#import "RPYuanTelApi.h"
#import "RPConfGuestCell.h"
#import "RPBlockUIAlertView.h"

extern NSBundle * g_bundleResorce;

@implementation RPHoldConfView

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
    _vcAddReceiver = [[RPAddReceiverViewController alloc] initWithNibName:NSStringFromClass([RPAddReceiverViewController class]) bundle:g_bundleResorce];
    _vcAddReceiver.delegate = self;
    _viewEditUser.delegate = self;
    _viewFrame.layer.cornerRadius = 8;
    _step = RPHOLDCONFSTEP_BEGIN;
}

-(void)setConf:(RPConf *)conf
{
    _conf = conf;
    _tfCallTheme.text = conf.strCallTheme;
    _lbHostPhone.text = conf.strHostPhone;
    _lbHostEmail.text = conf.strHostEmail;
    _lbHostName.text = conf.strHostName;
    _lbGuestCount.text = [NSString stringWithFormat:@"%d",conf.arrayGuest.count];
    [_tbGuest reloadData];
    [self UpdateChnTip];
}

-(IBAction)OnManualInput:(id)sender
{
    _guestTemp = [[RPConfGuest alloc] init];
    _viewEditUser.mode = ConfUserEditMode_AddNew;
    _viewEditUser.guest = _guestTemp;
    _viewEditUser.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewEditUser];
    
    [UIView beginAnimations:nil context:nil];
    _viewEditUser.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _step = RPHOLDCONFSTEP_ADDGUESTMANUAL;
}

-(IBAction)OnInputFromContacts:(id)sender
{
    _bModifyHost = NO;
    _vcAddReceiver.bSingleSelect = NO;
    _vcAddReceiver.view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self addSubview:_vcAddReceiver.view];
    
    _vcAddReceiver.arraySelected = [[NSMutableArray alloc] init];
    
    [UIView beginAnimations:nil context:nil];
    _vcAddReceiver.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    [_vcAddReceiver UpdateUI];
    
    _step = RPHOLDCONFSTEP_ADDGUESTCHOOSE;
}


-(IBAction)OnHoldConf:(id)sender
{
    NSString *strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    NSString *strStart = NSLocalizedStringFromTableInBundle(@"Start conference immediately?",@"RPString", g_bundleResorce,nil);
    NSString *strYes = NSLocalizedStringFromTableInBundle(@"YES",@"RPString", g_bundleResorce,nil);
    
    [self endEditing:YES];
    
    RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strStart cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {            
            [SVProgressHUD showWithStatus:@""];
            
            [[RPYuanTelApi defaultInstance] StartConference:_tfCallTheme.text HostPhone:_lbHostPhone.text Guests:_conf.arrayGuest success:^(id idResult) {
                [[RPConfDBMng defaultInstance] SaveConfHistory:_tfCallTheme.text HostPhone:_conf.strHostPhone Guests:_conf.arrayGuest Date:[NSDate date] LoginUser:[RPSDK defaultInstance].userLoginDetail.strUserId];
                
                [self.delegate OnHoldConfEnd];
                [SVProgressHUD dismiss];
            } failed:^(NSInteger nErrorCode, NSString *strDesc) {
                [SVProgressHUD showErrorWithStatus:strDesc];
            }];
        }
    } otherButtonTitles:strYes, nil];
    [alertView show];
}

-(IBAction)OnBookConf:(id)sender
{
    _viewBookConf.delegate = self;
    _viewBookConf.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewBookConf];
    
    RPConfBook * book = [[RPConfBook alloc] init];
    book.strCallTheme = _tfCallTheme.text;
    book.strHostName = _lbHostName.text;
    book.strHostPhone = _lbHostPhone.text;
    book.strHostEmail = _lbHostEmail.text;
    book.arrayMember = [[NSMutableArray alloc] init];
    for (RPConfGuest * guest in _conf.arrayGuest) {
        RPConfBookMember * member = [[RPConfBookMember alloc] init];
        member.strMemberDesc = guest.strGuestName;
        member.strMemberEmail = guest.strEmail;
        member.strMemberPhone = guest.strPhone;
        [book.arrayMember addObject:member];
    }
    _viewBookConf.confbook = book;
    
    [UIView beginAnimations:nil context:nil];
    _viewBookConf.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _step = RPHOLDCONFSTEP_BOOKING;
}

-(IBAction)OnEditHost:(id)sender
{
    NSString *strTitle = NSLocalizedStringFromTableInBundle(@"You want to...",@"RPString", g_bundleResorce,nil);
    NSString *strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    NSString *strEditHost = NSLocalizedStringFromTableInBundle(@"EDIT HOST INFORMATION",@"RPString", g_bundleResorce,nil);
    
    NSString *strChoose = NSLocalizedStringFromTableInBundle(@"CHOOSE FROM R+ CONTACT",@"RPString", g_bundleResorce,nil);
    
    [self endEditing:YES];
    
    RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strTitle cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
        if (indexButton == 1)
        {
            _guestTemp = [[RPConfGuest alloc] init];
            _viewEditUser.mode = ConfUserEditMode_ModifyHost;
            _guestTemp.strPhone = _lbHostPhone.text;
            _guestTemp.strGuestName = _lbHostName.text;
            _guestTemp.strEmail = _lbHostEmail.text;
            
            _viewEditUser.guest = _guestTemp;
            _viewEditUser.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            [self addSubview:_viewEditUser];
            
            [UIView beginAnimations:nil context:nil];
            _viewEditUser.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            
            _step = RPHOLDCONFSTEP_EDITHOST;
        }
        else if(indexButton == 2)
        {
            _bModifyHost = YES;
            _vcAddReceiver.bSingleSelect = YES;
            
            _vcAddReceiver.view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [self addSubview:_vcAddReceiver.view];
            
            _vcAddReceiver.arraySelected = [[NSMutableArray alloc] init];
            
            [UIView beginAnimations:nil context:nil];
            _vcAddReceiver.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            
            [_vcAddReceiver UpdateUI];
            
            _step = RPHOLDCONFSTEP_CHOOSEHOST;
        }
    }otherButtonTitles:strEditHost,strChoose, nil];
    [alertView show];
}

-(void)OnEditUserEnd
{
    switch (_viewEditUser.mode) {
        case ConfUserEditMode_AddNew:
        {
            [_conf.arrayGuest insertObject:_guestTemp atIndex:0];
            [_tbGuest reloadData];
        }
            break;
        case ConfUserEditMode_ModifyHost:
            _lbHostPhone.text = _guestTemp.strPhone;
            _lbHostName.text = _guestTemp.strGuestName;
            _lbHostEmail.text = _guestTemp.strEmail;
            break;
        case ConfUserEditMode_ModifyGuest:
            
            [_tbGuest reloadData];
            break;
        default:
            break;
    }
    [UIView beginAnimations:nil context:nil];
    _viewEditUser.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _lbGuestCount.text = [NSString stringWithFormat:@"%d",_conf.arrayGuest.count];
    
    _step = RPHOLDCONFSTEP_BEGIN;
}

-(void)AddColleague:(NSMutableArray *)arrayColleague;
{
    [UIView beginAnimations:nil context:nil];
    _vcAddReceiver.view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _step = RPHOLDCONFSTEP_BEGIN;
    
    if (_bModifyHost) {
        if (arrayColleague.count == 1) {
            UserDetailInfo * info = [arrayColleague objectAtIndex:0];
            _lbHostName.text = [NSString stringWithFormat:@"%@",info.strFirstName];
            _lbHostPhone.text = info.strUserAcount;
            _lbHostEmail.text = info.strUserEmail;
        }
    }
    else
    {
        for (UserDetailInfo * info in arrayColleague) {
            RPConfGuest * guest = [[RPConfGuest alloc] init];
            guest.strGuestName = [NSString stringWithFormat:@"%@",info.strFirstName];
            guest.strPhone = info.strUserAcount;
            guest.strEmail = info.strUserEmail;
            [_conf.arrayGuest addObject:guest];
        }
        _lbGuestCount.text = [NSString stringWithFormat:@"%d",_conf.arrayGuest.count];
        [_tbGuest reloadData];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPConfGuestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPConfGuestCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPConfGuestCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.guest = [_conf.arrayGuest objectAtIndex:indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _conf.arrayGuest.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _viewEditUser.mode = ConfUserEditMode_ModifyGuest;
    _viewEditUser.guest = [_conf.arrayGuest objectAtIndex:indexPath.row];
    _viewEditUser.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewEditUser];
    
    [UIView beginAnimations:nil context:nil];
    _viewEditUser.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _step = RPHOLDCONFSTEP_EDITGUEST;
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
        [_conf.arrayGuest removeObjectAtIndex:indexPath.row];
        [_tbGuest reloadData];
        _lbGuestCount.text = [NSString stringWithFormat:@"%d",_conf.arrayGuest.count];
    }
}

-(IBAction)OnEditChn:(id)sender
{
    _viewMngChn.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewMngChn];
    
    [UIView beginAnimations:nil context:nil];
    _viewMngChn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    [_viewMngChn LoadSavedAccount];
    _step = RPHOLDCONFSTEP_EDITCHN;
}

-(void)UpdateChnTip
{
    [_btnSelChn setImage:[UIImage imageNamed:@"button_no_channel1_no.png"] forState:UIControlStateNormal];
    _lbSelChn.hidden = YES;
    
    NSArray * arrayChn = [[RPConfDBMng defaultInstance] LoadConfAccounts:MAX_CONFACCOUNTCOUNT LoginUser:[RPSDK defaultInstance].userLoginDetail.strUserId];
    for (RPConfAccount * account in arrayChn) {
        if (account.bInited && account.bChecked) {
            _lbSelChn.hidden = NO;
            _lbSelChn.text = [NSString stringWithFormat:@"#%@",account.strID];
            
            [SVProgressHUD showWithStatus:@""];
            [_btnSelChn setImage:[UIImage imageNamed:@"button_no_channel1.png"] forState:UIControlStateNormal];
            
            [[RPYuanTelApi defaultInstance] LoginConf:account.strUserName PassWord:account.strPassWord success:^(id idResult) {
                account.bLogined = YES;
                [_btnSelChn setImage:[UIImage imageNamed:@"button_channel1.png"] forState:UIControlStateNormal];
                [SVProgressHUD dismiss];
            } failed:^(NSInteger nErrorCode, NSString *strDesc) {
                account.bLogined = NO;
                [SVProgressHUD showErrorWithStatus:strDesc];
            }];
        }
    }
}

-(BOOL)OnBack
{
    switch (_step) {
        case RPHOLDCONFSTEP_BEGIN:
            return YES;
            break;
        case RPHOLDCONFSTEP_EDITCHN:
            if ([_viewMngChn OnBack])
            {
                [UIView beginAnimations:nil context:nil];
                _viewMngChn.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
                [UIView commitAnimations];
                _step = RPHOLDCONFSTEP_BEGIN;
                [self UpdateChnTip];
            }
            return NO;
            break;
        case RPHOLDCONFSTEP_EDITHOST:
            [UIView beginAnimations:nil context:nil];
            _viewEditUser.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _step = RPHOLDCONFSTEP_BEGIN;
            return NO;
            break;
        case RPHOLDCONFSTEP_CHOOSEHOST:
            [UIView beginAnimations:nil context:nil];
            _vcAddReceiver.view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _step = RPHOLDCONFSTEP_BEGIN;
            return NO;
            break;
        case RPHOLDCONFSTEP_ADDGUESTMANUAL:
            [UIView beginAnimations:nil context:nil];
            _viewEditUser.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _step = RPHOLDCONFSTEP_BEGIN;
            return NO;
            break;
        case RPHOLDCONFSTEP_ADDGUESTCHOOSE:
            [UIView beginAnimations:nil context:nil];
            _vcAddReceiver.view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _step = RPHOLDCONFSTEP_BEGIN;
            return NO;
            break;
        case RPHOLDCONFSTEP_EDITGUEST:
            [UIView beginAnimations:nil context:nil];
            _viewEditUser.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _step = RPHOLDCONFSTEP_BEGIN;
            return NO;
            break;
        case RPHOLDCONFSTEP_BOOKING:
            if ([_viewBookConf OnBack]) {
                [UIView beginAnimations:nil context:nil];
                _viewBookConf.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
                [UIView commitAnimations];
                _step = RPHOLDCONFSTEP_BEGIN;
                [self UpdateChnTip];
            }
            return NO;
            break;
    }
    return YES;
}

-(void)OnAddBookSuccess
{
    [UIView beginAnimations:nil context:nil];
    _viewBookConf.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _step = RPHOLDCONFSTEP_BEGIN;
    [self.delegate OnHoldConfEnd];
}

-(void)OnCancelAddBook
{
    [UIView beginAnimations:nil context:nil];
    _viewBookConf.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _step = RPHOLDCONFSTEP_BEGIN;
    [self.delegate OnHoldConfEnd];
}

-(IBAction)OnQuit:(id)sender
{
    [self.delegate OnHoldConfEnd];
}
@end
