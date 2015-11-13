//
//  MarkView.h
//  RetailPlusIOS
//
//  Created by lin dong on 13-6-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MarkViewDelegate <NSObject>
@optional
- (void)OnMarkInPoint:(CGPoint)pt isMarked:(BOOL)bMarked;
@end

@interface MarkView : UIScrollView <UIScrollViewDelegate>
{
    UIImageView             * _imageView;
    CGPoint                 _ptLocation;
    UIButton                * _btnLocation;
    BOOL                    _bHiddenBef;
}

@property (nonatomic,assign) id<MarkViewDelegate>   edelegate;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image currentPoint:(CGPoint)ptCurrent isMarked:(BOOL)bMarked;

@end
