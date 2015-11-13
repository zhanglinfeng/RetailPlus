//
//  RPDSReportCurrentTableViewCell.h
//  RetailPlus
//
//  Created by lin dong on 14-7-10.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSDKDSDefine.h"

@interface RPDSReportCurrentTableViewCell : UITableViewCell
{
    IBOutlet UIView         * _viewFrame;
    IBOutlet UILabel        * _lbTime;
    IBOutlet UILabel        * _lbUserName;
    IBOutlet UILabel        * _lbCount;
}

@property (nonatomic,retain) RPDSCurrentStock * stockCurrent;
@property (nonatomic) BOOL                      bOpenReport;    
@property (nonatomic) BOOL                      bCurrentReport;//显示current or last
@end
