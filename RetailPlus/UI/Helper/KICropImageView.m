//
//  KICropImageView.m
//  Kitalker
//
//  Created by 杨 烽 on 12-8-9.
//
//

#import "KICropImageView.h"

@implementation KICropImageView

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [[self scrollView] setFrame:self.bounds];
    [[self maskView] setFrame:self.bounds];
    
    if (CGSizeEqualToSize(_cropSize, CGSizeZero)) {
        [self setCropSize:CGSizeMake(100, 100)];
    }
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setDelegate:self];
        [_scrollView setBounces:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setMinimumZoomScale:0.1];
        [_scrollView setMaximumZoomScale:5];
        [_scrollView setZoomScale:1];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [[self scrollView] addSubview:_imageView];
    }
    return _imageView;
}

- (KICropImageMaskView *)maskView {
    if (_maskView == nil) {
        _maskView = [[KICropImageMaskView alloc] init];
        [_maskView setBackgroundColor:[UIColor clearColor]];
        [_maskView setUserInteractionEnabled:NO];
        [self addSubview:_maskView];
        [self bringSubviewToFront:_maskView];
    }
    return _maskView;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [[self imageView] setImage:_image];
    [self updateZoomScale];
}

- (void)updateZoomScale {
    CGFloat width = _image.size.width;
    CGFloat height = _image.size.height;
    
    [[self imageView] setFrame:CGRectMake(0, 0, width, height)];
    
    CGFloat xScale = _cropSize.width / width;
    CGFloat yScale = _cropSize.height / height;
    
    CGFloat min = MAX(xScale, yScale);
    CGFloat max = 1.0;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        max = 1.0 / [[UIScreen mainScreen] scale];
    }
    
    if (min > max) {
        min = max;
    }
    
    [[self scrollView] setMinimumZoomScale:0.01];
    [[self scrollView] setMaximumZoomScale:max + 5.0f];
    
    [[self scrollView] setZoomScale:1 animated:YES];
}

- (void)SetFitScale
{
    CGFloat width = _image.size.width;
    CGFloat height = _image.size.height;
    
    CGFloat xScale = _cropSize.width / width;
    CGFloat yScale = _cropSize.height / height;
    
    CGFloat min = MAX(xScale, yScale);
    
    [[self scrollView] setMinimumZoomScale:min];
    [[self scrollView] setZoomScale:min animated:YES];
}

- (void)setCropSize:(CGSize)size {
    _cropSize = size;
    [self updateZoomScale];
    
    CGFloat width = _cropSize.width;
    CGFloat height = _cropSize.height;
    
    CGFloat x = (CGRectGetWidth(self.bounds) - width) / 2;
    CGFloat y = (CGRectGetHeight(self.bounds) - height) / 2;

    [(KICropImageMaskView *)[self maskView] setCropSize:_cropSize];
    
    CGFloat top = y;
    CGFloat left = x;
    CGFloat right = CGRectGetWidth(self.bounds)- width - x;
    CGFloat bottom = CGRectGetHeight(self.bounds)- height - y;
    _imageInset = UIEdgeInsetsMake(top, left, bottom, right);
    [[self scrollView] setContentInset:_imageInset];
    
    [[self scrollView] setContentOffset:CGPointMake(0, 0)];
}

static inline double radians (double degrees) {return degrees * M_PI/180;}

- (UIImage *)cropImage {
    CGFloat zoomScale = [self scrollView].zoomScale;
    
    CGFloat offsetX = [self scrollView].contentOffset.x;
    CGFloat offsetY = [self scrollView].contentOffset.y;
    CGFloat aX = offsetX>=0 ? offsetX+_imageInset.left : (_imageInset.left - ABS(offsetX));
    CGFloat aY = offsetY>=0 ? offsetY+_imageInset.top : (_imageInset.top - ABS(offsetY));
    
    aX = aX / zoomScale;
    aY = aY / zoomScale;
    
    CGFloat aWidth =  _cropSize.width / zoomScale;//MAX(_cropSize.width / zoomScale, _cropSize.width);
    CGFloat aHeight = _cropSize.height / zoomScale;//MAX(_cropSize.height / zoomScale, _cropSize.height);
    
#ifdef DEBUG
    NSLog(@"%f--%f--%f--%f", aX, aY, aWidth, aHeight);
#endif
//    UIGraphicsBeginImageContext(CGSizeMake(_image.size.width, _image.size.height));
//    CGContextRef ref = UIGraphicsGetCurrentContext();
//    
//    CGContextDrawImage(ref, CGRectMake(0, 0, _image.size.width, _image.size.height), _image.CGImage);
//    CGContextRotateCTM(ref, radians(-90));
//    
//    UIImage * tempimg = UIGraphicsGetImageFromCurrentImageContext();
    
    //UIImage * tempImg = [UIImage imageWithCGImage:_image.CGImage scale:1 orientation:0];
    
    UIGraphicsBeginImageContext(CGSizeMake(_image.size.width,_image.size.height));
    [_imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tempImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *image = [tempImg cropImageWithX:aX y:aY width:aWidth height:aHeight];
    UIGraphicsEndImageContext();
    //UIImage *image = [self CropImageWith:_imageView.image x:aX y:aY width:aWidth height:aHeight];
    
   // CGSize sz = image.size;
   // CGSize sz2 = _image.size;
   // image = [image resizeToWidth:960 height:1280];
    return image;
}

-(UIImage *)CropImageWith:(UIImage *)imageBef x:(float)fx y:(float)fy width:(float)fWidth height:(float)fHeight
{
    CGRect rect = CGRectMake(fx, fy, fWidth, fHeight);
    UIImage* newimage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([imageBef CGImage], rect)];    
    return newimage;
}

#pragma UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self imageView];
}

@end

#pragma KISnipImageMaskView

#define kMaskViewBorderWidth 2.0f

@implementation KICropImageMaskView

- (void)setCropSize:(CGSize)size {
    CGFloat x = (CGRectGetWidth(self.bounds) - size.width) / 2;
    CGFloat y = (CGRectGetHeight(self.bounds) - size.height) / 2;
    _cropRect = CGRectMake(x, y, size.width, size.height);
    
    [self setNeedsDisplay];
}

- (CGSize)cropSize {
    return _cropRect.size;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetRGBFillColor(ctx, 1, 1, 1, .6);
//    CGContextFillRect(ctx, self.bounds);
//    
//    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
//    CGContextStrokeRectWithWidth(ctx, _cropRect, kMaskViewBorderWidth);
//    
//    CGContextClearRect(ctx, _cropRect);
}
@end
