//
//  RPLogBookShowImageView.h
//  RetailPlus
//
//  Created by lin dong on 14-3-5.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPLogBookShowImageView : UIView
{
    IBOutlet UIImageView                 * _ivDetail;
    IBOutlet UIScrollView                *_svDetail;
    IBOutlet UIActivityIndicatorView     * _actDetail;
    
    CGRect                               _rcImage;
}

-(void)ShowImageView:(UIImage *)image URL:(NSString *)strUrl Array:(NSMutableArray *)arrayUrl;
@end
