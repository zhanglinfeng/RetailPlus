//
//  RPImageMarkTouchView.h
//  DrawPicTest
//
//  Created by lin dong on 13-7-19.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPImageMarkTouchView : UIView
{
    CGPoint _startPos;
    CGPoint _lastPos;
    BOOL    _touched;
    float   fScaleX;
    float   fScaleY;
}

@property (nonatomic) BOOL bReadOnly;

-(void)SetRect:(CGRect)rcPos ScaleX:(float)fx ScaleY:(float)fy;
-(CGRect)GetRect;

@end
