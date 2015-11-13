//
//  RPELLearnRecordCell.h
//  RetailPlus
//
//  Created by lin dong on 14-8-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPELLearnRecordCell : UITableViewCell
{
    IBOutlet UILabel        * _lbCourseWareCode;
    IBOutlet UILabel        * _lbCourseWareName;
    IBOutlet UILabel        * _lbCourseName;
    IBOutlet UILabel        * _lbReadDate;
}

@property (nonatomic,retain) RPELLearnRecord * record;
@end
