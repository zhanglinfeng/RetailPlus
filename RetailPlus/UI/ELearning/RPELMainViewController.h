//
//  RPELMainViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-7-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskNavViewController.h"
#import "RPELCourseViewController.h"
#import "RPELExamViewController.h"
#import "RPELRecordViewController.h"

@interface RPELMainViewController : RPTaskNavViewController
{
    RPELRecordViewController    * _vcRecord;
    RPELCourseViewController    * _vcCourse;
    RPELExamViewController      * _vcExam;
}

@property (nonatomic,assign) UIViewController * vcFrame;

-(BOOL)OnBack;

@end
