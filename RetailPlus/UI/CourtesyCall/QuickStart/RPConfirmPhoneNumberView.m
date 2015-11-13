//
//  RPConfirmPhoneNumberView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-13.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPConfirmPhoneNumberView.h"
#import "RPOwnedModel.h"

@implementation RPConfirmPhoneNumberView

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
    _viewPutIn.layer.cornerRadius=6;
}
-(void)MakeCall:(NSString *)strPhone
{
    UIWebView* callWebview =[[UIWebView alloc] init];
    
    NSString * strPhoneNo = [NSString stringWithFormat:@"tel://%@",strPhone];
    NSURL *telURL =[NSURL URLWithString:strPhoneNo];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self addSubview:callWebview];
}

- (IBAction)OnCall:(id)sender
{
    [self endEditing:YES];
    if (![RPSDK defaultInstance].bDemoMode && [RPSDK defaultInstance].bVoip)
    {
        _customer.strPhone1=_tfPhoneNumber.text;
        
        _viewMakeCall.delegate = self;
        _viewMakeCall.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:_viewMakeCall];
        
        [UIView beginAnimations:nil context:nil];
        _viewMakeCall.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        
        [_viewMakeCall MakeCall:_tfPhoneNumber.text withInfo:self.courtesyCallInfo withCallType:self.callType UpdateBeginDate:YES];
    }
    else
    {
        [self MakeCall:_tfPhoneNumber.text];
        _customer.strPhone1=_tfPhoneNumber.text;
        [self removeFromSuperview];
    }
}

- (IBAction)OnCancel:(id)sender
{
    [self removeFromSuperview];
}

-(void)setCustomer:(Customer *)customer
{
    _customer=customer;
    _tfPhoneNumber.text=_customer.strPhone1;
}

-(void)OnRPCCCallEnd
{
    [_viewMakeCall removeFromSuperview];
    [self.delegate OnRPCCCallEnd];
}
@end
