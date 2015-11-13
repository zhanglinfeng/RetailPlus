//
//  RPSystemTaskBaseViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-8-30.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPSystemTaskBaseViewControllerDelegate <NSObject>
-(void)OnSystemTaskViewChanged;
@end

@interface RPSystemTaskBaseViewController : UIViewController

@property (nonatomic,assign) id<RPSystemTaskBaseViewControllerDelegate> delegateTask;
@property (nonatomic,retain) NSString * strTaskName;

-(void)ShowTitleBar;
-(void)HideTitleBar;
-(BOOL)OnBack;
-(BOOL)isLastView;
@end
