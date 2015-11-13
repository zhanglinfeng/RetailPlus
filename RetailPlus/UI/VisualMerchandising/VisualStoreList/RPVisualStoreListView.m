//
//  RPVisualStoreListView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPVisualStoreListView.h"
#import "RPVisualStoreCell.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;
@implementation RPVisualStoreListView

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
    _viewFrame.layer.cornerRadius=10;
    _viewSearch.layer.cornerRadius=6;
    NSArray *array = [g_bundleResorce loadNibNamed:@"CustomView" owner:self options:nil];
    _viewStoreList = [array objectAtIndex:1];
    _viewStoreList.delegate = self;
    [self loadData];
    [self addHeader];
    _arrayDeleteStore=[[NSMutableArray alloc]init];
    
    _label=[[UILabel alloc]initWithFrame:CGRectMake(80, 160, 160, 30)];
    _label.font=[UIFont systemFontOfSize:12];
    _label.textColor=[UIColor colorWithWhite:0.8 alpha:1];
    _label.numberOfLines=0;
    _label.backgroundColor=[UIColor clearColor];
    _label.textAlignment=NSTextAlignmentCenter;
    _label.text=NSLocalizedStringFromTableInBundle(@"Temporarily no data",@"RPString", g_bundleResorce,nil);
    [self insertSubview:_label aboveSubview:_tbStoreList];
}
-(void)loadData
{
    [[RPSDK defaultInstance] getVisualStoreList:^(NSMutableArray *array)
     {
         _arrayFollowStore=array;
         [self search:_tfSearch.text];
     } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
         
     }];
}
- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tbStoreList;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self loadData];
    };
    _header = header;
    
}
-(void)search:(NSString*)s
{
    _arraySearch = [self genSearchArray:_arrayFollowStore condition:s];
    
    [_tbStoreList reloadData];
    
}
-(NSMutableArray *)genSearchArray:(NSMutableArray *)array condition:(NSString *)strSearch
{
    if (!strSearch) {
        strSearch=@"";
    }
    
    if (strSearch.length == 0) {
        return array;
    }
    
    NSString *str=strSearch;
    NSMutableArray * arrayResult = [[NSMutableArray alloc] init];
    
    for (int i=0; i<array.count; i++)
    {
        FollowStore *followStore=[[FollowStore alloc]init];
        followStore=[array objectAtIndex:i];
        
        NSRange res = [followStore.strStoreName rangeOfString:str options:NSCaseInsensitiveSearch];
        
        
        
        if ((strSearch.length == 0) || (res.length != 0  ))
        {
            [arrayResult addObject:followStore];
        }
        
    }
    
    return arrayResult;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self search:_tfSearch.text];
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    FollowStore *store=[_arrayFollowStore objectAtIndex:indexPath.row];
//    if (_bEdit)
//    {
//        RPVisualStoreCell *cell=(RPVisualStoreCell *)[tableView cellForRowAtIndexPath:indexPath];
//        cell.check = !cell.check;
//        
//        if (cell.check)
//        {
//            [_arrayDeleteStore addObject:store.strStoreId];
//        }
//        else
//        {
//            [_arrayDeleteStore removeObject:store.strStoreId];
//        }
//        if (_arrayDeleteStore.count==_arraySearch.count)
//        {
//            _btSelect.selected=YES;
//        }
//        else
//        {
//            _btSelect.selected=NO;
//        }
//    }
//    else
//    {
        [SVProgressHUD showWithStatus:@""];
        [[RPSDK defaultInstance]GetStoreInfo:store.strStoreId Success:^(StoreDetailInfo * storeInfo) {
            [SVProgressHUD dismiss];
            _currentStoreInfo=storeInfo;
            if ([RPRights hasRightsFunc:_currentStoreInfo.llRights type:RPRightsFuncType_VisualCheck]) {
                _viewVisualMerchandising.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                [self addSubview:_viewVisualMerchandising];
                [UIView beginAnimations:nil context:nil];
                _viewVisualMerchandising.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                [UIView commitAnimations];
                _viewVisualMerchandising.vcFrame=self.vcFrame;
                _viewVisualMerchandising.followStore=store;
                _viewVisualMerchandising.storeInfo=_currentStoreInfo;
                _bVisualMerchandisingView=YES;
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
            }
            
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
        }];
        
        
//    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arraySearch.count==0)
    {
        _label.hidden=NO;
        
    }
    else
    {
        _label.hidden=YES;
    }
    return _arraySearch.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPVisualStoreCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPVisualStoreCell"];
    if (cell==nil)
    {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPVisualStoreCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
    }
    cell.followStore=[_arraySearch objectAtIndex:indexPath.row];
    cell.bEdit=_bEdit;
    cell.check=_btSelect.selected;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowStore *store=[_arrayFollowStore objectAtIndex:indexPath.row];
    
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        [_arrayDeleteStore addObject:store.strStoreId];
        [[RPSDK defaultInstance]DelFollowStore:_arrayDeleteStore Success:^(id idResult) {
            [self loadData];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
        }];
    }
}

-(void)OnSelectedStore:(StoreDetailInfo *)store
{
    [self dismissView:_viewStoreList];
    _bStoreList=NO;
    _storeSelected = store;
    _arrayAddStore=[[NSMutableArray alloc]init];
    [_arrayAddStore addObject:_storeSelected.strStoreId];
    
    [[RPSDK defaultInstance]AddFollowStore:_arrayAddStore Success:^(id idResult) {
        [self loadData];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
    
}
- (IBAction)OnAddStore:(id)sender
{
//    if (_btAddStore.selected)
//    {
//        if (_arrayDeleteStore.count>0)
//        {
//            NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
//            NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
//            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to delete?",@"RPString", g_bundleResorce,nil);
//            RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
//                if (indexButton == 1)
//                {
//                    [[RPSDK defaultInstance]DelFollowStore:_arrayDeleteStore Success:^(id idResult) {
//                        [self loadData];
//                    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
//                        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
//                    }];
//                    
//                    [_arrayDeleteStore removeAllObjects];
//                }
//            } otherButtonTitles:strOK,nil];
//            [alertView show];
//        }
//        else
//        {
//            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No Store Selected",@"RPString", g_bundleResorce,nil)];
//        }
//        
//    }
//    else
//    {
        _viewStoreList.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _viewStoreList.tfSearch.text=@"";
        [self addSubview:_viewStoreList];
        [UIView beginAnimations:nil context:nil];
        _viewStoreList.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _bStoreList=YES;
        [_viewStoreList reloadStore];
//    }
}

//- (IBAction)OnEdit:(id)sender
//{
//    if (_btEdit.selected)
//    {
//        [UIView beginAnimations:nil context:nil];
//        _viewSearch.frame=CGRectMake(_viewSearch.frame.origin.x, _viewSearch.frame.origin.y, _viewSearch.frame.size.width+50, _viewSearch.frame.size.height);
//        _btAddStore.selected=NO;
//        _btEdit.selected=NO;
//        [UIView commitAnimations];
//        _bEdit=NO;
//    }
//    else
//    {
//        [UIView beginAnimations:nil context:nil];
//        _viewSearch.frame=CGRectMake(_viewSearch.frame.origin.x, _viewSearch.frame.origin.y, _viewSearch.frame.size.width-50, _viewSearch.frame.size.height);
//        _btAddStore.selected=YES;
//        _btEdit.selected=YES;
//        [UIView commitAnimations];
//        _bEdit=YES;
//        
//    }
//    _btSelect.selected=NO;
//    [_arrayDeleteStore removeAllObjects];
//    [_tbStoreList reloadData];
//}

- (IBAction)OnSelectAll:(id)sender
{
    _btSelect.selected=!_btSelect.selected;
    if (_btSelect.selected)
    {
        for (int i=0; i<_arrayFollowStore.count; i++)
        {
            FollowStore *store=[_arrayFollowStore objectAtIndex:i];
            
            [_arrayDeleteStore addObject:store.strStoreId];
        }
    }
    else
    {
        [_arrayDeleteStore removeAllObjects];
    }
    [_tbStoreList reloadData];
}

- (IBAction)OnSelectStore:(id)sender
{
    
}

- (IBAction)OnSearch:(id)sender
{
    [self search:_tfSearch.text];
}

- (IBAction)OnDeleteSearch:(id)sender
{
    _tfSearch.text=@"";
    [self search:_tfSearch.text];
}
-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}
-(BOOL)OnBack
{
    if (_bVisualMerchandisingView)
    {
        if ([_viewVisualMerchandising OnBack])
        {
            [self dismissView:_viewVisualMerchandising];
            _bVisualMerchandisingView=NO;
            [self loadData];
        }
        return NO;
    }
    if (_bStoreList)
    {
        [self dismissView:_viewStoreList];
        _bStoreList=NO;
        return NO;
    }
    return YES;
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}
-(IBAction)OnQuit:(id)sender
{
    [self endEditing:YES];
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to exit?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [self.delegate endVisualStoreList];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
    
}
@end
