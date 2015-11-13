//
//  RPConfHistoryCell.m
//  RetailPlus
//
//  Created by lin dong on 14-6-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPConfHistoryCell.h"
extern NSBundle * g_bundleResorce;

@implementation RPConfHistoryCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setConf:(RPConf *)conf
{
    _conf = conf;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString * strDate = [formatter stringFromDate:conf.dateCallHistory];
    if ( [strDate isEqualToString:[formatter stringFromDate:[NSDate date]]])
        _lbDate.text = NSLocalizedStringFromTableInBundle(@"Today",@"RPString", g_bundleResorce,nil);
    else
        _lbDate.text = strDate;
    
    [formatter setDateFormat:@"HH:mm"];
    _lbTime.text = [formatter stringFromDate:conf.dateCallHistory];
    
    if (conf.strCallTheme != (id)[NSNull null]) {
        _lbTheme.text = conf.strCallTheme;
    }
    
    
    _lbMemberCount.text = [NSString stringWithFormat:@"%d",conf.arrayGuest.count];
    
    _lbHostPhone.text = conf.strHostPhone;
}
@end
