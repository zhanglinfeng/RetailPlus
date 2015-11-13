//
//  RPMaintenIssueView.m
//  RetailPlus
//
//  Created by lin dong on 13-9-16.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "RPMaintenIssueView.h"
#import "ZSYPopoverListView.h"
#import "RPBlockUISelectView.h"
extern NSBundle * g_bundleResorce;

@implementation RPMaintenIssueView

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
    _btnVendor.layer.cornerRadius = 6;
    _btnVendor.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnVendor.layer.borderWidth = 1;
    
    [super awakeFromNib];
    
    _nScrollHeightExShopMap = 410;
    
    _btnVendor.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnVendor.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    _curIndex = -1;
}

-(IBAction)OnSelectVendor:(id)sender
{
    [self endEditing:YES];
    
//    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, _btnVendor.frame.size.width, 42*_arrayVendor.count)];
//    listView.datasource = self;
//    listView.delegate = self;
//    [listView show:CGPointMake(208,165 + 21 * _arrayVendor.count - _scollFrame.contentOffset.y)];
    
    
    NSMutableArray *strArray=[[NSMutableArray alloc]init];
    for (int i=0; i<_arrayVendor.count;i++)
    {
        NSString *strTemp = [NSString  stringWithFormat:@"%@:%@",((Vendor *)[_arrayVendor objectAtIndex:i]).strAssetType,((InspVendor *)[_arrayVendor objectAtIndex:i]).strVendorName];
        [strArray addObject:strTemp];
    }
    
    
    
    NSString *mode=NSLocalizedStringFromTableInBundle(@"CATEGORY",@"RPString", g_bundleResorce,nil);
    
    RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:mode clickButton:^(NSInteger indexButton) {
        if (indexButton > -1) {
            self.issue.strVendorType = ((Vendor *)[_arrayVendor objectAtIndex:indexButton]).strAssetType;
            self.issue.strVendorName = ((Vendor *)[_arrayVendor objectAtIndex:indexButton]).strVendorName;
            self.issue.strVendorID = ((Vendor *)[_arrayVendor objectAtIndex:indexButton]).strVendorID;
            _curIndex=indexButton;
            [self UpdateUI];
        }
    } curIndex:_curIndex  selectTitles:strArray];
    [selectView show];

    
}

-(void)setIssue:(InspIssue *)issue
{
    [super setIssue:issue];
    for (Vendor * vendor in _arrayVendor) {
        if ([issue.strVendorID isEqualToString:vendor.strVendorID])
        {
            self.issue.strVendorType = vendor.strAssetType;
            self.issue.strVendorName = vendor.strVendorName;
            self.issue.strVendorID = vendor.strVendorID;
            
            [self UpdateUI];
            break;
        }
    }
}

#pragma mark -
//- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _arrayVendor.count;
//}
//
//- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identifier = @"VendorCellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    cell.textLabel.text = [NSString  stringWithFormat:@"%@:%@",((Vendor *)[_arrayVendor objectAtIndex:indexPath.row]).strAssetType,((InspVendor *)[_arrayVendor objectAtIndex:indexPath.row]).strVendorName];
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
//    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
//    cell.textLabel.adjustsFontSizeToFitWidth = YES;
//    return cell;
//}
//
//-(void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//
//- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.issue.strVendorType = ((Vendor *)[_arrayVendor objectAtIndex:indexPath.row]).strAssetType;
//    self.issue.strVendorName = ((Vendor *)[_arrayVendor objectAtIndex:indexPath.row]).strVendorName;
//    self.issue.strVendorID = ((Vendor *)[_arrayVendor objectAtIndex:indexPath.row]).strVendorID;
//    
//    [self UpdateUI];
//    [tableView dismiss];
//}

-(void)UpdateUI
{
    if (self.issue.strVendorID != nil && self.issue.strVendorID.length > 0) {
        [_btnVendor setTitle:[NSString stringWithFormat:@"%@:%@",self.issue.strVendorType,self.issue.strVendorName] forState:UIControlStateNormal];
    }
    else
        [_btnVendor setTitle:@"" forState:UIControlStateNormal];
    
    [super UpdateUI];
}

-(IBAction)OnOk:(id)sender
{
    if (_tfTital.text.length>RPMAX_TITLE_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Title length should not exceed 50 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    if (_tvDesc.text.length>RPMAX_DESC_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Describe length should not exceed 300 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    if (self.issue.strVendorID == nil || self.issue.strVendorID.length == 0) {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Catagory is empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:strDesc];
        return;
    }
    [super OnOk:sender];
}
@end
