//
//  RPLogBookDetailView.m
//  RetailPlus
//
//  Created by lin dong on 14-3-3.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPLogBookDetailView.h"
#import "RPLogBookCell.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"
#import "RPBlockUISelectView.h"

extern NSBundle * g_bundleResorce;
@implementation RPLogBookDetailView

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
    _arrayLogBook=[[NSMutableArray alloc]init];
    bShowFilter = NO;
    bFilterMyPost = NO;
    bFilterUnRead = NO;
    bFilterFocus = NO;
    NSString* strAllTheme = NSLocalizedStringFromTableInBundle(@"All Theme",@"RPString", g_bundleResorce,nil);
    _lbThemeName.text = strAllTheme;
    _viewThemeSelection.layer.cornerRadius = 4.0;
    _viewFilter.hidden = YES;
    _viewFilterGuide.hidden = YES;
    _viewFrame.layer.cornerRadius=10;
    [self addFooter];
    [self addHeader];
    _viewSearchDetail.delegete=self;
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [_tbDetail reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _tbDetail;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self ReloadEndData];
    };
    _footer = footer;
}

- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tbDetail;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self ReloadBefData];
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
    };
    [header beginRefreshing];
    _header = header;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(BOOL)OnBack
{
    [self endEditing:YES];
    if (_bBookPost)
    {
        if ([_viewBookPost OnBack])
        {
            [UIView beginAnimations:nil context:nil];
            _viewBookPost.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _bBookPost=NO;
        }
        
        return NO;
    }
    if (_bBookSearch) {
        if ([_viewBookSearch OnBack])
        {
            [UIView beginAnimations:nil context:nil];
            _viewBookSearch.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _bBookSearch=NO;
        }
        
        return NO;
    }
    return YES;
}

-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _lbStoreName.text = storeSelected.strStoreName;
    _lbStoreTitle.text = [NSString stringWithFormat:@"%@",storeSelected.strBrandName];
    _storeSelected = storeSelected;
    [_lbStoreTitle Start];
    [_lbStoreName Start];
    [self ReloadData];
    // bShowFilter = NO;
    // [self SetFilterOn:bShowFilter];
}

NSInteger nDataCount = 1;

-(void)ReloadData
{
    [SVProgressHUD showWithStatus:@""];
    
    [[RPSDK defaultInstance]GetLogBookList:_storeSelected.strStoreId FiltMyPost:bFilterMyPost FiltUnRead:bFilterUnRead FiltFocus:bFilterFocus FiltTag:_strTagID LastId:@"" GetNew:NO Success:^(NSMutableArray *array) {
        _arrayLogBook=array;
        [_tbDetail reloadData];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [_arrayLogBook removeAllObjects];
        [_tbDetail reloadData];
        [SVProgressHUD dismiss];
    }];
}


-(void)ReloadBefData
{
    [SVProgressHUD showWithStatus:@""];
    
    NSString * strLastId = @"";
    if (_arrayLogBook && _arrayLogBook.count > 0) {
        LogBookDetail * detail = [_arrayLogBook objectAtIndex:0];
        strLastId = detail.strID;
    }
    
    [[RPSDK defaultInstance]GetLogBookList:_storeSelected.strStoreId FiltMyPost:bFilterMyPost FiltUnRead:bFilterUnRead FiltFocus:bFilterFocus FiltTag:_strTagID LastId:strLastId GetNew:YES Success:^(NSMutableArray *array) {
        
        if (_arrayLogBook) {
            NSRange range = NSMakeRange(0, [array count]);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [_arrayLogBook insertObjects:array atIndexes:indexSet];
        }
        else
            _arrayLogBook=array;
        
        [_tbDetail reloadData];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
    }];
}

-(void)ReloadEndData
{
    [SVProgressHUD showWithStatus:@""];
    
    NSString * strLastId = @"";
    if (_arrayLogBook && _arrayLogBook.count > 0) {
        LogBookDetail * detail = [_arrayLogBook objectAtIndex:(_arrayLogBook.count - 1)];
        strLastId = detail.strID;
    }
    
    [[RPSDK defaultInstance]GetLogBookList:_storeSelected.strStoreId FiltMyPost:bFilterMyPost FiltUnRead:bFilterUnRead FiltFocus:bFilterFocus FiltTag:_strTagID LastId:strLastId GetNew:NO Success:^(NSMutableArray *array) {
        
        if (_arrayLogBook)
            [_arrayLogBook addObjectsFromArray:array];
        else
            _arrayLogBook=array;
        
        [_tbDetail reloadData];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayLogBook.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogBookDetail * detail = (LogBookDetail *)[_arrayLogBook objectAtIndex:indexPath.row];
    RPLogBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPLogBookCell"];
    if (cell == nil)
    {
        NSArray *array=[[NSBundle mainBundle]loadNibNamed:@"RPLogBookCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.delegate = self;
        cell.storeSelected = self.storeSelected;
    }
    cell.themeId = _strTagID;
    cell.detail = detail;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogBookDetail * detail = (LogBookDetail *)[_arrayLogBook objectAtIndex:indexPath.row];
    return [RPLogBookCell calcCellHeight:detail];
}

-(void)SetFilterOn:(BOOL)bOn
{
    if (!bOn) {
        _viewFilter.hidden = YES;
        _viewFilterGuide.hidden = YES;
        _tbDetail.frame = CGRectMake(_tbDetail.frame.origin.x,_viewHead.frame.size.height, _tbDetail.frame.size.width, _tbDetail.frame.size.height + _viewFilter.frame.size.height);
    }
    else
    {
        _viewFilter.hidden = NO;
        _viewFilterGuide.hidden = NO;
        
        _tbDetail.frame = CGRectMake(_tbDetail.frame.origin.x,_viewHead.frame.size.height + _viewFilter.frame.size.height, _tbDetail.frame.size.width, _tbDetail.frame.size.height - _viewFilter.frame.size.height);
        
        //        bFilterUnRead = NO;
        //        bFilterMyPost = NO;
        //        [_btMyPost setSelected:bFilterMyPost];
        //        [_btUnread setSelected:bFilterUnRead];
    }
    [self ReloadData];
}

-(IBAction)OnFilter:(id)sender
{
    bShowFilter = !bShowFilter;
    _ivTriange.hidden=!bShowFilter;
    _viewLine.hidden=bShowFilter;
    //    [_btFilter setSelected:bShowFilter];
    [self SetFilterOn:bShowFilter];
}

-(IBAction)OnSearch:(id)sender
{
    _viewBookSearch.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    
    [self addSubview:_viewBookSearch];
    _viewBookSearch.storeSelected=_storeSelected;
    _viewBookSearch.delegate=self;
    [UIView beginAnimations:nil context:nil];
    _viewBookSearch.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bBookSearch=YES;
}

-(IBAction)OnMyPost:(id)sender
{
    bFilterMyPost=!bFilterMyPost;
    [_btMyPost setSelected:bFilterMyPost];
    if (bFilterMyPost||bFilterUnRead||bFilterFocus)
    {
        [_btFilter setSelected:YES];
    }
    else
    {
        [_btFilter setSelected:NO];
    }
    [self ReloadData];
}

-(IBAction)OnMyFocus:(id)sender
{
    bFilterFocus=!bFilterFocus;
    [_btMyFocus setSelected:bFilterFocus];
    if (bFilterMyPost||bFilterUnRead||bFilterFocus)
    {
        [_btFilter setSelected:YES];
    }
    else
    {
        [_btFilter setSelected:NO];
    }
    [self ReloadData];
}

-(void)postViewEnd
{
    [UIView beginAnimations:nil context:nil];
    _viewBookPost.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bBookPost=NO;
    [self ReloadData];
}

-(IBAction)OnUnread:(id)sender
{
    bFilterUnRead=!bFilterUnRead;
    [_btUnread setSelected:bFilterUnRead];
    if (bFilterMyPost||bFilterUnRead||bFilterFocus)
    {
        [_btFilter setSelected:YES];
    }
    else
    {
        [_btFilter setSelected:NO];
    }
    [self ReloadData];
}

-(IBAction)OnAddLogBook:(id)sender
{
    _viewBookPost.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewBookPost];
    
    _viewBookPost.delegate=self;
    [UIView beginAnimations:nil context:nil];
    _viewBookPost.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _viewBookPost.storeSelected=_storeSelected;
    _viewBookPost.vcFrame=_vcFrame;
    _bBookPost=YES;
}

- (IBAction)OnFresh:(id)sender
{
    [_tbDetail setContentOffset:CGPointMake(0, 0) animated:YES];
    [self ReloadData];
}

- (IBAction)OnThemeSelected:(id)sender {
    NSString* strCate = NSLocalizedStringFromTableInBundle(@"CATEGORIES",@"RPString", g_bundleResorce,nil);
    NSString* strAllTheme = NSLocalizedStringFromTableInBundle(@"All Theme",@"RPString", g_bundleResorce,nil);
    
    NSMutableArray* allThemes = [NSMutableArray array];
    NSMutableArray* arrTagID = [NSMutableArray array];
    [[RPSDK defaultInstance] GetLogBookTagSuccess:^(NSArray* arrayResult) {
        for (LogBookTag* BookTag in arrayResult) {
            [allThemes addObject:BookTag.strDesc];
            [arrTagID addObject:BookTag.strTagId];
        }
        [allThemes insertObject:strAllTheme atIndex:0];
        
        NSInteger nSel = 0;
        for (int i=0; i<allThemes.count; i++) {
            if ([_lbThemeName.text isEqualToString:allThemes[i]]) {
                nSel = i;
            }if (_lbThemeName.text.length==0) {
                nSel = -1;
            }
        }
        
        RPBlockUISelectView * selectView = [[RPBlockUISelectView alloc]initWithTitle:strCate
                                                                         clickButton:^(NSInteger indexButton) {
                                                                             if (indexButton > -1) {
                                                                                 _lbThemeName.text = allThemes[indexButton];
                                                                                 if (indexButton==0) {
                                                                                     _strTagID = @"";
                                                                                 }else {
                                                                                     _strTagID = arrTagID[indexButton-1];
                                                                                 }
                                                                                 [self ReloadData];
                                                                             }
                                                                         } curIndex:nSel
                                                                        selectTitles:allThemes];
        [selectView show];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
        
    }];
    
}

-(void)UpdateDetailTable
{
    //    [self ReloadData];
    [_tbDetail reloadData];
}

-(void)deleteEnd
{
    [self ReloadData];
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}
-(void)OnQuit:(id)sender
{
    [self.delegate OnLogBookEnd];
}
-(void)OnLogBookEnd
{
    [self dismissView:_viewBookSearch];
    [self.delegate OnLogBookEnd];
}
-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}
-(void)refreshLogBook
{
    [self ReloadData];
}
@end
