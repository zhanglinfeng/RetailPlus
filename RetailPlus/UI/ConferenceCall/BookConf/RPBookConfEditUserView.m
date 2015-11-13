//
//  RPBookConfEditUserView.m
//  RetailPlus
//
//  Created by lin dong on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBookConfEditUserView.h"

@implementation RPBookConfEditUserView

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
    _viewTextFrame.layer.cornerRadius = 8;
    _viewTextFrame.layer.borderWidth = 1;
    _viewTextFrame.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
}

-(void)setMember:(RPConfBookMember *)member
{
    _member = member;
    _tfPhone.text = member.strMemberPhone;
    _tfEmail.text = member.strMemberEmail;
    _tfName.text = member.strMemberDesc;
}

-(IBAction)OnConfirm:(id)sender
{
    if (_tfPhone.text.length > 0) {
        _member.strMemberDesc = _tfName.text;
        _member.strMemberPhone = _tfPhone.text;
        _member.strMemberEmail = _tfEmail.text;
        [_delegate OnEditUserEnd];
    }
}
@end
