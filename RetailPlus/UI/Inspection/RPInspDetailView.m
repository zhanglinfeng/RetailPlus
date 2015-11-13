//
//  RPInspDetailView.m
//  RetailPlus
//
//  Created by lin dong on 13-8-19.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
#import "ZSYPopoverListView.h"
#import "RPInspDetailView.h"
#import "RPInspHeaderView.h"
#import "RPInspMarkCell.h"
#import "RPInspIssueCell.h"
#import "RPInspAddIssueCell.h"
#import "RPinspCategoryDescCell.h"
#import "RPBlockUISelectView.h"
extern NSBundle * g_bundleResorce;

@implementation RPInspDetailView

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
    
    CALayer * sublayer = _viewFrame.layer;
    sublayer.cornerRadius = 8;
    
    sublayer = _viewSelVendor.layer;
    sublayer.cornerRadius = 5;
    
    _viewIssue.delegate = self;
    _viewIssue.bMarkRectInImage = YES;
}

-(void)updateUI
{
    NSInteger nMarkCount = 0;
    NSInteger nAllCount = 0;
    
    if (_dataInsp.arrayInsp && (_nSelVendorIndex < _dataInsp.arrayInsp.count)) {
        InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:_nSelVendorIndex];
        [_btnVendor setTitle:[NSString stringWithFormat:@"%@:%@",vendor.strAssetType,vendor.strVendorName] forState:UIControlStateNormal];
        
        nAllCount = vendor.arrayCatagory.count;
        for (NSInteger n = 0; n < vendor.arrayCatagory.count; n ++) {
            InspCatagory * category = [vendor.arrayCatagory objectAtIndex:n];
            if (category.markCatagory != MARK_NONE)
                nMarkCount ++;
        }
    }
    else
    {
        NSString * str = NSLocalizedStringFromTableInBundle(@"All Catagory",@"RPString", g_bundleResorce,nil);
        
        [_btnVendor setTitle:str forState:UIControlStateNormal];
        for (NSInteger n = 0; n < _dataInsp.arrayInsp.count; n ++) {
            InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:n];
            nAllCount += vendor.arrayCatagory.count;
            
            for (NSInteger n2 = 0; n2 < vendor.arrayCatagory.count; n2 ++) {
                InspCatagory * category = [vendor.arrayCatagory objectAtIndex:n2];
                if (category.markCatagory != MARK_NONE)
                    nMarkCount ++;
            }
        }
    }
    
    _lbCount.text = [NSString stringWithFormat:@"%d/%d",nMarkCount,nAllCount];
    if (nAllCount != 0) {
        _viewCountMark.frame = CGRectMake(_viewCountMark.frame.origin.x, _viewCountMark.frame.origin.y, _viewCountAll.frame.size.width * nMarkCount / nAllCount, _viewCountMark.frame.size.height);
    }
    else
    {
        _viewCountMark.frame = CGRectMake(_viewCountMark.frame.origin.x, _viewCountMark.frame.origin.y, 0, _viewCountMark.frame.size.height);
    }
    [_tvDetail reloadData];
    [_pickVendor reloadAllComponents];
}

-(void)setDataInsp:(InspData *)dataInsp
{
    _nSelVendorIndex = -1;
    _dataInsp = dataInsp;
    [self updateUI];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger nAllCount = 0;
    if (_dataInsp.arrayInsp && (_nSelVendorIndex < _dataInsp.arrayInsp.count))
    {
        InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:_nSelVendorIndex];
        nAllCount = vendor.arrayCatagory.count;
    }
    else
    {
        
        for (NSInteger n = 0; n < _dataInsp.arrayInsp.count; n ++) {
            InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:n];
            nAllCount += vendor.arrayCatagory.count;
        }
    }
    return nAllCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == _nSelCataIndex) {
        NSInteger nAllCount = 0;
        InspCatagory * category = nil;
        
        if (_dataInsp.arrayInsp && (_nSelVendorIndex < _dataInsp.arrayInsp.count))
        {
            InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:_nSelVendorIndex];
            category = [vendor.arrayCatagory objectAtIndex:section];
        }
        else
        {
            
            for (NSInteger n = 0; n < _dataInsp.arrayInsp.count; n ++) {
                InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:n];
                nAllCount += vendor.arrayCatagory.count;
                if (section < nAllCount) {
                    category = [vendor.arrayCatagory objectAtIndex:section - (nAllCount - vendor.arrayCatagory.count)];
                    break;
                }
            }
        }
        
        return 3 + category.arrayIssue.count;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == _nSelCataIndex) {
        
        NSInteger nAllCount = 0;
        InspCatagory * category = nil;
        
        if (_dataInsp.arrayInsp && (_nSelVendorIndex < _dataInsp.arrayInsp.count))
        {
            InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:_nSelVendorIndex];
            category = [vendor.arrayCatagory objectAtIndex:indexPath.section];
        }
        else
        {
            
            for (NSInteger n = 0; n < _dataInsp.arrayInsp.count; n ++) {
                InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:n];
                nAllCount += vendor.arrayCatagory.count;
                if (indexPath.section < nAllCount) {
                    category = [vendor.arrayCatagory objectAtIndex:indexPath.section - (nAllCount - vendor.arrayCatagory.count)];
                    break;
                }
            }
        }
        
        if (indexPath.row == 0) {
            RPinspCategoryDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPinspCategoryDescCell"];
            if (cell == nil)
            {
                NSArray *array = [g_bundleResorce loadNibNamed:@"RPInspCell" owner:self options:nil];
                cell = [array objectAtIndex:4];
            }
            cell.category = category;
            return cell;
        }
        else if (indexPath.row == 1) {
            RPInspMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPInspMarkCell"];
            if (cell == nil)
            {
                NSArray *array = [g_bundleResorce loadNibNamed:@"RPInspCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
                cell.delegate = self;
            }
            cell.catagory = category;
            return cell;
        }
        else if (indexPath.row == (category.arrayIssue.count + 2))
        {
            RPInspAddIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPInspAddIssueCell"];
            if (cell == nil)
            {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPInspCell" owner:self options:nil];
                cell = [array objectAtIndex:2];
            }
            cell.catagory = category;
            cell.delegate = self;
            return cell;
        }
        else
        {
            RPInspIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPInspIssueCell"];
            if (cell == nil)
            {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPInspCell" owner:self options:nil];
                cell = [array objectAtIndex:1];
            }
            
            cell.category = category;
            cell.issue = (InspIssue *)[category.arrayIssue objectAtIndex:(indexPath.row - 2)];
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
        InspCatagory * category = nil;
        
        if (_dataInsp.arrayInsp && (_nSelVendorIndex < _dataInsp.arrayInsp.count))
        {
            InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:_nSelVendorIndex];
            category = [vendor.arrayCatagory objectAtIndex:indexPath.section];
        }
        else
        {
            
            for (NSInteger n = 0; n < _dataInsp.arrayInsp.count; n ++) {
                InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:n];
                nAllCount += vendor.arrayCatagory.count;
                if (indexPath.section < nAllCount) {
                    category = [vendor.arrayCatagory objectAtIndex:indexPath.section - (nAllCount - vendor.arrayCatagory.count)];
                    break;
                }
            }
        }
        
        if (indexPath.row == 0) {
           return 60;
        }
        else if (indexPath.row == 1)
        {
            return 38;
        }
        else if (indexPath.row == (category.arrayIssue.count + 2))
        {
            return 45;
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
    RPInspHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"RPInspHeaderView" owner:nil options:nil] objectAtIndex:0];
    
    NSInteger nAllCount = 0;
    InspCatagory * category = nil;
    
    if (_dataInsp.arrayInsp && (_nSelVendorIndex < _dataInsp.arrayInsp.count))
    {
        InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:_nSelVendorIndex];
        category = [vendor.arrayCatagory objectAtIndex:section];
    }
    else
    {
        
        for (NSInteger n = 0; n < _dataInsp.arrayInsp.count; n ++) {
            InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:n];
            nAllCount += vendor.arrayCatagory.count;
            if (section < nAllCount) {
                category = [vendor.arrayCatagory objectAtIndex:section - (nAllCount - vendor.arrayCatagory.count)];
                break;
            }
        }
    }
    
    view.delegate = self;
    [view setExpand:(section == _nSelCataIndex ? YES : NO)];
    view.nIndex = section;
    view.category = category;
    return view;
}

#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nAllCount = 0;
    InspCatagory * category = nil;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_dataInsp.arrayInsp && (_nSelVendorIndex < _dataInsp.arrayInsp.count))
    {
        InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:_nSelVendorIndex];
        category = [vendor.arrayCatagory objectAtIndex:indexPath.section];
    }
    else
    {
        
        for (NSInteger n = 0; n < _dataInsp.arrayInsp.count; n ++) {
            InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:n];
            nAllCount += vendor.arrayCatagory.count;
            if (indexPath.section < nAllCount) {
                category = [vendor.arrayCatagory objectAtIndex:indexPath.section - (nAllCount - vendor.arrayCatagory.count)];
                break;
            }
        }
    }
    
    if (indexPath.row > 1 && indexPath.row < (category.arrayIssue.count + 2)) {
        _viewIssue.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        _viewIssue.vcFrame = self.vcFrame;
        _viewIssue.strShopMapUrl = self.dataInsp.strImgShopUrl;
        _viewIssue.issue = (InspIssue *)[category.arrayIssue objectAtIndex:(indexPath.row - 2)];
        _viewIssue.catagory = category;
        [self addSubview:_viewIssue];
        
        [UIView beginAnimations:nil context:nil];
        _viewIssue.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        
        _bShowIssueView = YES;
    }
}

#pragma mark -UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataInsp.arrayInsp.count + 1;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (row >= self.dataInsp.arrayInsp.count) {
        return @"ALL";
    }
    else
        return ((InspVendor *)[self.dataInsp.arrayInsp objectAtIndex:row]).strVendorName;
}

#pragma mark -UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _nSelVendorIndex = row;
    
    [self updateUI];
    [self endEditing:YES];
}

- (void)sectionTapped:(NSInteger)nCatagoryIndex
{
    _nSelCataIndex = nCatagoryIndex;
    [self updateUI];
}

-(void)OnMark:(InspCatagory *)catagory
{
    [self updateUI];
}

-(void)OnAddIssue:(InspCatagory *)catagory
{
    int allIssueCount=0;
    for (NSInteger n = 0; n < _dataInsp.arrayInsp.count; n ++) {
        InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:n];
        for (NSInteger n2 = 0; n2 < vendor.arrayCatagory.count; n2 ++) {
            InspCatagory * item = [vendor.arrayCatagory objectAtIndex:n2];
            allIssueCount=allIssueCount+item.arrayIssue.count;
        }
    }
    if (catagory.arrayIssue.count>9)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"There can be 10 issues at the most in one problem",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    if (allIssueCount>199) {
        NSString *s=NSLocalizedStringFromTableInBundle(@"There can be 200 issues at the most in total",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    _viewIssue.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _viewIssue.vcFrame = self.vcFrame;
    
    _viewIssue.strShopMapUrl = self.dataInsp.strImgShopUrl;
    _viewIssue.issue = nil;
    _viewIssue.catagory = catagory;
    
    
    [self addSubview:_viewIssue];
    
    [UIView beginAnimations:nil context:nil];
    _viewIssue.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _bShowIssueView = YES;
}

-(void)OnDeleteIssue:(InspCatagory *)catagory Issue:(InspIssue *)issue
{
    [catagory.arrayIssue removeObject:issue];
    [self updateUI];
    
    if (_bInspectReport) {
        [[RPSDK defaultInstance] SaveInspCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataInsp isNormalExit:NO];
    }
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
    
    if (_bInspectReport) {
        [[RPSDK defaultInstance] SaveInspCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataInsp isNormalExit:NO];
    }
}

-(void)OnDeleteIssue
{
    if (_bInspectReport) {
        [[RPSDK defaultInstance] SaveInspCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataInsp isNormalExit:NO];
    }
    
    [self DismissIssueView];
    [self updateUI];
}

-(BOOL)OnBack
{
    if (_bShowComment)
    {
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
    
    if (_bInspectReport) {
        [[RPSDK defaultInstance] SaveInspCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataInsp isNormalExit:NO];
    }
    else
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Current data will be erased!\r\nConfirm to exit?",@"RPString", g_bundleResorce,nil);
        NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
        NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1) {
                [self.delegate OnRectifyEnd];
            }
        } otherButtonTitles:strOK,nil];
        [alertView show];
        return NO;
    }
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
    for (int i=0; i<self.dataInsp.arrayInsp.count+1;i++)
    {
        NSInteger nMarkCount = 0;
        NSInteger nAllCount = 0;
        if (_dataInsp.arrayInsp&& i>0)
        {
            InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:i-1];
            nAllCount = vendor.arrayCatagory.count;
            for (NSInteger n = 0; n < vendor.arrayCatagory.count; n ++)
            {
                InspCatagory * category = [vendor.arrayCatagory objectAtIndex:n];
                if (category.markCatagory != MARK_NONE)
                    nMarkCount ++;
            }
        }
        else
        {
            for (NSInteger n = 0; n < _dataInsp.arrayInsp.count; n ++)
            {
                InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:n];
                nAllCount += vendor.arrayCatagory.count;
                
                for (NSInteger n2 = 0; n2 < vendor.arrayCatagory.count; n2 ++)
                {
                    InspCatagory * category = [vendor.arrayCatagory objectAtIndex:n2];
                    if (category.markCatagory != MARK_NONE)
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
            NSString *strTemp = [NSString stringWithFormat:@"%@:%@ (%@)",((InspVendor *)[self.dataInsp.arrayInsp objectAtIndex:i - 1]).strAssetType,((InspVendor *)[self.dataInsp.arrayInsp objectAtIndex:i - 1]).strVendorName,strCount];
            [strArray addObject:strTemp];
        }
        
    }
    
    
    
    NSString *mode=NSLocalizedStringFromTableInBundle(@"CATEGORY",@"RPString", g_bundleResorce,nil);
   
    RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:mode clickButton:^(NSInteger indexButton) {
        _nSelVendorIndex = indexButton - 1;
        [self updateUI];
    } curIndex:_nSelVendorIndex + 1 selectTitles:strArray];
    [selectView show];
    
}

#pragma mark -
//- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.dataInsp.arrayInsp.count + 1;
//}
//
//- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identifier = @"VendorCellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
//    
//    
//    NSInteger nMarkCount = 0;
//    NSInteger nAllCount = 0;
//    
//    if (_dataInsp.arrayInsp && (indexPath.row > 0)) {
//        InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:indexPath.row - 1];
//   //     [_btnVendor setTitle:vendor.strVendorName forState:UIControlStateNormal];
//        
//        nAllCount = vendor.arrayCatagory.count;
//        for (NSInteger n = 0; n < vendor.arrayCatagory.count; n ++) {
//            InspCatagory * category = [vendor.arrayCatagory objectAtIndex:n];
//            if (category.markCatagory != MARK_NONE)
//                nMarkCount ++;
//        }
//    }
//    else
//    {
//   //     [_btnVendor setTitle:@"ALL" forState:UIControlStateNormal];
//        for (NSInteger n = 0; n < _dataInsp.arrayInsp.count; n ++) {
//            InspVendor * vendor = [_dataInsp.arrayInsp objectAtIndex:n];
//            nAllCount += vendor.arrayCatagory.count;
//            
//            for (NSInteger n2 = 0; n2 < vendor.arrayCatagory.count; n2 ++) {
//                InspCatagory * category = [vendor.arrayCatagory objectAtIndex:n2];
//                if (category.markCatagory != MARK_NONE)
//                    nMarkCount ++;
//            }
//        }
//    }
//    
//    NSString * strCount = [NSString stringWithFormat:@"%d/%d",nMarkCount,nAllCount];
//    
//    if (nil == cell)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    
//    if (indexPath.row == 0) {
//        NSString * str = NSLocalizedStringFromTableInBundle(@"All Catagory",@"RPString", g_bundleResorce,nil);
//        cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",str,strCount];
//    }
//    else
//    {
//        cell.textLabel.text = [NSString stringWithFormat:@"%@:%@ (%@)",((InspVendor *)[self.dataInsp.arrayInsp objectAtIndex:indexPath.row - 1]).strAssetType,((InspVendor *)[self.dataInsp.arrayInsp objectAtIndex:indexPath.row - 1]).strVendorName,strCount];
//    }
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
//    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
//    return cell;
//}
//
//- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   
//}
//
//- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    _nSelVendorIndex = indexPath.row - 1;
//    [self updateUI];
//    
//    [tableView dismiss];
//}

-(IBAction)OnSend:(id)sender
{
    if (self.bInspectReport)
    {
        _viewComments.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        _viewComments.dataInsp = self.dataInsp;
        _viewComments.storeSelected=self.storeSelected;
        _viewComments.delegate = self;
        [self addSubview:_viewComments];
        [UIView beginAnimations:nil context:nil];
        _viewComments.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _bShowComment = YES;
    }
    else
    {
        _viewReporter.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [self addSubview:_viewReporter];
        self.dataInsp.reporters = [[InspReporters alloc] init];
        self.dataInsp.reporters.arraySection = [[NSMutableArray alloc] init];
        BOOL bHasIssue = NO;
        
        for (InspVendor * vendor in self.dataInsp.arrayInsp) {
            for (InspCatagory * category in vendor.arrayCatagory)
            {
                if (category.arrayIssue.count > 0) {
                    bHasIssue = YES;
                    BOOL bFound = NO;
                    for (InspReporterSection * sec in self.dataInsp.reporters.arraySection) {
                        if ([sec.strVendorID isEqualToString:vendor.strVendorID]) {
                            bFound = YES;
                            break;
                        }
                    }
                    if (!bFound) {
                        for (InspReporterSection * sec in _repRectify.arraySection) {
                            if ([sec.strVendorID isEqualToString:vendor.strVendorID]) {
                                [self.dataInsp.reporters.arraySection addObject:sec];
                                break;
                            }
                        }
                    }
                    break;
                }
            }
        }
        
        if (!bHasIssue) {
            NSString * str = NSLocalizedStringFromTableInBundle(@"No issues exist",@"RPString", g_bundleResorce,nil);
            [SVProgressHUD showErrorWithStatus:str];
            return;
        }
        
        _viewReporter.reporters = self.dataInsp.reporters;
        if (self.bInspectReport) {
            NSString * str = NSLocalizedStringFromTableInBundle(@"Created Inspection Reports",@"RPString", g_bundleResorce,nil);
            _viewReporter.strTitle = str;
        }
        else
        {
            NSString * str = NSLocalizedStringFromTableInBundle(@"Created Rectifying Reports",@"RPString", g_bundleResorce,nil);
            
            _viewReporter.strTitle = [NSString stringWithFormat:@"%@(%d)",str,_dataInsp.arrayInsp.count];
        }
        _viewReporter.delegate = self;
        [UIView beginAnimations:nil context:nil];
        _viewReporter.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _bShowReporterView = YES;
    }
}



-(void)SubmitInsp
{
    NSString * str = NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showWithStatus:str];
    
    [[RPSDK defaultInstance] SubmitInsp:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataInsp Success:^(id dictResult) {
        [[RPSDK defaultInstance] ClearCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_INSPECTION];
        [SVProgressHUD dismiss];
        [self.delegate OnInspEnd];
        NSString * str = NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showSuccessWithStatus:str];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        if (nErrorCode == RPSDKError_SubmitAddToCache) {
            [self.delegate OnInspEnd];
        }
    }];
}

-(void)SubmitRectification
{
    NSString * str = NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showWithStatus:str];
    
    [[RPSDK defaultInstance] SubmitRectification:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataInsp Success:^(id dictResult) {
        [SVProgressHUD dismiss];
        [self.delegate OnInspEnd];
        NSString * str = NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showSuccessWithStatus:str];
        
    }Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        if (nErrorCode == RPSDKError_SubmitAddToCache) {
            [self.delegate OnInspEnd];
        }
    }];
}

-(void)OnEndAddUser:(InspReporters *)reporters
{
    [self DismissReporterView];

    _dataInsp.reporters = reporters;
    
    if (!_bInspectReport) {
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
                [self SubmitRectification];
                break;
            }
            case ReachableViaWWAN:
            {
                NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
                NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
                NSString * strDesc = NSLocalizedStringFromTableInBundle(@"No WLAN connection. Confirm to upload now?",@"RPString", g_bundleResorce,nil);
                RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
                    if (indexButton==1) {
                        [self SubmitRectification];
                    }
                }otherButtonTitles:strOK, nil];
                [alertView show];
                
                break;
            }
            default:
                break;
        }
    }
    else
    {
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
                [self SubmitInsp];
                break;
            }
            case ReachableViaWWAN:
            {
                NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
                NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
                NSString * strDesc = NSLocalizedStringFromTableInBundle(@"No WLAN connection. Confirm to upload now?",@"RPString", g_bundleResorce,nil);
                RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
                    if (indexButton==1) {
                        [self SubmitInsp];
                    }
                }otherButtonTitles:strOK, nil];
                [alertView show];
                
                break;
            }
            default:
                break;
        }
    }
}

-(IBAction)OnCache:(id)sender
{
    if (_bInspectReport) {
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Current data will be erased!\r\nConfirm to exit boutique handover?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);

    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [[RPSDK defaultInstance] SaveInspCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataInsp isNormalExit:YES];
            [self.delegate OnInspEnd];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
        
    }
    else
    {
        [self.delegate OnInspEnd];
    }
    
//    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Current data will be erased!\r\nConfirm to exit boutique handover?",@"RPString", g_bundleResorce,nil);
//    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
//    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
//    
//    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
//        if (indexButton == 1) {
//            [self.delegate OnInspEnd];
//        }
//    } otherButtonTitles:strOK,nil];
//    [alertView show];
    
    
}

-(void)OnAddCommentsEnd
{
    _viewComments.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _bShowComment = NO;
    
    _viewReporter.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewReporter];
    
    _viewReporter.reporters = self.dataInsp.reporters;
    NSString * str = NSLocalizedStringFromTableInBundle(@"Created Inspection Reports",@"RPString", g_bundleResorce,nil);
    _viewReporter.strTitle = str;
    _viewReporter.delegate = self;
    [UIView beginAnimations:nil context:nil];
    _viewReporter.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bShowReporterView = YES;
}

-(void)OnQuitComments
{
    [self DismissCommentView];
    [self OnCache:nil];
}

-(void)setBInspectReport:(BOOL)bInspectReport
{
    _bInspectReport = bInspectReport;
    if (_bInspectReport) {
        [_btnOk setImage:[UIImage imageNamed:@"Icon_check_big.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnOk setImage:[UIImage imageNamed:@"button_donereport_01.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)OnHelp:(id)sender
{
   [RPGuide ShowGuide:self];
}
@end
