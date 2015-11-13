//
//  RPDSReportTableView.m
//  RetailPlus
//
//  Created by lin dong on 14-7-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPDSReportTableView.h"
#import "RPDSReportIOTableViewCell.h"
#import "RPDSReportCurrentTableViewCell.h"
#import "RPIOTotalCell.h"
#import "RPCurrentTotalCell.h"
extern NSBundle * g_bundleResorce;

@implementation RPDSReportTableView

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
    self.delegate = self;
    self.dataSource = self;
 //   UINib * nib = [UINib nibWithNibName:@"RPDSReportHeadView" bundle:nil];
 //   [self registerNib:nib forHeaderFooterViewReuseIdentifier:@"RPDSReportHeadView"];
//    [self initData];
    _bShowCurrentStock = NO;
    _detailGather = [[RPDSDetail alloc] init];
    _bOpenReport = YES;
    _bHaveDeleteAuth = YES;
}

-(void)initData
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    RPDSDetail * detail = [[RPDSDetail alloc] init];
    detail.nCurrentAmount = 80;
    detail.nLastAmount = 80;
    detail.nInAmount = 0;
    detail.nOutAmount = 0;
    detail.arrayTags = [[NSMutableArray alloc] init];
    RPDSTag * tag = [[RPDSTag alloc] init];
    tag.strTagName = @"Area A";
    [detail.arrayTags addObject:tag];
    tag = [[RPDSTag alloc] init];
    tag.strTagName = @"Man's W";
    [detail.arrayTags addObject:tag];
    
    detail.arrayCurrent = [[NSMutableArray alloc] init];
    RPDSCurrentStock * cur = [[RPDSCurrentStock alloc] init];
    cur.nCount = 99;
    cur.userInfo = [[UserDetailInfo alloc] init];
    cur.userInfo.rank = Rank_Manager;
    cur.userInfo.strFirstName = @"pop";
//    cur.userInfo.strSurName = @"Dong";
    cur.dateAdd = [NSDate date];
    [detail.arrayCurrent addObject:cur];
    
    detail.arrayIO = [[NSMutableArray alloc] init];
    RPDSIOStock * io = [[RPDSIOStock alloc] init];
    io.nCount = 9;
    io.typeIO = RPDSIOType_In;
    [detail.arrayIO addObject:io];
    
    io = [[RPDSIOStock alloc] init];
    io.nCount = 9;
    io.typeIO = RPDSIOType_Out;
    [detail.arrayIO addObject:io];
    
    detail.arrayLast = detail.arrayCurrent;
    [array addObject:detail];
    
    detail = [[RPDSDetail alloc] init];
    detail.nCurrentAmount = 0;
    detail.nLastAmount = 0;
    detail.nInAmount = 0;
    detail.nOutAmount = 10;
    detail.arrayTags = [[NSMutableArray alloc] init];
    tag = [[RPDSTag alloc] init];
    tag.strTagName = @"Area A";
    [detail.arrayTags addObject:tag];
//    tag = [[RPDSTag alloc] init];
//    tag.strTagName = @"Man's W";
//    [detail.arrayTags addObject:tag];
    
    detail.arrayCurrent = [[NSMutableArray alloc] init];
    cur = [[RPDSCurrentStock alloc] init];
    cur.nCount = 99;
    [detail.arrayCurrent addObject:cur];
    
    detail.arrayIO = [[NSMutableArray alloc] init];
    io = [[RPDSIOStock alloc] init];
    io.nCount = 2;
    io.typeIO = RPDSIOType_In;
    io.dateAdd = [NSDate date];
    io.userInfo = [[UserDetailInfo alloc] init];
    io.userInfo.rank = Rank_Manager;
    io.userInfo.strFirstName = @"pop";
//    io.userInfo.strSurName = @"Dong";
    io.strComment = @"所有继承自NSObject都有一个可回传一个class物件的classmethod。这非常近似于";
    [detail.arrayIO addObject:io];
    
    io = [[RPDSIOStock alloc] init];
    io.nCount = 3;
    io.typeIO = RPDSIOType_Out;
    [detail.arrayIO addObject:io];
    
    detail.arrayLast = detail.arrayCurrent;
    [array addObject:detail];
    
    self.arrayStockDetail = array;
    _nLastOffsetY = 0;
}

-(void)setArrayStockDetail:(NSMutableArray *)arrayStockDetail
{
    _arrayStockDetail = arrayStockDetail;
    _strGatherTag = nil;
    [self reloadData];
}

-(void)setBShowCurrentStock:(BOOL)bShowCurrentStock
{
    _bShowCurrentStock = bShowCurrentStock;
    
    if (!_bShowCurrentStock && _typeExpand == RPDSReportExpandType_Current) {
        _typeExpand = RPDSReportExpandType_NONE;
        [self reloadData];
    }
    else
    {
        for (NSInteger n = 0; n < [self numberOfSections]; n ++) {
            RPDSReportHeadView * viewHead = (RPDSReportHeadView *)[self headerViewForSection:n];
            viewHead.bShowCurrentStock = bShowCurrentStock;
        }
    }
}

-(void)setBShowInOutStock:(BOOL)bShowInOutStock
{
    _bShowInOutStock = bShowInOutStock;
    if (!_bShowInOutStock && _typeExpand == RPDSReportExpandType_IO) {
        _typeExpand = RPDSReportExpandType_NONE;
        [self reloadData];
    }
    else
    {
        for (NSInteger n = 0; n < [self numberOfSections]; n ++) {
            RPDSReportHeadView * viewHead = (RPDSReportHeadView *)[self headerViewForSection:n];
            viewHead.bShowInOutStock = bShowInOutStock;
        }
    }
}

-(void)setBShowLastStock:(BOOL)bShowLastStock
{
    _bShowLastStock = bShowLastStock;
    if (!_bShowLastStock && _typeExpand == RPDSReportExpandType_Last) {
        _typeExpand = RPDSReportExpandType_NONE;
        [self reloadData];
    }
    else
    {
        for (NSInteger n = 0; n < [self numberOfSections]; n ++) {
            RPDSReportHeadView * viewHead = (RPDSReportHeadView *)[self headerViewForSection:n];
            viewHead.bShowLastStock = bShowLastStock;
        }
    }
}

-(void)OnSelectCurrentStock:(RPDSDetail *)detail
{
    if (_detailSelect == detail && _typeExpand == RPDSReportExpandType_Current)
        _detailSelect = nil;
    else
        _detailSelect = detail;
    
    _typeExpand = RPDSReportExpandType_Current;
    [self reloadData];
}

-(void)OnSelectIOStock:(RPDSDetail *)detail
{
    if (_detailSelect == detail && _typeExpand == RPDSReportExpandType_IO)
        _detailSelect = nil;
    else
        _detailSelect = detail;
    
    _typeExpand = RPDSReportExpandType_IO;
    [self reloadData];
}

-(void)OnSelectLastStock:(RPDSDetail *)detail
{
    if (_detailSelect == detail && _typeExpand == RPDSReportExpandType_Last)
        _detailSelect = nil;
    else
        _detailSelect = detail;
    
    _typeExpand = RPDSReportExpandType_Last;
    [self reloadData];
}

-(void)OnSelectTag:(NSString *)strTag
{
    if ([_strGatherTag isEqualToString:strTag])
    {
        _strGatherTag = nil;
        [_arrayStockDetail removeObject:_detailGather];
    }
    else
    {
        [_arrayStockDetail removeObject:_detailGather];
        
        _strGatherTag = strTag;
        _detailGather.arrayTags = [[NSMutableArray alloc] init];
        _detailGather.arrayCurrent = [[NSMutableArray alloc] init];
        _detailGather.arrayIO = [[NSMutableArray alloc] init];
        _detailGather.arrayLast = [[NSMutableArray alloc] init];
        
        RPDSTag * tag = [[RPDSTag alloc] init];
        tag.strTagName = strTag;
        [_detailGather.arrayTags addObject:tag];
        _detailGather.nCurrentAmount = 0;
        _detailGather.nInAmount = 0;
        _detailGather.nOutAmount = 0;
        _detailGather.nLastAmount = 0;
        
        for (RPDSDetail * detail in _arrayStockDetail) {
            for (RPDSTag * tag in detail.arrayTags) {
                if ([tag.strTagName isEqualToString:strTag]) {
                    _detailGather.nCurrentAmount += detail.nCurrentAmount;
                    _detailGather.nInAmount += detail.nInAmount;
                    _detailGather.nOutAmount += detail.nOutAmount;
                    _detailGather.nLastAmount += detail.nLastAmount;
                    
                    [_detailGather.arrayCurrent addObjectsFromArray:detail.arrayCurrent];
                    [_detailGather.arrayIO addObjectsFromArray:detail.arrayIO];
                    [_detailGather.arrayLast addObjectsFromArray:detail.arrayLast];
                    break;
                }
            }
        }
        [_arrayStockDetail insertObject:_detailGather atIndex:0];
    }
    [self reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrayStockDetail.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RPDSDetail * detail = [_arrayStockDetail objectAtIndex:section];
    if (detail == _detailSelect) {
        switch (_typeExpand) {
            case RPDSReportExpandType_Current:
                return detail.arrayCurrent.count+1;
                break;
            case RPDSReportExpandType_IO:
                return detail.arrayIO.count+1;
                break;
            case RPDSReportExpandType_Last:
                return detail.arrayLast.count+1;
                break;
            default:
                break;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_detailSelect) {
        switch (_typeExpand) {
            case RPDSReportExpandType_Current:
            {
                if (indexPath.row==0)
                {
                    RPCurrentTotalCell*cell=[tableView dequeueReusableCellWithIdentifier:@"RPCurrentTotalCell"];
                    if (cell==nil)
                    {
                        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPCurrentTotalCell" owner:self options:nil];
                        cell=[arrayNib objectAtIndex:0];
                    }
                    cell.type=0;
                    cell.dsDetail=_detailSelect;
                    
                    return cell;
                }
                else
                {
                    RPDSReportCurrentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPDSReportCurrentTableViewCell"];
                    if (cell==nil)
                    {
                        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPDSReportCurrentTableViewCell" owner:self options:nil];
                        cell=[arrayNib objectAtIndex:0];
                    }
                    cell.stockCurrent = [_detailSelect.arrayCurrent objectAtIndex:indexPath.row-1];
                    cell.bOpenReport = _bOpenReport;
                    cell.bCurrentReport = YES;
                    return cell;
                }
                
            }
                break;
            case RPDSReportExpandType_Last:
            {
                if (indexPath.row==0)
                {
                    RPCurrentTotalCell*cell=[tableView dequeueReusableCellWithIdentifier:@"RPCurrentTotalCell"];
                    if (cell==nil)
                    {
                        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPCurrentTotalCell" owner:self options:nil];
                        cell=[arrayNib objectAtIndex:0];
                    }
                    cell.type=1;
                    cell.dsDetail=_detailSelect;
                    
                    return cell;
                }
                else
                {
                    
                        RPDSReportCurrentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPDSReportLastTableViewCell"];
                        if (cell==nil)
                        {
                            NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPDSReportCurrentTableViewCell" owner:self options:nil];
                            cell=[arrayNib objectAtIndex:0];
                        }
                        cell.stockCurrent = [_detailSelect.arrayLast objectAtIndex:indexPath.row-1];
                        cell.bOpenReport = _bOpenReport;
                        cell.bCurrentReport = NO;
                        return cell;
                    
                    
                }
                
            }
                break;
            case RPDSReportExpandType_IO:
            {
                if (indexPath.row==0)
                {
                    RPIOTotalCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPIOTotalCell"];
                    if (cell==nil)
                    {
                        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPIOTotalCell" owner:self options:nil];
                        cell=[arrayNib objectAtIndex:0];
                    }
                    cell.dsDetail=_detailSelect;
                    return cell;
                }
                else
                {
                    RPDSReportIOTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPDSReportIOTableViewCell"];
                    if (cell==nil)
                    {
                        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPDSReportIOTableViewCell" owner:self options:nil];
                        cell=[arrayNib objectAtIndex:0];
                    }
                    cell.stockIO = [_detailSelect.arrayIO objectAtIndex:indexPath.row-1];
                    
                    return cell;
                }
            }
                break;
            default:
                break;
        }
    }
    return nil;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_detailSelect) {
        switch (_typeExpand) {
            case RPDSReportExpandType_IO:
                return 50;
                break;
            case RPDSReportExpandType_Current:
                return 35;
                break;
            case RPDSReportExpandType_Last:
                return 35;
                break;
            case RPDSReportExpandType_NONE:
                return 0;
                break;
        }
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RPDSReportHeadView * view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RPDSReportHeadView"];
    if (view == nil) {
        view = [[[NSBundle mainBundle] loadNibNamed:@"RPDSReportHeadView" owner:nil options:nil] objectAtIndex:0];
        view.delegate = self;
    }
    
    RPDSDetail * detail = [_arrayStockDetail objectAtIndex:section];
    view.detail = detail;
    if (detail == _detailSelect) {
        view.typeExpand = _typeExpand;
    }
    else
        view.typeExpand = RPDSReportExpandType_NONE;
    view.strGatherTag = _strGatherTag;
    view.bShowCurrentStock = _bShowCurrentStock;
    view.bShowInOutStock = _bShowInOutStock;
    view.bShowLastStock = _bShowLastStock;
    
    if (section == 0 && _strGatherTag)
        view.bGatherMode = YES;
    else
        view.bGatherMode = NO;
    
    view.bOpenReport = self.bOpenReport;
    return view;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 47;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPDSDetail * detail = nil;
    if (_strGatherTag)
        detail = [_arrayStockDetail objectAtIndex:indexPath.section - 1];
    else
        detail = [_arrayStockDetail objectAtIndex:indexPath.section];
    
    switch (_typeExpand) {
        case RPDSReportExpandType_Current:
        {
            RPDSCurrentStock * stock = [detail.arrayCurrent objectAtIndex:indexPath.row - 1];
            [_delegateReport OnDeleteCurrentCount:stock.strCountId UserId:stock.userInfo.strUserId];
        }
            break;
        case RPDSReportExpandType_IO:
        {
            RPDSIOStock * stock = [detail.arrayIO objectAtIndex:indexPath.row - 1];
            [_delegateReport OnDeleteIOCount:stock.strCountId Type:stock.typeIO UserId:stock.userInfo.strUserId];
        }
            break;
        default:
            break;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        if (_bOpenReport) {
            if (!(indexPath.section == 0 && _strGatherTag)) {
                if (!_bHaveDeleteAuth) {
                    RPDSDetail * detail = nil;
                    if (_strGatherTag)
                        detail = [_arrayStockDetail objectAtIndex:indexPath.section - 1];
                    else
                        detail = [_arrayStockDetail objectAtIndex:indexPath.section];
                    
                    switch (_typeExpand) {
                        case RPDSReportExpandType_Current:
                        {
                            RPDSCurrentStock * stock = [detail.arrayCurrent objectAtIndex:indexPath.row];
                            if ([stock.userInfo.strUserId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId]) {
                                return UITableViewCellEditingStyleDelete;
                            }
                        }
                            break;
                        case RPDSReportExpandType_IO:
                        {
                            RPDSIOStock * stock = [detail.arrayIO objectAtIndex:indexPath.row];
                            if ([stock.userInfo.strUserId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId]) {
                                return UITableViewCellEditingStyleDelete;
                            }
                        }
                            break;
                        default:
                            break;
                    }
                    return UITableViewCellEditingStyleNone;
                }
                else
                {
                    switch (_typeExpand) {
                        case RPDSReportExpandType_Current:
                        case RPDSReportExpandType_IO:
                            return UITableViewCellEditingStyleDelete;
                            break;
                            
                        default:
                            break;
                    }
                }
            }
        }
    }
    return UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedStringFromTableInBundle(@"DELETE",@"RPString", g_bundleResorce,nil);
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _nLastOffsetY = scrollView.contentOffset.y;
    _bDraging = YES;
    _bReportDraging = NO;
    _bReportDragingUp = NO;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _bDraging = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_bDraging) {

        BOOL bCurDragingUp = NO;
        if (_nLastOffsetY < scrollView.contentOffset.y)
            bCurDragingUp = YES;
        _nLastOffsetY = scrollView.contentOffset.y;
        
        if (!_bReportDraging || (_bReportDragingUp != bCurDragingUp)) {
            [_delegateReport OnScrollReportTable:bCurDragingUp];
            
            _bReportDragingUp = bCurDragingUp;
            _bReportDraging = YES;
        }
    }
}

@end
