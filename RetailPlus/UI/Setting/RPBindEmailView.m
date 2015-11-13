//
//  RPBindEmailView.m
//  RetailPlus
//
//  Created by lin dong on 13-11-13.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import "RPBindEmailView.h"

extern NSBundle * g_bundleResorce;

@implementation RPBindEmailView

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
    _viewTextFrame.layer.cornerRadius = 6;
    _viewTextFrame.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewTextFrame.layer.borderWidth = 1;
    
    _btnSend.layer.cornerRadius = 6;
    _btnSend.layer.borderWidth = 1;
    _btnSend.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
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

-(void)Show
{
    [_timer invalidate];
    _tfEmail.text = @"";
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"SEND",@"RPString", g_bundleResorce,nil);
    [_btnSend setTitle:strDesc forState:UIControlStateNormal];
}

-(IBAction)OnSend:(id)sender
{
    if (_tfEmail.text.length > 0) {
        [[RPSDK defaultInstance] BoundEmail:_tfEmail.text SendEmail:_tfEmail.text Success:^(id dictResult) {
            
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
            
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        _nRemain = 60;
        
        _btnSend.userInteractionEnabled = NO;
        
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"SEND AGAIN",@"RPString", g_bundleResorce,nil);
        NSString * str = [NSString stringWithFormat:@"%@(%02d)",strDesc,_nRemain];
        [_btnSend setTitle:str forState:UIControlStateNormal];
    }
    [self endEditing:YES];
}

-(IBAction)OnOk:(id)sender
{
    [self.delegate OnEnd];
    [self endEditing:YES];
}

- (void)onTimer
{
    _nRemain --;
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"SEND AGAIN",@"RPString", g_bundleResorce,nil);
    NSString * str = [NSString stringWithFormat:@"%@(%02d)",strDesc,_nRemain];
    [_btnSend setTitle:str forState:UIControlStateNormal];
    
    if (_nRemain == 0) {
        _btnSend.userInteractionEnabled = YES;
        [_btnSend setBackgroundImage:[UIImage imageNamed:@"Button_middlesquare_02green.png"] forState:UIControlStateNormal];
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"SEND",@"RPString", g_bundleResorce,nil);
        [_btnSend setTitle:strDesc forState:UIControlStateNormal];
        
        [_timer invalidate];
    }
    
}

@end
