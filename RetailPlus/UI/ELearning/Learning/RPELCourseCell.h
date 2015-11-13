//
//  RPELCourseCell.h
//  RetailPlus
//
//  Created by lin dong on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSDKELDefine.h"

@interface RPELCourseCell : UITableViewCell
{
    IBOutlet UIView             * _viewFrame;
    IBOutlet UILabel            * _lbNo;
    IBOutlet UILabel            * _lbTitle;
    IBOutlet UILabel            * _lbDesc;
    IBOutlet UIImageView        * _ivThumb;
    IBOutlet UILabel            * _lbProgress;
    IBOutlet UIImageView        * _ivProgress;
}

@property (nonatomic,retain) RPELCourse             * course;

@end
