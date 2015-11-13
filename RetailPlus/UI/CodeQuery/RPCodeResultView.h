//
//  RPCodeResultView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-5-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMAttributedHighlightLabel.h"

@protocol RPCodeResultViewDelegate <NSObject>
    -(void)OnShowResultEnd;
@end

@interface RPCodeResultView : UIView<AMAttributedHighlightLabelDelegate>
{
    IBOutlet UIView  *_viewHeader;
    IBOutlet AMAttributedHighlightLabel *_lbCode;
    IBOutlet UILabel *_lbContent;
}

@property(nonatomic,assign)id<RPCodeResultViewDelegate> delegate;
@property(nonatomic,retain)NSString *strCode;
@property(nonatomic,retain)GoodsTrackingInfo* result;
- (IBAction)OnOK:(id)sender;
- (IBAction)OnDelete:(id)sender;

@end
