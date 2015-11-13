//
//  RPCustomerCellMaskView.m
//  RetailPlus
//
//  Created by lin dong on 13-12-24.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import "RPCustomerCellMaskView.h"
#import "UIButton+WebCache.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;
#define degreesToRadian(x) (M_PI * (x) / 180.0)

@implementation RPCustomerCellMaskView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    self.frame = CGRectMake(0, 0, keywindow.frame.size.width, keywindow.frame.size.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped:)];
    [self addGestureRecognizer:tap];
    
    _rcCall = _viewCall.frame;
    _rcMessage = _viewMessage.frame;
    _rcEdit = _viewEdit.frame;
    _rcPurchase = _viewPurchase.frame;
    
    _btnImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnImage.layer.borderWidth = 1;
    _btnImage.layer.cornerRadius = 5;
}
-(void)setCustomer:(Customer *)customer
{
    _customer=customer;
    if ([_customer.strRelationUserId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId] &&
        [RPRights hasRightsFunc:[RPSDK defaultInstance].llRights type:RPRightsFuncType_Customer])
    {
        _btEdit.alpha=1;
        _lbEdit.alpha=1;
        _btPurchase.alpha=1;
        _lbPurchase.alpha=1;
        _btEdit.userInteractionEnabled=YES;
        _btPurchase.userInteractionEnabled=YES;
    }
    else
    {
        _btEdit.alpha=0.5;
        _lbEdit.alpha=0.5;
        _btPurchase.alpha=0.5;
        _lbPurchase.alpha=0.5;
        _btEdit.userInteractionEnabled=NO;
        _btPurchase.userInteractionEnabled=NO;
    }
}
- (void)locationTapped:(UITapGestureRecognizer *)tap
{
    [self Hide];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)Show:(NSString *)strImgUrl Position:(CGPoint)pt
{
    NSInteger nOffset = pt.y - _btnImage.frame.origin.y;
    _viewFrame.frame = CGRectMake(0, nOffset, _viewFrame.frame.size.width, _viewFrame.frame.size.height);
    
    [_btnImage setImageWithURLString:strImgUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_userimage01_224.png"]];
    
    _viewCall.frame = _viewMessage.frame = _viewEdit.frame = _viewPurchase.frame = _btnImage.frame;
    
    CGAffineTransform oneTransform = CGAffineTransformRotate(_viewCall.transform, degreesToRadian(180));
    [_viewCall setTransform:oneTransform];
    [_viewMessage setTransform:oneTransform];
    [_viewEdit setTransform:oneTransform];
    [_viewPurchase setTransform:oneTransform];
    
    _lbCall.hidden = _lbMessage.hidden = _lbEdit.hidden = _lbPurchase.hidden = YES;
    
    self.alpha = 0;
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ShowTaskAnimationStopped)];
    
    self.alpha = 1;
    _viewCall.frame = _rcCall;
    _viewMessage.frame = _rcMessage;
    _viewEdit.frame = _rcEdit;
    _viewPurchase.frame = _rcPurchase;
    
    oneTransform = CGAffineTransformRotate(_viewCall.transform, degreesToRadian(180));
    [_viewCall setTransform:oneTransform];
    [_viewMessage setTransform:oneTransform];
    [_viewEdit setTransform:oneTransform];
    [_viewPurchase setTransform:oneTransform];
    
    [UIView commitAnimations];
}

-(IBAction)OnImage:(id)sender
{
    [self Hide];
}

-(void)MakeCall:(NSString *)strPhone
{
    UIWebView* callWebview =[[UIWebView alloc] init];
    
    NSString * strPhoneNo = [NSString stringWithFormat:@"tel://%@",strPhone];
    NSURL *telURL =[NSURL URLWithString:strPhoneNo];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self addSubview:callWebview];
    
    [self Hide];
}

-(void)MakeMsg:(NSString *)strPhone
{
//    UIWebView* callWebview =[[UIWebView alloc] init];
//    
//    NSString * strPhoneNo = [NSString stringWithFormat:@"sms://%@",strPhone];
//    NSURL *telURL =[NSURL URLWithString:strPhoneNo];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
//    [self addSubview:callWebview];
//
    [self Hide];
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.recipients = [NSArray arrayWithObject:strPhone];
            picker.messageComposeDelegate = self;
            [self.vcFrame presentViewController:picker animated:YES completion:^{
                
            }];
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    switch ( result ) {
        case MessageComposeResultCancelled:
        {
            //click cancel button
        }
            break;
        case MessageComposeResultFailed:// send failed
            
            break;
        case MessageComposeResultSent:
        {
            
            //do something
        }
            break;
        default:
            break;
    }
}

-(IBAction)OnCall:(id)sender
{
    NSString *s=NSLocalizedStringFromTableInBundle(@"Please select phone No.",@"RPString", g_bundleResorce,nil);
    NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    if (_customer.strPhone1.length > 0 && _customer.strPhone2.length > 0) {
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:s cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1) {
                [self MakeCall:_customer.strPhone1];
            }
            if (indexButton == 2) {
                [self MakeCall:_customer.strPhone2];
            }
        } otherButtonTitles:_customer.strPhone1,_customer.strPhone2,nil];
        [alertView show];
        
        return;
    }
    
    if (_customer.strPhone1.length > 0)
    {
        [self MakeCall:_customer.strPhone1];
        return;
    }
    
    if (_customer.strPhone2.length > 0) {
        [self MakeCall:_customer.strPhone2];
        return;
    }
}

-(IBAction)OnMessage:(id)sender
{
    NSString *s=NSLocalizedStringFromTableInBundle(@"Please select phone No.",@"RPString", g_bundleResorce,nil);
    NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    if (_customer.strPhone1.length > 0 && _customer.strPhone2.length > 0) {
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:s cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1) {
                [self MakeMsg:_customer.strPhone1];
            }
            if (indexButton == 2) {
                [self MakeMsg:_customer.strPhone2];
            }
        } otherButtonTitles:_customer.strPhone1,_customer.strPhone2,nil];
        [alertView show];
        
        return;
    }
    
    if (_customer.strPhone1.length > 0)
    {
        [self MakeMsg:_customer.strPhone1];
        return;
    }
    
    if (_customer.strPhone2.length > 0) {
        [self MakeMsg:_customer.strPhone2];
        return;
    }
}

-(IBAction)OnEdit:(id)sender
{
    [self.delegate OnEditCustomer:_customer];
    [self Hide];
}

-(IBAction)OnPurchase:(id)sender
{
    [self.delegate OnCustomerPurchase:_customer];
    [self Hide];
}

-(void)ShowTaskAnimationStopped
{
   _lbCall.hidden = _lbMessage.hidden = _lbEdit.hidden = _lbPurchase.hidden = NO;
}

-(void)HideTaskAnimationStopped
{
    [self removeFromSuperview];
    CGAffineTransform oneTransform = CGAffineTransformRotate(_viewCall.transform, degreesToRadian(180));
    [_viewCall setTransform:oneTransform];
    [_viewMessage setTransform:oneTransform];
    [_viewEdit setTransform:oneTransform];
    [_viewPurchase setTransform:oneTransform];
}

-(void)Hide
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(HideTaskAnimationStopped)];
    _viewCall.frame = _viewMessage.frame = _viewEdit.frame = _viewPurchase.frame = _btnImage.frame;
    _lbCall.hidden = _lbMessage.hidden = _lbEdit.hidden = _lbPurchase.hidden = YES;
    
    CGAffineTransform oneTransform = CGAffineTransformRotate(_viewCall.transform, degreesToRadian(180));
    [_viewCall setTransform:oneTransform];
    [_viewMessage setTransform:oneTransform];
    [_viewEdit setTransform:oneTransform];
    [_viewPurchase setTransform:oneTransform];
    
    [UIView commitAnimations];
}
@end
