//
//  RPVerifyThroughView.m
//  RetailPlus
//
//  Created by lin dong on 13-11-14.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPVerifyThroughView.h"

extern NSBundle * g_bundleResorce;

@implementation RPVerifyThroughView

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

-(BOOL)OnBack
{
    [self endEditing:YES];
    
    if (_bByMobile) {
        [UIView beginAnimations:nil context:nil];
        _viewMobileVerify.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        
        NSString * str = NSLocalizedStringFromTableInBundle(@"SECURITY VERIFICATION",@"RPString", g_bundleResorce,nil);
        [self.delegate OnSetTitle:str];
        _bByMobile = NO;
        return NO;
    }
    
    if (_bByEmail) {
        [UIView beginAnimations:nil context:nil];
        _viewEmailVerify.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        
        NSString * str = NSLocalizedStringFromTableInBundle(@"SECURITY VERIFICATION",@"RPString", g_bundleResorce,nil);
        [self.delegate OnSetTitle:str];
        _bByEmail = NO;
        return NO;
    }
    
    return YES;
}

-(IBAction)OnByMobile:(id)sender
{
    _viewMobileVerify.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    _viewMobileVerify.strEmail = self.strEmail;
    _viewMobileVerify.delegate = self.delegate;
    [_viewMobileVerify Show];
    [self addSubview:_viewMobileVerify];
    [UIView beginAnimations:nil context:nil];
    _viewMobileVerify.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    NSString * str = NSLocalizedStringFromTableInBundle(@"SECURITY VERIFYING",@"RPString", g_bundleResorce,nil);
    [self.delegate OnSetTitle:str];
    
    _bByMobile = YES;
}

-(IBAction)OnByEmail:(id)sender
{
    _viewEmailVerify.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    _viewEmailVerify.strEmail = self.strEmail;
    _viewEmailVerify.delegate = self.delegate;
    [_viewEmailVerify Show];
    [self addSubview:_viewEmailVerify];
    [UIView beginAnimations:nil context:nil];
    _viewEmailVerify.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    NSString * str = NSLocalizedStringFromTableInBundle(@"SECURITY VERIFYING",@"RPString", g_bundleResorce,nil);
    [self.delegate OnSetTitle:str];
    
    _bByEmail = YES;
}

@end
