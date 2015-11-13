//
//  RPMarkImageViewController.m
//  RetailPlusIOS
//
//  Created by lin dong on 13-7-23.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPMarkImageViewController.h"

@interface RPMarkImageViewController ()

@end

@implementation RPMarkImageViewController

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
    _viewFrame.layer.cornerRadius = 8;

    if (!self.bReadOnly)
    {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        [backButton setImage:[UIImage imageNamed:@"Submit1.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"Submit2.png"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(ConfirmAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.rightBarButtonItem =temporaryBarButtonItem;
    }
    _markView.bReadOnly = self.bReadOnly;
    
    _imgView.image = _issueImage.imgIssue;
    [_markView SetRect:_issueImage.rcIssue ScaleX:_imgView.image.size.width / _markView.frame.size.width ScaleY:_imgView.image.size.height / _markView.frame.size.height];
}

-(IBAction)ConfirmAction
{
    _issueImage.rcIssue = [_markView GetRect];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setImage:(InspIssueImage *)image
{
    _issueImage = image;
    _imgView.image = _issueImage.imgIssue;
    [_markView SetRect:_issueImage.rcIssue ScaleX:_imgView.image.size.width / _markView.frame.size.width ScaleY:_imgView.image.size.height / _markView.frame.size.height];
}

-(void)setBReadOnly:(BOOL)bReadOnly
{
    _bReadOnly = bReadOnly;
    _markView.bReadOnly = self.bReadOnly;
}

-(IBAction)OnConfirm:(id)sender
{
    _issueImage.rcIssue = [_markView GetRect];
    [self.delegate OnMarkInViewEnd];
}
@end
