//
//  RPAppDelegate.m
//  RetailPlus
//
//  Created by lin dong on 13-8-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPAppDelegate.h"
#import "VideoPlaySDK.h"
#import "RPMainViewController.h"
#import "SVProgressHUD.h"
#import "ELCUIApplication.h"
#import "RPCheckVersion.h"

//#import "ELCUIApplication.h"
//#import "RPLoginViewController.h"
@implementation RPAppDelegate

extern LangType g_langType;
extern NSString * g_strLangCode;
extern NSBundle * g_bundleResorce;


NSString    * g_strDeviceToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   // NSUUID * uuid = [[UIDevice currentDevice] identifierForVendor];
//    application.applicationSupportsShakeToEdit = YES;//允许摇动手势
    VP_InitSDK();
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSString *filename=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"language.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSNumber * num = [data objectForKey:@"LanguageEnum"];
    if (num != nil) g_langType = num.integerValue;
    else g_langType = LangType_Auto;
    
    switch (g_langType) {
        case LangType_Auto:
        {
            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
            NSArray * languages = [defs objectForKey:@"AppleLanguages"];
            NSString * preferredLang = [languages objectAtIndex:0];
            if ([preferredLang isEqualToString:@"zh-Hans"]) {
                g_strLangCode = @"zh-Hans";
            }
            else
            {
                g_strLangCode = @"Base";
            }
        }
            break;
        case LangType_English:
            g_strLangCode = @"Base";
            break;
        case  LangType_Hans:
            g_strLangCode = @"zh-Hans";
            break;
    }
    
    NSString *path = [[ NSBundle mainBundle ] pathForResource:g_strLangCode ofType:@"lproj" ];
    g_bundleResorce = [NSBundle bundleWithPath:path];
    [SVProgressHUD showWithStatus:@""];
    
    _bStartUpGetDeviceId = NO;
    
    [self StartUI];
//    [application registerForRemoteNotificationTypes:
//     UIRemoteNotificationTypeBadge |
//     UIRemoteNotificationTypeAlert |
//     UIRemoteNotificationTypeSound];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        //这里还是原来的代码
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    NSString *s1=@"aaa";
    NSString *s2=@"bbb";
    NSString *s3=@"ccc";
    NSString *s4=@"ddd";
    NSString *documentsPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"documentsPath====%@",documentsPath);
    NSString *filePath1 = [documentsPath stringByAppendingPathComponent:@"11.txt"];
    NSString *filePath2 = [documentsPath stringByAppendingPathComponent:@"12.txt"];
    NSString *filePath3 = [documentsPath stringByAppendingPathComponent:@"21.txt"];
    NSString *filePath4 = [documentsPath stringByAppendingPathComponent:@"22.txt"];
    
    [s1 writeToFile:filePath1
                 atomically:YES
                   encoding:NSUTF8StringEncoding
                      error:nil];
    [s2 writeToFile:filePath2
         atomically:YES
           encoding:NSUTF8StringEncoding
              error:nil];
    [s3 writeToFile:filePath3
         atomically:YES
           encoding:NSUTF8StringEncoding
              error:nil];
    [s4 writeToFile:filePath4
         atomically:YES
           encoding:NSUTF8StringEncoding
              error:nil];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                           forKey:NSFileProtectionKey];
    [[NSFileManager defaultManager] setAttributes:attributes
                                     ofItemAtPath:filePath1
                                            error:nil];
    [[NSFileManager defaultManager] setAttributes:attributes
                                     ofItemAtPath:filePath2
                                            error:nil];
    [[NSFileManager defaultManager] setAttributes:attributes
                                     ofItemAtPath:filePath3
                                            error:nil];
    [[NSFileManager defaultManager] setAttributes:attributes
                                     ofItemAtPath:filePath4
                                            error:nil];
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    [[NSNotificationCenter defaultCenter]
//	 postNotificationName:kApplicationDidTimeoutNotification object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)StartUI
{
    self.viewController = [[RPMainViewController alloc] initWithNibName:@"RPMainViewController" bundle:g_bundleResorce];
    
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    
    [RPCheckVersion CheckVersion];
}

- ( void )application : (UIApplication * )application didRegisterForRemoteNotificationsWithDeviceToken : ( NSData * )deviceToken
{
    g_strDeviceToken = [[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""];
   
    g_strDeviceToken = [[g_strDeviceToken description] stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    g_strDeviceToken = [[g_strDeviceToken description] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (!_bStartUpGetDeviceId)
    {
        NSLog ( @ "DeviceToken: {%@}",deviceToken );
        //这里进行的操作，是将Device Token发送到服务端
        [SVProgressHUD dismiss];
        _bStartUpGetDeviceId = YES;
        if ([RPSDK defaultInstance].userLoginDetail) {
            [[RPSDK defaultInstance] UpdateDeviceToken:g_strDeviceToken Success:^(id idResult) {
                
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                
            }];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (!_bStartUpGetDeviceId) {
        NSLog(@"Regist fail%@",error);
        g_strDeviceToken = nil;
        [SVProgressHUD dismiss];
        _bStartUpGetDeviceId = YES;
    }
}
@end
