//
//  RPAddReceiverViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-9-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPAddReceiverViewController.h"
#import "RPAddReceiverCell.h"
#import "SVProgressHUD.h"
#import "RPBlockUISelectView.h"

extern NSBundle * g_bundleResorce;
@interface RPAddReceiverViewController ()
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@end

@implementation RPAddReceiverViewController

@synthesize viewAddEmail = _viewAddEmail;
@synthesize viewAddEmailFrame = _viewAddEmailFrame;
@synthesize arraySelected = _arraySelected;
@synthesize autoCompleter = _autoCompleter;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(AutocompletionTableView*)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        //计算套在输入框外面的View相对对输入框父视图的位置大小
        CGPoint p=[_viewEmailEditFrame.superview convertPoint:_viewEmailEditFrame.frame.origin toView:_viewAddEmail];
        CGRect rect=CGRectMake(p.x, p.y, _viewEmailEditFrame.frame.size.width, _viewEmailEditFrame.frame.size.height);
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:_tfEmail inViewController:_viewAddEmail withOptions:options frame:rect];
        _autoCompleter.type = AutoRemaindType_SubmitEmail;
    }
    return _autoCompleter;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _bSingleSelect = NO;
    
    _viewFrame.layer.cornerRadius = 10;
    _viewFrame.layer.shadowOffset = CGSizeMake(0, 1);
    _viewFrame.layer.shadowRadius =3.0;
    _viewFrame.layer.shadowColor =[UIColor blackColor].CGColor;
    _viewFrame.layer.shadowOpacity =0.5;
    
    _viewSearchFrame.layer.cornerRadius = 6;
    
    _viewAddEmailFrame.layer.cornerRadius = 8;
    _viewAddEmailFrame.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:1].CGColor;
    _viewAddEmailFrame.layer.borderWidth = 1;
    _viewEmailEditFrame.layer.cornerRadius = 6;
    _btnEmailOk.layer.cornerRadius = 6;
    _btnEmailOk.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:1].CGColor;
    _btnEmailOk.layer.borderWidth = 1;
    _btnEmailMore.layer.cornerRadius = 6;
    _btnEmailMore.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:1].CGColor;
    _btnEmailMore.layer.borderWidth = 1;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(EmailViewLocationTapped:)];
//    [_viewAddEmail addGestureRecognizer:tap];
    
    _arraySec = [NSArray arrayWithObjects:@"#",@"A",@"B",@"C",@"D",@"E",@"F",
                 @"G",@"H",@"I",@"J",@"K",
                 @"L",@"M",@"N",@"O",@"P",
                 @"Q",@"R",@"S",@"T",@"U",
                 @"V",@"W",@"X",@"Y",@"Z",nil];
    
    [[RPSDK defaultInstance] GetUserRankCount:^(UserRankCount * rankCount) {
        _nCount1 = rankCount.nCountManager;
        _nCount2 = rankCount.nCountStoreManager;
        _nCount3 = rankCount.nCountAssistant;
        _nCount4 = rankCount.nCountVendor;
        [self UpdateUI];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
    
    [_tfEmail addTarget:self.autoCompleter action:@selector(textFieldEditDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    
    [_tfEmail addTarget:self.autoCompleter action:@selector(textFieldEditDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    [_tfEmail addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UILongPressGestureRecognizer * longPressFiltUser = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPressFiltUser.minimumPressDuration = 0.8;
    [_btnFiltUser addGestureRecognizer:longPressFiltUser];
}

-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        if (_strCurFiltTag && _strCurFiltTag.length > 0) {
            _strCurFiltTag = nil;
            [self UpdateUI];
        }
    }
}
//- (void)EmailViewLocationTapped:(UITapGestureRecognizer *)tap
//{
////    [self.viewAddEmail endEditing:YES];
////     [self.delegate EndAddEmail];
////    _tfEmail.text = @"";
//}//修改于20140421


-(void)awakeFromNib
{
    self.viewAddEmail.frame = CGRectMake(0, 0, 0, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)UpdateUI
{
    _arrayCurColleague = [[NSMutableArray alloc] init];
    _arrayCurColleagueUnsort = [[NSMutableArray alloc] init];
    
    if (_bLev1 && _arrayLev1) {
        [self addColleague:_arrayLev1];
    }
    if (_bLev2 && _arrayLev2) {
        [self addColleague:_arrayLev2];
    }
    if (_bLev3 && _arrayLev3) {
        [self addColleague:_arrayLev3];
    }
    if (_bLev4 && _arrayLev4) {
        [self addColleague:_arrayLev4];
    }
    
    [_btnCount1 setTitle:[NSString stringWithFormat:@"%d",_nCount1] forState:UIControlStateNormal];
    [_btnCount2 setTitle:[NSString stringWithFormat:@"%d",_nCount2] forState:UIControlStateNormal];
    [_btnCount3 setTitle:[NSString stringWithFormat:@"%d",_nCount3] forState:UIControlStateNormal];
    [_btnCount4 setTitle:[NSString stringWithFormat:@"%d",_nCount4] forState:UIControlStateNormal];
    
    [_tfSearch resignFirstResponder];
    [_tbAddressBook reloadData];
    
    if (_strCurFiltTag && _strCurFiltTag.length > 0) {
        [_btnFiltUser setTitle:_strCurFiltTag forState:UIControlStateNormal];
        [_btnFiltUser setBackgroundImage:[UIImage imageNamed:@"button_choose2.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnFiltUser setBackgroundImage:[UIImage imageNamed:@"button_choose1.png"] forState:UIControlStateNormal];
        [_btnFiltUser setTitle:@"" forState:UIControlStateNormal];
    }
    [self UpdateSelAllUI];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = 0;
    NSString * strSecHead = [_arraySec objectAtIndex:section];
    for (UserDetailInfo * colleague in _arrayCurColleague) {
        if ([colleague.strSectionLetter compare:strSecHead options:NSCaseInsensitiveSearch] == NSOrderedSame)
            nCount ++;
    }
    return nCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPAddReceiverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPAddReceiverCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPAddReceiverCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.delegate = self;
    }
    
    NSInteger nRowIndex = 0;
    NSString * strSecHead = [_arraySec objectAtIndex:indexPath.section];
    for (UserDetailInfo * colleague in _arrayCurColleague) {
        if ([colleague.strSectionLetter compare:strSecHead options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            if (nRowIndex == indexPath.row) {
                cell.colleague = colleague;
                
                cell.bSelect = NO;
                for (UserDetailInfo * colleagueGet in _arraySelected) {
                    if ([colleagueGet.strUserId isEqualToString:colleague.strUserId]) {
                        cell.bSelect = YES;
                        break;
                    }
                }
                
                break;
            }
            nRowIndex ++;
        }
    }
    
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arraySec.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_arrayCurColleague == nil || _arrayCurColleague.count == 0) return nil;
    
    return _arraySec;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [_arraySec indexOfObject:title];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tfSearch resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSInteger nRowIndex = 0;
    NSString * strSecHead = [_arraySec objectAtIndex:indexPath.section];
    for (UserDetailInfo * colleague in _arrayCurColleague) {
        if ([colleague.strSectionLetter compare:strSecHead options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            if (nRowIndex == indexPath.row) {
//                [_delegate OnSelectColleague:colleague];
                break;
            }
            nRowIndex ++;
        }
    }
}

-(void)addColleague:(NSArray *)array
{
    if (_tfSearch.text.length == 0) {
        [_arrayCurColleagueUnsort addObjectsFromArray:array];
    }
    else
    {
        for (UserDetailInfo * colleague in array) {
            NSRange range1 = [colleague.strFirstName rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
//            NSRange range2 = [colleague.strSurName rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
            NSRange range3 = [colleague.strRoleName rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
            
            if (range1.length != 0|| range3.length != 0) {
                [_arrayCurColleagueUnsort addObject:colleague];
            }
        }
    }
    
    _arrayCurColleague = [_arrayCurColleagueUnsort sortedArrayUsingComparator:^(UserDetailInfo * obj1, UserDetailInfo * obj2)
                          {
                              if (obj1.bFirstAlph && !obj2.bFirstAlph) {
                                  return NSOrderedAscending;
                              }
                              else if (!obj1.bFirstAlph && obj2.bFirstAlph)
                              {
                                  return NSOrderedDescending;
                              }
                              else
                                  return [obj1.strCompare compare:obj2.strCompare options:NSCaseInsensitiveSearch];
                          }];
    
    if (_strCurFiltTag && _strCurFiltTag.length > 0) {
        NSMutableArray * arrayTemp = [[NSMutableArray alloc] init];
        for (UserDetailInfo * user in _arrayCurColleague) {
            if ([user.strTag1 isEqualToString:_strCurFiltTag] || [user.strTag2 isEqualToString:_strCurFiltTag] || [user.strTag3 isEqualToString:_strCurFiltTag]) {
                [arrayTemp addObject:user];
            }
        }
        _arrayCurColleague = arrayTemp;
    }
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

-(IBAction)OnSelLev1:(id)sender
{
    _bLev1 = !_bLev1;
    [(UIButton *)sender setSelected:_bLev1];
    
    if (_bLev1) {
        if (_arrayLev1 == nil) {
            [[RPSDK defaultInstance] GetUserInfoList:Rank_Manager Success:^(NSArray * array) {
                _arrayLev1 = array;
                
                
                [self UpdateUI];
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                [self UpdateUI];
            }];
        }
        else
            [self UpdateUI];
    }
    else
        [self UpdateUI];
}

-(IBAction)OnSelLev2:(id)sender
{
    _bLev2 = !_bLev2;
    [(UIButton *)sender setSelected:_bLev2];
    
    if (_bLev2) {
        if (_arrayLev2 == nil) {
            [[RPSDK defaultInstance] GetUserInfoList:Rank_StoreManager Success:^(NSArray * array) {
                _arrayLev2 = array;
                
                [self UpdateUI];
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                [self UpdateUI];
            }];
        }
        else
            [self UpdateUI];
    }
    else
        [self UpdateUI];
}

-(IBAction)OnSelLev3:(id)sender
{
    _bLev3 = !_bLev3;
    [(UIButton *)sender setSelected:_bLev3];
    
    if (_bLev3) {
        if (_arrayLev3 == nil) {
            [[RPSDK defaultInstance] GetUserInfoList:Rank_Assistant Success:^(NSArray * array) {
                _arrayLev3 = array;
                
                [self UpdateUI];
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                [self UpdateUI];
            }];
        }
        else
            [self UpdateUI];
    }
    else
        [self UpdateUI];
}

-(IBAction)OnSelLev4:(id)sender
{
    _bLev4 = !_bLev4;
    [(UIButton *)sender setSelected:_bLev4];
    
    if (_bLev4) {
        if (_arrayLev4 == nil) {
            [[RPSDK defaultInstance] GetUserInfoList:Rank_Vendor Success:^(NSArray * array) {
                _arrayLev4 = array;
                [self UpdateUI];
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                [self UpdateUI];
            }];
        }
        else
            [self UpdateUI];
    }
    else
        [self UpdateUI];
}

-(IBAction)OnDeleteSearch:(id)sender
{
    [_tfSearch resignFirstResponder];
    _tfSearch.text = @"";
    [self UpdateUI];
}
- (BOOL)isValidateEmail:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}
-(IBAction)OnEmailOK:(id)sender
{
    if (![self isValidateEmail:_tfEmail.text]) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Email address format is not correct",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
        return;
    }
    if (_tfEmail.text.length > 0)
    {
        [self.viewAddEmail endEditing:YES];
        [self.delegate AddEmail:_tfEmail.text isEnd:YES];
        _tfEmail.text = @"";
        [self.autoCompleter hideOptionsView];
    }
}

-(IBAction)OnEmailEnd:(id)sender
{
    [self.viewAddEmail endEditing:YES];
    [self.delegate EndAddEmail];
    _tfEmail.text = @"";
    [self.autoCompleter hideOptionsView];
}

-(IBAction)OnEmailMore:(id)sender
{
    if (![self isValidateEmail:_tfEmail.text]) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Email address format is not correct",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
        return;
    }
    
    if (_tfEmail.text.length > 0)
    {
        [self.viewAddEmail endEditing:YES];
        [self.delegate AddEmail:_tfEmail.text isEnd:NO];
        _tfEmail.text = @"";
        [self.autoCompleter hideOptionsView];
    }
}

-(void)OnSelectUser:(UserDetailInfo *)colleagueSet bSelected:(BOOL)bSelect
{
    if (bSelect) {
        BOOL bFound = NO;
        for (UserDetailInfo * colleague in _arraySelected) {
            if ([colleague.strUserId isEqualToString:colleagueSet.strUserId]) {
                bFound = YES;
                break;
            }
        }
        if (_bSingleSelect)
            [_arraySelected removeAllObjects];
        if (_arraySelected==nil)
        {
            _arraySelected=[[NSMutableArray alloc]init];
        }
        if (!bFound) {
            [_arraySelected addObject:colleagueSet];
        }
    }
    else
    {
        for (UserDetailInfo * colleague in _arraySelected) {
            if ([colleague.strUserId isEqualToString:colleagueSet.strUserId]) {
                [_arraySelected removeObject:colleague];
                break;
            }
        }
    }
    
    [_tbAddressBook reloadData];
    [self UpdateSelAllUI];
}

-(void)OnSelectEmail:(NSString *)strEmail bSelected:(BOOL)bSelect
{
    
}

-(IBAction)OnAddColleague:(id)sender
{
    if (_arraySelected.count > 0) [self.delegate AddColleague:_arraySelected];
}

-(IBAction)OnFiltTag:(id)sender
{
    [[RPSDK defaultInstance] GetExistUserTagSuccess:^(NSMutableArray * arrayResult) {
        
        NSInteger nSel = 0;
        NSInteger nIndex = 0;
        for (NSString * str in arrayResult) {
            if ([str isEqualToString:_strCurFiltTag]) {
                nSel = nIndex + 1;
                break;
            }
            nIndex ++;
        }
        [arrayResult insertObject:NSLocalizedStringFromTableInBundle(@"(No limitation)",@"RPString", g_bundleResorce,nil) atIndex:0];
        
        NSString *strDesc=NSLocalizedStringFromTableInBundle(@"Show which tag only?",@"RPString", g_bundleResorce,nil);
        RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:strDesc clickButton:^(NSInteger indexButton) {
            if (indexButton > -1) {
                if (indexButton == 0)
                    _strCurFiltTag = nil;
                else
                    _strCurFiltTag = [arrayResult objectAtIndex:indexButton];
            }
            [self UpdateUI];
        } curIndex:nSel  selectTitles:arrayResult];
        [selectView show];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}

-(void)UpdateSelAllUI
{
    BOOL bAllSelect = YES;
    BOOL bHasSelect = NO;
    
    if (_arrayCurColleague.count == 0) {
        bAllSelect = NO;
    }
    else
    {
        for (UserDetailInfo * colleague in _arrayCurColleague)
        {
            BOOL bFoundSel = NO;
            for (UserDetailInfo * colleagueGet in _arraySelected)
            {
                if ([colleague.strUserId isEqualToString:colleagueGet.strUserId]) {
                    bFoundSel = YES;
                    break;
                }
            }
            
            if (!bFoundSel) {
                bAllSelect = NO;
                break;
            }
        }
    }
    
    _btnSelectAll.selected = bAllSelect;
    if (bAllSelect == NO) {
        bHasSelect = NO;
        for (UserDetailInfo * colleague in _arrayCurColleague)
        {
            for (UserDetailInfo * colleagueGet in _arraySelected)
            {
                if ([colleague.strUserId isEqualToString:colleagueGet.strUserId]) {
                    bHasSelect = YES;
                    break;
                }
            }
            if (bHasSelect) break;
        }
        
        if (bHasSelect)
            [_btnSelectAll setImage:[UIImage imageNamed:@"button_choose4.png"] forState:UIControlStateNormal];
        else
            [_btnSelectAll setImage:[UIImage imageNamed:@"button_choose.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)OnSelectAll:(id)sender
{
    if (_btnSelectAll.selected) {
        for (UserDetailInfo * colleague in _arrayCurColleague)
        {
            for (UserDetailInfo * colleagueGet in _arraySelected)
            {
                if ([colleagueGet.strUserId isEqualToString:colleague.strUserId]) {
                    [_arraySelected removeObject:colleagueGet];
                    break;
                }
            }
        }
    }
    else
    {
        
        for (UserDetailInfo * colleague in _arrayCurColleague)
        {
            BOOL bFound = NO;
            for (UserDetailInfo * colleagueGet in _arraySelected)
            {
                if ([colleagueGet.strUserId isEqualToString:colleague.strUserId]) {
                    bFound = YES;
                    break;
                }
            }
            if (!bFound) {
                [_arraySelected addObject:colleague];
            }
        }
    }
    
    [_tbAddressBook reloadData];
    [self UpdateSelAllUI];
}

-(void)setBSingleSelect:(BOOL)bSingleSelect
{
    _bSingleSelect = bSingleSelect;
    _btnSelectAll.hidden = bSingleSelect;
}
@end
