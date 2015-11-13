//
//  RPFinishView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-10.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPFinishView.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@implementation RPFinishView

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
    _view1.frame = CGRectMake(0, self.frame.size.height, _view1.frame.size.width, _view1.frame.size.height);
    _view2.frame = CGRectMake(0, self.frame.size.height, _view2.frame.size.width, _view2.frame.size.height);
    _view3.layer.cornerRadius=6;
    _view4.layer.cornerRadius=6;
    _view4.layer.borderColor=[UIColor darkGrayColor].CGColor;
    _view4.layer.borderWidth=1;
    _btYes.layer.cornerRadius=6;
    _btCancel.layer.cornerRadius=6;
    _btCancel.layer.borderWidth=1;
    _btCancel.layer.borderColor=[UIColor darkGrayColor].CGColor;
}
-(void)AnimationStopped
{
    self.hidden = YES;
    [self removeFromSuperview];
}
-(void)OnShow1
{
    self.hidden = NO;
    
    _view1.frame = CGRectMake(0, self.frame.size.height, _view1.frame.size.width, _view1.frame.size.height);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _view1.frame = CGRectMake(0, self.frame.size.height - _view1.frame.size.height, _view1.frame.size.width, _view1.frame.size.height);
    [UIView commitAnimations];
}
-(void)OnShow2
{
    self.hidden = NO;
    
    _view2.frame = CGRectMake(0, self.frame.size.height, _view2.frame.size.width, _view2.frame.size.height);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _view2.frame = CGRectMake(0, self.frame.size.height - _view2.frame.size.height, _view2.frame.size.width, _view2.frame.size.height);
    [UIView commitAnimations];
}
//提交不平账
- (IBAction)OnSubmit:(id)sender
{
    if (_tvReason.text.length<1)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Reason cannot be empty",@"RPString", g_bundleResorce,nil)];
        return;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(AnimationStopped)];
    _view1.frame = CGRectMake(0, self.frame.size.height, _view1.frame.size.width, _view1.frame.size.height);
    [UIView commitAnimations];
    
    NSString * str = NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showWithStatus:str];
    [[RPSDK defaultInstance]FinishStockTaking:self.storeSelected.strStoreId SN:self.sn Comments:_tvReason.text Success:^(id idResult) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil)];
        _tvReason.text=@"";
        [self.delegate endFinish];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
    }];
}

- (IBAction)OnCencel1:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(AnimationStopped)];
    _view1.frame = CGRectMake(0, self.frame.size.height, _view1.frame.size.width, _view1.frame.size.height);
    [UIView commitAnimations];
    
    
}

//提交平账

- (IBAction)OnYes:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(AnimationStopped)];
    _view2.frame = CGRectMake(0, self.frame.size.height, _view2.frame.size.width, _view2.frame.size.height);
    [UIView commitAnimations];
    
    NSString * str = NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showWithStatus:str];
    [[RPSDK defaultInstance]FinishStockTaking:self.storeSelected.strStoreId SN:self.sn Comments:@"" Success:^(id idResult) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil)];
        [self.delegate endFinish];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
    }];
}

- (IBAction)OnCancel2:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(AnimationStopped)];
    _view2.frame = CGRectMake(0, self.frame.size.height, _view2.frame.size.width, _view2.frame.size.height);
    [UIView commitAnimations];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    _view1.frame = CGRectMake(_view1.frame.origin.x, _view1.frame.origin.y-200, _view1.frame.size.width, _view1.frame.size.height);
    [UIView commitAnimations];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    _view1.frame = CGRectMake(_view1.frame.origin.x, _view1.frame.origin.y+200, _view1.frame.size.width, _view1.frame.size.height);
    [UIView commitAnimations];
}
@end
