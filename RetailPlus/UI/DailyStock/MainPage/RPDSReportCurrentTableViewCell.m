//
//  RPDSReportCurrentTableViewCell.m
//  RetailPlus
//
//  Created by lin dong on 14-7-10.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPDSReportCurrentTableViewCell.h"

@implementation RPDSReportCurrentTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    _viewFrame.layer.borderWidth = 1;
    _viewFrame.layer.cornerRadius = 6;
    _viewFrame.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setStockCurrent:(RPDSCurrentStock *)stockCurrent
{
    _stockCurrent = stockCurrent;
    _lbCount.text = [NSString stringWithFormat:@"%d",stockCurrent.nCount];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    _lbTime.text = [formatter stringFromDate:stockCurrent.dateAdd];
    _lbUserName.text = [NSString stringWithFormat:@"%@",_stockCurrent.userInfo.strFirstName];
    [self UpdateColor];
}

-(void)setBOpenReport:(BOOL)bOpenReport
{
    _bOpenReport = bOpenReport;
    [self UpdateColor];
}

-(void)setBCurrentReport:(BOOL)bCurrentReport
{
    _bCurrentReport = bCurrentReport;
    [self UpdateColor];
}

-(void)UpdateColor
{
    switch (_stockCurrent.userInfo.rank) {
        case Rank_Manager:
            _lbUserName.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbUserName.textColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _lbUserName.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _lbUserName.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }
    
    if (_bCurrentReport)
    {
        if (_bOpenReport)
            _lbCount.textColor = [UIColor colorWithRed:55.0f/255.0f green:115.0f/255.0f blue:120.0f/255.0f alpha:1];
        else
            _lbCount.textColor = [UIColor colorWithRed:224.0f/255.0f green:130.0f/255.0f blue:1.0f/255.0f alpha:1];
    }
    else
        _lbCount.textColor = [UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1];
}
@end

