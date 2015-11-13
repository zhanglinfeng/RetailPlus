//
//  RPBlockUISelectView.m
//  RetailPlus
//
//  Created by lin dong on 14-2-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBlockUISelectView.h"
#define ALERT_FONTSIZE          17

@implementation RPBlockUISelectView

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
- (id)initWithTitle:(NSString *)title
        clickButton:(RPAlertSelectBlock)blockSet
           curIndex:(NSInteger)nCurSel
       selectTitles:(NSArray *)arrayTitle
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    self = [super initWithFrame:CGRectMake(0, 0, keywindow.frame.size.width, keywindow.frame.size.height)];
    
    if (self) {
        _nCurSel = nCurSel;
        
        self.block = blockSet;
        
        self.frame = CGRectMake(0, 0, keywindow.frame.size.width, keywindow.frame.size.height);
        self.backgroundColor = [UIColor clearColor];
        
        _viewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _viewBackground.backgroundColor = [UIColor blackColor];
        _viewBackground.alpha = 0.5f;
        [self addSubview:_viewBackground];
        
        
        UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(tapBackGroud:)];
        [_viewBackground addGestureRecognizer:singleTapGR];
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPBlockUISelectView" owner:self options:nil];
        _viewBody = [array objectAtIndex:0];
        _viewBody.nMaxHeight = keywindow.frame.size.height - 100;
        _viewBody.strTitle = title;
        _viewBody.delegate = self;
        
        for (NSString *str in arrayTitle)
        {
            [_viewBody AddSelTitle:str];
        }
        
        _viewBody.nCurSel = nCurSel;
        
        _viewBody.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width,_viewBody.nViewHeight);
        [self addSubview:_viewBody];
        
//
//        _viewFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//        _viewFrame.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
//        [self addSubview:_viewFrame];
//        
//        _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//        _lbTitle.numberOfLines = 1;
//        _lbTitle.font = [UIFont systemFontOfSize:ALERT_FONTSIZE];
//        _lbTitle.text = title;
//        _lbTitle.backgroundColor = [UIColor clearColor];
//        _lbTitle.textColor = [UIColor colorWithWhite:0.3 alpha:1];
//        [_viewFrame addSubview:_lbTitle];
        
        return self;
    }
    return nil;
}

- (void)tapBackGroud:(UIGestureRecognizer *)gestureRecognizer {
    [self OnSelect:_nCurSel];
}

-(void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [UIView beginAnimations:nil context:nil];
    _viewBody.frame = CGRectMake(0, self.frame.size.height - _viewBody.frame.size.height, self.frame.size.width, _viewBody.frame.size.height);
    [UIView commitAnimations];
}

-(void)HideFrameAnimationStopped
{
    self.hidden = YES;
}

-(void)OnSelect:(NSInteger)nIndex
{
    self.block(nIndex);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(HideFrameAnimationStopped)];
    _viewBody.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, _viewBody.frame.size.height);
    [UIView commitAnimations];
}
@end
