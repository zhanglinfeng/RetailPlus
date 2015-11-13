//
//  RPLoginProtectView.m
//  RetailPlus
//
//  Created by lin dong on 13-11-20.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPLoginProtectView.h"
#import "RPLoginDeviceCell.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

@implementation RPLoginProtectView

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
    _viewTab.layer.cornerRadius = 6;
    _viewTab.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewTab.layer.borderWidth = 1;
    _tbDevice.layer.cornerRadius = 6;
    _tbDevice.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tbDevice.layer.borderWidth = 1;
//    _tbDevice.frame = CGRectMake(_tbDevice.frame.origin.x, _tbDevice.frame.origin.y, _tbDevice.frame.size.width, 40 * [RPBLogic defaultInstance].arrayLoginDevice.count);
    
    _viewEditNameEditFrame.layer.cornerRadius = 6;
    _viewEditNameEditFrame.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewEditNameEditFrame.layer.borderWidth = 1;
    
    _viewEditNameFrame.layer.cornerRadius = 8;
    
    if (![RPSDK defaultInstance].userLoginDetail.IsLoginProtection) {
        _ivLoginProtect.image = [UIImage imageNamed:@"icon_noselected_setup.png"];
    }
    else
    {
        _ivLoginProtect.image = [UIImage imageNamed:@"icon_selected_setup.png"];
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _viewEditName.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewEditName];
    [UIView beginAnimations:nil context:nil];
    _viewEditName.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    NSString * str = NSLocalizedStringFromTableInBundle(@"EDIT NAME",@"RPString", g_bundleResorce,nil);
    [self.delegate OnSetTitle:str];
    
    _curDevice = [[RPSDK defaultInstance].arrayLoginDevice objectAtIndex:indexPath.row];
    _tfDeviceName.text = _curDevice.strDeviceName;
    
    _bEditName = YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([RPSDK defaultInstance].arrayLoginDevice.count < 5) {
        _tbDevice.frame = CGRectMake(_tbDevice.frame.origin.x, _tbDevice.frame.origin.y, _tbDevice.frame.size.width, 40 * [RPSDK defaultInstance].arrayLoginDevice.count);
    }
    
    RPLoginDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPLoginDeviceCell"];
    if (cell == nil)
    {
        NSArray *array = [g_bundleResorce loadNibNamed:@"RPLoginDeviceCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.device = [[RPSDK defaultInstance].arrayLoginDevice objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [RPSDK defaultInstance].arrayLoginDevice.count;
}

-(IBAction)OnLoginProtect:(id)sender
{
    self.userInteractionEnabled = NO;
    
    NSString * str = NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showWithStatus:str];
    
    [[RPSDK defaultInstance] SetLoginProtectionStatus:![RPSDK defaultInstance].userLoginDetail.IsLoginProtection Success:^(id idResult) {
        self.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        [RPSDK defaultInstance].userLoginDetail.IsLoginProtection = ![RPSDK defaultInstance].userLoginDetail.IsLoginProtection;
        if (![RPSDK defaultInstance].userLoginDetail.IsLoginProtection) {
            _ivLoginProtect.image = [UIImage imageNamed:@"icon_noselected_setup.png"];
        }
        else
        {
            _ivLoginProtect.image = [UIImage imageNamed:@"icon_selected_setup.png"];
        }
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        self.userInteractionEnabled = YES;
    }];
}

-(IBAction)OnEditName:(id)sender
{
    [self endEditing:YES];
    
    [[RPSDK defaultInstance] UpdateDeviceName:_curDevice.strLoginDeviceId DeviceName:_tfDeviceName.text Success:^(id idResult) {
        [UIView beginAnimations:nil context:nil];
        _viewEditName.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _bEditName = NO;
        
        [[RPSDK defaultInstance] GetLoginDeviceList:^(NSArray * arrayDevice) {
            [RPSDK defaultInstance].arrayLoginDevice = arrayDevice;
            [_tbDevice reloadData];
            NSString * str = NSLocalizedStringFromTableInBundle(@"LOGIN PROTECTION",@"RPString", g_bundleResorce,nil);
            [self.delegate OnSetTitle:str];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}

-(BOOL)OnBack
{
    if (_bEditName) {
        [UIView beginAnimations:nil context:nil];
        _viewEditName.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        
        _bEditName = NO;
        
        NSString * str = NSLocalizedStringFromTableInBundle(@"LOGIN PROTECTION",@"RPString", g_bundleResorce,nil);
        [self.delegate OnSetTitle:str];
        return NO;
    }
    return YES;
}
@end
