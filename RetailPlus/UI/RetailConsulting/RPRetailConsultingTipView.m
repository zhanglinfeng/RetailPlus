//
//  RPRetailConsultingTipView.m
//  RetailPlus
//
//  Created by lin dong on 14-6-25.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPRetailConsultingTipView.h"

@implementation RPRetailConsultingTipView

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
    _viewFrame.layer.cornerRadius = 8;
    _btnOK.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnOK.layer.borderWidth = 1;
    _btnOK.layer.cornerRadius = 6;
}

-(IBAction)OnClose:(id)sender
{
    [self removeFromSuperview];
    [self.delegate OnConfirmPost];
}
@end
