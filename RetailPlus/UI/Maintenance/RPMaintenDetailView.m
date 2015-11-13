//
//  RPMaintenDetailView.m
//  RetailPlus
//
//  Created by lin dong on 13-9-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
#import "RPMaintenDetailView.h"

extern NSBundle * g_bundleResorce;

@implementation RPMaintenDetailView

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
    _viewFrame.layer.cornerRadius = 8;
    
    _viewIssue.delegate = self;
    _viewIssue.bMarkRectInImage = YES;
    
    _viewAdditional.delegate = self;
}

-(BOOL)OnBack
{
    if (_bShowIssueView) {
        if ([_viewIssue OnBack])
            [self DismissIssueView];
        return NO;
    }
    if (_bShowAddView) {
        if ([_viewAdditional OnBack])
            [self DismissAddView];
        return NO;
    }
    
    [[RPSDK defaultInstance] SaveMaintenCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataMainten isNormalExit:YES];
    return YES;
}

-(void)setDataMainten:(MaintenanceData *)dataMainten
{
    _dataMainten = dataMainten;
    [_tbIssue reloadData];
    _lbCount.text=[NSString stringWithFormat:@"%d",_dataMainten.arrayIssue.count];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataMainten.arrayIssue.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == _dataMainten.arrayIssue.count)
    {
        RPInspAddIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPInspAddIssueCell"];
        if (cell == nil)
        {
            NSArray *array = [g_bundleResorce loadNibNamed:@"RPInspCell" owner:self options:nil];
            cell = [array objectAtIndex:2];
        }
        cell.delegate = self;
        return cell;
    }
    else
    {
        RPInspIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPInspIssueCell"];
        if (cell == nil)
        {
            NSArray *array = [g_bundleResorce loadNibNamed:@"RPInspCell" owner:self options:nil];
            cell = [array objectAtIndex:1];
        }
        
        cell.issue = (InspIssue *)[_dataMainten.arrayIssue objectAtIndex:indexPath.row];
        cell.delegate = self;
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _dataMainten.arrayIssue.count) return 45;
    return 38;
}

#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataMainten.arrayIssue.count) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _viewIssue.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _viewIssue.vcFrame = self.vcFrame;

    _viewIssue.strShopMapUrl = self.dataMainten.strImgShopUrl;
    _viewIssue.arrayVendor = _arrayVendor;
    [self addSubview:_viewIssue];
    _viewIssue.issue = (InspIssue *)[self.dataMainten.arrayIssue objectAtIndex:indexPath.row];
    
    [UIView beginAnimations:nil context:nil];
    _viewIssue.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _bShowIssueView = YES;
}

-(void)OnAddIssue:(InspCatagory *)catagory
{
    _viewIssue.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _viewIssue.vcFrame = self.vcFrame;
    
    _viewIssue.strShopMapUrl = self.dataMainten.strImgShopUrl;
    _viewIssue.arrayVendor = _arrayVendor;
    _viewIssue.issue = nil;
    [self addSubview:_viewIssue];
    
    [UIView beginAnimations:nil context:nil];
    _viewIssue.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _bShowIssueView = YES;
}

-(void)DismissIssueView
{
    [UIView beginAnimations:nil context:nil];
    _viewIssue.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bShowIssueView = NO;
}

-(void)OnModifyIssueEnd
{
    if (_dataMainten.arrayIssue == nil) {
        _dataMainten.arrayIssue = [[NSMutableArray alloc] init];
    }
    if (!_viewIssue.bModifyMode) [_dataMainten.arrayIssue addObject:_viewIssue.issue];
    
    NSArray * arraySort = [_dataMainten.arrayIssue sortedArrayUsingComparator:^(InspIssue * obj1, InspIssue * obj2){
          return [obj1.strVendorType compare:obj2.strVendorType options:NSCaseInsensitiveSearch];
      }];
    _dataMainten.arrayIssue = [[NSMutableArray alloc] initWithArray:arraySort];
    
    [self DismissIssueView];
    
    _lbCount.text = [NSString stringWithFormat:@"%d",_dataMainten.arrayIssue.count];
    [_tbIssue reloadData];
    
    [[RPSDK defaultInstance] SaveMaintenCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataMainten isNormalExit:NO];
}


-(void)OnDeleteIssue
{
    if (_viewIssue.bModifyMode) {
        [_dataMainten.arrayIssue removeObject:_viewIssue.issue];
        
        _lbCount.text = [NSString stringWithFormat:@"%d",_dataMainten.arrayIssue.count];
        [[RPSDK defaultInstance] SaveMaintenCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataMainten isNormalExit:NO];
    }
    
    [self DismissIssueView];
    [_tbIssue reloadData];
}

-(void)OnDeleteIssue:(InspCatagory *)catagory Issue:(InspIssue *)issue
{
    [_dataMainten.arrayIssue removeObject:issue];
    
    _lbCount.text = [NSString stringWithFormat:@"%d",_dataMainten.arrayIssue.count];
    [_tbIssue reloadData];
    
    [[RPSDK defaultInstance] SaveMaintenCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataMainten isNormalExit:NO];
}

-(void)DismissAddView
{
    [UIView beginAnimations:nil context:nil];
    _viewAdditional.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bShowAddView = NO;
}

-(IBAction)OnAdditional:(id)sender
{
    if (_dataMainten.arrayIssue.count == 0) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"No issues exist",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
        return;
    }
    
    _viewAdditional.arrayContact = self.arrayContact;
    _viewAdditional.storeSelected = self.storeSelected;
    _viewAdditional.dataMainten = self.dataMainten;
    
    _viewAdditional.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewAdditional];
    
    [UIView beginAnimations:nil context:nil];
    _viewAdditional.frame = CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _bShowAddView = YES;
}

-(void)OnMaintenEnd
{
    [self.delegate OnMaintenEnd];
}

-(IBAction)OnCache:(id)sender
{
    [[RPSDK defaultInstance] SaveMaintenCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataMainten isNormalExit:YES];
    
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Current data will be erased!\r\nConfirm to exit maintenance?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [self.delegate OnMaintenEnd];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}
@end
