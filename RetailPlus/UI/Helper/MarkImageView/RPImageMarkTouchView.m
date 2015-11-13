//
//  RPImageMarkTouchView.m
//  DrawPicTest
//
//  Created by lin dong on 13-7-19.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPImageMarkTouchView.h"

@implementation RPImageMarkTouchView

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

-(BOOL)isMultipleTouchEnabled
{
    return NO;    
}

-(void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置矩形填充颜色：红色
    //CGContextSetFillColor(context, [UIColor clearColor].CGColor);
    //设置画笔颜色：黑色
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    //设置画笔线条粗细
    CGContextSetLineWidth(context, 2.0);
    
    float lengths[] = {10,10};
    CGContextSetLineDash(context, 0, (CGFloat *)lengths,2);
    //画矩形边框
    CGContextAddRect(context,CGRectMake(_startPos.x, _startPos.y, _lastPos.x - _startPos.x, _lastPos.y - _startPos.y));
    //执行绘画
    CGContextStrokePath(context);
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.bReadOnly) return;
    
    _startPos = [[touches anyObject] locationInView:self];
    
    _lastPos = _startPos;
    
    _touched = YES;
    
    [self setNeedsDisplay];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.bReadOnly) return;
    
    _lastPos = [[touches anyObject] locationInView:self];
    if (_lastPos.x < 0) {
        _lastPos.x = 0;
    }
    if (_lastPos.y < 0) {
        _lastPos.y = 0;
    }
    
    if (_lastPos.x > self.frame.size.width) {
        _lastPos.x = self.frame.size.width;
    }
    if (_lastPos.y > self.frame.size.height) {
        _lastPos.y = self.frame.size.height;
    }
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touched = NO;
    [self setNeedsDisplay];
}

-(void)SetRect:(CGRect)rcPos ScaleX:(float)fx ScaleY:(float)fy
{
    if (fx == 0 || fy == 0) {
        return;
    }
    
    fScaleX = fx;
    fScaleY = fy;
    
    _startPos = CGPointMake(rcPos.origin.x / fx, rcPos.origin.y / fy) ;
    _lastPos = CGPointMake(_startPos.x + rcPos.size.width / fx, _startPos.y + rcPos.size.height / fy);
    [self setNeedsDisplay];
}

-(CGRect)GetRect
{
    return CGRectMake(
                    (_startPos.x < _lastPos.x ? _startPos.x : _lastPos.x)*fScaleX,
                    (_startPos.y < _lastPos.y ? _startPos.y : _lastPos.y)*fScaleY,
                    ((_lastPos.x - _startPos.x) > 0 ? (_lastPos.x - _startPos.x) :(_startPos.x - _lastPos.x))*fScaleX,
                    ((_lastPos.y - _startPos.y) > 0 ? (_lastPos.y - _startPos.y) :(_startPos.y - _lastPos.y))*fScaleY);
}

@end
