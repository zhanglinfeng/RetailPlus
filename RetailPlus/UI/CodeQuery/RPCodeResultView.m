//
//  RPCodeResultView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-5-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCodeResultView.h"
#import "UILabel+VerticalAlign.h"

@implementation RPCodeResultView

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
    _viewHeader.layer.cornerRadius=10;
    _lbCode.delegate = self;
    _lbCode.lineBreakMode = NSLineBreakByCharWrapping;
}

-(void)setResult:(GoodsTrackingInfo *)result
{
    _result=result;
    _lbContent.text=result.strDetail;
    [_lbContent alignTop];
    //_lbCode.text=result.strCode;
    [_lbCode setString:result.strCode];
}

- (IBAction)OnOK:(id)sender {
    [[RPSDK defaultInstance]InsertGoodsTrackingInfo:_result];
    [UIView beginAnimations:nil context:nil];
    self.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [self.delegate OnShowResultEnd];
}

- (IBAction)OnDelete:(id)sender {
    [[RPSDK defaultInstance] DeleteGoodsTrackingInfo:_result.strID];
    _result=nil;
    [UIView beginAnimations:nil context:nil];
    self.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [self.delegate OnShowResultEnd];
}

- (void)selectedMention:(NSString *)string {
    
}

- (void)selectedHashtag:(NSString *)string {
    
}

- (void)selectedLink:(NSString *)string {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_result.strCode]];
}
@end
