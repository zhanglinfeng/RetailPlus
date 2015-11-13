//
//  RPSwitchView.m
//  RetailPlus
//
//  Created by lin dong on 13-9-2.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPSwitchView.h"

@implementation RPSwitchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 8;
        
        _ivBack = [[UIImageView alloc] initWithFrame:CGRectMake(-(frame.size.width - RPSWITCH_BARWIDTH), 0, 2 * frame.size.width - RPSWITCH_BARWIDTH, frame.size.height)];
        [self addSubview:_ivBack];
        
        _ivFrame = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_ivFrame];
        _ivFrame.image = [UIImage imageNamed:@"icon_swither_frame01@2x.png"];
        
        _btnBar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, RPSWITCH_BARWIDTH, frame.size.height)];
        [_btnBar setImage:[UIImage imageNamed:@"icon_swither_button01@2x.png"] forState:UIControlStateNormal];
         [_btnBar addTarget:self action:@selector(didTouchBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnBar];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped:)];
        [self addGestureRecognizer:tap];
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

-(void)setImgBack:(UIImage *)imgBack
{
    _imgBack = imgBack;
    _ivBack.image = _imgBack;
}

- (void)ChangeStatus
{
    [UIView beginAnimations:nil context:nil];
    
    _bOn = !_bOn;
    
    if (_bOn) {
        _btnBar.frame = CGRectMake(self.frame.size.width - RPSWITCH_BARWIDTH, 0, RPSWITCH_BARWIDTH, _btnBar.frame.size.height);
        _ivBack.frame = CGRectMake(0, 0, _ivBack.frame.size.width, _ivBack.frame.size.height);
    }
    else
    {
        _btnBar.frame = CGRectMake(0, 0, RPSWITCH_BARWIDTH, _btnBar.frame.size.height);
        _ivBack.frame = CGRectMake(-(self.frame.size.width - RPSWITCH_BARWIDTH), 0, _ivBack.frame.size.width, _ivBack.frame.size.height);
    }
   
    [self.delegate SelectSwitch:self isOn:_bOn];
    
    [UIView commitAnimations];
}

- (void)locationTapped:(UITapGestureRecognizer *)tap
{
    [self ChangeStatus];
}

-(void)didTouchBtn:(id)sender
{
    [self ChangeStatus];
}

-(void)SetOn:(BOOL)bOn
{
    _bOn = bOn;
    if (_bOn) {
        _btnBar.frame = CGRectMake(self.frame.size.width - RPSWITCH_BARWIDTH, 0, RPSWITCH_BARWIDTH, _btnBar.frame.size.height);
        _ivBack.frame = CGRectMake(0, 0, _ivBack.frame.size.width, _ivBack.frame.size.height);
    }
    else
    {
        _btnBar.frame = CGRectMake(0, 0, RPSWITCH_BARWIDTH, _btnBar.frame.size.height);
        _ivBack.frame = CGRectMake(-(self.frame.size.width - RPSWITCH_BARWIDTH), 0, _ivBack.frame.size.width, _ivBack.frame.size.height);
    }
}
@end
