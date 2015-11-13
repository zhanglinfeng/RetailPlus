//
//  RPSystemTaskBaseViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-8-30.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPSystemTaskBaseViewController.h"

@interface RPSystemTaskBaseViewController ()

@end

@implementation RPSystemTaskBaseViewController

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

-(void)ShowTitleBar
{
    
}

-(void)HideTitleBar
{
    
}

-(BOOL)OnBack
{
    return YES;
}

-(BOOL)isLastView
{
    return YES;
}

@end
