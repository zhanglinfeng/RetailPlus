//
//  RPDynamicVK.m
//  RetailPlus
//
//  Created by lin dong on 14-3-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPDynamicVK.h"
#import "RPExBtnTextField.h"

@implementation RPDynamicVK

static RPDynamicVK *defaultObject;

+(RPDynamicVK *)defaultInstance
{
    @synchronized(self){
        if (!defaultObject)
        {
            defaultObject = [[self alloc] init];
            
        }
    }
    return defaultObject;
}

-(void)AddDynamicCloseButton
{
  // [tf addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidChange:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldDidShow:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextViewDidShow:) name:UITextViewTextDidBeginEditingNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextViewChange:) name:UITextViewTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)didTouchBtn:(id)sender
{
    //[self ChangeStatus];
    [_tfInput endEditing:YES];
    [_tvInput endEditing:YES];
}

- (CGFloat)visibleKeyboardHeight {
    
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")] || [possibleKeyboard isKindOfClass:NSClassFromString(@"UIKeyboard")])
            return possibleKeyboard.bounds.size.height;
    }
    
    return 0;
}


- (void)handleKeyboardDidChange:(NSNotification*)notification {
//    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
//    CGFloat keyboardHeight = self.visibleKeyboardHeight;
//    if (keyboardHeight > 100) {
//        [UIView beginAnimations:nil context:nil];
//        _btnClose.frame = CGRectMake(_btnClose.frame.origin.x, keywindow.frame.size.height - keyboardHeight - _btnClose.frame.size.height, _btnClose.frame.size.width, _btnClose.frame.size.height);
//        [UIView commitAnimations];
//    }
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    NSDictionary* userInfo = notification.userInfo;
    CGRect keyboardframe = [userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat keyboardHeight = keyboardframe.size.height;
    _lastKeyBoarHeight = keyboardHeight;
    [UIView beginAnimations:nil context:nil];
    _btnClose.frame = CGRectMake(_btnClose.frame.origin.x, keywindow.frame.size.height - keyboardHeight - _btnClose.frame.size.height, _btnClose.frame.size.width, _btnClose.frame.size.height);
    [UIView commitAnimations];
}

-(void)handleTextFieldChange:(NSNotification *)notification
{
    UITextField * tfInput = (UITextField *)notification.object;
    if (_strLast && tfInput.text.length > 10) {
        tfInput.text = _strLast;
    }
    _strLast = tfInput.text;
}

-(void)handleTextFieldDidShow:(NSNotification *)notification
{
    _tfInput = (UITextField *)notification.object;
    if ([_tfInput isKindOfClass:[RPExBtnTextField class]]) return;
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if (_btnClose == nil)
    {
        _btnClose = [[UIButton alloc]initWithFrame:CGRectMake(keywindow.frame.size.width - 90, keywindow.frame.size.height, 90 , 42)];
        [_btnClose addTarget:self action:@selector(didTouchBtn:) forControlEvents:UIControlEventTouchUpInside];
        _btnClose.backgroundColor = [UIColor clearColor];
        [_btnClose setImage:[UIImage imageNamed:@"button_hide_kb.png"] forState:UIControlStateNormal];
    }
    
//    NSDictionary* userInfo = notification.userInfo;
//    CGRect keyboardframe = [userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
//    CGFloat keyboardHeight = keyboardframe.size.height;
    CGFloat keyboardHeight = _lastKeyBoarHeight;
    //CGFloat keyboardHeight = self.visibleKeyboardHeight;
    _btnClose.frame = CGRectMake(_btnClose.frame.origin.x, keywindow.frame.size.height - keyboardHeight - _btnClose.frame.size.height, _btnClose.frame.size.width, _btnClose.frame.size.height);
    [keywindow addSubview:_btnClose];
    
    _strLast = _tfInput.text;
}

-(void)handleTextViewChange:(NSNotification *)notification
{
    UITextView * tvInput = (UITextView *)notification.object;
    if (_strLast && tvInput.text.length > 10) {
        tvInput.text = _strLast;
    }
    _strLast = tvInput.text;
}

-(void)handleTextViewDidShow:(NSNotification *)notification
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if (_btnClose == nil)
    {
        _btnClose = [[UIButton alloc]initWithFrame:CGRectMake(keywindow.frame.size.width - 90, keywindow.frame.size.height, 90 , 42)];
        [_btnClose addTarget:self action:@selector(didTouchBtn:) forControlEvents:UIControlEventTouchUpInside];
        _btnClose.backgroundColor = [UIColor clearColor];
        [_btnClose setImage:[UIImage imageNamed:@"button_hide_kb.png"] forState:UIControlStateNormal];
    }
    
    _tvInput = (UITextView *)notification.object;
    
   // NSDictionary* userInfo = notification.userInfo;
  //  CGRect keyboardframe = [userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat keyboardHeight = _lastKeyBoarHeight;
    
    //CGFloat keyboardHeight = self.visibleKeyboardHeight;
    _btnClose.frame = CGRectMake(_btnClose.frame.origin.x, keywindow.frame.size.height - keyboardHeight - _btnClose.frame.size.height, _btnClose.frame.size.width, _btnClose.frame.size.height);
    [keywindow addSubview:_btnClose];
    
    _strLast = _tfInput.text;
}

-(void)handleKeyboardWillHide:(NSNotification *)notification
{
    [_btnClose removeFromSuperview];
    _tfInput = nil;
    _tvInput = nil;
    _strLast = nil;
}
@end
