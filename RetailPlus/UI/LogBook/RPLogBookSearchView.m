//
//  RPLogBookSearchView.m
//  RetailPlus
//
//  Created by lin dong on 14-3-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPLogBookSearchView.h"
#import "RPLogBookSearchCell.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;
@implementation RPLogBookSearchView

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
    _viewBackground.layer.cornerRadius=10;
    _viewSearch.layer.cornerRadius=6;
    [self setUpForDismissKeyboard];
//    UITapGestureRecognizer *tapGR =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(tapAnywhereToDismissKeyboard:)];
//    [self addGestureRecognizer:tapGR];
    
    [self addFooter];
    _switchSearchScope=[[RPSwitchView alloc] initWithFrame:CGRectMake(0, 0, _viewSwitch.frame.size.width, _viewSwitch.frame.size.height)];
    _switchSearchScope.delegate = self;
    [_viewSwitch addSubview:_switchSearchScope];
    _switchSearchScope.imgBack = [UIImage imageNamed:@"image_sgl_multi_swatch@2x.png"];
    [_switchSearchScope SetOn:YES];
    _bAllStore=NO;
    
}
-(void)SelectSwitch:(RPSwitchView *)view isOn:(BOOL)bOn
{
    if (bOn) {
        _lbState.text=_storeSelected.strStoreName;
        
    }
    else
    {
        _lbState.text=NSLocalizedStringFromTableInBundle(@"All available stores",@"RPString", g_bundleResorce,nil);
        
    }
    _bAllStore=!bOn;
    [self OnSearch:nil];
}
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    //    singleTapGR.cancelsTouchesInView = NO;
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [_tbLogBook addGestureRecognizer:singleTapGR];
 //                   NSLog(@"ziji===%@",self);
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [_tbLogBook removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self endEditing:YES];
}
-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _storeSelected=storeSelected;
    if (_tfSearch.text.length>0)
    {
        [self OnSearch:nil];
    }
    _lbState.text=_storeSelected.strStoreName;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPLogBookSearchCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPLogBookSearchCell"];
    if (cell == nil)
    {
        NSArray *array = [g_bundleResorce loadNibNamed:@"RPLogBookSearchCell" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
    }
    LogBookDetail * searchDetail = (LogBookDetail *)[_arraySearch objectAtIndex:indexPath.row];
    cell.searchDetail=searchDetail;
        return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _viewSearchDetail.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewSearchDetail];
    
    LogBookDetail * detail = (LogBookDetail *)[_arraySearch objectAtIndex:indexPath.row];
    
    
    [[RPSDK defaultInstance]GetLogBookDetail:detail.strID Success:^(LogBookDetail * detail) {
        
        _viewSearchDetail.storeSelected=((LogBookDetail *)[_arraySearch objectAtIndex:indexPath.row]).store;
        
        [UIView beginAnimations:nil context:nil];
        _viewSearchDetail.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _bSearchDetail=YES;
        _viewSearchDetail.delegete=self;
        _viewSearchDetail.detail=detail;
       
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arraySearch.count;
}
-(BOOL)OnBack
{
    if (_bSearchDetail)
    {
        [UIView beginAnimations:nil context:nil];
        _viewSearchDetail.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        [self OnSearch:nil];
        _bSearchDetail=NO;
        return NO;
    }
    return YES;
}

- (IBAction)OnSearch:(id)sender
{
    [self endEditing:YES];
    NSString *searchId=@"";
    if (!_bAllStore)
    {
        searchId=_storeSelected.strStoreId;
    }
    
    [[RPSDK defaultInstance]SearchLogBook:searchId LastLogBookID:@"" Condition:_tfSearch.text Success:^(NSMutableArray *array) {
        _arraySearch=array;
        if (_arraySearch.count==0)
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"The search result is empty",@"RPString", g_bundleResorce,nil)];
        }
        [_tbLogBook reloadData];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"The search result is empty",@"RPString", g_bundleResorce,nil)];
        [_arraySearch removeAllObjects];
        [_tbLogBook reloadData];
    }];
}

- (IBAction)OnDelete:(id)sender
{
    _tfSearch.text=@"";
    [_arraySearch removeAllObjects];
    [_tbLogBook reloadData];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    NSString *searchId=@"";
    if (!_bAllStore)
    {
        searchId=_storeSelected.strStoreId;
    }
    [[RPSDK defaultInstance]SearchLogBook:searchId LastLogBookID:@"" Condition:_tfSearch.text Success:^(NSMutableArray *array) {
        _arraySearch=array;
        if (_arraySearch.count==0)
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"The search result is empty",@"RPString", g_bundleResorce,nil)];
        }
        [_tbLogBook reloadData];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
        [_arraySearch removeAllObjects];
        [_tbLogBook reloadData];
    }];
    return YES;
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}
-(void)OnQuit:(id)sender
{
    [self.delegate OnLogBookEnd];
}

- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _tbLogBook;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self ReloadEndData];
    };
    _footer = footer;
}

//上拉加载
-(void)ReloadEndData
{
    if (_tfSearch.text.length > 0) {
        [SVProgressHUD showWithStatus:@""];
        
        NSString * strLastId = @"";
        if (_arraySearch && _arraySearch.count > 0) {
            LogBookDetail * detail = [_arraySearch objectAtIndex:(_arraySearch.count - 1)];
            strLastId = detail.strID;
        }
        NSString *searchId=@"";
        if (!_bAllStore)
        {
            searchId=_storeSelected.strStoreId;
        }
        [[RPSDK defaultInstance] SearchLogBook:searchId LastLogBookID:strLastId Condition:_tfSearch.text Success:^(NSMutableArray *array) {
            if (_arraySearch)
                [_arraySearch addObjectsFromArray:array];
            else
                _arraySearch=array;
             
            [_tbLogBook reloadData];
            [SVProgressHUD dismiss];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
           [SVProgressHUD dismiss];
        }];
    }
}
-(void)refreshLogBook
{
    [self OnBack];
    [self OnSearch:nil];
}
@end
