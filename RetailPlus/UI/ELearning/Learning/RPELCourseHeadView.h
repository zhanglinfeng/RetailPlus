//
//  RPELCourseHeadView.h
//  RetailPlus
//
//  Created by lin dong on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSDKELDefine.h"

@protocol RPELCourseHeadViewDelegate <NSObject>
    -(void)OnExpandCatagory:(RPELCourseCatagory *)catagory;
@end

@interface RPELCourseHeadView : UIView
{
    IBOutlet UILabel        * _lbCatagory;
    IBOutlet UIImageView    * _ivExpand;
}

@property (nonatomic,assign) id<RPELCourseHeadViewDelegate> delegate;
@property (nonatomic,retain) RPELCourseCatagory             * catagory;
@end
