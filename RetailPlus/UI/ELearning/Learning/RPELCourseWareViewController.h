//
//  RPELCourseWareViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSDKELDefine.h"
#import "RPTaskNavViewController.h"
#import "iCarousel.h"
#import "RPELWebCache.h"

@interface RPELCourseWareViewController : RPTaskNavViewController<iCarouselDataSource,iCarouselDelegate>
{
    IBOutlet UIView         * _viewFrame;
    IBOutlet UIView         * _viewCorner;
    IBOutlet UILabel        * _lbNo;
    IBOutlet UILabel        * _lbTitle;
    IBOutlet UILabel        * _lbReadCount;
    IBOutlet UILabel        * _lbAllCount;
    
    IBOutlet UIButton       * _btnDownload;
    IBOutlet UIButton       * _btnDownloadAll;
    IBOutlet UILabel        * _lbCourseWareNo;
    IBOutlet UILabel        * _lbCourseWareTitle;
    IBOutlet UITextView     * _tvCourseWareDesc;
    
    IBOutlet iCarousel      * _carousel;
    IBOutlet UIImageView    * _ivRead;
    
    RPELCourseWare          * _courseWare;
    RPELWebCache            * _cacheCourseWare;
    RPELWebCache            * _cacheCourseWareArray;
    NSMutableArray          * _arrayDownload;
}

@property (nonatomic,retain) RPELCourse             * course;
@end
