//
//  RPVisualCommentView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPImageMarkTouchView.h"
#import "CPTextViewPlaceholder.h"
@protocol RPVisualCommentViewDelegate <NSObject>
-(void)OnMarkInViewEnd;
@end
@interface RPVisualCommentView : UIView<UITextViewDelegate>
{
    IBOutlet UIView                 *_viewHeader;
    IBOutlet UIImageView            *_ivPic;
    IBOutlet RPImageMarkTouchView   *_markView;
    ReplyImg                        *_replyImage;
    IBOutlet UIView *_viewFrame;
    IBOutlet CPTextViewPlaceholder *_tvComment;
    
}
@property (nonatomic,assign) id<RPVisualCommentViewDelegate>  delegate;
@property (nonatomic) BOOL                                    bReadOnly;
@property (nonatomic,strong) FollowStore                     *followStore;
@property(nonatomic,strong) VisualDisplay                    *visualDisplay;
@property(nonatomic,strong) ReplyImg                         *replyImg;
@property(nonatomic,strong) VMImage                          *vmImage;

-(IBAction)OnConfirm:(id)sender;
- (IBAction)OnHelp:(id)sender;
@end
