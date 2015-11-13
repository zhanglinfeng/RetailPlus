//
//  RPBVisitIssueCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBVisitIssueCell.h"
#import "RPBlockUIAlertView.h"

extern NSBundle * g_bundleResorce;
@implementation RPBVisitIssueCell

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

-(IBAction)OnDelete:(id)sender
{
    if (self.delegate) {
        NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
        NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        NSString * str = NSLocalizedStringFromTableInBundle(@"Confirm to delete this issue?",@"RPString", g_bundleResorce,nil);
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:str cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1) {
                [self.delegate OnDeleteIssue:self.visitItem Issue:self.issue];
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
