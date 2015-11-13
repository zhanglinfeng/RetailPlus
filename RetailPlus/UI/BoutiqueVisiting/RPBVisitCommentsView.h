//
//  RPBVisitCommentsView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RPBVisitCommentsViewDelegate <NSObject>
-(void)OnAddCommentsEnd;
-(void)OnQuitComments;
@end
@interface RPBVisitCommentsView : UIView
{
    
    IBOutlet UIView             * _viewFrame;
    
    IBOutlet UIView             * _viewComments;
    IBOutlet UITextView         * _tvComments;
    
    IBOutlet UIView             * _viewTitle;
    IBOutlet UITextView         * _tvTitle;
    IBOutlet UIButton *_btUnfinished;
}

@property (nonatomic,assign) BVisitData                       * dataVisit;
@property (nonatomic,assign) id<RPBVisitCommentsViewDelegate> delegate;

-(BOOL)OnBack;
-(IBAction)OnCache:(id)sender;
- (IBAction)OnHelp:(id)sender;
- (IBAction)OnUnfinished:(id)sender;
@end
