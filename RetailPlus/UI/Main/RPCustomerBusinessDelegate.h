//
//  RPCustomerBusinessDelegate.h
//  RetailPlus
//
//  Created by lin dong on 14-3-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol RPCustomerBusinessDelegate <NSObject>
-(void)OnCustomerCCall:(Customer *)customer;

@end