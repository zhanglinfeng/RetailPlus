//
//  RPBookConfView.m
//  RetailPlus
//
//  Created by lin dong on 14-6-19.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBookConfView.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
#import "RPConfDBMng.h"
#import "RPYuanTelApi.h"
#import "RPConfBookCell.h"

extern NSBundle * g_bundleResorce;

@implementation RPBookConfView

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
    _btnEditChn.layer.borderWidth = 1;
    _btnEditChn.layer.cornerRadius = 6;
    _btnEditChn.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
}

-(void)ReloadData
{
    [SVProgressHUD showWithStatus:@""];
    _tfSearch.text = @"";
    [_arrayBook removeAllObjects];
    [_arrayBookShow removeAllObjects];
    [_tbBookList reloadData];
    
    [[RPYuanTelApi defaultInstance] GetBookingConferenceSuccess:^(NSMutableArray * array) {
        _arrayBook = array;
        [self UpdateUI];
        [SVProgressHUD dismiss];
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
    }];
}

-(void)UpdateUI
{
    if (_tfSearch.text.length > 0) {
        _arrayBookShow = [[NSMutableArray alloc] init];
        for (RPConfBook * book in _arrayBook) {
            NSRange range = [book.strCallTheme rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                [_arrayBookShow addObject:book];
                continue;
            }
            if (book.strHostPhone) {
                NSRange range = [book.strHostPhone rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
                if (range.location != NSNotFound) {
                    [_arrayBookShow addObject:book];
                    continue;
                }
            }
        }
    }
    else
        _arrayBookShow = _arrayBook;
    
    [_tbBookList reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPConfBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPConfBookCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPConfBookCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.book = [_arrayBookShow objectAtIndex:indexPath.row];
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayBookShow.count;
}

-(void)ShowStartBook:(RPConfBook *)book
{
    _viewConfStart.confbook = book;
    _viewConfStart.delegate = self;
    _viewConfStart.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewConfStart];
    
    [UIView beginAnimations:nil context:nil];
    _viewConfStart.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _step = RPBOOKCONFSTEP_STARTBOOK;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RPConfBook * book = [_arrayBookShow objectAtIndex:indexPath.row];
    if (![book.strHostPhone isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserAcount]) {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"This meeting may not be booked by yourself, please be careful.\nConfirm to continue?",@"RPString", g_bundleResorce,nil);
        NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
        NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        
        [self endEditing:YES];
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1) {
                [self ShowStartBook:book];
            }
        } otherButtonTitles:strOK,nil];
        [alertView show];
    }
    else
       [self ShowStartBook:book];
}

-(IBAction)OnAddBook:(id)sender
{
    _viewConfBookDetail.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    _viewConfBookDetail.delegate = self;
    [self addSubview:_viewConfBookDetail];
    RPConfBook * book = [[RPConfBook alloc] init];
    book.strHostName = [NSString stringWithFormat:@"%@",[RPSDK defaultInstance].userLoginDetail.strFirstName];
    book.strHostPhone = [RPSDK defaultInstance].userLoginDetail.strUserAcount;
    book.strHostEmail = [RPSDK defaultInstance].userLoginDetail.strUserEmail;
    book.arrayMember = [[NSMutableArray alloc] init];
    
    _viewConfBookDetail.confbook = book;
    
    [UIView beginAnimations:nil context:nil];
    _viewConfBookDetail.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _step = RPBOOKCONFSTEP_ADDBOOK;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self UpdateUI];
    return YES;
}

-(IBAction)OnClearSearch:(id)sender
{
    _tfSearch.text = @"";
    [self UpdateUI];
}

-(IBAction)OnEditChn:(id)sender
{
    _viewMngChn.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewMngChn];
    
    [UIView beginAnimations:nil context:nil];
    _viewMngChn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    [_viewMngChn LoadSavedAccount];
    _step = RPBOOKCONFSTEP_EDITCHN;
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

-(IBAction)OnQuit:(id)sender
{
    [self.delegate OnBookConfEnd];
}

-(BOOL)OnBack
{
    switch (_step) {
        case RPBOOKCONFSTEP_BEGIN:
            
            break;
        case RPBOOKCONFSTEP_EDITCHN:
            if ([_viewMngChn OnBack])
            {
                [UIView beginAnimations:nil context:nil];
                _viewMngChn.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
                [UIView commitAnimations];
                _step = RPBOOKCONFSTEP_BEGIN;
                [self UpdateChnTip];
            }
            return NO;
            break;
        case RPBOOKCONFSTEP_ADDBOOK:
            if ([_viewConfBookDetail OnBack]) {
                [UIView beginAnimations:nil context:nil];
                _viewConfBookDetail.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
                [UIView commitAnimations];
                _step = RPBOOKCONFSTEP_BEGIN;
                [self ReloadData];
            }
            return NO;
            break;
        case RPBOOKCONFSTEP_STARTBOOK:
            [UIView beginAnimations:nil context:nil];
            _viewConfStart.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _step = RPBOOKCONFSTEP_BEGIN;
            [self ReloadData];
            return NO;
            break;
        default:
            break;
    }
    return YES;
}

-(void)OnStartBookEnd
{
    [UIView beginAnimations:nil context:nil];
    _viewConfStart.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _step = RPBOOKCONFSTEP_BEGIN;
    [self ReloadData];
}

-(void)OnAddBookSuccess
{
    [UIView beginAnimations:nil context:nil];
    _viewConfBookDetail.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _step = RPBOOKCONFSTEP_BEGIN;
    [self ReloadData];
}

-(void)OnCancelAddBook
{
    [UIView beginAnimations:nil context:nil];
    _viewConfBookDetail.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _step = RPBOOKCONFSTEP_BEGIN;
}
@end
