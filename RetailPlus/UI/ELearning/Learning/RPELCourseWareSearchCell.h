//
//  RPELCourseWareSearchCell.h
//  RetailPlus
//
//  Created by lin dong on 14-7-28.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPELCourseWareSearchCellDelegate <NSObject>
-(void)DoDownloadOrOpenCourseWare:(RPELCourseWare *)courseWare InCourse:(RPELCourse *)course Open:(BOOL)bOpen;
@end

@interface RPELCourseWareSearchCell : UITableViewCell
{
    IBOutlet UILabel        * _lbCourseWareNo;
    IBOutlet UILabel        * _lbCourseWareTitle;
    IBOutlet UILabel        * _lbCourseTitle;
    IBOutlet UIButton       * _btnDownLoad;
    IBOutlet UIImageView    * _ivRead;
}

@property (nonatomic,assign) id<RPELCourseWareSearchCellDelegate> delegate;
@property (nonatomic,retain) NSDictionary * dictResult;
@end
