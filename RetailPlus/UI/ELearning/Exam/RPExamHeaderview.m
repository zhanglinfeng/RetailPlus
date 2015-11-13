//
//  RPExamHeaderview.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPExamHeaderview.h"

@implementation RPExamHeaderview

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
-(void)setPaperList:(RPELPaperList *)paperList
{
    _paperList=paperList;
    _lbType.text=paperList.strType;
}

- (IBAction)OnExpand:(id)sender
{
    _paperList.bExpand=!_paperList.bExpand;
    
    [self.delegate OnExpandExamHeader:_paperList];
}
@end
