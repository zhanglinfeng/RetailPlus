//
//  RPInspIssueCell.m
//  RetailPlus
//
//  Created by lin dong on 13-8-19.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPInspIssueCell.h"
#import "RPBlockUIAlertView.h"

extern NSBundle * g_bundleResorce;

@implementation RPInspIssueCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)awakeFromNib
//{
//    self.editingAccessoryView = _btnDelete;
//}

-(IBAction)OnDelete:(id)sender
{
    if (self.delegate) {
        NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
        NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        NSString * str = NSLocalizedStringFromTableInBundle(@"Confirm to delete this issue?",@"RPString", g_bundleResorce,nil);
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:str cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1) {
                [self.delegate OnDeleteIssue:self.category Issue:self.issue];
            }
        } otherButtonTitles:strOK,nil];
        [alertView show];
        
       
    }
}

-(void)setIssue:(InspIssue *)issue
{
    _issue = issue;
    _lbIssue.text = issue.strIssueTitle;
    
    if (issue.strVendorID.length == 0) {
        _viewVendor.hidden = YES;
    }
    else
    {
        _viewVendor.hidden = NO;
        _lbVendor.text = issue.strVendorType;
    }
}
@end
