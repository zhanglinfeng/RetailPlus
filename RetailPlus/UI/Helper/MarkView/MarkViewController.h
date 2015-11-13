//
//  MarkViewController.h
//  RetailPlusIOS
//
//  Created by lin dong on 13-6-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkView.h"

@protocol MarkViewControllerDelegate <NSObject>
    - (void)Markend:(CGPoint)point isMarked:(BOOL)bMarked;
@end

@interface MarkViewController : UIViewController<MarkViewDelegate>
{
    IBOutlet UIView             * _viewFrame;
    MarkView                    * _markView;
    UIImage                     * _image;
    CGPoint                     _ptCurrent;
    BOOL                        _bMarked;
}

@property (nonatomic,assign) id<MarkViewControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cadImage:(UIImage *)image curentPoint:(CGPoint)ptCurrent isMarked:(BOOL)bMarked;

-(IBAction)OnConfirm:(id)sender;

@end
