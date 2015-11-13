//
//  RPInspAddIssueCell.m
//  RetailPlus
//
//  Created by lin dong on 13-8-19.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPInspAddIssueCell.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@implementation RPInspAddIssueCell

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

-(IBAction)OnAddIssue:(id)sender
{
    
    if (self.delegate) {
        [self.delegate OnAddIssue:_catagory];
    }
}
@end
