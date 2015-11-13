//
//  RPDSReportIOTableViewCell.h
//  RetailPlus
//
//  Created by lin dong on 14-7-10.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSDKDSDefine.h"

@interface RPDSReportIOTableViewCell : UITableViewCell
{
    IBOutlet UIView     * _viewFrame;
    IBOutlet UILabel    * _lbTime;
    IBOutlet UILabel    * _lbUserName;
    IBOutlet UILabel    * _lbCount;
    IBOutlet UILabel    * _lbComment;
}

@property (nonatomic,retain) RPDSIOStock * stockIO;

@end
