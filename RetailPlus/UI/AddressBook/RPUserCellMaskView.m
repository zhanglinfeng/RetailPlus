//
//  RPUserCellMaskView.m
//  RetailPlus
//
//  Created by lin dong on 14-1-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPUserCellMaskView.h"
#import "UIButton+WebCache.h"
#import "RPBlockUIAlertView.h"
#define degreesToRadian(x) (M_PI * (x) / 180.0)
extern NSBundle * g_bundleResorce;
@implementation RPUserCellMaskView

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
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    self.frame = CGRectMake(0, 0, keywindow.frame.size.width, keywindow.frame.size.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped:)];
    [self addGestureRecognizer:tap];
    
    _rcCall = _viewCall.frame;
    _rcMessage = _viewMessage.frame;
    _rcClientsList = _viewClientsList.frame;
    
    _btnImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnImage.layer.borderWidth = 1;
    _btnImage.layer.cornerRadius = 5;
    _ivLock.layer.cornerRadius = 5;
}
- (void)locationTapped:(UITapGestureRecognizer *)tap
{
    [self Hide];
}

-(void)Show:(NSString *)strImgUrl Position:(CGPoint)pt
{
    NSInteger nOffset = pt.y - _btnImage.frame.origin.y;
    _viewFrame.frame = CGRectMake(0, nOffset, _viewFrame.frame.size.width, _viewFrame.frame.size.height);
    
    [_btnImage setImageWithURLString:strImgUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_userimage01_224.png"]];
    
    _viewCall.frame = _viewMessage.frame = _viewClientsList.frame = _btnImage.frame;
    
    CGAffineTransform oneTransform = CGAffineTransformRotate(_viewCall.transform, degreesToRadian(180));
    [_viewCall setTransform:oneTransform];
    [_viewMessage setTransform:oneTransform];
    [_viewClientsList setTransform:oneTransform];
   
    
    _lbCall.hidden = _lbMessage.hidden = _lbClientsList.hidden  = YES;
    
    self.alpha = 0;
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ShowTaskAnimationStopped)];
    
    self.alpha = 1;
    _viewCall.frame = _rcCall;
    _viewMessage.frame = _rcMessage;
    _viewClientsList.frame = _rcClientsList;
   
    
    oneTransform = CGAffineTransformRotate(_viewCall.transform, degreesToRadian(180));
    [_viewCall setTransform:oneTransform];
    [_viewMessage setTransform:oneTransform];
    [_viewClientsList setTransform:oneTransform];

    
    [UIView commitAnimations];
}
-(void)ShowTaskAnimationStopped
{
    _lbCall.hidden = _lbMessage.hidden = NO;
    _lbClientsList.hidden  = YES;
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
    
    if (_colleague.strUserAcount.length > 0 && _colleague.strAlternatePhone.length > 0) {
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:s cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1) {
                [self MakeCall:_colleague.strUserAcount];
            }
            if (indexButton == 2) {
                [self MakeCall:_colleague.strAlternatePhone];
            }
        } otherButtonTitles:_colleague.strUserAcount,_colleague.strAlternatePhone,nil];
        [alertView show];
        
        return;
    }
    
    if (_colleague.strUserAcount.length > 0)
    {
        [self MakeCall:_colleague.strUserAcount];
        return;
    }
    
    if (_colleague.strAlternatePhone.length > 0) {
        [self MakeCall:_colleague.strAlternatePhone];
        return;
    }
}

-(IBAction)OnMessage:(id)sender
{
    NSString *s=NSLocalizedStringFromTableInBundle(@"Please select phone No.",@"RPString", g_bundleResorce,nil);
    NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    if (_colleague.strUserAcount.length > 0 && _colleague.strAlternatePhone.length > 0) {
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:s cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1) {
                [self MakeMsg:_colleague.strUserAcount];
            }
            if (indexButton == 2) {
                [self MakeMsg:_colleague.strAlternatePhone];
            }
        } otherButtonTitles:_colleague.strUserAcount,_colleague.strAlternatePhone,nil];
        [alertView show];
        
        return;
    }
    
    if (_colleague.strUserAcount.length > 0)
    {
        [self MakeMsg:_colleague.strUserAcount];
        return;
    }
    
    if (_colleague.strAlternatePhone.length > 0) {
        [self MakeMsg:_colleague.strAlternatePhone];
        return;
    }
}

-(IBAction)OnClientsList:(id)sender
{
    [self.delegate OnCustomerlist:_colleague];
    [self Hide];
}

-(void)HideTaskAnimationStopped
{
    [self removeFromSuperview];
    CGAffineTransform oneTransform = CGAffineTransformRotate(_viewCall.transform, degreesToRadian(180));
    [_viewCall setTransform:oneTransform];
    [_viewMessage setTransform:oneTransform];
    [_viewClientsList setTransform:oneTransform];
   
}

-(void)Hide
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(HideTaskAnimationStopped)];
    _viewCall.frame = _viewMessage.frame = _viewClientsList.frame = _btnImage.frame;
    _lbCall.hidden = _lbMessage.hidden = _lbClientsList.hidden  = YES;
    
    CGAffineTransform oneTransform = CGAffineTransformRotate(_viewCall.transform, degreesToRadian(180));
    [_viewCall setTransform:oneTransform];
    [_viewMessage setTransform:oneTransform];
    [_viewClientsList setTransform:oneTransform];
    
    [UIView commitAnimations];
}

-(void)setColleague:(UserDetailInfo *)colleague
{
    _colleague = colleague;
    _ivLock.hidden = (colleague.status == UserStatus_Locked ? NO : YES);
}
@end
