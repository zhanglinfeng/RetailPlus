//
//  RPAddressBookCustomerView.m
//  RetailPlus
//
//  Created by lin dong on 13-8-28.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPAddressBookCustomerView.h"
#import "RPAddressBookCustomerCell.h"
extern NSBundle * g_bundleResorce;
@implementation RPAddressBookCustomerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

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
    
    _bShowVip = NO;
    _bShowRelation = NO;
    _bShowMale = NO;
    _bShowFemale = NO;
    
    [[RPSDK defaultInstance]GetCustomerCareerList:^(NSArray * arrayList) {
        [RPSDK defaultInstance].arrayCareerList = arrayList;
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
    [self addHeader];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tbAddressBook;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self ReloadData];
    };
    _headerCustomer = header;
    
}
-(void)InitCustomerList
{
    if (_arrayCurCustomer == nil) {
        [[RPSDK defaultInstance] GetCustomerList:^(NSArray * array) {
            _arrayAllCustomer = array;
            [self UpdateUI];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
}

-(void)UpdateUI
{
    _nVipCount = 0;
    _nRelationCount = 0;
    _nMaleCount = 0;
    _nFemaleCount = 0;
    
    _arrayCurCustomerUnsort = [[NSMutableArray alloc] init];
    
    NSString * strSearchRelationUser = @"";
    if ([_tfSearch.text hasPrefix:@"-Re:"]) {
        strSearchRelationUser = [_tfSearch.text substringFromIndex:4];
    }
    
    for (Customer * custom in _arrayAllCustomer) {
        if (custom.isVip) _nVipCount ++;
        if (custom.isRelate) _nRelationCount ++;
        if (custom.Sex == Sex_Male) _nMaleCount ++;
        if (custom.Sex == Sex_Female) _nFemaleCount ++;
        
        if (_bShowVip && custom.isVip == NO) continue;
        if (_bShowRelation && custom.isRelate == NO) continue;
        if (_bShowMale && (custom.Sex != Sex_Male)) continue;
        if (_bShowFemale && (custom.Sex != Sex_Female)) continue;
        
        if (strSearchRelationUser.length > 0) {
            if (![strSearchRelationUser isEqualToString:custom.strRelationUserName]) {
                continue;
            }
        }
        else
        {
            if (_tfSearch.text.length > 0) {
                NSRange range1 = [custom.strFirstName rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
//                NSRange range2 = [custom.strSurName rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
                NSRange range3 = [custom.strAddress rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
                NSRange range4 = [custom.strRelationUserName rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
                if (range1.length == 0 && range3.length == 0 && range4.length == 0) {
                    continue;
                }
            }
        }
        [_arrayCurCustomerUnsort addObject:custom];
    }
    
    [_btnMale setTitle:[NSString stringWithFormat:@"%d",_nMaleCount] forState:UIControlStateNormal];
    [_btnFemale setTitle:[NSString stringWithFormat:@"%d",_nFemaleCount] forState:UIControlStateNormal];
    [_btnVip setTitle:[NSString stringWithFormat:@"%d",_nVipCount] forState:UIControlStateNormal];
    [_btnRelation setTitle:[NSString stringWithFormat:@"%d",_nRelationCount] forState:UIControlStateNormal];
    
    _btnMale.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnMale.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 20);
    
    _btnFemale.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnFemale.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 20);
    
    _btnVip.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnVip.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 20);
    
    
    _btnRelation.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnRelation.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 20);
    
    
    _arrayCurCustomer = [_arrayCurCustomerUnsort sortedArrayUsingComparator:^(Customer * obj1, Customer * obj2)
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
    
    [_tbAddressBook reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = 0;
    NSString * strSecHead = [_arraySec objectAtIndex:section];
    for (Customer * customer in _arrayCurCustomer) {
        if ([customer.strSectionLetter compare:strSecHead options:NSCaseInsensitiveSearch] == NSOrderedSame)
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
    RPAddressBookCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPAddressBookCustomerCell"];
    if (cell == nil)
    {
        NSArray *array = [g_bundleResorce loadNibNamed:@"RPAddressBookCell" owner:self options:nil];
        cell = [array objectAtIndex:2];
        cell.vcFrame = self.vcFrame;
        cell.delegate = self;
    }
    
    NSInteger nRowIndex = 0;
    NSString * strSecHead = [_arraySec objectAtIndex:indexPath.section];
    for (Customer * customer in _arrayCurCustomer) {
        if ([customer.strSectionLetter compare:strSecHead options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            if (nRowIndex == indexPath.row) {
                cell.customer = customer;
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
    if (_arrayCurCustomer == nil || _arrayCurCustomer.count == 0) return nil;
    
    return _arraySec;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [_arraySec indexOfObject:title];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Client
    [_tfSearch resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger nRowIndex = 0;
    NSString * strSecHead = [_arraySec objectAtIndex:indexPath.section];
    for (Customer * customer in _arrayCurCustomer) {
        if ([customer.strSectionLetter compare:strSecHead options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            if (nRowIndex == indexPath.row) {
                [_delegate OnSelectCustomer:customer];
                break;
            }
            nRowIndex ++;
        }
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

-(IBAction)OnVip:(id)sender
{
    _bShowVip = !_bShowVip;
    [(UIButton *)sender setSelected:_bShowVip];
    [self UpdateUI];
}

-(IBAction)OnRelation:(id)sender
{
    _bShowRelation = !_bShowRelation;
    [(UIButton *)sender setSelected:_bShowRelation];
    [self UpdateUI];
}

-(IBAction)OnMale:(id)sender
{
    _bShowMale = !_bShowMale;
    [(UIButton *)sender setSelected:_bShowMale];
    if (_bShowMale) {
        [_btnFemale setSelected:NO];
        _bShowFemale = NO;
    }
    [self UpdateUI];
}

-(IBAction)OnFemale:(id)sender
{
    _bShowFemale = !_bShowFemale;
    [(UIButton *)sender setSelected:_bShowFemale];
    if (_bShowFemale) {
        [_btnMale setSelected:NO];
        _bShowMale = NO;
    }
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
    _arrayCurCustomer = nil;
    [_btnMale setTitle:@"" forState:UIControlStateNormal];
    [_btnFemale setTitle:@"" forState:UIControlStateNormal];
    [_btnVip setTitle:@"" forState:UIControlStateNormal];
    [_btnRelation setTitle:@"" forState:UIControlStateNormal];
    
    [_tbAddressBook reloadData];
    
    [self InitCustomerList];
}

-(void)OnSearchRelationUser:(Customer *)customer
{
    _tfSearch.text = [NSString stringWithFormat:@"-Re:%@",customer.strRelationUserName];
    [self UpdateUI];
}

 -(void)OnEditCustomer:(Customer *)customer
{
    [_delegate OnEditCustomer:customer];
}

-(void)OnCustomerPurchase:(Customer *)customer
{
    [_delegate OnCustomerPurchase:customer];
}

-(void)SearchRelationUser:(NSString *)strUserName
{
    if (_arrayCurCustomer == nil) {
        [[RPSDK defaultInstance] GetCustomerList:^(NSArray * array) {
            _arrayAllCustomer = array;
            _tfSearch.text = [NSString stringWithFormat:@"-Re:%@",strUserName];
            [self UpdateUI];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
    else
    {
        _tfSearch.text = [NSString stringWithFormat:@"-Re:%@",strUserName];
        [self UpdateUI];
    }
}
//-(void)OnEditCustomerEnd
//{
//    RPModifyCustomerViewController*vcInsp = [[RPModifyCustomerViewController alloc] initWithNibName:NSStringFromClass([RPModifyCustomerViewController class]) bundle:g_bundleResorce];
//    [UIView beginAnimations:nil context:nil];
//    vcInsp.view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
//    [UIView commitAnimations];
//}
@end
