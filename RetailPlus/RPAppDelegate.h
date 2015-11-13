//
//  RPAppDelegate.h
//  RetailPlus
//
//  Created by lin dong on 13-8-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>



@class RPMainViewController;

@interface RPAppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL _bStartUpGetDeviceId;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RPMainViewController *viewController;

@end
