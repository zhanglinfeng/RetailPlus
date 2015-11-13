//
//  RPInspReporterCmdCell.m
//  RetailPlus
//
//  Created by lin dong on 13-9-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPInspReporterCmdCell.h"

@implementation RPInspReporterCmdCell

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

-(IBAction)OnSelectAddColleague:(id)sender
{
    [self.delegate OnSelectAddColleague:self.section];
}


-(IBAction)OnSelectAddEmail:(id)sender
{
    [self.delegate OnSelectAddEmail:self.section];
}

-(void)setBAll:(BOOL)bAll
{
    _bAll = bAll;
    [_btnAll setSelected:bAll];
}

-(IBAction)OnSelectAll:(id)sender
{
    _bAll = !_bAll;
    [self.delegate OnSelectAllUser:_bAll];
}
@end
