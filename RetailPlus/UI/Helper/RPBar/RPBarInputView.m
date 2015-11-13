//
//  RPBarInputView.m
//  TestBarCode
//
//  Created by lin dong on 14-5-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBarInputView.h"

@implementation RPBarInputView

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped:)];
    [self addGestureRecognizer:tap];
}

//- (CGFloat)visibleKeyboardHeight {
//    
//    UIWindow *keyboardWindow = nil;
//    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
//        if(![[testWindow class] isEqual:[UIWindow class]]) {
//            keyboardWindow = testWindow;
//            break;
//        }
//    }
//    
//    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
//        if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")] || [possibleKeyboard isKindOfClass:NSClassFromString(@"UIKeyboard")])
//            return possibleKeyboard.bounds.size.height;
//    }
//    
//    return 0;
//}

- (void)positionHUD:(NSNotification*)notification {
    
//    CGFloat keyboardHeight = self.visibleKeyboardHeight;
    if ([_tfComment isEditing])
    {
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        NSDictionary* userInfo = notification.userInfo;
        CGRect keyboardframe = [userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
        CGFloat keyboardHeight = keyboardframe.size.height;
        
        [UIView beginAnimations:nil context:nil];
        _viewFrame.frame = CGRectMake(0, keywindow.frame.size.height - keyboardHeight - _viewFrame.frame.size.height, keywindow.frame.size.width, _viewFrame.frame.size.height);
        [UIView commitAnimations];
    }
}

-(void)ShowCommentView
{
    _tfComment.text = @"";
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    self.frame = CGRectMake(0, 0, keywindow.frame.size.width, keywindow.frame.size.height);
    [keywindow addSubview:self];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
    [_tfComment becomeFirstResponder];
}

- (void)locationTapped:(UITapGestureRecognizer *)tap
{
    if ([_tfComment isFirstResponder])
    {
        [_tfComment endEditing:YES];
        
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        [UIView beginAnimations:nil context:nil];
        _viewFrame.frame = CGRectMake(0, keywindow.frame.size.height - _viewFrame.frame.size.height, keywindow.frame.size.width, _viewFrame.frame.size.height);
        [UIView commitAnimations];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
        
        [self removeFromSuperview];
    }
}

-(void)OnSearch:(id)sender
{
    [self.delegate SearchEnd:_tfComment.text];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    [self removeFromSuperview];
}

@end
