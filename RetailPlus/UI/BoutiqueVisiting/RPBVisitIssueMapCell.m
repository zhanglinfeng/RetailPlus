//
//  RPBVisitIssueMapCell.m
//  RetailPlus
//
//  Created by lin dong on 14-7-29.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBVisitIssueMapCell.h"
extern NSBundle * g_bundleResorce;

@implementation RPBVisitIssueMapCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBHasLocation:(BOOL)bHasLocation
{
    if (!bHasLocation)
        _ivMap.image = [UIImage imageNamed:@"icon_planview.png"];
    else
        _ivMap.image = [UIImage imageNamed:@"icon_planview_mark.png"];
}

-(void)setBHasMap:(BOOL)bHasMap
{
    if (!bHasMap) {
        _lbNoMap.hidden = NO;
        _lbMapTitle.hidden = YES;
        _ivMap.hidden = YES;
        _lbNoMap.text = NSLocalizedStringFromTableInBundle(@"NO FLOOR PLAN UPLOADED",@"RPString", g_bundleResorce,nil);
    }
    else
    {
        _lbNoMap.hidden = YES;
        _lbMapTitle.hidden = NO;
        _ivMap.hidden = NO;
    }
}

-(void)setMap:(StoreShopMap *)map
{
    _map = map;
    _lbMapTitle.text = map.strTitle;
}

@end
