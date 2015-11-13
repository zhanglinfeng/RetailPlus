//
//  RPELCourseCell.m
//  RetailPlus
//
//  Created by lin dong on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPELCourseCell.h"
#import "UIImageView+WebCache.h"

#define PI 3.14159265358979323846  

@implementation RPELCourseCell

- (void)awakeFromNib
{
    // Initialization code
    _ivThumb.layer.cornerRadius = 6;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

static float radians(double degrees) {
    return degrees * PI / 180;
}

-(UIImage *)GetRoundImg:(float)fPercent
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil,72,92,8,0, colorSpace,1);
    CFRelease(colorSpace);
    
    UIImage *imageback = [UIImage imageNamed:@"icon_courselist_unread.png"];
    [imageback drawInRect:CGRectMake(0, 0, 72, 92)];//在坐标中画出图片
    CGContextDrawImage(context, CGRectMake(0, 0, 72, 92), imageback.CGImage);
    
    CGColorRef fillColor = [[UIColor whiteColor] CGColor];
    CGContextSetFillColor(context, CGColorGetComponents(fillColor));
    CGContextMoveToPoint(context, 36, 62);
    
    CGContextAddArc(context, 36, 62, 15, radians(90),radians(90 - 360 * fPercent), 1);
    CGContextFillPath(context);
    
    // convert the context into a CGImageRef
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    return [UIImage imageWithCGImage:image];
}

-(void)setCourse:(RPELCourse *)course
{
    _course = course;
    _lbNo.text = course.strNo;
    _lbTitle.text = course.strName;
    _lbDesc.text = course.strDesc;
    
    if (course.strDesc.length == 0)
        _lbDesc.hidden = YES;
    else
        _lbDesc.hidden = NO;
    
    [_ivThumb setImageWithURLString:course.strThumbUrl];
    
    NSInteger nRead = 0;
    for (RPELCourseWare * ware in course.arrayCourseWare) {
        if (ware.bRead) nRead ++;
    }
    
    if (nRead == 0)
    {
        _viewFrame.backgroundColor = [UIColor colorWithRed:190.0f/255 green:60.0f/255 blue:70.0f/255 alpha:1];
        _ivProgress.image = [UIImage imageNamed:@"icon_courselist_unread.png"];
    }
    else if (nRead == course.arrayCourseWare.count)
    {
        _viewFrame.backgroundColor = [UIColor colorWithRed:135.0f/255 green:150.0f/255 blue:85.0f/255 alpha:1];
        _ivProgress.image = [UIImage imageNamed:@"icon_courselist_finished.png"];
    }
    else
    {
        _viewFrame.backgroundColor = [UIColor colorWithRed:247.0f/255 green:177.0f/255 blue:15.0f/255 alpha:1];
        _ivProgress.image = [self GetRoundImg:(float)nRead / course.arrayCourseWare.count];
    }
    
    NSString * strProgress = [NSString stringWithFormat:@"%d/%d",nRead,course.arrayCourseWare.count];
    _lbProgress.text = strProgress;
    
}
@end
