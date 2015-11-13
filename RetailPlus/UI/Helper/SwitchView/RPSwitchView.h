//
//  RPSwitchView.h
//  RetailPlus
//
//  Created by lin dong on 13-9-2.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RPSWITCH_BARWIDTH 30

@class RPSwitchView;

@protocol RPSwitchViewDelegate <NSObject>
    -(void)SelectSwitch:(RPSwitchView *)view isOn:(BOOL)bOn;
@end

@interface RPSwitchView : UIView
{
    UIImageView * _ivBack;
    UIImageView * _ivFrame;
    UIButton    * _btnBar;
    BOOL        _bOn;
}

-(void)SetOn:(BOOL)bOn;

@property (nonatomic,assign) id<RPSwitchViewDelegate> delegate;
@property (nonatomic,assign) UIImage * imgBack;

@end
