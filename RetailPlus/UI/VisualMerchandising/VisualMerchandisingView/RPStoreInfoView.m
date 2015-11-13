//
//  RPStoreInfoView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-19.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPStoreInfoView.h"
extern NSBundle * g_bundleResorce;
@implementation RPStoreInfoView

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
    NSArray * array = [g_bundleResorce loadNibNamed:@"RPStoreCardView" owner:self options:nil];
    _viewStoreCard = [array objectAtIndex:0];
    CGSize szScreen = [[UIScreen mainScreen] bounds].size;
    _viewStoreCard.frame = CGRectMake(8, 15, 304, szScreen.height - 125);
//    _viewStoreCard.delegate = self;
    [self addSubview:_viewStoreCard];
    [_viewStoreCard Hide:NO];
}
-(void)setStoreInfo:(StoreDetailInfo *)storeInfo
{
    _storeInfo=storeInfo;
    _viewStoreCard.store=_storeInfo;
}
@end
