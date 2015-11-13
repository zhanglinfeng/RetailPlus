//
//  RPTaskNavViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-7-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTaskNavViewController.h"

@interface RPTaskNavViewController ()

@end

@implementation RPTaskNavViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)OnNavBack
{
    [self DoNavBack];
}

-(void)DoNavBack
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)DoNavRoot
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)DoQuit
{
    [self.delegate OnTaskEnd];
}
-(void)OnActive
{
    
}
@end
