//
//  RPCompareView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-4-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCompareView.h"

@implementation RPCompareView

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

- (IBAction)OnChooseDate:(id)sender {
    //不操作
}

- (IBAction)OnDateSelect1:(id)sender {
     //不操作
}

- (IBAction)OnDateSelect2:(id)sender {
     //不操作
}
-(int)getIndex1
{
    return 1;
}
-(int)getIndex2
{
    return 2;
}
@end
