//
//  RPConfEditUserView.m
//  RetailPlus
//
//  Created by lin dong on 14-6-19.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPConfEditUserView.h"

@implementation RPConfEditUserView

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

-(void)setGuest:(RPConfGuest *)guest
{
    _guest = guest;
    _tfPhone.text = guest.strPhone;
    _tfEmail.text = guest.strEmail;
    _tfName.text = guest.strGuestName;
}

-(IBAction)OnConfirm:(id)sender
{
    if (_tfPhone.text.length > 0) {
        _guest.strGuestName = _tfName.text;
        _guest.strPhone = _tfPhone.text;
        _guest.strEmail = _tfEmail.text;
        [_delegate OnEditUserEnd];
    }
}

@end
