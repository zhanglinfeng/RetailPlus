//
//  RPBlockUIAlertView.h
//  RetailPlus
//
//  Created by lin dong on 13-10-22.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RPAlertBlock)(NSInteger);

@interface RPBlockUIAlertView : UIView
{
    UIView          * _viewFrame;
    UIView          * _viewBackground;
    UILabel         * _lbTitle;
    NSMutableArray  * _arrayButton;
}

@property(nonatomic,copy)RPAlertBlock block;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
        clickButton:(RPAlertBlock)blockSet
  otherButtonTitles:(NSString *)otherButtonTitles,...NS_REQUIRES_NIL_TERMINATION;

-(void)show;
@end
