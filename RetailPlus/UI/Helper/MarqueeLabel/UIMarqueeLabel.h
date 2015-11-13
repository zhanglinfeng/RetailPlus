//
//  UIMarqueeLabel.h
//  testlabel
//
//  Created by lin dong on 14-4-11.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIMarqueeLabel : UILabel
{
    NSTimer     * _timer;
    NSInteger   _nOffset;
    NSInteger   _nBreakCount;
}

-(void)Start;
-(void)Stop;

@end
