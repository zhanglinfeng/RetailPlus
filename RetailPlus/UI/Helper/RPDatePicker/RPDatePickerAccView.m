//
//  RPDatePickerAccView.m
//  InputTable
//
//  Created by lin dong on 13-12-21.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPDatePickerAccView.h"

@implementation RPDatePickerAccView

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

-(IBAction)OnEndEdit:(id)sender
{
    if ([_viewParent isKindOfClass:[UITextField class]]) {
        [(UITextField *)_viewParent endEditing:YES];
    }
}
@end
