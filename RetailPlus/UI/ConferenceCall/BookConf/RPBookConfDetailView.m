//
//  RPBookConfDetailView.m
//  RetailPlus
//
//  Created by lin dong on 14-6-19.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBookConfDetailView.h"
#import "SVProgressHUD.h"
#import "RPYuanTelApi.h"
#import "RPBlockUIAlertView.h"
#import "RPBookMemberCell.h"
#import "RPConfDBMng.h"

extern NSBundle * g_bundleResorce;

@implementation RPBookConfDetailView

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
    
    _vcAddReceiver = [[RPAddReceiverViewController alloc] initWithNibName:NSStringFromClass([RPAddReceiverViewController class]) bundle:g_bundleResorce];
    _vcAddReceiver.delegate = self;
    _viewEditUser.delegate = self;
}

-(void)setConfbook:(RPConfBook *)confbook
{
    _confbook = confbook;
    _tfCallTheme.text = confbook.strCallTheme;
    _lbHostName.text = confbook.strHostName;
    _lbHostPhone.text = confbook.strHostPhone;
    _lbHostEmail.text = confbook.strHostEmail;
    _lbGuestCount.text = [NSString stringWithFormat:@"%d",_confbook.arrayMember.count];
    
    [_tbGuest reloadData];
    [self UpdateChnTip];
}

-(IBAction)OnManualInput:(id)sender
{
    _memberTemp = [[RPConfBookMember alloc] init];
    _viewEditUser.mode = BookConfEditUserMode_AddNew;
    _viewEditUser.member = _memberTemp;
    _viewEditUser.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewEditUser];
    
    [UIView beginAnimations:nil context:nil];
    _viewEditUser.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _step = RPBOOKCONFDETAILSTEP_ADDGUESTMANUAL;
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
    
    _step = RPBOOKCONFDETAILSTEP_ADDGUESTCHOOSE;
}

-(IBAction)OnConfirm:(id)sender
{
    NSString *strTitle = NSLocalizedStringFromTableInBundle(@"Book time can not be empty",@"RPString", g_bundleResorce,nil);

    
    if (_dateCallTime == nil) {
        [SVProgressHUD showErrorWithStatus:strTitle];
        return;
    }
    
    strTitle = NSLocalizedStringFromTableInBundle(@"Invite one user at least",@"RPString", g_bundleResorce,nil);
    
    if (_confbook.arrayMember.count == 0) {
        [SVProgressHUD showErrorWithStatus:strTitle];
        return;
    }
    
    
    [SVProgressHUD showWithStatus:@""];
    
    _confbook.strHostPhone = _lbHostPhone.text;
    _confbook.strHostEmail = _lbHostEmail.text;
    _confbook.strHostName = _lbHostName.text;
    _confbook.strCallTheme = _tfCallTheme.text;
    _confbook.dateBooking = _dateCallTime;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if (!_confbook.strCallTheme)
        _confbook.strCallTheme = @"";
    
    [[RPYuanTelApi defaultInstance]BookingConference:_confbook.strCallTheme BookTime:[formatter stringFromDate:_confbook.dateBooking] HostPhone:_confbook.strHostPhone Members:_confbook.arrayMember success:^(NSString * strRoomId) {
        [SVProgressHUD dismiss];
        _confbook.strConfRoomId = strRoomId;
        _viewNotify.delegate = self;
        _viewNotify.frame = CGRectMake(0, self.frame.size.width, self.frame.size.width, self.frame.size.height);
        [self addSubview:_viewNotify];
        [UIView beginAnimations:nil context:nil];
        _viewNotify.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        
        _viewNotify.confBook = _confbook;
        _step = RPBOOKCONFDETAILSTEP_SENDNOTIFY;
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:strDesc];
    }];
}

-(IBAction)OnQuit:(id)sender
{
    [self.delegate OnCancelAddBook];
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
            _memberTemp = [[RPConfBookMember alloc] init];
            _viewEditUser.mode = BookConfEditUserMode_ModifyHost;
            _memberTemp.strMemberPhone = _lbHostPhone.text;
            _memberTemp.strMemberDesc = _lbHostName.text;
            _memberTemp.strMemberEmail = _lbHostEmail.text;
            
            _viewEditUser.member = _memberTemp;
            _viewEditUser.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            [self addSubview:_viewEditUser];
            
            [UIView beginAnimations:nil context:nil];
            _viewEditUser.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            
            _step = RPBOOKCONFDETAILSTEP_EDITHOST;
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
            
            _step = RPBOOKCONFDETAILSTEP_CHOOSEHOST;
        }
    }otherButtonTitles:strEditHost,strChoose, nil];
    [alertView show];
}

-(void)OnEditUserEnd
{
    switch (_viewEditUser.mode) {
        case BookConfEditUserMode_AddNew:
        {
            [_confbook.arrayMember insertObject:_memberTemp atIndex:0];
            [_tbGuest reloadData];
        }
            break;
        case BookConfEditUserMode_ModifyHost:
            _lbHostPhone.text = _memberTemp.strMemberPhone;
            _lbHostName.text = _memberTemp.strMemberDesc;
            _lbHostEmail.text = _memberTemp.strMemberEmail;
            break;
        case BookConfEditUserMode_ModifyGuest:
            
            [_tbGuest reloadData];
            break;
        default:
            break;
    }
    [UIView beginAnimations:nil context:nil];
    _viewEditUser.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _lbGuestCount.text = [NSString stringWithFormat:@"%d",_confbook.arrayMember.count];
}

-(void)AddColleague:(NSMutableArray *)arrayColleague;
{
    [UIView beginAnimations:nil context:nil];
    _vcAddReceiver.view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
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
            RPConfBookMember * member = [[RPConfBookMember alloc] init];
            member.strMemberDesc = [NSString stringWithFormat:@"%@",info.strFirstName];
            member.strMemberPhone = info.strUserAcount;
            member.strMemberEmail = info.strUserEmail;
            [_confbook.arrayMember addObject:member];
        }
        _lbGuestCount.text = [NSString stringWithFormat:@"%d",_confbook.arrayMember.count];
        [_tbGuest reloadData];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPBookMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPBookMemberCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPConfBookCell" owner:self options:nil];
        cell = [array objectAtIndex:2];
    }
    cell.member = [_confbook.arrayMember objectAtIndex:indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _confbook.arrayMember.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _viewEditUser.mode = BookConfEditUserMode_ModifyGuest;
    _viewEditUser.member = [_confbook.arrayMember objectAtIndex:indexPath.row];
    _viewEditUser.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewEditUser];
    
    [UIView beginAnimations:nil context:nil];
    _viewEditUser.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _step = RPBOOKCONFDETAILSTEP_EDITGUEST;
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
        [_confbook.arrayMember removeObjectAtIndex:indexPath.row];
        [_tbGuest reloadData];
        _lbGuestCount.text = [NSString stringWithFormat:@"%d",_confbook.arrayMember.count];
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
    _step = RPBOOKCONFDETAILSTEP_EDITCHN;
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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _tfCallTime) {
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd ccc. HH:mm"];
        if (_dateCallTime == nil) {
            _dateCallTime = [NSDate date];
        }
        _pickDate = [[RPDatePicker alloc] init:_tfCallTime Format:formatter curDate:_dateCallTime canDelete:NO Mode:UIDatePickerModeDateAndTime canFuture:YES canPreviously:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==_tfCallTime)
    {
        _dateCallTime = [_pickDate GetDate];
    }
}

-(void)OnBookingSendMsgEnd
{
    [UIView beginAnimations:nil context:nil];
    _viewNotify.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [self.delegate OnAddBookSuccess];
}

-(BOOL)OnBack
{
    switch (_step) {
        case RPBOOKCONFDETAILSTEP_BEGIN:
            return YES;
            break;
        case RPBOOKCONFDETAILSTEP_EDITCHN:
            if ([_viewMngChn OnBack])
            {
                [UIView beginAnimations:nil context:nil];
                _viewMngChn.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
                [UIView commitAnimations];
                _step = RPBOOKCONFDETAILSTEP_BEGIN;
                [self UpdateChnTip];
            }
            return NO;
            break;
        case RPBOOKCONFDETAILSTEP_EDITHOST:
            [UIView beginAnimations:nil context:nil];
            _viewEditUser.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _step = RPBOOKCONFDETAILSTEP_BEGIN;
            return NO;
            break;
        case RPBOOKCONFDETAILSTEP_CHOOSEHOST:
            [UIView beginAnimations:nil context:nil];
            _vcAddReceiver.view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _step = RPBOOKCONFDETAILSTEP_BEGIN;
            return NO;
            break;
        case RPBOOKCONFDETAILSTEP_ADDGUESTMANUAL:
            [UIView beginAnimations:nil context:nil];
            _viewEditUser.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _step = RPBOOKCONFDETAILSTEP_BEGIN;
            return NO;
            break;
        case RPBOOKCONFDETAILSTEP_ADDGUESTCHOOSE:
            [UIView beginAnimations:nil context:nil];
            _vcAddReceiver.view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _step = RPBOOKCONFDETAILSTEP_BEGIN;
            return NO;
            break;
        case RPBOOKCONFDETAILSTEP_EDITGUEST:
            [UIView beginAnimations:nil context:nil];
            _viewEditUser.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _step = RPBOOKCONFDETAILSTEP_BEGIN;
            return NO;
            break;
        case RPBOOKCONFDETAILSTEP_SENDNOTIFY:
            [UIView beginAnimations:nil context:nil];
            _viewNotify.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _step = RPBOOKCONFDETAILSTEP_BEGIN;
            return YES;
            break;
    }
    return YES;
}
@end
