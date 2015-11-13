//
//  RPGuide.m
//  RetailPlus
//
//  Created by lin dong on 14-8-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPGuide.h"
#import "RPBlockUIAlertView.h"

extern NSBundle * g_bundleResorce;

@implementation RPGuide

+(void)MakeCall:(NSString *)strPhone View:(UIView *)view
{
    UIWebView* callWebview =[[UIWebView alloc] init];
    
    NSString * strPhoneNo = [NSString stringWithFormat:@"tel://%@",strPhone];
    NSURL *telURL =[NSURL URLWithString:strPhoneNo];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [view addSubview:callWebview];
}

+(void)ShowGuide:(UIView *)view
{
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Have Problems in using?You can...",@"RPString", g_bundleResorce,nil);
    NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    NSString *strCall=NSLocalizedStringFromTableInBundle(@"DAIL HOT LINE OF CUSTOMER SERVICE",@"RPString", g_bundleResorce,nil);
//    NSString *strGuide=NSLocalizedStringFromTableInBundle(@"VIEW THE USER GUIDE",@"RPString", g_bundleResorce,nil);
    RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
        if (indexButton==0)
        {
            
        }
        else
        {
            [RPGuide MakeCall:@"4000196628" View:view];
        }
    }otherButtonTitles:strCall, nil];
    [alertView show];
}

@end
