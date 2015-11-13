//
//  BlockUIAlertView.m
//  RetailPlus
//
//  Created by lin dong on 13-8-22.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "BlockUIAlertView.h"

@implementation BlockUIAlertView

@synthesize block;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
        clickButton:(AlertBlock)_block
  otherButtonTitles:(NSString *)otherButtonTitles otherButtonTitles2:(NSString *)otherButtonTitles2 {
    
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,otherButtonTitles2,nil];
    
    if (self) {
        self.block = _block;
    }
    
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.block(buttonIndex);
}


@end
