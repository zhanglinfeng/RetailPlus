//
//  RPChangeBindEmailView.m
//  RetailPlus
//
//  Created by lin dong on 13-11-13.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPChangeBindEmailView.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

@implementation RPChangeBindEmailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)awakeFromNib
{
    _viewFrame.layer.cornerRadius = 8;
    _viewNewEmail.layer.cornerRadius = 6;
    _viewCode.layer.cornerRadius = 6;
    _btnSendCode.layer.cornerRadius = 6;
    _btnSendCode.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnSendCode.layer.borderWidth = 1;
    [self setUpForDismissKeyboard];
}

- (void)setUpForDismissKeyboard {
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapAnywhereToDismissKeyboard:)];
    [self addGestureRecognizer:singleTapGR];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self endEditing:YES];
}

-(IBAction)OnVerify:(id)sender
{
    [[RPSDK defaultInstance] VerifyIdCert:_tfCode.text CertType:CertType_ChangeBoundMail Success:^(id idResult) {
        _viewVerifyThrough.strEmail = _tfMail.text;
        _viewVerifyThrough.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        _viewVerifyThrough.delegate = self.delegate;
        [self addSubview:_viewVerifyThrough];
        [UIView beginAnimations:nil context:nil];
        _viewVerifyThrough.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        
        NSString * str = NSLocalizedStringFromTableInBundle(@"SECURITY VERIFICATION",@"RPString", g_bundleResorce,nil);
        [self.delegate OnSetTitle:str];
        
        _bNext = YES;
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {

    }];
    [self endEditing:YES];
}

-(BOOL)OnBack
{
    [self endEditing:YES];
    
    if (_bNext) {
        _bNext = ![_viewVerifyThrough OnBack];
        if (!_bNext) {
            [UIView beginAnimations:nil context:nil];
            _viewVerifyThrough.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            
            NSString * str = NSLocalizedStringFromTableInBundle(@"CHANGE EMAIL BINDING",@"RPString", g_bundleResorce,nil);
            [self.delegate OnSetTitle:str];
        }
        return NO;
    }
    return YES;
}
- (BOOL)isValidateEmail:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}
-(IBAction)OnGetCode:(id)sender
{
    if (![self isValidateEmail:_tfMail.text]) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Email address format is not correct",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showSuccessWithStatus:str];
        return;
    }
    if (_tfMail.text.length > 0) {
        [[RPSDK defaultInstance] RequestIdCert:_tfMail.text CertDevice:CertDevice_Email CertType:CertType_ChangeBoundMail withLoginToken:YES Success:^(id idResult) {
            NSString * str = NSLocalizedStringFromTableInBundle(@"Verify Code is sent",@"RPString", g_bundleResorce,nil);
            [SVProgressHUD showSuccessWithStatus:str];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {

        }];
        [self endEditing:YES];
    }
}
@end
