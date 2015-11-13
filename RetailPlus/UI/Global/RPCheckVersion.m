//
//  RPCheckVersion.m
//  RetailPlus
//
//  Created by lin dong on 14-5-6.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCheckVersion.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

@implementation RPCheckVersion

+(void)CheckVersion
{
    static BOOL bShowUpdateView = NO;
    if (bShowUpdateView) return;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    VersionModel * version = [[RPSDK defaultInstance] CheckVersion:app_Version];
    if (version) {
        if (version.status == VersionStatus_Force)
        {
            bShowUpdateView = YES;
            NSString * strDesc = [NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTableInBundle(@"Found new version",@"RPString", g_bundleResorce,nil),version.strVersionNum];
            RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"Update",@"RPString", g_bundleResorce,nil) clickButton:^(NSInteger indexButton){
                NSURL* url = [[ NSURL alloc] initWithString:version.strDownloadURL];
                [[UIApplication sharedApplication] openURL:url];
                exit(0);
                bShowUpdateView = NO;
            } otherButtonTitles:nil];
            [alertView show];
        }
        
        if (version.status == VersionStatus_recommend) {
            bShowUpdateView = YES;
            
            NSString * strDesc = [NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTableInBundle(@"Found new version",@"RPString", g_bundleResorce,nil),version.strVersionNum];
            RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"Cancel",@"RPString", g_bundleResorce,nil) clickButton:^(NSInteger indexButton){
                if (indexButton == 1) {
                    NSURL* url = [[ NSURL alloc] initWithString:version.strDownloadURL];
                    [[UIApplication sharedApplication] openURL:url];
                    exit(0);
                }
                bShowUpdateView = NO;
            } otherButtonTitles:NSLocalizedStringFromTableInBundle(@"Update",@"RPString", g_bundleResorce,nil),nil];
            [alertView show];
        }
    }
    else
    {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Network Unavailable\rPlease check your network",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
    }
}
@end
