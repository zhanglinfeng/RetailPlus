//
//  RPTaskNavViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-7-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPMainViewController.h"

@interface RPTaskNavViewController : UIViewController

-(void)OnNavBack;
-(void)OnActive;

-(void)DoNavBack;
-(void)DoNavRoot;
-(void)DoQuit;

@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;

@end
