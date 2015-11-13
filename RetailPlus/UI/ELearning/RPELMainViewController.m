//
//  RPELMainViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-7-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPELMainViewController.h"
extern NSBundle * g_bundleResorce;
@interface RPELMainViewController ()

@end

@implementation RPELMainViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)OnBack
{
    return YES;
}

-(IBAction)OnRecord:(id)sender
{
    _vcRecord = [[RPELRecordViewController alloc]initWithNibName:NSStringFromClass([RPELRecordViewController class]) bundle:g_bundleResorce];
    _vcRecord.delegate=self.delegate;
    //    _vcAddRecord.delegateAddRecord=self;
    //    _vcAddRecord.vcFrame=self.vcFrame;
    //    _vcAddRecord.sn=_snSum;
    //    _vcAddRecord.storeSelected=_storeSelected;
    [self.navigationController pushViewController:_vcRecord animated:YES];
}

-(IBAction)OnLearinng:(id)sender
{
    _vcCourse = [[RPELCourseViewController alloc]initWithNibName:NSStringFromClass([RPELCourseViewController class]) bundle:g_bundleResorce];
    _vcCourse.delegate=self.delegate;
//    _vcAddRecord.delegateAddRecord=self;
//    _vcAddRecord.vcFrame=self.vcFrame;
//    _vcAddRecord.sn=_snSum;
//    _vcAddRecord.storeSelected=_storeSelected;
    [self.navigationController pushViewController:_vcCourse animated:YES];
}

-(IBAction)OnExam:(id)sender
{
    _vcExam = [[RPELExamViewController alloc]initWithNibName:NSStringFromClass([RPELExamViewController class]) bundle:g_bundleResorce];
    _vcExam.delegate=self.delegate;
    [self.navigationController pushViewController:_vcExam animated:YES];
}
- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self.view];
}
@end
