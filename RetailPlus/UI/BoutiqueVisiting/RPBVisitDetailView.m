//
//  RPBVisitDetailView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
#import "RPBVisitHeaderView.h"
#import "RPBVisitMarkCell.h"
#import "RPBVisitIssueCell.h"
#import "RPBVisitAddIssueCell.h"
#import "RPBVisitCategoryDescCell.h"
#import "RPBlockUISelectView.h"
#import "RPBVisitDetailView.h"
extern NSBundle * g_bundleResorce;
@implementation RPBVisitDetailView

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
    //    _tvDetail.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //    _tvDetail.separatorColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
    
    _bShowIssueView = NO;
    _viewFrame.layer.cornerRadius=10;
    CALayer * sublayer = _viewFrame.layer;
    sublayer.cornerRadius = 8;
    
    sublayer = _viewSelVendor.layer;
    sublayer.cornerRadius = 5;
    
    _viewIssue.delegate = self;
    _viewIssue.bMarkRectInImage = YES;
}

-(void)RecalcPoint
{
    float fYesAllCount = 0;
    float fNAAllCount = 0;
    float fNoAllCount = 0;
    
    for (NSInteger n = 0; n < _dataVisit.arrayCatagory.count; n ++) {
        BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:n];
        float fYesCount = 0;
        float fNACount = 0;
        float fNoCount = 0;
        
        for (NSInteger n2 = 0; n2 < category.arrayItem.count; n2 ++) {
            BVisitItem * item = [category.arrayItem objectAtIndex:n2];
            switch (item.mark) {
                case BVisitMark_EMPTY:
                case BVisitMark_NONE:
                    fNACount += item.fWeight;
                    break;
                case BVisitMark_YES:
                    fYesCount += item.fWeight;
                    break;
                case BVisitMark_NO:
                    fNoCount += item.fWeight;
                    break;
                default:
                    break;
            }
        }
        
        if ((fNACount + fYesCount + fNoCount - fNACount) == 0)
            category.fPoint = -1;
        else
            category.fPoint = ((float)fYesCount / (fNACount + fYesCount + fNoCount - fNACount) * 100);
        
        fYesAllCount += fYesCount;
        fNAAllCount += fNACount;
        fNoAllCount += fNoCount;
    }
    if ((fNAAllCount + fYesAllCount + fNoAllCount - fNAAllCount) == 0)
        _dataVisit.fPoint = -1;
    else
        _dataVisit.fPoint = ((float)fYesAllCount / (fNAAllCount + fYesAllCount + fNoAllCount - fNAAllCount) * 100);
}

-(void)updateUI
{
    NSInteger nMarkCount = 0;
    NSInteger nAllCount = 0;
    if (_dataVisit.arrayCatagory && (_nSelVendorIndex < (NSInteger)_dataVisit.arrayCatagory.count) && (_nSelVendorIndex >= 0)) {
        BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:_nSelVendorIndex];
        [_btnVendor setTitle:[NSString stringWithFormat:@"%@",category.strCategoryName] forState:UIControlStateNormal];
        
        nAllCount = category.arrayItem.count;
        for (NSInteger n = 0; n < category.arrayItem.count; n ++) {
            BVisitItem * item = [category.arrayItem objectAtIndex:n];
            if (item.mark != BVisitMark_EMPTY)
                nMarkCount ++;
        }
    }
    else
    {
        NSString * str = NSLocalizedStringFromTableInBundle(@"All Catagory",@"RPString", g_bundleResorce,nil);
        
        [_btnVendor setTitle:str forState:UIControlStateNormal];
        for (NSInteger n = 0; n < _dataVisit.arrayCatagory.count; n ++) {
            BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:n];
            nAllCount += category.arrayItem.count;
            
            for (NSInteger n2 = 0; n2 < category.arrayItem.count; n2 ++) {
                BVisitItem * item = [category.arrayItem objectAtIndex:n2];
                if (item.mark != BVisitMark_EMPTY)
                    nMarkCount ++;
            }
        }
    }
    
    _lbCount.text = [NSString stringWithFormat:@"%d/%d",nMarkCount,nAllCount];
    
    [self RecalcPoint];
    
    if (_nSelVendorIndex == -1) {
        if (_dataVisit.fPoint >= 0)
            _lbScore.text = [NSString stringWithFormat:@"%0.1f",_dataVisit.fPoint];
        else
            _lbScore.text = @"N/A";
    }
    else
    {
        BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:_nSelVendorIndex];
        
        if (category.fPoint >= 0)
            _lbScore.text = [NSString stringWithFormat:@"%0.1f",category.fPoint];
        else
            _lbScore.text = @"N/A";
    }
    
    if (nAllCount != 0) {
        //为了方便计算，_viewCountMark的origin改为左下角
        _viewCountMark.frame = CGRectMake(_viewCountMark.frame.origin.x, _viewCountAll.frame.size.height-_viewCountAll.frame.size.height*nMarkCount / nAllCount, _viewCountMark.frame.size.width , _viewCountAll.frame.size.height*nMarkCount / nAllCount);
    }
    else
    {
        _viewCountMark.frame = CGRectMake(_viewCountMark.frame.origin.x, _viewCountMark.frame.origin.y, 0, _viewCountMark.frame.size.height);
    }
    [_tvDetail reloadData];

}
-(void)setDataVisit:(BVisitData *)dataVisit
{
    _nSelVendorIndex=-1;
    _nSelCataIndex=-1;
    _dataVisit=dataVisit;
    [self updateUI];
}
-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _storeSelected=storeSelected;
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger nAllCount = 0;
    if (_dataVisit.arrayCatagory && (_nSelVendorIndex <(NSInteger)_dataVisit.arrayCatagory.count)&&(_nSelVendorIndex >= 0))
    {
        BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:_nSelVendorIndex];
        nAllCount = category.arrayItem.count;
    }
    else
    {
        
        for (NSInteger n = 0; n < _dataVisit.arrayCatagory.count; n ++) {
            BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:n];
            nAllCount += category.arrayItem.count;
        }
    }
    return nAllCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == _nSelCataIndex) {
        NSInteger nAllCount = 0;
        BVisitItem * visitItem = nil;
        
        if (_dataVisit.arrayCatagory && (_nSelVendorIndex < (NSInteger)_dataVisit.arrayCatagory.count)&&(_nSelVendorIndex >= 0))
        {
            BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:_nSelVendorIndex];
            visitItem = [category.arrayItem objectAtIndex:section];
        }
        else
        {
            
            for (NSInteger n = 0; n < _dataVisit.arrayCatagory.count; n ++) {
                BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:n];
                nAllCount += category.arrayItem.count;
                if (section < nAllCount) {
                    visitItem = [category.arrayItem objectAtIndex:section - (nAllCount - category.arrayItem.count)];
                    break;
                }
            }
        }
        
        return 2 + visitItem.arrayIssue.count;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == _nSelCataIndex) {
        
        NSInteger nAllCount = 0;
        BVisitItem * visitItem = nil;
        
        if (_dataVisit.arrayCatagory && (_nSelVendorIndex < (NSInteger)_dataVisit.arrayCatagory.count)&&(_nSelVendorIndex >= 0))
        {
            BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:_nSelVendorIndex];
            visitItem = [category.arrayItem objectAtIndex:indexPath.section];
        }
        else
        {
            
            for (NSInteger n = 0; n < _dataVisit.arrayCatagory.count; n ++) {
                BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:n];
                nAllCount += category.arrayItem.count;
                if (indexPath.section < nAllCount) {
                    visitItem = [category.arrayItem objectAtIndex:indexPath.section - (nAllCount - category.arrayItem.count)];
                    break;
                }
            }
        }
        
        if (indexPath.row == 0) {
            RPBVisitCategoryDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPBVisitCategoryDescCell"];
            if (cell == nil)
            {
//                NSArray *array = [g_bundleResorce loadNibNamed:@"RPBVisitCell" owner:self options:nil];
                NSArray *array=[[NSBundle mainBundle]loadNibNamed:@"RPBVisitCell" owner:self options:nil];
                cell = [array objectAtIndex:2];
            }
            cell.visitItem = visitItem;
            return cell;
        }
        else if (indexPath.row == 1) {
            RPBVisitMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPBVisitMarkCell"];
            if (cell == nil)
            {
                NSArray *array=[[NSBundle mainBundle]loadNibNamed:@"RPBVisitCell" owner:self options:nil];
                cell = [array objectAtIndex:1];
                cell.delegate = self;
            }
            cell.visitItem = visitItem;
            return cell;
        }
        else
        {
            RPBVisitIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPBVisitIssueCell"];
            if (cell == nil)
            {
                NSArray *array=[[NSBundle mainBundle]loadNibNamed:@"RPBVisitCell" owner:self options:nil];
                cell = [array objectAtIndex:3];
            }
            
            cell.visitItem = visitItem;
            cell.issue = (InspIssue *)[visitItem.arrayIssue objectAtIndex:(indexPath.row - 2)];
            cell.delegate = self;
            return cell;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == _nSelCataIndex) {
        
        NSInteger nAllCount = 0;
        BVisitItem * visitItem = nil;
        
        if (_dataVisit.arrayCatagory && (_nSelVendorIndex < (NSInteger)_dataVisit.arrayCatagory.count)&&(_nSelVendorIndex >= 0))
        {
            BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:_nSelVendorIndex];
            visitItem = [category.arrayItem objectAtIndex:indexPath.section];
        }
        else
        {
            
            for (NSInteger n = 0; n < _dataVisit.arrayCatagory.count; n ++) {
                BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:n];
                nAllCount += category.arrayItem.count;
                if (indexPath.section < nAllCount) {
                    visitItem = [category.arrayItem objectAtIndex:indexPath.section - (nAllCount - category.arrayItem.count)];
                    break;
                }
            }
        }
        
        if (indexPath.row == 0) {
            return [RPBVisitCategoryDescCell calcLabelHeight:visitItem.strItemDesc];
        }
        else if (indexPath.row == 1)
        {
            
            return 42;
        }
        else if (indexPath.row == (visitItem.arrayIssue.count + 2))
        {
            return 38;
        }
        else
        {
            return 38;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RPBVisitHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"RPBVisitHeaderView" owner:nil options:nil] objectAtIndex:0];
    
    NSInteger nAllCount = 0;
    BVisitItem * visitItem = nil;
    
    if (_dataVisit.arrayCatagory && (_nSelVendorIndex <(NSInteger) _dataVisit.arrayCatagory.count)&&(_nSelVendorIndex >= 0))
    {
        BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:_nSelVendorIndex];
        visitItem = [category.arrayItem objectAtIndex:section];
    }
    else
    {
        
        for (NSInteger n = 0; n < _dataVisit.arrayCatagory.count; n ++) {
            BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:n];
            nAllCount += category.arrayItem.count;
            if (section < nAllCount) {
                visitItem = [category.arrayItem objectAtIndex:section - (nAllCount - category.arrayItem.count)];
                break;
            }
        }
    }
    
    view.delegate = self;
    [view setExpand:(section == _nSelCataIndex ? YES : NO)];
    view.nIndex = section;
    view.visitItem = visitItem;
    return view;
}

#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nAllCount = 0;
   BVisitItem * visitItem = nil;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_dataVisit.arrayCatagory && (_nSelVendorIndex <(NSInteger) _dataVisit.arrayCatagory.count)&&(_nSelVendorIndex >= 0))
    {
        BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:_nSelVendorIndex];
        visitItem = [category.arrayItem objectAtIndex:indexPath.section];
    }
    else
    {
        
        for (NSInteger n = 0; n < _dataVisit.arrayCatagory.count; n ++) {
            BVisitCategory * category  = [_dataVisit.arrayCatagory objectAtIndex:n];
            nAllCount += category.arrayItem.count;
            if (indexPath.section < nAllCount) {
                visitItem = [category.arrayItem objectAtIndex:indexPath.section - (nAllCount - category.arrayItem.count)];
                break;
            }
        }
    }
    
    if (indexPath.row > 1 && indexPath.row < (visitItem.arrayIssue.count + 2)) {
        _viewIssue.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        _viewIssue.vcFrame = self.vcFrame;
        _viewIssue.arrayMap = self.dataVisit.arrayMap;
        _viewIssue.issue = (InspIssue *)[visitItem.arrayIssue objectAtIndex:(indexPath.row - 2)];
        _viewIssue.visitItem = visitItem;
        [self addSubview:_viewIssue];
        
        [UIView beginAnimations:nil context:nil];
        _viewIssue.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        
        _bShowIssueView = YES;
    }
}



//设置选择tableview的第几个header
- (void)sectionTapped:(NSInteger)nCatagoryIndex
{
    _nSelCataIndex = nCatagoryIndex;
    [self updateUI];
}

//tablecell里设置标记后更新界面
-(void)OnMark:(BVisitCategory *)catagory
{
    [self updateUI];
}

-(void)OnAddIssue:(BVisitItem *)visitItem
{
    int allIssueCount=0;
    for (NSInteger n = 0; n < _dataVisit.arrayCatagory.count; n ++) {
        BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:n];
        for (NSInteger n2 = 0; n2 < category.arrayItem.count; n2 ++) {
            BVisitItem * item = [category.arrayItem objectAtIndex:n2];
            allIssueCount=allIssueCount+item.arrayIssue.count;
        }
    }
    if (visitItem.arrayIssue.count>9)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"There can be 10 issues at the most in one problem",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    if (allIssueCount>199)
    {
        
        NSString *s=NSLocalizedStringFromTableInBundle(@"There can be 200 issues at the most in total",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    _viewIssue.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _viewIssue.vcFrame = self.vcFrame;
    
    _viewIssue.arrayMap = self.dataVisit.arrayMap;
    _viewIssue.issue = nil;
    _viewIssue.visitItem = visitItem;
    
    
    [self addSubview:_viewIssue];
    [UIView beginAnimations:nil context:nil];
    _viewIssue.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bShowIssueView = YES;
}

-(void)OnDeleteIssue:(BVisitItem *)visitItem Issue:(InspIssue *)issue
{
    [visitItem.arrayIssue removeObject:issue];
    [self updateUI];
  
    [[RPSDK defaultInstance] UpdateBVisitCacheData:self.strCacheDataId StroeId:_storeSelected.strStoreId Desc:_storeSelected.strStoreName Data:_dataVisit isNormalExit:NO];
}

-(void)DismissCommentView
{
    [UIView beginAnimations:nil context:nil];
    _viewComments.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bShowComment = NO;
}

-(void)DismissIssueView
{
    [UIView beginAnimations:nil context:nil];
    _viewIssue.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bShowIssueView = NO;
}


-(void)DismissReporterView
{
    [UIView beginAnimations:nil context:nil];
    _viewReporter.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bShowReporterView = NO;
}

-(void)OnModifyIssueEnd
{
    [self DismissIssueView];
    [self updateUI];
    [[RPSDK defaultInstance] UpdateBVisitCacheData:self.strCacheDataId StroeId:_storeSelected.strStoreId Desc:_storeSelected.strStoreName Data:_dataVisit isNormalExit:NO];
}

-(void)OnDeleteIssue
{
//    if (_bInspectReport) {
        [[RPSDK defaultInstance] UpdateBVisitCacheData:self.strCacheDataId StroeId:_storeSelected.strStoreId Desc:_storeSelected.strStoreName Data:_dataVisit isNormalExit:NO];
//    }
    
    [self DismissIssueView];
    [self updateUI];
}

-(BOOL)OnBack
{
    [[RPSDK defaultInstance] UpdateBVisitCacheData:self.strCacheDataId StroeId:_storeSelected.strStoreId Desc:_storeSelected.strStoreName Data:_dataVisit isNormalExit:YES];
    
    if (_bShowComment)
    {
        if ([_viewComments OnBack])
            [self DismissCommentView];
        return NO;
    }
    
    if (_bShowIssueView) {
        if ([_viewIssue OnBack]) {
            [self DismissIssueView];
        }
        return NO;
    }
    if (_bShowReporterView) {
        if ([_viewReporter OnBack]) {
            [self DismissReporterView];
        }
        return NO;
    }
    
    NSString * str = NSLocalizedStringFromTableInBundle(@"Saved",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showSuccessWithStatus:str];
    
    return YES;
}

-(IBAction)OnSelectVendor:(id)sender
{
    //    NSInteger nMaxCount = (self.dataInsp.arrayInsp.count + 1) > 7 ? 7 : (self.dataInsp.arrayInsp.count + 1);
    //
    //    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, _viewSelVendor.frame.size.width, 42 * nMaxCount)];
    //    listView.datasource = self;
    //    listView.delegate = self;
    //    [listView show:CGPointMake(137,105 + 21 * nMaxCount)];
    
    
    
    NSMutableArray *strArray=[[NSMutableArray alloc]init];
    for (int i=0; i<self.dataVisit.arrayCatagory.count+1;i++)
    {
        NSInteger nMarkCount = 0;
        NSInteger nAllCount = 0;
        if (_dataVisit.arrayCatagory&& i>0)
        {
            BVisitCategory * category= [_dataVisit.arrayCatagory objectAtIndex:i-1];
            nAllCount = category.arrayItem.count;
            for (NSInteger n = 0; n < category.arrayItem.count; n ++)
            {
                BVisitItem * visitItem = [category.arrayItem objectAtIndex:n];
                if (visitItem.mark != BVisitMark_EMPTY)
                    nMarkCount ++;
            }
        }
        else
        {
            for (NSInteger n = 0; n < _dataVisit.arrayCatagory.count; n ++)
            {
                BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:n];
                nAllCount += category.arrayItem.count;
                
                for (NSInteger n2 = 0; n2 < category.arrayItem.count; n2 ++)
                {
                    BVisitItem * visitItem = [category.arrayItem objectAtIndex:n2];
                    if (visitItem.mark != BVisitMark_EMPTY)
                        nMarkCount ++;
                }
            }
        }
        
        
        NSString * strCount = [NSString stringWithFormat:@"%d/%d",nMarkCount,nAllCount];
        
        
        if (i == 0) {
            NSString * str = NSLocalizedStringFromTableInBundle(@"All Catagory",@"RPString", g_bundleResorce,nil);
            NSString *strTemp = [NSString stringWithFormat:@"%@(%@)",str,strCount];
            
            [strArray addObject:strTemp];
        }
        else
        {
            NSString *strTemp = [NSString stringWithFormat:@"%@ (%@)",((BVisitCategory *)[self.dataVisit.arrayCatagory objectAtIndex:i - 1]).strCategoryName,strCount];
            [strArray addObject:strTemp];
        }
        
    }
    
    
    
    NSString *strDesc=NSLocalizedStringFromTableInBundle(@"CATEGORY",@"RPString", g_bundleResorce,nil);
    
    RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:strDesc clickButton:^(NSInteger indexButton) {
        _nSelVendorIndex = indexButton - 1;
        [self updateUI];
    } curIndex:_nSelVendorIndex + 1 selectTitles:strArray];
    [selectView show];
    
}

#pragma mark -
//进入评论界面
-(void)onComments
{
    _viewComments.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _viewComments.dataVisit = self.dataVisit;
    _viewComments.delegate = self;
    [self addSubview:_viewComments];
    [UIView beginAnimations:nil context:nil];
    _viewComments.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bShowComment = YES;
}
-(IBAction)OnSend:(id)sender
{
    NSInteger nMarkCount = 0;
    NSInteger nAllCount = 0;
    
        for (NSInteger n = 0; n < _dataVisit.arrayCatagory.count; n ++) {
            BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:n];
            nAllCount += category.arrayItem.count;
            
            for (NSInteger n2 = 0; n2 < category.arrayItem.count; n2 ++) {
                BVisitItem * item = [category.arrayItem objectAtIndex:n2];
                if (item.mark != BVisitMark_EMPTY)
                    nMarkCount ++;
            }
        }
    
    if (nMarkCount!=nAllCount)
    {
        NSString * strOK = NSLocalizedStringFromTableInBundle(@"YES",@"RPString", g_bundleResorce,nil);
        NSString * strNO = NSLocalizedStringFromTableInBundle(@"NO,KEEP THEM EMPTY",@"RPString", g_bundleResorce,nil);
        NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"There are still some Items not checked. Do you want to mark them as N/A",@"RPString", g_bundleResorce,nil);
        RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
            if (indexButton==1)
            {
                
               
                for (NSInteger n = 0; n < _dataVisit.arrayCatagory.count; n ++) {
                    BVisitCategory * category = [_dataVisit.arrayCatagory objectAtIndex:n];
                   
                    
                    for (NSInteger n2 = 0; n2 < category.arrayItem.count; n2 ++) {
                        BVisitItem * item = [category.arrayItem objectAtIndex:n2];
                        if (item.mark == BVisitMark_EMPTY)
                           item.mark=BVisitMark_NONE;
                    }
                }
              
                [self updateUI];
                [self onComments];
            }
            else if(indexButton==2)
            {
                [self updateUI];
                [self onComments];
            }
        }otherButtonTitles:strOK,strNO, nil];
        [alertView show];
    }
    else
    {
        [self onComments];
    }
    
}
-(void)SubmitBVisit
{
    NSString * str = NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showWithStatus:str];
//    if (_dataVisit.nStatus==0)
//    {
//        NSString *s=@"未完成";
//        _dataVisit.strTitle=[NSString stringWithFormat:@"%@(%@)",_dataVisit.strTitle,s];
//    }
//    else
//    {
//        
//    }
    [[RPSDK defaultInstance]SubmitBVisit:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataVisit Success:^(NSString* reportId) {
        [[RPSDK defaultInstance] ClearCacheDataById:_strCacheDataId];
        NSString * str = NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showSuccessWithStatus:str];
//        NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
//        NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
//        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"马上针对问题分配任务？",@"RPString", g_bundleResorce,nil);
//        RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
//            if (indexButton==1) {
//                [self.delegate OnGoTask:@"123"];
//            }
//            else
//            {
        [self.delegate OnVisitEnd:reportId];
//            }
//        }otherButtonTitles:strOK, nil];
//        [alertView show];
        
        
        
        
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        if (nErrorCode == RPSDKError_SubmitAddToCache) {
            [self.delegate OnVisitEnd:nil];
        }
    }];
}
-(void)OnEndAddUser:(InspReporters *)reporters
{

    [self DismissReporterView];
    
    _dataVisit.reporters = reporters;
    
    NetworkStatus networkStatus=[RPSDK GetConnectionStatus];
    switch (networkStatus)
    {
        case NotReachable:
        {
            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Network not found",@"RPString", g_bundleResorce,nil);
            [SVProgressHUD showErrorWithStatus:strDesc];
            break;
        }
        case ReachableViaWiFi:
        {
            [self SubmitBVisit];
            break;
        }
        case ReachableViaWWAN:
        {
            NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
            NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"No WLAN connection. Confirm to upload now?",@"RPString", g_bundleResorce,nil);
            RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
                if (indexButton==1) {
                    [self SubmitBVisit];
                }
            }otherButtonTitles:strOK, nil];
            [alertView show];
            
            break;
        }
        default:
            break;
    }
}

-(IBAction)OnCache:(id)sender
{
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Current data will be erased!\r\nConfirm to exit Boutique Visit?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [[RPSDK defaultInstance] UpdateBVisitCacheData:self.strCacheDataId StroeId:_storeSelected.strStoreId Desc:_storeSelected.strStoreName Data:_dataVisit isNormalExit:YES];
            [self.delegate OnVisitEnd:nil];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
}

-(void)OnAddCommentsEnd
{
    
    _viewComments.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _bShowComment = NO;
    
    _viewReporter.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewReporter];
    
    _viewReporter.reporters = _dataVisit.reporters;
    _viewReporter.nState=_dataVisit.nStatus;
    NSString * str = NSLocalizedStringFromTableInBundle(@"Report Delivering",@"RPString", g_bundleResorce,nil);
    _viewReporter.strTitle = str;
    _viewReporter.delegate = self;
    [UIView beginAnimations:nil context:nil];
    _viewReporter.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bShowReporterView = YES;
}

-(void)OnQuitComments
{
//    [self DismissCommentView];
    [self OnCache:nil];
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}
@end
