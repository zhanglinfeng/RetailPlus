//
//  RPRetailConsultingTipView.h
//  RetailPlus
//
//  Created by lin dong on 14-6-25.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPRetailConsultingTipViewDelegate <NSObject>
    -(void)OnConfirmPost;
@end

@interface RPRetailConsultingTipView : UIView
{
    IBOutlet UIView     * _viewFrame;
    IBOutlet UIButton   * _btnOK;
}

@property (nonatomic,assign) id<RPRetailConsultingTipViewDelegate> delegate;
@end

