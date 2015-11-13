//
//  RPLogBookCommentView.m
//  RetailPlus
//
//  Created by lin dong on 14-3-5.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPLogBookCommentView.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@implementation RPLogBookCommentView

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
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    self.frame = CGRectMake(0, 0, keywindow.frame.size.width, keywindow.frame.size.height);
    [keywindow addSubview:self];
    
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
-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _storeSelected=storeSelected;
}
-(void)setDetail:(LogBookDetail *)detail
{
    _detail=detail;
    _tfComment.text=@"";
}
-(void)OnPostComment:(id)sender
{
    if (_tfComment.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"The comment cannot be empty",@"RPString", g_bundleResorce,nil)];
    }
    else if(_tfComment.text.length>50)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"The comment is too long",@"RPString", g_bundleResorce,nil)];
    }
    else
    {
        NSString * strDesc = @"";
        [SVProgressHUD showWithStatus:strDesc];
        [[RPSDK defaultInstance]CommentLogBook:_storeSelected.strStoreId LogBookID:_detail.strID Comment:_tfComment.text Success:^(id idResult) {
            [SVProgressHUD dismiss];
            [self.delegate PostCommentEnd];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
            [self removeFromSuperview];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
        }];
    }
    
}
@end
