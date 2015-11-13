//
//  RPDocImformationView.m
//  RetailPlus
//
//  Created by zwhe on 13-12-10.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPDocImformationView.h"

@implementation RPDocImformationView

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
    [self setUpForDismissKeyboard];
    _viewDetail.layer.cornerRadius = 6;
    _viewDetail.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewDetail.layer.borderWidth = 1;
    
    _btnOK.layer.cornerRadius = 6;
    _btnOK.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnOK.layer.borderWidth = 1;
}

- (void)setUpForDismissKeyboard {
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapAnywhereToDismiss:)];
    [_viewMask addGestureRecognizer:singleTapGR];
}

- (void)tapAnywhereToDismiss:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self okClick:nil];
}

-(void)AnimationStopped
{
    self.hidden = YES;
    [self removeFromSuperview];
}

- (IBAction)okClick:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(AnimationStopped)];
    _viewFrame.frame = CGRectMake(0, self.frame.size.height, _viewFrame.frame.size.width, _viewFrame.frame.size.height);
    [UIView commitAnimations];
    
    
}

-(void)setDoc:(Document *)doc
{
    _doc = doc;
    
    NSString *desc=[[NSString alloc]initWithFormat:@"%@%@",doc.strStoreName,doc.strBrandName];
    _lbDesc.text=desc;
    _lbAuthor.text=doc.strAuthor;
    _lbCreatedTime.text=doc.strCreateTime;
    _lbDocumentID.text=doc.strDocumentCode;
    _lbTitle.text=doc.strDocType;

    switch (doc.rankAuthor) {
        case Rank_Manager:
            _lbAuthor.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbAuthor.textColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _lbAuthor.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _lbAuthor.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }

    
}

-(void)Show
{
    self.hidden = NO;
    
    _viewFrame.frame = CGRectMake(0, self.frame.size.height, _viewFrame.frame.size.width, _viewFrame.frame.size.height);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    _viewFrame.frame = CGRectMake(0, self.frame.size.height - _viewFrame.frame.size.height, _viewFrame.frame.size.width, _viewFrame.frame.size.height);
    [UIView commitAnimations];
}
@end
