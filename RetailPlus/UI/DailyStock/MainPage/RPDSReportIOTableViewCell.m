//
//  RPDSReportIOTableViewCell.m
//  RetailPlus
//
//  Created by lin dong on 14-7-10.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPDSReportIOTableViewCell.h"

@implementation RPDSReportIOTableViewCell

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

-(void)setStockIO:(RPDSIOStock *)stockIO
{
    _stockIO = stockIO;
    
    switch (stockIO.typeIO) {
        case RPDSIOType_In:
             _lbCount.text = [NSString stringWithFormat:@"+%d",stockIO.nCount];
            break;
        case RPDSIOType_Out:
            _lbCount.text = [NSString stringWithFormat:@"-%d",stockIO.nCount];
            break;
        default:
            break;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    _lbTime.text = [formatter stringFromDate:stockIO.dateAdd];
    _lbUserName.text = [NSString stringWithFormat:@"%@",_stockIO.userInfo.strFirstName];
    _lbComment.text = stockIO.strComment;
    [self UpdateColor];
}

-(void)UpdateColor
{
    switch (_stockIO.userInfo.rank) {
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
    
    switch (_stockIO.typeIO) {
        case RPDSIOType_In:
            _lbCount.textColor = [UIColor colorWithRed:55.0f/255.0f green:115.0f/255.0f blue:120.0f/255.0f alpha:1];
            break;
        case RPDSIOType_Out:
            _lbCount.textColor = [UIColor colorWithRed:201.0f/255.0f green:69.0f/255.0f blue:54.0f/255.0f alpha:1];
            break;
        default:
            break;
    }
}

@end
