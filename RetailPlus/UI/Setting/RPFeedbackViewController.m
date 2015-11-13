//
//  RPFeedbackViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-10-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPFeedbackViewController.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

@interface RPFeedbackViewController ()

@end

@implementation RPFeedbackViewController

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
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"FEEDBACK",@"RPString", g_bundleResorce,nil);
    
    _viewFrame.layer.cornerRadius = 5;
    _tvFeedback.layer.cornerRadius = 5;
    _tvFeedback.layer.borderWidth = 1;
    _tvFeedback.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _btnSubmit.layer.cornerRadius = 6;
    _btnSubmit.layer.borderWidth = 1;
    _btnSubmit.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    [self.view addGestureRecognizer:singleTapGR];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)OnOk:(id)sender
{
    [self.view endEditing:YES];
    
    if (_tvFeedback.text.length > 0)
    {
//        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
//        if (!mailClass) {
//            // [self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
//            return;
//        }
//        if (![mailClass canSendMail]) {
//            // [self alertWithMessage:@"用户没有设置邮件账户"];
//            return;
//        }
//        [self displayMailPicker];
        NSString * str = NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showWithStatus:str];
        
        [[RPSDK defaultInstance] FeedBack:_tvFeedback.text Success:^(id dictResult) {
            NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Your feedback is submitted.Thank you very much!",@"RPString", g_bundleResorce,nil);
            RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strOK clickButton:^(NSInteger indexButton){
                if (indexButton == 0) {
                    [self.delegate OnTaskEnd];
                }
            } otherButtonTitles:nil];
            [alertView show];
            [SVProgressHUD dismiss];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
    else
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Feedback is empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:strDesc];
    }
}

//调出邮件发送窗口
- (void)displayMailPicker
{
    _mailPicker = [[MFMailComposeViewController alloc] init];
    _mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [_mailPicker setSubject: @"Retail Pro Feedback"];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"autoreport@r-vision-group.com"];
    [_mailPicker setToRecipients: toRecipients];
    
    [_mailPicker setMessageBody:_tvFeedback.text isHTML:YES];
    
    [self.vcFrame presentViewController:_mailPicker animated:YES completion:^{
        
    }];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [_mailPicker dismissViewControllerAnimated:YES completion:^{
        [self.delegate OnTaskEnd];
    }];
    
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
    //  [self alertWithMessage:msg];
}
-(BOOL)OnBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    return YES;
}
@end
