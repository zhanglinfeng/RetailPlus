//
//  RPShakeNotify.m
//  RetailPlus
//
//  Created by lin dong on 14-4-14.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPShakeNotify.h"


@implementation RPShakeNotify

static RPShakeNotify *defaultObject;

+(RPShakeNotify *)defaultInstance
{
    @synchronized(self){
        if (!defaultObject)
        {
            defaultObject = [[self alloc] init];
        }
    }
    return defaultObject;
}

-(id)init
{
    id ret = [super init];
    if (ret) {
        _vcShakeNotify = [[RPShakeNotifyViewController alloc] initWithNibName:NSStringFromClass([RPShakeNotifyViewController class]) bundle:nil];
        
    }
    return ret;
}

- (void)Start:(UIView *)view
{
    _cmManager = [[CMMotionManager alloc]init];
    if (!_cmManager.accelerometerAvailable) {
        NSLog(@"CMMotionManager unavailable");
    }
    _cmManager.accelerometerUpdateInterval =0.5; // 数据更新时间间隔
    [_cmManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]withHandler:^(CMAccelerometerData *accelerometerData,NSError *error) {
        double x = accelerometerData.acceleration.x;
        double y = accelerometerData.acceleration.y;
        double z = accelerometerData.acceleration.z;
        
        if (fabs(x)>2.0 ||fabs(y)>2.0 ||fabs(z)>2.0) {
            NSLog(@"CoreMotionManager, x: %f,y: %f, z: %f",x,y,z);
            if ([self.delegate GetShakeNotifyType] > 0) {
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
                    _vcShakeNotify.view.frame = CGRectMake(0, 20, view.frame.size.width, view.frame.size.height - 20);
                else
                    _vcShakeNotify.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
                _vcShakeNotify.type = [self.delegate GetShakeNotifyType];
                [view addSubview:_vcShakeNotify.view];
            }
        }
    }];
}

@end
