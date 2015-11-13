//
//  RPMarkImageViewController.h
//  RetailPlusIOS
//
//  Created by lin dong on 13-7-23.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPImageMarkTouchView.h"

@protocol RPMarkImageViewControllerDelegate <NSObject>
    -(void)OnMarkInViewEnd;
@end

@interface RPMarkImageViewController : UIViewController
{
    IBOutlet UIView                 * _viewFrame;
    IBOutlet UIImageView            * _imgView;
    IBOutlet RPImageMarkTouchView   * _markView;
    InspIssueImage                  * _issueImage;
}

@property (nonatomic,assign) id<RPMarkImageViewControllerDelegate>  delegate;

@property (nonatomic) BOOL bReadOnly;
-(void)setImage:(InspIssueImage *)image;

-(IBAction)OnConfirm:(id)sender;

@end
