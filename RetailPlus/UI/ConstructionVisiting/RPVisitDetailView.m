//
//  RPVisitDetailView.m
//  RetailPlus
//
//  Created by lin dong on 13-9-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
#import "RPVisitDetailView.h"
#import "RPInspAddIssueCell.h"
#import "RPInspIssueCell.h"

extern NSBundle * g_bundleResorce;

@implementation RPVisitDetailView

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
    _viewDesc.layer.cornerRadius = 6;
    _viewDesc.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewDesc.layer.borderWidth = 1;
    
    _viewMark.layer.cornerRadius = 6;
    _viewMark.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewMark.layer.borderWidth = 1;
    
    _viewComments.frame = CGRectMake(_svFrame.frame.size.width, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
    [_svFrame addSubview:_viewComments];
    
    _tbIssue = [[UITableView alloc] init];
    _tbIssue.frame = CGRectMake(0, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
    [_svFrame addSubview:_tbIssue];
    _tbIssue.dataSource = self;
    _tbIssue.delegate = self;
    _tbIssue.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbIssue.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    _tbIssue.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width * 2, 10);
    
    _viewIssue.delegate = self;
    _viewIssue.bMarkRectInImage = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    [_viewComments addGestureRecognizer:tap];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self endEditing:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    self.frame = CGRectMake(0, -180, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}

-(void)setDataVisit:(CVisitData *)dataVisit
{
    _dataVisit = dataVisit;
    
    [_tbIssue reloadData];
    [self UpdateMark];
    _tvDesc.text = dataVisit.strDesc;
    
    _lbCount.text = [NSString stringWithFormat:@"%d",_dataVisit.arrayIssue.count];
    
    [[RPSDK defaultInstance] SaveVisitCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataVisit isNormalExit:NO];
}

-(IBAction)OnSend:(id)sender
{
    if (_tvDesc.text.length>RPMAX_DESC_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Remarks length should not exceed 300 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    self.dataVisit.strDesc = _tvDesc.text;
    
    if (_dataVisit.mark == MARK_NONE) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Not Scored",@"RPString", g_bundleResorce,nil);
        
        [SVProgressHUD showErrorWithStatus:str];
        return;
    }
    
    if (_dataVisit.strDesc.length == 0) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Comments Empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
        return;
    }
    
    _viewReporter.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewReporter];
    
    _viewReporter.reporters = self.dataVisit.reporters;
    NSString * str = NSLocalizedStringFromTableInBundle(@"Visiting Report Created",@"RPString", g_bundleResorce,nil);
    _viewReporter.strTitle = str;

    _viewReporter.delegate = self;
    [UIView beginAnimations:nil context:nil];
    _viewReporter.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
     _bShowReporterView = YES;
}

-(void)DismissReporterView
{
    [UIView beginAnimations:nil context:nil];
    _viewReporter.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bShowReporterView = NO;
}

-(void)SubmitVisit
{
    NSString * str = NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil);
    
    [SVProgressHUD showWithStatus:str];
    
    [[RPSDK defaultInstance] SubmitVisit:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:self.dataVisit Success:^(id dictResult) {
        [[RPSDK defaultInstance] ClearCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_VISITING];
        [SVProgressHUD dismiss];
        [self.delegate OnVisitEnd];
        NSString * str = NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showSuccessWithStatus:str];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {

        if (nErrorCode == RPSDKError_SubmitAddToCache) {
            [SVProgressHUD dismiss];
            [self.delegate OnVisitEnd];
        }
    }];
}

-(void)OnEndAddUser:(InspReporters *)reporters
{
    [self DismissReporterView];
    
    self.dataVisit.reporters = reporters;
    
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
            [self SubmitVisit];
            break;
        }
        case ReachableViaWWAN:
        {
            NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
            NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"No WLAN connection. Confirm to upload now?",@"RPString", g_bundleResorce,nil);
            RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
                if (indexButton==1) {
                    [self SubmitVisit];
                }
            }otherButtonTitles:strOK, nil];
            [alertView show];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataVisit.arrayIssue.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == _dataVisit.arrayIssue.count)
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
        
        cell.issue = (InspIssue *)[_dataVisit.arrayIssue objectAtIndex:indexPath.row];
        cell.delegate = self;
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _dataVisit.arrayIssue.count) return 45;
    return 38;
}

-(void)OnAddIssue:(InspCatagory *)catagory
{
    _viewIssue.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _viewIssue.vcFrame = self.vcFrame;
    _viewIssue.strShopMapUrl = self.dataVisit.strImgShopUrl;
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
    if (_dataVisit.arrayIssue == nil) {
        _dataVisit.arrayIssue = [[NSMutableArray alloc] init];
    }
    if (!_viewIssue.bModifyMode) [_dataVisit.arrayIssue addObject:_viewIssue.issue];
    
    [self DismissIssueView];
    
    _lbCount.text = [NSString stringWithFormat:@"%d",_dataVisit.arrayIssue.count];
    [_tbIssue reloadData];
    
    [[RPSDK defaultInstance] SaveVisitCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataVisit isNormalExit:NO];
}

-(void)OnDeleteIssue
{
    if (_viewIssue.bModifyMode) {
        [_dataVisit.arrayIssue removeObject:_viewIssue.issue];
        
        _lbCount.text = [NSString stringWithFormat:@"%d",_dataVisit.arrayIssue.count];
        [[RPSDK defaultInstance] SaveVisitCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataVisit isNormalExit:NO];
    }
    
    [self DismissIssueView];
    [_tbIssue reloadData];
}

-(void)OnDeleteIssue:(InspCatagory *)catagory Issue:(InspIssue *)issue
{
    [_dataVisit.arrayIssue removeObject:issue];
    
    _lbCount.text = [NSString stringWithFormat:@"%d",_dataVisit.arrayIssue.count];
    [_tbIssue reloadData];
    
    [[RPSDK defaultInstance] SaveVisitCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataVisit isNormalExit:NO];
}

#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataVisit.arrayIssue.count) {
        return;
    }
    
    _viewIssue.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _viewIssue.vcFrame = self.vcFrame;
    _viewIssue.strShopMapUrl = self.dataVisit.strImgShopUrl;
    _viewIssue.issue = (InspIssue *)[self.dataVisit.arrayIssue objectAtIndex:indexPath.row];
    [self addSubview:_viewIssue];
    
    [UIView beginAnimations:nil context:nil];
    _viewIssue.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _bShowIssueView = YES;
}

-(void)UpdateMark
{
    [_btnMark1 setSelected:NO];
    [_btnMark2 setSelected:NO];
    [_btnMark3 setSelected:NO];
    [_btnMark4 setSelected:NO];
    [_btnMark5 setSelected:NO];
    
    _imgMark1.image = [UIImage imageNamed:@"Icon_star_noactive_small_2.png"];
    _imgMark2.image = [UIImage imageNamed:@"Icon_star_noactive_small_2.png"];
    _imgMark3.image = [UIImage imageNamed:@"Icon_star_noactive_small_2.png"];
    _imgMark4.image = [UIImage imageNamed:@"Icon_star_noactive_small_2.png"];
    _imgMark5.image = [UIImage imageNamed:@"Icon_star_noactive_small_2.png"];
    
    switch (_dataVisit.mark) {
        case MARK_1:
            [_btnMark1 setSelected:YES];
            _lbMarkDesc.text = NSLocalizedStringFromTableInBundle(@"BAD",@"RPString", g_bundleResorce,nil);
            _imgMark1.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            break;
        case MARK_2:
            [_btnMark1 setSelected:YES];
            [_btnMark2 setSelected:YES];
            _imgMark1.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark2.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _lbMarkDesc.text = NSLocalizedStringFromTableInBundle(@"NORMAL",@"RPString", g_bundleResorce,nil);
            break;
        case MARK_3:
            [_btnMark1 setSelected:YES];
            [_btnMark2 setSelected:YES];
            [_btnMark3 setSelected:YES];
            _imgMark1.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark2.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark3.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _lbMarkDesc.text = NSLocalizedStringFromTableInBundle(@"GOOD",@"RPString", g_bundleResorce,nil);
            break;
        case MARK_4:
            [_btnMark1 setSelected:YES];
            [_btnMark2 setSelected:YES];
            [_btnMark3 setSelected:YES];
            [_btnMark4 setSelected:YES];
            _imgMark1.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark2.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark3.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark4.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _lbMarkDesc.text = NSLocalizedStringFromTableInBundle(@"GREAT",@"RPString", g_bundleResorce,nil);
            break;
        case MARK_5:
            [_btnMark1 setSelected:YES];
            [_btnMark2 setSelected:YES];
            [_btnMark3 setSelected:YES];
            [_btnMark4 setSelected:YES];
            [_btnMark5 setSelected:YES];
            _imgMark1.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark2.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark3.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark4.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark5.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _lbMarkDesc.text = NSLocalizedStringFromTableInBundle(@"EXCELLENT",@"RPString", g_bundleResorce,nil);
            break;
        default:
            break;
    }
}

-(IBAction)OnMark:(id)sender
{
    _dataVisit.mark = MARK_1 + ((UIButton *)sender).tag - 100;
    [self UpdateMark];
}

-(BOOL)OnBack
{
    self.dataVisit.strDesc = _tvDesc.text;
    
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
    
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Current data will be erased!\r\nConfirm to exit visiting?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [[RPSDK defaultInstance] SaveVisitCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataVisit isNormalExit:YES];
            [self.delegate backVisit];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
    return NO;
}

-(IBAction)OnDescView:(id)sender
{
    [_svFrame setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(IBAction)OnIssueView:(id)sender
{
    [_svFrame setContentOffset:CGPointMake(_svFrame.frame.size.width, 0) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _svFrame)
    {
        [UIView beginAnimations:nil context:nil];
        if (scrollView.contentOffset.x == 0)
        {
            _ivPoint.frame = CGRectMake(57, _ivPoint.frame.origin.y, _ivPoint.frame.size.width, _ivPoint.frame.size.height);
            _viewHeadBack2.backgroundColor = [UIColor lightGrayColor];
            _viewHeadBack1.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1];
        }
        
        if (scrollView.contentOffset.x == _svFrame.frame.size.width)
        {
            _ivPoint.frame = CGRectMake(140, _ivPoint.frame.origin.y, _ivPoint.frame.size.width, _ivPoint.frame.size.height);
            _viewHeadBack1.backgroundColor = [UIColor lightGrayColor];
            _viewHeadBack2.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1];
        }
        [UIView commitAnimations];
    }
    [self endEditing:YES];
}

-(IBAction)OnCache:(id)sender
{
    _dataVisit.strDesc = _tvDesc.text;
    [[RPSDK defaultInstance] SaveVisitCacheData:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:_dataVisit isNormalExit:YES];
    
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Current data will be erased!\r\nConfirm to exit visiting?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [self.delegate OnVisitEnd];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}
@end
