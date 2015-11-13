//
//  RPAddressBookInternalView.m
//  RetailPlus
//
//  Created by lin dong on 13-8-16.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPAddressBookInternalView.h"
#import "RPAddressBookCell.h"
#import "pinyin.h"
#import "RPBlockUISelectView.h"

extern NSBundle * g_bundleResorce;
@implementation RPAddressBookInternalView



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
    _viewFrame.layer.cornerRadius = 10;
    _viewFrame.layer.shadowOffset = CGSizeMake(0, 1);
    _viewFrame.layer.shadowRadius =3.0;
    _viewFrame.layer.shadowColor =[UIColor blackColor].CGColor;
    _viewFrame.layer.shadowOpacity =0.5;
    
    _viewSearchFrame.layer.cornerRadius = 6;
    
    _arraySec = [NSArray arrayWithObjects:@"#",@"A",@"B",@"C",@"D",@"E",@"F",
                           @"G",@"H",@"I",@"J",@"K",
                           @"L",@"M",@"N",@"O",@"P",
                           @"Q",@"R",@"S",@"T",@"U",
                           @"V",@"W",@"X",@"Y",@"Z",nil];
    
    
    [_btnCount1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_btnCount1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [_btnCount2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_btnCount2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [_btnCount3 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_btnCount3 setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [_btnCount4 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_btnCount4 setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    
    
    _longPressFiltUser = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    _longPressFiltUser.minimumPressDuration = 0.8;
    [_btnFiltUser addGestureRecognizer:_longPressFiltUser];
    
    _longPressTagMode = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    _longPressTagMode.minimumPressDuration = 0.8;
    [_btnTagMode addGestureRecognizer:_longPressTagMode];
    
    
    [[RPSDK defaultInstance] GetUserRankCount:^(UserRankCount * state) {
        _nCount1 = state.nCountManager;
        _nCount2 = state.nCountStoreManager;
        _nCount3 = state.nCountAssistant;
        _nCount4 = state.nCountVendor;
        
        [self OnSelLev1:_btnCount1];
        [self UpdateUI];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
    }];
    [self addHeader];
}

-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        if (gestureRecognizer == _longPressTagMode) {
            if (_strCurFiltTag && _strCurFiltTag.length > 0) {
                _strCurFiltTag = nil;
                [self UpdateUI];
            }
        }
        if (gestureRecognizer == _longPressFiltUser) {
            if (_strCurFiltTag && _strCurFiltTag.length > 0) {
                _strCurFiltTag = nil;
                [self UpdateUI];
            }
        }
    }
}

- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tbAddressBook;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self ReloadData];
    };
    _headerInternal = header;
    
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
    RPAddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPAddressBookCell"];
    if (cell == nil)
    {
        NSArray *array = [g_bundleResorce loadNibNamed:@"RPAddressBookCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.vcFrame = self.vcFrame;
        cell.delegate = self;
    }
    
    cell.strFiltString = _strCurFiltTag;
    cell.bShowTag = _bShowTag;
    
    NSInteger nRowIndex = 0;
    NSString * strSecHead = [_arraySec objectAtIndex:indexPath.section];
    for (UserDetailInfo * colleague in _arrayCurColleague) {
        if ([colleague.strSectionLetter compare:strSecHead options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            if (nRowIndex == indexPath.row) {
                cell.colleague = colleague;
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
               [_delegate OnSelectColleague:colleague];
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
            
            NSString * strFullName = [NSString stringWithFormat:@"%@",colleague.strFirstName];
            NSRange range4 = [strFullName rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
            
            if (range1.length != 0 ||range3.length != 0 || range4.length != 0) {
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
    
    if (_strCurFiltTag && _strCurFiltTag.length > 0)
    {
        [_btnFiltUser setTitle:_strCurFiltTag forState:UIControlStateNormal];
        [_btnFiltUser setBackgroundImage:[UIImage imageNamed:@"button_choose2.png"] forState:UIControlStateNormal];
        [_btnTagMode setImage:[UIImage imageNamed:@"button_choose3.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnFiltUser setBackgroundImage:[UIImage imageNamed:@"button_choose1.png"] forState:UIControlStateNormal];
        [_btnFiltUser setTitle:@"" forState:UIControlStateNormal];
        [_btnTagMode setImage:[UIImage imageNamed:@"button_tag.png"] forState:UIControlStateNormal];
    }
    [_tfSearch resignFirstResponder];
    [_tbAddressBook reloadData];
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

-(void)ReloadData
{
    [_btnCount1 setSelected:NO];
    [_btnCount2 setSelected:NO];
    [_btnCount3 setSelected:NO];
    [_btnCount4 setSelected:NO];
    
    //_bLev1 = _bLev2 = _bLev3 = _bLev4 = NO;
    _nCount1 = _nCount2 = _nCount3 = _nCount4 = 0;
    
    _arrayLev1 = _arrayLev2 = _arrayLev3 = _arrayLev4 = _arrayCurColleague = _arrayCurColleagueUnsort = nil;
    
    [[RPSDK defaultInstance] GetUserRankCount:^(UserRankCount * state) {
        _nCount1 = state.nCountManager;
        _nCount2 = state.nCountStoreManager;
        _nCount3 = state.nCountAssistant;
        _nCount4 = state.nCountVendor;
        [self UpdateUI];
        if (_bLev1)
        {
            _bLev1 = !_bLev1;
            [self OnSelLev1:_btnCount1];
        }
        
        if (_bLev2)
        {
            _bLev2 = !_bLev2;
            [self OnSelLev2:_btnCount2];
        }
        
        if (_bLev3)
        {
            _bLev3 = !_bLev3;
            [self OnSelLev3:_btnCount3];
        }
        
        if (_bLev4)
        {
            _bLev4 = !_bLev4;
            [self OnSelLev4:_btnCount4];
        }
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}

-(void)OnCustomerlist:(UserDetailInfo *)colleague
{
    [_delegate OnCustomerlist:colleague];
}

-(void)OnShowTag:(BOOL)bShow
{
    _bShowTag = bShow;
    _btnFiltUser.hidden = !_bShowTag;
    _btnAddUser.hidden = _bShowTag;
    
    [_tbAddressBook reloadData];
}

-(IBAction)OnShowFilt:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    _viewFiltFrame.frame = CGRectMake(_viewFiltFrame.frame.origin.x, -41, _viewFiltFrame.frame.size.width, _viewFiltFrame.frame.size.height);
    [UIView commitAnimations];
    
    [self OnShowTag:YES];
}

-(IBAction)OnHideFilt:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    _viewFiltFrame.frame = CGRectMake(_viewFiltFrame.frame.origin.x, 0, _viewFiltFrame.frame.size.width, _viewFiltFrame.frame.size.height);
    [UIView commitAnimations];
    
    [self OnShowTag:NO];
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

-(void)OnEditTagEnd
{
    [self UpdateUI];
}

-(void)OnSetFilt:(NSString *)strFiltTag
{
    _strCurFiltTag = strFiltTag;
    [self UpdateUI];
}

-(void)OnRemoveFilt
{
    _strCurFiltTag = nil;
    [self UpdateUI];
}

@end
