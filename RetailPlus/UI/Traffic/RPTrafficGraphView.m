//
//  RPTrafficGraphView.m
//  RetailPlus
//
//  Created by lin dong on 13-8-14.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPTrafficGraphView.h"

@implementation RPTrafficGraphView

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
    CGRect rcFrame = CGRectMake(0, 0, _scrollFrame.frame.size.width, _scrollFrame.frame.size.height);
    _viewGraph1.frame = rcFrame;
    [_scrollFrame addSubview:_viewGraph1];
    
    rcFrame.origin.x = _scrollFrame.frame.size.width;
    _viewGraph2.frame = rcFrame;
    [_scrollFrame addSubview:_viewGraph2];
    
    rcFrame.origin.x = _scrollFrame.frame.size.width * 2;
    _viewGraph3.frame = rcFrame;
    [_scrollFrame addSubview:_viewGraph3];
    
    _scrollFrame.contentSize = CGSizeMake(_scrollFrame.frame.size.width * 3, _scrollFrame.frame.size.height);
    
}

-(void)setFrame:(CGRect)frame
{
    _scrollFrame.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
    [super setFrame:frame];
}
@end
