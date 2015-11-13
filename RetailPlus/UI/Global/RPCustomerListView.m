//
//  RPCustomerListView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-12.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCustomerListView.h"
#import "SVProgressHUD.h"
#import "RPCustomerListCell.h"
extern NSBundle * g_bundleResorce;
@implementation RPCustomerListView

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
    CALayer * sublayer = _viewFrame.layer;
    sublayer.cornerRadius = 8;
    
    sublayer = _viewSearch.layer;
    sublayer.cornerRadius = 5;
    sublayer.borderColor = [UIColor lightGrayColor].CGColor;
    sublayer.borderWidth = 1;
    
    _bSelfOnly = NO;
}

-(void)reloadCustomer
{
    _arrayCustomer = nil;
    [_tbCustomer reloadData];
    
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTableInBundle(@"Please wait...",@"RPString", g_bundleResorce,nil)];
        
    [[RPSDK defaultInstance] GetCustomerList:^(NSMutableArray * array) {
        if (self.bSelfOnly) {
            _arrayCustomer = [[NSMutableArray alloc] init];
            for (Customer * customer in array) {
                if ([customer.strRelationUserId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId])
                {
                    [_arrayCustomer addObject:customer];
                }
            }
        }
        else
        {
            _arrayCustomer = array;
        }
        [SVProgressHUD dismiss];
        [self updateUI];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
  
}
-(void)updateUI
{
    _arrayCustomerShow = [[NSMutableArray alloc] init];
    for (Customer * customer in _arrayCustomer) {
        if(_tfSearch.text.length > 0)
        {
            NSRange range1 = [customer.strFirstName rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
//            NSRange range2 = [customer.strSurName rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
            
            if (range1.length == 0)
                continue;
        }
        [_arrayCustomerShow addObject:customer];
    }
    [_tbCustomer reloadData];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrayCustomerShow) {
        return _arrayCustomerShow.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPCustomerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPCustomerListCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPCustomCell" owner:self options:nil];
        cell = [array objectAtIndex:1];
    }
    
    [cell setCustomer:(Customer *)[_arrayCustomerShow objectAtIndex:indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate) {
        [self.delegate OnSelectedCustomer:[_arrayCustomerShow objectAtIndex:indexPath.row]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    
    [self updateUI];
    return YES;
}

-(IBAction)OnDeleteSearch:(id)sender
{
    [self endEditing:YES];
    
    _tfSearch.text = @"";
    [self updateUI];
}

-(void)dismiss
{
    [SVProgressHUD dismiss];
}
@end
