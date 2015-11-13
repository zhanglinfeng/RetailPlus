//
//  RPWakeUpView.m
//  RetailPlus
//
//  Created by zwhe on 13-12-17.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPWakeUpView.h"
#import "SVProgressHUD.h"
#import "ELCUIApplication.h"
#import "RPCheckVersion.h"
extern NSBundle * g_bundleResorce;
@implementation RPWakeUpView

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
    _viewPassword.layer.cornerRadius=7;
    _btContinue.layer.cornerRadius=7;
    _btContinue.layer.borderColor = [UIColor whiteColor].CGColor;
    _btContinue.layer.borderWidth=1;
    
    _tfPassword.secureTextEntry = YES;
}


- (void)OnEnd
{
    _tfPassword.text=@"";
    [self removeFromSuperview];
}

- (IBAction)OnContinue:(id)sender
{
    NSString * s=[_tfPassword text];
    NSLog(@"s====%@",s);
    NSLog(@"password=====%@",[[RPSDK defaultInstance]strLoginPassword]);
    if ([RPSDK defaultInstance].bDemoMode || [[[RPSDK defaultInstance]strLoginPassword] isEqualToString:s]) {
        _tfPassword.text=@"";
        [self removeFromSuperview];
        [RPCheckVersion CheckVersion];
    }
    else
    {
//        NSString * showError=NSLocalizedStringFromTableInBundle(@"Password error",@"RPString", g_bundleResorce,nil);
//        [SVProgressHUD showErrorWithStatus:showError];
        [self lockAnimationForView:_viewPassword];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:_vcParent
                                             selector:@selector(applicationDidTimeout:)
                                                 name:kApplicationDidTimeoutNotification object:nil];
}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.frame=CGRectMake(0, -44, self.frame.size.width, self.frame.size.height);
        
    } completion:^(BOOL finished){
        
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_tfPassword resignFirstResponder];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
    } completion:^(BOOL finished){
        
    }];

    return YES;
}

//输入密码错误View抖动
-(void)lockAnimationForView:(UIView*)view
{
    CALayer *lbl = [view layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-10, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+10, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [lbl addAnimation:animation forKey:nil];
}

-(IBAction)OnLogout:(id)sender
{
    _tfPassword.text=@"";
    [self removeFromSuperview];
    [self.delegate OnLogout];
}

@end
