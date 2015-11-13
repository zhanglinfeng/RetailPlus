//
//  RPStoreListView.m
//  RetailPlus
//
//  Created by lin dong on 13-8-19.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "GTMBase64.h"
#import "RPStoreListView.h"
#import "RPStoreListCell.h"
#import "RPDomainListCell.h"

extern NSBundle * g_bundleResorce;

@implementation RPStoreListView

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
    _bStoreMode = YES;
    [_btnStoreMode setSelected:YES];
    [_btnDomainMode setSelected:NO];
    //_viewStoreModeTitle.hidden = NO;
    //_viewDomainModeTitle.hidden = YES;
    
    _viewFrame.layer.cornerRadius = 10;
    _viewFrame.layer.shadowOffset = CGSizeMake(0, 1);
    _viewFrame.layer.shadowRadius =3.0;
    _viewFrame.layer.shadowColor =[UIColor blackColor].CGColor;
    _viewFrame.layer.shadowOpacity =0.5;
    
    _viewStoreModeTitleDomain.layer.cornerRadius = 3;
    
    _viewSearchFrame.layer.cornerRadius = 6;
    
    _viewDomainModeTitle.delegate = self;
    
    _arrayShow = [[NSMutableArray alloc] init];

//    [self ReloadData];
    [self addHeader];
}

- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tbContent;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self ReloadData];
    };
    _headerStoreList = header;
    
}

-(void)reloadStore
{
//    _arrayStore = nil;
//    [_tbStore reloadData];
//    
//    [SVProgressHUD showWithStatus:NSLocalizedStringFromTableInBundle(@"Please wait...",@"RPString", g_bundleResorce,nil)];
//    
//    [[RPSDK defaultInstance] GetStoreList:self.sitType Success:^(NSMutableArray * arrayResult) {
//        _arrayStore = arrayResult;
//        [SVProgressHUD dismiss];
//        [self updateUI];
//    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
//       
//    }];
    if (_arrayDomain == nil || _arrayStore == nil) {
        [self ReloadData];
    }
}

-(void)dismiss
{
    [SVProgressHUD dismiss];
}

//-(void)updateUI
//{
//    _arrayStoreShow = [[NSMutableArray alloc] init];
//    for (StoreDetailInfo * store in _arrayStore) {
//        if(_tfSearch.text.length > 0)
//        {
//            NSRange range1 = [store.strStoreName rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
//            NSRange range2 = [store.strStoreAddress rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
//
//            if (range1.length == 0 && range2.length == 0)
//                continue;
//        }
//        [_arrayStoreShow addObject:store];
//    }
//    [_tbStore reloadData];
//}
//
//#pragma mark -UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (_arrayStoreShow) {
//        return _arrayStoreShow.count;
//    }
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    RPStoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPStoreListCell"];
//    if (cell == nil)
//    {
//        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPCustomCell" owner:self options:nil];
//        cell = [array objectAtIndex:0];
//    }
//    
//    [cell setStore:(StoreDetailInfo *)[_arrayStoreShow objectAtIndex:indexPath.row]];
//    return cell;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}
//
//#pragma mark -UITableViewDelegate
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    if (self.delegate) {
//        [self.delegate OnSelectedStore:[_arrayStoreShow objectAtIndex:indexPath.row]];
//    }
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [self endEditing:YES];
//    
//    [self updateUI];
//    return YES;
//}
//
//-(IBAction)OnDeleteSearch:(id)sender
//{
//   [self endEditing:YES];
//    
//   _tfSearch.text = @"";
//   [self updateUI];
//}
//
//-(void)dismiss
//{
//   [SVProgressHUD dismiss];
//}

-(DomainInfo *)FindRootDomain:(NSArray *)arrayDomain
{
    for (DomainInfo * info in arrayDomain) {
        if (info.strParentDomainID.length == 0) {
            return info;
        }
    }
    return [arrayDomain objectAtIndex:0];
}

-(void)ReloadData
{
    [SVProgressHUD showWithStatus:@""];
    
    [[RPSDK defaultInstance] GetDomainListSuccess:^(NSArray * arrayResult) {
        _arrayDomain = arrayResult;
        _rootDomain = [self FindRootDomain:_arrayDomain];
        _currentDomain = _rootDomain;
        
        [[RPSDK defaultInstance] GetStoreList:_sitType Success:^(NSArray * arrayResult) {
            _arrayStore = arrayResult;
            [self CalcShowArrayUpdate];
            [SVProgressHUD dismiss];
            [self OnStoreMode:nil];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}

-(void)ReloadStoreData
{
    [SVProgressHUD showWithStatus:@""];
    [[RPSDK defaultInstance] GetStoreList:_sitType Success:^(NSArray * arrayResult) {
        _arrayStore = arrayResult;
        [self CalcShowArrayUpdate];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}

-(void)CalcShowArrayUpdate
{
    [_arrayShow removeAllObjects];
    
    if (_bStoreMode) {
        _nOwnedStore = 0;
        for (StoreDetailInfo * store in _arrayStore) {
            if ([store.strDomainNo hasPrefix:_currentDomain.strDomainCode])
            {
                if (store.isOwn) {
                    _nOwnedStore ++;
                }
                
                if ((!store.isOwn) && _bShowOwnedStore) continue;
                
                if (_tfSearch.text.length > 0) {
                    NSRange range1 = [store.strStoreName rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
                    
                    NSRange range2 = [store.strBrandName rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
                    
                    NSRange range3 = [store.strStoreAddress rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
                    
                    if (range1.length == 0 && range2.length == 0 && range3.length == 0) {
                        continue;
                    }
                }
                
                [_arrayShow addObject:store];
            }
        }
    }
    else
    {
        
        NSMutableArray * arrayStoreCompare = [[NSMutableArray alloc] init];
        _nOwnedStore = 0;
        for (StoreDetailInfo * store in _arrayStore) {
            if ([store.strDomainNo hasPrefix:_currentDomain.strDomainCode]) {
                if (store.isOwn) _nOwnedStore ++;
                
                if ((!store.isOwn) && _bShowOwnedStore) continue;
                [arrayStoreCompare addObject:store];
            }
        }
        
        for (DomainInfo * info in _arrayDomain) {
            if ([info.strParentDomainID isEqualToString:_currentDomain.strDomainID]) {
                BOOL bHasSubStore = NO;
                for (StoreDetailInfo * store in arrayStoreCompare) {
                    if ([store.strDomainNo hasPrefix:info.strDomainCode])
                    {
                        bHasSubStore = YES;
                        break;
                    }
                }
                if (bHasSubStore) {
                    [_arrayShow addObject:info];
                }
            }
        }
        
        for (StoreDetailInfo * store in _arrayStore)
        {
            if ([store.strParentDomainId isEqualToString:_currentDomain.strDomainID])
            {
                if ((!store.isOwn) && _bShowOwnedStore) continue;
                
                [_arrayShow addObject:store];
            }
        }
    }
    [self UpdateUI];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayShow.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id idData = [_arrayShow objectAtIndex:indexPath.row];
    
    if ([idData isKindOfClass:[StoreDetailInfo class]]) {
        RPStoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPStoreListCell"];
        if (cell == nil)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPCustomCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        
        StoreDetailInfo * store = [_arrayShow objectAtIndex:indexPath.row];
        cell.store = store;
        
        return cell;
    }
    
    if ([idData isKindOfClass:[DomainInfo class]]) {
        RPDomainListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPStoreManagerCell"];
        if (cell == nil)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPCustomCell" owner:self options:nil];
            cell = [array objectAtIndex:3];
            cell.bCanSelDomain = _bCanSelDomain;
            cell.delegate = self;
        }
        
        DomainInfo * info = [_arrayShow objectAtIndex:indexPath.row];
        cell.info = info;
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id idData = [_arrayShow objectAtIndex:indexPath.row];
    if ([idData isKindOfClass:[StoreDetailInfo class]]) {
        StoreDetailInfo * store = [_arrayShow objectAtIndex:indexPath.row];
        [self.delegate OnSelectedStore:store];
    }
    
    if ([idData isKindOfClass:[DomainInfo class]]) {
        DomainInfo * info = [_arrayShow objectAtIndex:indexPath.row];
        _currentDomain = info;
        [self CalcShowArrayUpdate];
    }
}

-(void)UpdateUI
{
    _viewDomainModeTitle.arrayDomainTree = _arrayDomain;
    _viewDomainModeTitle.domainCurrent = _currentDomain;
    [UIView beginAnimations:nil context:nil];
    if ([_currentDomain.strDomainID isEqualToString:_rootDomain.strDomainID])
    {
        _viewStoreModeTitleDomain.hidden = YES;
        _viewStoreModeTitleSearch.frame = CGRectMake(_viewStoreModeTitleSearch.frame.origin.x,
                                                     _viewStoreModeTitleSearch.frame.origin.y,
                                                     _viewFrame.frame.size.width - 6 - _viewStoreModeTitleSearch.frame.origin.x,
                                                     _viewStoreModeTitleSearch.frame.size.height);
    }
    else
    {
        _viewStoreModeTitleDomain.hidden = NO;
        _viewStoreModeTitleSearch.frame = CGRectMake(_viewStoreModeTitleSearch.frame.origin.x,
                                                     _viewStoreModeTitleSearch.frame.origin.y,
                                                     _viewFrame.frame.size.width - 6 - _viewStoreModeTitleDomain.frame.size.width - 6 - _viewStoreModeTitleSearch.frame.origin.x,
                                                     _viewStoreModeTitleSearch.frame.size.height);
    }
    
    [UIView commitAnimations];
    
    _lbStoreModeTitleDomain.text = _currentDomain.strDomainName;
    _lbOwnedCount.text = [NSString stringWithFormat:@"%d",_nOwnedStore];
    [_tbContent reloadData];
}

-(void)UpdateStore:(StoreDetailInfo *)store
{
    [self ReloadStoreData];
}

-(void)OnDomainChange:(DomainInfo *)domain
{
    _currentDomain = domain;
    [self CalcShowArrayUpdate];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self CalcShowArrayUpdate];
    return YES;
}

-(void)OnSelectDomain:(DomainInfo *)info
{
    if([(NSObject *)_delegate respondsToSelector:@selector(OnSelectDomain:)] == YES )
    {
        [self.delegate OnSelectDomain:info];
    }
}

-(IBAction)OnDeleteSearch:(id)sender
{
    [_tfSearch resignFirstResponder];
    _tfSearch.text = @"";
    [self CalcShowArrayUpdate];
}

-(IBAction)OnOwnedStore:(id)sender
{
    if (_bShowOwnedStore)
    {
        _ivOwned.alpha = 0.3;
        _lbOwnedCount.alpha = 0.3;
    }
    else
    {
        _ivOwned.alpha = 1;
        _lbOwnedCount.alpha = 1;
    }
    
    _bShowOwnedStore = !_bShowOwnedStore;
    [self CalcShowArrayUpdate];
}

-(IBAction)OnStoreMode:(id)sender
{
    _bStoreMode = YES;
    [_btnStoreMode setSelected:YES];
    [_btnDomainMode setSelected:NO];
//    _viewStoreModeTitle.hidden = NO;
//    _viewDomainModeTitle.hidden = YES;
    
    [UIView beginAnimations:nil context:nil];
    _viewStoreModeTitle.frame = CGRectMake(0, 1, _viewStoreModeTitle.frame.size.width, _viewStoreModeTitle.frame.size.height);
    _viewDomainModeTitle.frame = CGRectMake(0, _viewStoreModeTitle.frame.size.height + 1, _viewDomainModeTitle.frame.size.width, _viewDomainModeTitle.frame.size.height);
    [UIView commitAnimations];
    
    [self CalcShowArrayUpdate];
}

-(IBAction)OnDomainMode:(id)sender
{
    _bStoreMode = NO;
    [_btnStoreMode setSelected:NO];
    [_btnDomainMode setSelected:YES];
//    _viewStoreModeTitle.hidden = YES;
//    _viewDomainModeTitle.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    _viewStoreModeTitle.frame = CGRectMake(0, -_viewStoreModeTitle.frame.size.height + 1, _viewStoreModeTitle.frame.size.width, _viewStoreModeTitle.frame.size.height);
    _viewDomainModeTitle.frame = CGRectMake(0, 1, _viewDomainModeTitle.frame.size.width, _viewDomainModeTitle.frame.size.height);
    
    [UIView commitAnimations];
    
    [self CalcShowArrayUpdate];
}

-(IBAction)OnDeleteDomain:(id)sender
{
    _currentDomain = _rootDomain;
    [self CalcShowArrayUpdate];
}
@end
