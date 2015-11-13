//
//  RPLogBookShowImageView.m
//  RetailPlus
//
//  Created by lin dong on 14-3-5.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPLogBookShowImageView.h"
#import "UIImageView+WebCache.h"

@implementation RPLogBookShowImageView

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
    _rcImage = _svDetail.frame;
}

- (void)locationTapped:(UITapGestureRecognizer *)tap
{
    [self removeFromSuperview];
}

-(void)ShowImageView:(UIImage *)image URL:(NSString *)strUrl Array:(NSMutableArray *)arrayUrl
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    self.frame = CGRectMake(0, 0, keywindow.frame.size.width, keywindow.frame.size.height);
    [keywindow addSubview:self];
    _svDetail.frame = _rcImage;
    _actDetail.hidden = NO;
    [_actDetail startAnimating];

    UIActivityIndicatorView * actView = _actDetail;
    UIImageView             * imageView = _ivDetail;
    UIScrollView            * scrollView=_svDetail;
    UIView                  * view      = self;
    
    [_ivDetail setImageWithURLString:strUrl placeholderImage:image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            imageView.image = image;
            [UIView beginAnimations:nil context:nil];
            scrollView.frame = CGRectMake(0, (view.frame.size.height - view.frame.size.width) / 2, view.frame.size.width, view.frame.size.width);
            [UIView commitAnimations];
            
            scrollView.contentSize=CGSizeMake(scrollView.frame.size.width*arrayUrl.count, scrollView.frame.size.height);
            for (int i=0; i<arrayUrl.count; i++)
            {
                if ([strUrl isEqualToString:[arrayUrl objectAtIndex:i]])
                {
                    scrollView.contentOffset=CGPointMake(scrollView.frame.size.width*i, 0);
                }
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(scrollView.frame.size.width*i , 0, scrollView.frame.size.width, scrollView.frame.size.height)];
                [scrollView addSubview:imageView];
                [imageView setImageWithURLString:[arrayUrl objectAtIndex:i ]placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    
                }];
            }

        }
        actView.hidden = YES;
    }];
}

@end
