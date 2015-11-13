//
//  RPELCourseSearchViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskNavViewController.h"
#import "RPELCourseWareSearchCell.h"
#import "RPELWebCache.h"

@interface RPELCourseSearchViewController : RPTaskNavViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RPELCourseWareSearchCellDelegate>
{
    IBOutlet UIView         * _viewFrame;
    IBOutlet UIView         * _viewSearch;
    IBOutlet UITextField    * _tfSearch;
    IBOutlet UITableView    * _tbSearch;
    
    NSMutableArray          * _arrayCourseWare;
    RPELWebCache            * _cacheDownloadCourseWare;
}

@property (nonatomic,retain) NSArray        * arrayCourseCatagory;

@end
