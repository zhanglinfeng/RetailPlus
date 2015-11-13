//
//  RPELRecordHeadView.m
//  RetailPlus
//
//  Created by lin dong on 14-8-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPELRecordHeadView.h"

@implementation RPELRecordHeadView

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
-(void)setCatagory:(RPELRecordCatagory *)catagory
{
    _catagory = catagory;
    _lbCatagory.text = catagory.strCatagory;
    if (catagory.bExpand)
        _ivExpand.image = [UIImage imageNamed:@"icon_arrow_down_white.png"];
    else
        _ivExpand.image = [UIImage imageNamed:@"icon_arrow_right_white.png"];
}

-(void)setBLearnRecord:(BOOL)bLearnRecord
{
    if (bLearnRecord)
        _viewContent.backgroundColor = [UIColor colorWithRed:202.0f/255 green:82.0f/255 blue:43.0f/255 alpha:1];
    else
        _viewContent.backgroundColor = [UIColor colorWithRed:135.0f/255 green:150.0f/255 blue:85.0f/255 alpha:1];
}

-(IBAction)OnExpand:(id)sender
{
    [_delegate OnExpandCatagory:_catagory];
}
@end
