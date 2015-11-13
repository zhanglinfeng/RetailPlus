//
//  RPDSReasonView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPDSReasonView.h"

@implementation RPDSReasonView

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
-(void)awakeFromNib
{
    _tvReason.layer.cornerRadius=4;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnTapped:)];
    [self addGestureRecognizer:tap];
    tap.cancelsTouchesInView=NO;//为yes只响应优先级最高的事件，Button高于手势，textfield高于手势，textview高于手势，手势高于tableview。为no同时都响应，默认为yes
    _tvReason.editable=NO;
}
-(void)OnTapped:(UITapGestureRecognizer *)tap
{
    [self endEditing:YES];
    [self removeFromSuperview];
   
}
@end
