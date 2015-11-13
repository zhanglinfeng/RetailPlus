//
//  MarkView.m
//  RetailPlus
//
//  Created by lin dong on 13-6-4.
//  Copyright (c) 2013年 舒 鹏. All rights reserved.
//

#import "MarkView.h"
@interface MarkView (Utility)

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation MarkView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image currentPoint:(CGPoint)currentPoint isMarked:(BOOL)bMarked
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        _imageView.userInteractionEnabled = YES;
        [_imageView setImage:image];
        [self addSubview:_imageView];
                
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationCanvasTapped:)];
        [_imageView addGestureRecognizer:tap];
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [_imageView addGestureRecognizer:doubleTapGesture];

        float minimumScale = self.frame.size.width / _imageView.frame.size.width;
        [self setMinimumZoomScale:minimumScale];
        [self setZoomScale:minimumScale];
        
        _ptLocation = currentPoint;
        

        float fCurScale = image.size.width / _imageView.frame.size.width;
        _btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnLocation setBounds:CGRectMake(0, 0, 50, 50)];
        [_btnLocation setCenter:CGPointMake(_ptLocation.x / fCurScale , _ptLocation.y / fCurScale)];
        [_btnLocation setImage:[UIImage imageNamed:@"icon_target.png"] forState:UIControlStateNormal];
        [_btnLocation addTarget:self action:@selector(locationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
      //  [self addSubview:_btnLocation];
        [self insertSubview:_btnLocation aboveSubview:_imageView];
        
        if (!bMarked) _btnLocation.hidden = YES;
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

/*!
 @method     locationCanvasTapped:
 @abstract   获取添加点的位置信息
 @discussion 获取一个添加点的位置信息CGPoint
 @param      UITapGestureRecognizer
 @param      nil
 @result     nil
 */
- (void)locationCanvasTapped:(UITapGestureRecognizer *)tap
{
    _ptLocation = [tap locationInView:_imageView];
    _btnLocation.hidden = NO;
    [_btnLocation setCenter:[tap locationInView:self]];
    if ([self.edelegate respondsToSelector:@selector(OnMarkInPoint:isMarked:)]) {
        [self.edelegate OnMarkInPoint:_ptLocation isMarked:YES];
    }
}

#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    float newScale = self.zoomScale * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    [self zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)locationButtonPressed:(UIButton *)sender
{
    if ([self.edelegate respondsToSelector:@selector(OnMarkInPoint:isMarked:)]) {
        [self.edelegate OnMarkInPoint:CGPointMake(0, 0) isMarked:NO];
        _btnLocation.hidden = YES;
    }
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    _bHiddenBef = _btnLocation.hidden;
    _btnLocation.hidden = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [scrollView setZoomScale:scale animated:NO];
    [self.edelegate OnMarkInPoint:_ptLocation isMarked:YES];
    
    if (_bHiddenBef == NO) {
         _btnLocation.hidden = NO;
        [_btnLocation setCenter:CGPointMake(_ptLocation.x * scale, _ptLocation.y * scale)];
    }
    
}


@end
