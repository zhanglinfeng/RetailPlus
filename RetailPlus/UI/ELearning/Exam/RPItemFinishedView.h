//
//  RPItemFinishedView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-29.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RPSDKELDefine.h"
@protocol RPItemFinishedViewDelegate
-(void)selectQuestion:(NSInteger)nQuestion;
-(void)addSubmitPaper:(RPELPaper *)paper;
@end
@interface RPItemFinishedView : UIView
{
    
    IBOutlet UIScrollView *_viewButtonContent;
    IBOutlet UILabel *_lbFinished;
    IBOutlet UILabel *_lbAll;
    IBOutlet UIView *_viewSub;
    IBOutlet UIView *_viewFrame;
}
@property(nonatomic,weak)id<RPItemFinishedViewDelegate>delegate;
@property(nonatomic,strong)RPELPaper *paper;
- (IBAction)OnSubmit:(id)sender;
@end
