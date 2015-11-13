//
//  RPAccountSecView.m
//  RetailPlus
//
//  Created by lin dong on 13-11-13.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import "RPAccountSecView.h"

@implementation RPAccountSecView

extern NSBundle * g_bundleResorce;

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
    
    _viewGroup1.layer.cornerRadius = 6;
    _viewGroup2.layer.cornerRadius = 6;
    
    if ([RPSDK defaultInstance].userLoginDetail.strUserEmail.length > 0) {
        _viewWarning1.hidden = YES;
        _viewWarning2.hidden = YES;
        _lbWarning.hidden = YES;
        _viewRebound.hidden = NO;
        _viewNext.hidden = YES;
        _lbEmail.text = [RPSDK defaultInstance].userLoginDetail.strUserEmail;
    }
    else
    {
        _viewRebound.hidden = YES;
        _viewNext.hidden = NO;
    }
    
    _lbRpID.text = [RPSDK defaultInstance].userLoginDetail.strUserCode;
    _lbMobile.text = [RPSDK defaultInstance].userLoginDetail.strUserAcount;
    
    _viewGroup1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewGroup1.layer.borderWidth = 1;
    
    _viewGroup2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewGroup2.layer.borderWidth = 1;
    
    _lbEnableLoginProtect.hidden = ![RPSDK defaultInstance].userLoginDetail.IsLoginProtection;
    _lbEnableLoginAuto.hidden=![RPSDK defaultInstance].IsAutoLogin;
}

-(IBAction)OnBindEmail:(id)sender
{
    if ([RPSDK defaultInstance].userLoginDetail.strUserEmail.length == 0) {
        _viewBindEmail.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        _viewBindEmail.delegate = self.delegate;
        [self addSubview:_viewBindEmail];
        [UIView beginAnimations:nil context:nil];
        _viewBindEmail.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        
        NSString * str = NSLocalizedStringFromTableInBundle(@"BIND EMAIL",@"RPString", g_bundleResorce,nil);
        [self.delegate OnSetTitle:str];
        [_viewBindEmail Show];
        _bBindEmail = YES;
    }
    else
    {
        _viewChgBindEmail.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        _viewChgBindEmail.delegate = self.delegate;
        [self addSubview:_viewChgBindEmail];
        [UIView beginAnimations:nil context:nil];
        _viewChgBindEmail.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        
        NSString * str = NSLocalizedStringFromTableInBundle(@"CHANGE EMAIL BINDING",@"RPString", g_bundleResorce,nil);
        [self.delegate OnSetTitle:str];
        
        _bChangeBindEmail = YES;
    }
}

-(BOOL)OnBack
{
    [self endEditing:YES];
    
    if (_bBindEmail) {
        [UIView beginAnimations:nil context:nil];
        _viewBindEmail.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _bBindEmail = NO;
        NSString * str = NSLocalizedStringFromTableInBundle(@"ACCOUNT SECURITY",@"RPString", g_bundleResorce,nil);
        [self.delegate OnSetTitle:str];
        [self.delegate OnEnd];
        return NO;
    }
    
    if (_bChangeBindEmail) {
        _bChangeBindEmail = ![_viewChgBindEmail OnBack];
        if (!_bChangeBindEmail) {
            [UIView beginAnimations:nil context:nil];
            _viewChgBindEmail.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            
            NSString * str = NSLocalizedStringFromTableInBundle(@"ACCOUNT SECURITY",@"RPString", g_bundleResorce,nil);
            [self.delegate OnSetTitle:str];
        }
        return NO;
    }
    
    if (_bLoginProtect) {
        _bLoginProtect = ![_viewLoginProtect OnBack];
        if (!_bLoginProtect) {
            [UIView beginAnimations:nil context:nil];
            _viewLoginProtect.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            NSString * str = NSLocalizedStringFromTableInBundle(@"ACCOUNT SECURITY",@"RPString", g_bundleResorce,nil);
            [self.delegate OnSetTitle:str];
            _lbEnableLoginProtect.hidden = ![RPSDK defaultInstance].userLoginDetail.IsLoginProtection;
        }
        return NO;
    }
    
    if (_bLoginAuto) {
        [UIView beginAnimations:nil context:nil];
        _viewLoginAuto.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        NSString * str = NSLocalizedStringFromTableInBundle(@"ACCOUNT SECURITY",@"RPString", g_bundleResorce,nil);
        [self.delegate OnSetTitle:str];
        _lbEnableLoginAuto.hidden=![RPSDK defaultInstance].IsAutoLogin;
        _bLoginAuto = NO;
        return NO;
    }
    return YES;
}

-(IBAction)OnLoginProtect:(id)sender
{
    _viewLoginProtect.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    _viewLoginProtect.delegate = self.delegate;
    [self addSubview:_viewLoginProtect];
    [UIView beginAnimations:nil context:nil];
    _viewLoginProtect.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    NSString * str = NSLocalizedStringFromTableInBundle(@"LOGIN PROTECTION",@"RPString", g_bundleResorce,nil);
    [self.delegate OnSetTitle:str];
    _bLoginProtect = YES;
}

- (IBAction)OnLoginAuto:(id)sender
{
    _viewLoginAuto.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewLoginAuto];
    [UIView beginAnimations:nil context:nil];
    _viewLoginAuto.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    NSString * str = NSLocalizedStringFromTableInBundle(@"LOGIN AUTOMATICALLY",@"RPString", g_bundleResorce,nil);
    [self.delegate OnSetTitle:str];
    _bLoginAuto = YES;
}
@end
