//
//  RPDLProgressViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-4-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPDLProgressViewController : UIViewController
{
    IBOutlet UILabel        * _lbPercent;
    IBOutlet UILabel        * _lbTotalSize;
    IBOutlet UIImageView    * _ivImage;
    IBOutlet UIView         * _viewPercent;
    
    
    NSInteger               _nTotalWidth;
    NSInteger               _nMarkBeginPos;
    NSInteger               _nMarkEndPos;
    float                   _lastPercent;
}

@property (nonatomic,strong) IBOutlet UIView         * viewEx;
@property (nonatomic,strong) IBOutlet UILabel        * lbDesc;

-(void)setProgressBar:(long long)llCurSize TotalSize:(long long)llTotalSize;

+(void)showProgress:(long long)llCurSize TotalSize:(long long)llTotalSize target:(id)target Desc:(NSString *)strDesc selector:(SEL)aSelector;

+(void)dismiss;

@end
