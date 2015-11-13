//
//  RPMaintenContactView.m
//  RetailPlus
//
//  Created by lin dong on 13-9-16.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPMaintenContactView.h"
#import "RPBlockUISelectView.h"
extern NSBundle * g_bundleResorce;

@implementation RPMaintenContactView
@synthesize tfPhone = _tfPhone;
@synthesize tfUserName = _tfUserName;
@synthesize btnSelectContact = _btnSelectContact;

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
    _viewFrame.layer.cornerRadius = 6;
    _viewFrame.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewFrame.layer.borderWidth = 1;
    
    _btnContactName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnContactName.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
}

-(void)setContact:(MaintenContact *)contact
{
    _contact = contact;
    
    if (contact == nil) {
        _tfUserName.hidden = YES;
        _viewVertSplit.hidden = YES;
        _btnSelectContact.hidden = YES;
        _btnContactName.hidden = NO;
        
        _tfUserName.text = @"";
        _tfPhone.text = @"";
        [_btnContactName setTitle:@"" forState:UIControlStateNormal];
        return;
    }
    
    if (contact.bColleague) {
        _tfUserName.hidden = YES;
        _viewVertSplit.hidden = YES;
        _btnSelectContact.hidden = YES;
        _btnContactName.hidden = NO;
        
        [_btnContactName setTitle:contact.strUserName forState:UIControlStateNormal];
        _tfPhone.text = contact.strPhone;
    }
    else
    {
        _tfUserName.hidden = NO;
        _viewVertSplit.hidden = NO;
        _btnSelectContact.hidden = NO;
        _btnContactName.hidden = YES;
        
        _tfUserName.text = contact.strUserName;
        _tfPhone.text = contact.strPhone;
    }
}


-(IBAction)OnSelectVendor:(id)sender
{
//    NSInteger nMaxCount = (_arrayContact.count + 1) > 4 ? 4 : (_arrayContact.count + 1);
//    
//    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, _btnContactName.frame.size.width, 42 * (nMaxCount + 1))];
//    listView.datasource = self;
//    listView.delegate = self;
//    [listView show:CGPointMake(211,130 + self.frame.origin.y + 21 * (nMaxCount + 1))];
    
    NSMutableArray *strArray=[[NSMutableArray alloc]init];
    for (int i=0; i<_arrayContact.count + 1;i++)
    {
        if (i < _arrayContact.count)
        {
            NSString *strTemp = ((MaintenContact *)[_arrayContact objectAtIndex:i]).strUserName;
            [strArray addObject:strTemp];
        }
        else
        {
            NSString *strTemp = NSLocalizedStringFromTableInBundle(@"other",@"RPString", g_bundleResorce,nil);
            [strArray addObject:strTemp];
        }
        
    }
    
    
    
    NSString *mode=NSLocalizedStringFromTableInBundle(@"Store Contact",@"RPString", g_bundleResorce,nil);
    
    RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:mode clickButton:^(NSInteger indexButton) {
        
        if (indexButton < _arrayContact.count) {
            _tfUserName.hidden = YES;
            _viewVertSplit.hidden = YES;
            _btnSelectContact.hidden = YES;
            _btnContactName.hidden = NO;
            
            [_btnContactName setTitle:((MaintenContact *)[_arrayContact objectAtIndex:indexButton]).strUserName forState:UIControlStateNormal];
            _strColleagueName = ((MaintenContact *)[_arrayContact objectAtIndex:indexButton]).strUserName;
            _tfPhone.text = ((MaintenContact *)[_arrayContact objectAtIndex:indexButton]).strPhone;
            
            self.isColleague = YES;
        }
        else
        {
            _tfUserName.hidden = NO;
            _viewVertSplit.hidden = NO;
            _btnSelectContact.hidden = NO;
            _btnContactName.hidden = YES;
            
            _tfUserName.text = @"";
            _tfPhone.text = @"";
            
            self.isColleague = NO;
        }
        _curIndex=indexButton;
    } curIndex:_curIndex  selectTitles:strArray];
    [selectView show];
}

#pragma mark -
//- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _arrayContact.count + 1;
//}
//
//- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identifier = @"VendorCellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    if (indexPath.row < _arrayContact.count) {
//        cell.textLabel.text = ((MaintenContact *)[_arrayContact objectAtIndex:indexPath.row]).strUserName;
//    }
//    else
//        cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"other",@"RPString", g_bundleResorce,nil);;
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
//    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
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
//    if (indexPath.row < _arrayContact.count) {
//        _tfUserName.hidden = YES;
//        _viewVertSplit.hidden = YES;
//        _btnSelectContact.hidden = YES;
//        _btnContactName.hidden = NO;
//        
//        [_btnContactName setTitle:((MaintenContact *)[_arrayContact objectAtIndex:indexPath.row]).strUserName forState:UIControlStateNormal];
//        _strColleagueName = ((MaintenContact *)[_arrayContact objectAtIndex:indexPath.row]).strUserName;
//        _tfPhone.text = ((MaintenContact *)[_arrayContact objectAtIndex:indexPath.row]).strPhone;
//        
//        self.isColleague = YES;
//    }
//    else
//    {
//        _tfUserName.hidden = NO;
//        _viewVertSplit.hidden = NO;
//        _btnSelectContact.hidden = NO;
//        _btnContactName.hidden = YES;
//        
//        _tfUserName.text = @"";
//        _tfPhone.text = @"";
//        
//        self.isColleague = NO;
//    }
//    [tableView dismiss];
//}


-(void)OnConfirm
{
    _contact.strPhone = _tfPhone.text;
    _contact.bColleague = self.isColleague;
    if (_contact.bColleague) {
        _contact.strUserName = _strColleagueName;
    }
    else
    {
        _contact.strUserName = _tfUserName.text;
    }
}

-(void)OnEndAddUser:(InspReporters *)reporters
{
    
}

@end
