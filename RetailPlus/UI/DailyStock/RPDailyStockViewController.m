//
//  RPDailyStockViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-7-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPDailyStockViewController.h"
#import "RPTaskNavViewController.h"
extern NSBundle * g_bundleResorce;
@interface RPDailyStockViewController ()

@end

@implementation RPDailyStockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"DAILY STOCK",@"RPString", g_bundleResorce,nil);
    // Do any additional setup after loading the view from its nib.
    _vcRoot = [[RPDSMainViewController alloc] initWithNibName:NSStringFromClass([RPDSMainViewController class]) bundle:g_bundleResorce];

    
    _vcRoot.delegate = self.delegate;
    _vcRoot.vcFrame=self.vcFrame;
    _vcRoot.storeSelected=self.storeSelected;
    _vcRoot.tag=self.tag;
    _vcNav = [[UINavigationController alloc] initWithRootViewController:_vcRoot];
    _vcNav.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _vcNav.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]init];
    _vcNav.navigationBar.hidden = YES;
    _vcNav.delegate = self;
   // _vcNav.interactivePopGestureRecognizer.enabled = NO;
    
    [self.view addSubview:_vcNav.view];
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [(RPTaskNavViewController *)_vcNav.topViewController OnActive];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)OnBack
{
    if (_vcNav.viewControllers.count == 1 ) {
        return [_vcRoot OnBack];
//        return  YES;
    }
    
    [(RPTaskNavViewController *)_vcNav.topViewController OnNavBack];
    return NO;
}

@end
