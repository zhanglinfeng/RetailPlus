//
//  RPShakeNotify.h
//  RetailPlus
//
//  Created by lin dong on 14-4-14.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CMMotionManager.h>
#import "RPShakeNotifyViewController.h"

@protocol RPShakeNotifyDelegate<NSObject>
-(NSInteger)GetShakeNotifyType;
@end

@interface RPShakeNotify : NSObject
{
    CMMotionManager             * _cmManager;
    UIImageView                 * _ivImage;
    RPShakeNotifyViewController * _vcShakeNotify;
}

@property (nonatomic,assign) id<RPShakeNotifyDelegate> delegate;

@property (nonatomic) NSInteger nShakeNotifyUIIndex;

+(RPShakeNotify *)defaultInstance;
-(void)Start:(UIView *)view;

@end
