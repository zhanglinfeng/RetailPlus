//
//  RPStoreManagerListView.m
//  RetailPlus
//
//  Created by lin dong on 13-9-3.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPStoreManagerListView.h"
#import "RPStoreManagerCell.h"

@implementation RPStoreManagerListView

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
-(void)UpdateUI
{
    NSInteger nUserStore = 0;
    NSInteger nComplete = 0;
    
    
    _arrayStoreShow = [[NSMutableArray alloc] init];
    for (StoreDetailInfo * store in _arrayStoreAll) {
        if (store.isPerfect) {
            nComplete ++;
        }
        if (store.isOwn) {
            nUserStore ++;
        }
        
        if ((!store.isPerfect) && _bShowComplete) continue;
        if ((!store.isOwn) && _bShowStoreUser) continue;
        
        if (_tfSearch.text.length > 0) {
            NSRange range1 = [store.strStoreName rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
            
            NSRange range2 = [store.strBrandName rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
            
            NSRange range3 = [store.strStoreAddress rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
            
            if (range1.length == 0 && range2.length == 0 && range3.length == 0) {
                continue;
            }
        }
        
        [_arrayStoreShow addObject:store];
    }
    
    
    [_btnShowComplete setTitle:[NSString stringWithFormat:@"%d",nComplete] forState:UIControlStateNormal];
    [_btnShowStoreUser setTitle:[NSString stringWithFormat:@"%d",nUserStore] forState:UIControlStateNormal];
    
    [_tbStore reloadData];
}

-(void)awakeFromNib
{
    _viewFrame.layer.cornerRadius = 10;
    _viewFrame.layer.shadowOffset = CGSizeMake(0, 1);
    _viewFrame.layer.shadowRadius =3.0;
    _viewFrame.layer.shadowColor =[UIColor blackColor].CGColor;
    _viewFrame.layer.shadowOpacity =0.5;
    
    _btnShowStoreUser.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnShowStoreUser.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 20);
    
    
    _btnShowComplete.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnShowComplete.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 20);
    
    _viewSearchFrame.layer.cornerRadius = 6;
    
    [[RPSDK defaultInstance] GetStoreList:SituationType_NotAssign Success:^(NSMutableArray * array) {
        _arrayStoreAll = array;
        [self UpdateUI];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [self UpdateUI];
    }];
    [self addHeader];
}
- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tbStore;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self ReloadData];
    };
    _headerStoreList = header;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayStoreShow.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPStoreManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPStoreManagerCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPStoreManagerCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    StoreDetailInfo * store = [_arrayStoreShow objectAtIndex:indexPath.row];
    cell.store = store;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StoreDetailInfo * store = [_arrayStoreShow objectAtIndex:indexPath.row];
    [self.delegate OnSelectStoreManagerStore:store];
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
    [_tfSearch resignFirstResponder];
    _tfSearch.text = @"";
    [self UpdateUI];
}

-(IBAction)OnShowComplete:(id)sender
{
    _bShowComplete = !_bShowComplete;
    if (_bShowComplete)
        [_btnShowComplete setSelected:YES];
    else
        [_btnShowComplete setSelected:NO];
    
    [self UpdateUI];
}

-(IBAction)OnShowStoreUser:(id)sender
{
    _bShowStoreUser = !_bShowStoreUser;
    
    if (_bShowStoreUser)
        [_btnShowStoreUser setSelected:YES];
    else
        [_btnShowStoreUser setSelected:NO];
    
    [self UpdateUI];
}

-(void)ReloadData
{
    _arrayStoreAll = nil;
    [self UpdateUI];
    
    [[RPSDK defaultInstance] GetStoreList:SituationType_NotAssign Success:^(NSMutableArray * array) {
        _arrayStoreAll = array;
        [self UpdateUI];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
         [self UpdateUI];
    }];
}

-(void)UpdateStore:(StoreDetailInfo *)store
{
    [self ReloadData];
}

@end
