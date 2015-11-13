//
//  RPAccountSetupViewControllerDelegate.h
//  RetailPlus
//
//  Created by lin dong on 13-11-13.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RPAccountSetupViewControllerDelegate <NSObject>
    -(void)OnSetTitle:(NSString *)strTitle;
    -(void)OnEnd;
@end
