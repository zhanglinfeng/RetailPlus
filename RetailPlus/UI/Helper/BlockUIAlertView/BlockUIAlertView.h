//
//  BlockUIAlertView.h
//  RetailPlus
//
//  Created by lin dong on 13-8-22.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertBlock)(NSInteger);

@interface BlockUIAlertView : UIAlertView

@property(nonatomic,copy)AlertBlock block;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
        clickButton:(AlertBlock)_block
  otherButtonTitles:(NSString *)otherButtonTitles otherButtonTitles2:(NSString *)otherButtonTitles2;

@end
