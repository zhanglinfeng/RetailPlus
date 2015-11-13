//
//  RPShowImgViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-8-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPShowImgViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic,retain) IBOutlet UIScrollView       * viewScroll;
@property (nonatomic,retain) IBOutlet UIImageView        * ivImage;

-(void)SetImageUrl:(NSString *)strURL;
@end
