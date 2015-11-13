//
//  RPDailyStockViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-7-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
#import "RPDSMainViewController.h"

@interface RPDailyStockViewController : RPTaskBaseViewController<UINavigationControllerDelegate>
{
    UINavigationController * _vcNav;
    RPDSMainViewController * _vcRoot;
}
@property (nonatomic,assign) UIViewController * vcFrame;
@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;
@property (nonatomic,assign) StoreDetailInfo * storeSelected;
@property(nonatomic,assign)NSInteger tag;//为-1表示从店铺进入
@end
