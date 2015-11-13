//
//  RPBlockUIAlertView.m
//  RetailPlus
//
//  Created by lin dong on 13-10-22.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPBlockUIAlertView.h"

@implementation RPBlockUIAlertView

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
#define ALERTBTN_WIDTH         280
#define ALERTBTN_HEIGHT         38
#define ALERTVERT_OFFSET        14
#define ALERTBOTTOM_OFFSET      32
#define ALERT_FONTSIZE          17

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
        clickButton:(RPAlertBlock)blockSet
  otherButtonTitles:(NSString *)otherButtonTitles,...
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    self = [super initWithFrame:CGRectMake(0, 0, keywindow.frame.size.width, keywindow.frame.size.height)];
    if (self) {
        self.block = blockSet;
        
        self.backgroundColor = [UIColor clearColor];
        
        _viewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _viewBackground.backgroundColor = [UIColor blackColor];
        _viewBackground.alpha = 0.5f;
        [self addSubview:_viewBackground];
        
        _viewFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _viewFrame.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self addSubview:_viewFrame];
        
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _lbTitle.numberOfLines = 10;
        _lbTitle.font = [UIFont systemFontOfSize:ALERT_FONTSIZE];
        _lbTitle.text = message;
        _lbTitle.backgroundColor = [UIColor clearColor];
        _lbTitle.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [_viewFrame addSubview:_lbTitle];
        
        _arrayButton = [[NSMutableArray alloc] init];
        
        va_list args;
        va_start(args, otherButtonTitles); // scan for arguments after firstObject.
        
        // get rest of the objects until nil is found
        for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            btn.clipsToBounds = YES;
            [btn setBackgroundImage:[RPBlockUIAlertView createImageWithColor:[UIColor colorWithWhite:0.5 alpha:1]] forState:UIControlStateHighlighted];
            
            btn.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
            btn.layer.cornerRadius = 5;
            btn.layer.borderWidth = 1;
            [btn addTarget:self action:@selector(pressedBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = _arrayButton.count + 1;
            [btn setTitle:str forState:UIControlStateNormal];
            [_arrayButton addObject:btn];
            [_viewFrame addSubview:btn];
        }
        
        va_end(args);
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        btn.clipsToBounds = YES;
        [btn setBackgroundImage:[RPBlockUIAlertView createImageWithColor:[UIColor colorWithWhite:0.5 alpha:1]] forState:UIControlStateHighlighted];
        
        btn.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        [btn setTitle:cancelButtonTitle forState:UIControlStateNormal];
        btn.tag = 0;
        [btn addTarget:self action:@selector(pressedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_arrayButton addObject:btn];
        [_viewFrame addSubview:btn];
        
//        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [UIFont systemFontOfSize:ALERT_FONTSIZE], NSFontAttributeName,
//                                    nil];
//        
//        CGSize sizeMessage = [message boundingRectWithSize:CGSizeMake(ALERTBTN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        
        CGSize sizeMessage = [message sizeWithFont:[UIFont systemFontOfSize:ALERT_FONTSIZE] constrainedToSize:CGSizeMake(ALERTBTN_WIDTH, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        
        NSInteger nMessageHeight = sizeMessage.height + 10;
        NSInteger nHeight = nMessageHeight + (_arrayButton.count + 2) * ALERTVERT_OFFSET + _arrayButton.count * ALERTBTN_HEIGHT + ALERTBOTTOM_OFFSET;
        _viewFrame.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, nHeight);
        
        NSInteger nLeftOffset = (self.frame.size.width - ALERTBTN_WIDTH) / 2;
        _lbTitle.frame = CGRectMake(nLeftOffset, ALERTVERT_OFFSET, ALERTBTN_WIDTH, nMessageHeight);
        
        for (NSInteger n = 0;n < _arrayButton.count;n ++ ) {
            UIButton * btn = [_arrayButton objectAtIndex:n];
            btn.frame = CGRectMake(nLeftOffset, nMessageHeight + n * (ALERTBTN_HEIGHT + ALERTVERT_OFFSET) + 2 *ALERTVERT_OFFSET , ALERTBTN_WIDTH, ALERTBTN_HEIGHT);
        }
    }
    
    return self;
}

-(void)HideFrameAnimationStopped
{
    self.hidden = YES;
}

- (void)pressedBtn:(UIButton *)sender
{
    self.block(sender.tag);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(HideFrameAnimationStopped)];
    _viewFrame.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, _viewFrame.frame.size.height);
    [UIView commitAnimations];
}

-(void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    
 //   [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [UIView beginAnimations:nil context:nil];
    _viewFrame.frame = CGRectMake(0, self.frame.size.height - _viewFrame.frame.size.height, self.frame.size.width, _viewFrame.frame.size.height);
    [UIView commitAnimations];
}


@end
