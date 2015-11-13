//
//  RPELCourseHeadView.m
//  RetailPlus
//
//  Created by lin dong on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPELCourseHeadView.h"

@implementation RPELCourseHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setCatagory:(RPELCourseCatagory *)catagory
{
    _catagory = catagory;
    _lbCatagory.text = catagory.strCatagory;
    if (catagory.bExpand)
        _ivExpand.image = [UIImage imageNamed:@"icon_arrow_down_gray.png"];
    else
        _ivExpand.image = [UIImage imageNamed:@"icon_arrow_right_gray.png"];
}

-(IBAction)OnExpand:(id)sender
{
    [_delegate OnExpandCatagory:_catagory];
}

@end
