//
//  RPELCourseViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-7-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSDKELDefine.h"
#import "RPTaskNavViewController.h"
#import "RPELWebCache.h"
#import "RPELCourseWareViewController.h"
#import "RPELCourseSearchViewController.h"
#import "RPELCourseHeadView.h"

@interface RPELCourseViewController : RPTaskNavViewController<UITableViewDataSource,UITableViewDelegate,RPELCourseHeadViewDelegate>
{
    IBOutlet UIView                 * _viewFrame;
    IBOutlet UIButton               * _btnFilter;
    IBOutlet UIView                 * _viewFilter;
    IBOutlet UIView                 * _viewFilterTip;
    IBOutlet UIView                 * _viewHead;
    IBOutlet UIButton               * _btnFinish;
    IBOutlet UIButton               * _btnLearning;
    IBOutlet UIButton               * _btnNerverRead;
    IBOutlet UITableView            * _tbCourse;
    
    RPELCourseWareViewController    * _vcCourseWare;
    RPELCourseSearchViewController  * _vcCourseSearch;
    
    BOOL                            _bShowFilter;
    NSArray                         * _arrayCourseCatagory;
    RPELWebCache                    * _cache;
    
    BOOL                            _bFiltUnFinished;
    BOOL                            _bFiltUnLearning;
    BOOL                            _bFiltUnNerverRead;
}

-(IBAction)OnFiltFinished:(id)sender;
-(IBAction)OnFiltLearning:(id)sender;
-(IBAction)OnFiltNeverRead:(id)sender;
@end
