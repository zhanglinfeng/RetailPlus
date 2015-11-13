//
//  RPMaintenAddView.m
//  RetailPlus
//
//  Created by lin dong on 13-9-16.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "RPMaintenAddView.h"
#import "RPBlockUIAlertView.h"

extern NSBundle * g_bundleResorce;

@implementation RPMaintenAddView

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
    _viewBorder.layer.cornerRadius = 8;
    _viewRemark.layer.cornerRadius = 8;
    _viewRemark.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewRemark.layer.borderWidth = 1;
    
    _viewReporter.delegate = self;
    
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    [_viewTap addGestureRecognizer:singleTapGR];
}

-(void)setArrayContact:(NSMutableArray *)arrayContact
{
    _arrayContact = arrayContact;
    _viewContact1.arrayContact = arrayContact;
    _viewContact2.arrayContact = arrayContact;
}

-(void)setDataMainten:(MaintenanceData *)dataMainten
{
    _dataMainten = dataMainten;
    
    if (dataMainten.arrayContacts == nil) {
        dataMainten.arrayContacts = [[NSMutableArray alloc] init];
        MaintenContact * contact = [[MaintenContact alloc] init];
        [dataMainten.arrayContacts addObject:contact];
        
        contact = [[MaintenContact alloc] init];
        [dataMainten.arrayContacts addObject:contact];
    }
    
    _viewContact1.contact = [dataMainten.arrayContacts objectAtIndex:0];
    _viewContact2.contact = [dataMainten.arrayContacts objectAtIndex:1];
}

-(IBAction)OnConfirm:(id)sender
{
    if (_tvRemark.text.length>RPMAX_DESC_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Remarks length should not exceed 300 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    [_viewContact1 OnConfirm];
    [_viewContact2 OnConfirm];
    _dataMainten.strContactsRemark = _tvRemark.text;
    
    _viewReporter.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewReporter];
    
    InspReporters * reporters = [[InspReporters alloc] init];
    reporters.arraySection = [[NSMutableArray alloc] init];
    
//    for (InspReporterSection * section in self.dataMainten.reporters.arraySection) {
//        for (InspIssue * issue in _dataMainten.arrayIssue) {
//            if ([issue.strVendorID isEqualToString:section.strVendorID]) {
//                [reporters.arraySection addObject:section];
//                break;
//            }
//        }
//    }
    
    
    for (InspReporterSection * section in self.dataMainten.reporters.arraySection)
    {
        for (InspIssue * issue in _dataMainten.arrayIssue) {
            if ([issue.strVendorID isEqualToString:section.strVendorID]) {
                [reporters.arraySection addObject:section];
                break;
            }
        }
    }
    
    _viewReporter.reporters = reporters;
    _viewReporter.strTitle = NSLocalizedStringFromTableInBundle(@"Maintenance Application Created",@"RPString", g_bundleResorce,nil);;
    
    
    [UIView beginAnimations:nil context:nil];
    _viewReporter.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bShowReporterView = YES;
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self endEditing:YES];
}

-(void)DismissReporterView
{
    [UIView beginAnimations:nil context:nil];
    _viewReporter.frame = CGRectMake(0, self.frame.size.height + 260, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bShowReporterView = NO;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    self.frame = CGRectMake(0, -260, self.frame.size.width, self.frame.size.height + 260);
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 260);
    [UIView commitAnimations];
}

-(void)SubmitMainten:(InspReporters *)reporters
{
    NSString * str = NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil);
    
    [SVProgressHUD showWithStatus:str];
    
    [[RPSDK defaultInstance] SubmitMainten:_storeSelected.strStoreId StoreName:_storeSelected.strStoreName Data:self.dataMainten Reporter:reporters Success:^(id dictResult) {
        [[RPSDK defaultInstance] ClearCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_MAINTEN];
        [SVProgressHUD dismiss];
        [self.delegate OnMaintenEnd];
        NSString * str = NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showSuccessWithStatus:str];
        
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        if (nErrorCode == RPSDKError_SubmitAddToCache) {
            [self.delegate OnMaintenEnd];
        }
    }];
}

-(void)OnEndAddUser:(InspReporters *)reporters
{
    [self DismissReporterView];
    
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
            [self SubmitMainten:reporters];
            break;
        }
        case ReachableViaWWAN:
        {
            NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
            NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"No WLAN connection. Confirm to upload now?",@"RPString", g_bundleResorce,nil);
            RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
                if (indexButton==1) {
                    [self SubmitMainten:reporters];
                }
            }otherButtonTitles:strOK, nil];
            [alertView show];
            
            break;
        }
        default:
            break;
    }
}

-(BOOL)OnBack
{
    [_viewContact1 OnConfirm];
    [_viewContact2 OnConfirm];
    _dataMainten.strContactsRemark = _tvRemark.text;
    
    if (_bShowReporterView) {
        if ([_viewReporter OnBack])
            [self DismissReporterView];
        return NO;
    }
    return YES;
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}
@end
