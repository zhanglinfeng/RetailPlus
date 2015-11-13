//
//  RPVisualMerchandisingViewController.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPVisualMerchandisingViewController.h"
extern NSBundle * g_bundleResorce;
@interface RPVisualMerchandisingViewController ()

@end

@implementation RPVisualMerchandisingViewController

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
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"VISUAL MERCHANDISING",@"RPString", g_bundleResorce,nil);
    _viewVisualMerchandising.delegate=self;
    _viewVisualDetail.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnVMProjects:(id)sender
{
    _viewVisualStoreList.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewVisualStoreList];
    [UIView beginAnimations:nil context:nil];
    _viewVisualStoreList.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _viewVisualStoreList.vcFrame=self.vcFrame;
    _viewVisualStoreList.delegate=self;
    _bProject=YES;
}

- (IBAction)OnVMGuide:(id)sender
{
    _viewGuide.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewGuide];
    [UIView beginAnimations:nil context:nil];
    _viewGuide.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _viewGuide.vcFrame=self.vcFrame;
    _viewGuide.delegate=self;
    _bGuide=YES;
}
-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}
-(BOOL)OnBack
{
    if (_bProject)
    {
        if ([_viewVisualStoreList OnBack])
        {
            [self dismissView:_viewVisualStoreList];
            _bProject=NO;
        }
        return NO;
    }
    if (_bGuide)
    {
        [self dismissView:_viewGuide];
        _bGuide=NO;
        return NO;
    }
    return YES;
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self.view];
}
-(void)endVisualStoreList
{
    [self.delegate OnTaskEnd];
}
-(void)endVisualMerchandising
{
    [self.delegate OnTaskEnd];
}
-(void)endVisualDetail
{
    [self.delegate OnTaskEnd];
}
-(void)endVMGuide
{
    [self.delegate OnTaskEnd];
}
@end
