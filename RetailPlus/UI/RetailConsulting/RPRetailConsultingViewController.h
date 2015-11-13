//
//  RPRetailConsultingViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-6-25.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPMainViewController.h"
#import "RPTaskBaseViewController.h"
#import "RPRetailConsultingTipView.h"

@interface RPRetailConsultingViewController : RPTaskBaseViewController<UITextViewDelegate,RPRetailConsultingTipViewDelegate>
{
    IBOutlet UIView                             * _viewFrame;
    IBOutlet RPRetailConsultingTipView          * _viewTip;
    IBOutlet UITextView                         * _tvDesc;
    IBOutlet UILabel                            * _lbTip;
}

@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;
- (IBAction)OnHelp:(id)sender;

@end
