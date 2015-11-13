//
//  UIMarqueeLabel.m
//  testlabel
//
//  Created by lin dong on 14-4-11.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "UIMarqueeLabel.h"

@implementation UIMarqueeLabel

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
    [self Start];
}

- (void)onTimer
{
    if (_nBreakCount > 0) {
        _nBreakCount --;
        if (_nBreakCount == 0 && _nOffset != 0) {
            _nOffset = 0;
            _nBreakCount = 20;
            [self setNeedsDisplay];
        }
        return;
    }
    
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    if (size.width > self.frame.size.width) {
            _nOffset -= 1;
        
            if (_nOffset + size.width < self.frame.size.width) {
                _nBreakCount = 20;
            }
        [self setNeedsDisplay];
    }
}

-(void)Start
{
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    if (size.width > self.frame.size.width)
    {
        _nOffset = 0;
        _nBreakCount = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
}

-(void)Stop
{
    [_timer invalidate];
    _nOffset = 0;
    [self setNeedsDisplay];
}

-(void) drawTextInRect:(CGRect)rect {
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    rect.size.width = size.width;
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, _nOffset, 0, 0))];
}
@end
