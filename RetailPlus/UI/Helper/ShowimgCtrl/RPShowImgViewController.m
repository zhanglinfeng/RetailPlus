//
//  RPShowImgViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-8-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPShowImgViewController.h"
#import "UIImageView+WebCache.h"

@interface RPShowImgViewController ()

@end

@implementation RPShowImgViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_viewScroll setMinimumZoomScale:1];
    [_viewScroll setMaximumZoomScale:1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationCanvasTapped:)];
    [_ivImage addGestureRecognizer:tap];
    _ivImage.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _ivImage;
}

- (void)locationCanvasTapped:(UITapGestureRecognizer *)tap
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    _ivImage.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
}

-(void)SetImageUrl:(NSString *)strURL
{
    _ivImage.image = nil;
    [_viewScroll setMinimumZoomScale:1];
    [_viewScroll setMaximumZoomScale:1];
    
    __block RPShowImgViewController *blockSelf = self;
    
    [_ivImage setImageWithURLString:strURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            blockSelf.ivImage.image = image;
            float fScaleX = 1,fScaleY = 1,fScale;
            if (image.size.width < blockSelf.viewScroll.frame.size.width)
                fScaleX = (float)image.size.width  / blockSelf.viewScroll.frame.size.width;
            if (image.size.height < blockSelf.viewScroll.frame.size.height)
                fScaleY = (float)image.size.height  / blockSelf.viewScroll.frame.size.height;
            
            fScale = fScaleX > fScaleY ? fScaleY : fScaleX;
            [blockSelf.viewScroll setMinimumZoomScale:fScale];
            [blockSelf.viewScroll setMaximumZoomScale:10];
            [blockSelf.viewScroll setZoomScale:fScale];
        }
    }];
}
@end
