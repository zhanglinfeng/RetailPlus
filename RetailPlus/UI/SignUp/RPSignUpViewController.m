//
//  RPSignUpViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-8-13.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPSignUpViewController.h"
#import "RPSignUpProfileViewController.h"

extern NSBundle  * g_bundleResorce;

@interface RPSignUpViewController ()

@end

@implementation RPSignUpViewController

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
    _navCtrl.view.frame = CGRectMake(0, 0, _viewNavFrame.frame.size.width, _viewNavFrame.frame.size.height);
    [_viewNavFrame addSubview:_navCtrl.view];
    _rootViewCtrl.delegate = self;
    _rootViewCtrl.vcFrame = self;
    
    CGSize szScreen = [[UIScreen mainScreen] bounds].size;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        _viewBorder.frame = CGRectMake(0, 20, szScreen.width, szScreen.height - 20);
    else
        _viewBorder.frame = CGRectMake(0, 0, szScreen.width, szScreen.height - 20);
    
    [self setUpForDismissKeyboard];
}

- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                    [UIView beginAnimations:nil context:nil];
                    self.view.frame = CGRectMake(0, -80, self.view.frame.size.width, self.view.frame.size.height);
                    [UIView commitAnimations];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                    [UIView beginAnimations:nil context:nil];
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
                        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                    else
                        self.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
                    [UIView commitAnimations];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)OnBackBtn:(id)sender
{
    UIViewController * viewCtrl = [_navCtrl popViewControllerAnimated:YES];
    if (viewCtrl == nil) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[RPSignUpProfileViewController class]])
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"PROFILE",@"RPString", g_bundleResorce,nil);
        _lbTitle.text = strDesc;
    }
    else
    {
         NSString * strDesc = NSLocalizedStringFromTableInBundle(@"SIGN UP",@"RPString", g_bundleResorce,nil);
        _lbTitle.text = strDesc;
    }
}

-(void)OnSignUpSuccess:(NSInteger)nInviteStatus Account:(NSString *)strAccount PassWord:(NSString *)strPassWord
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate OnSignUpSuccess:nInviteStatus Account:strAccount PassWord:strPassWord];
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
