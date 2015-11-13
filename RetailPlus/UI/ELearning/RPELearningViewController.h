//
//  RPELearningViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-7-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
#import "RPELMainViewController.h"

@interface RPELearningViewController : RPTaskBaseViewController<UINavigationControllerDelegate>
{
    UINavigationController * _vcNav;
    RPELMainViewController * _vcRoot;
}
@property (nonatomic,assign) UIViewController * vcFrame;
@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;

@end
