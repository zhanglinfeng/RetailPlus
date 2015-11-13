//
//  RPShakeNotifyViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-5-21.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPShakeNotifyViewController.h"
extern NSBundle * g_bundleResorce;

@interface RPShakeNotifyViewController ()

@end

@implementation RPShakeNotifyViewController

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
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped:)];
    [self.view addGestureRecognizer:tap];
}

- (void)locationTapped:(UITapGestureRecognizer *)tap
{
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setType:(NSInteger)type
{
   _type = type;
   _ivImage.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"img_KPI_live_help@2x" ofType:@"png"]];
}
@end
