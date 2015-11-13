//
//  RPVisualCommentCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RRPVisualCommentCellDelegate <NSObject>
-(void)DeleteEnd;
@end
@interface RPVisualCommentCell : UITableViewCell
{
    
    IBOutlet UIView *_viewFrame;
    IBOutlet UILabel *_lbName;
    IBOutlet UIImageView *_ivPic;
    IBOutlet UILabel *_lbComment;
    IBOutlet UILabel *_lbDate;
    IBOutlet UIButton *_btDelete;
    IBOutlet UIView *_viewSelect;
    IBOutlet UIImageView *_ivSelect;
}
@property(nonatomic,assign)id<RRPVisualCommentCellDelegate>delegate;
@property(nonatomic,strong)VMReply *vmReply;
@property(nonatomic,strong)ReplyList *replyList;
@property(nonatomic)BOOL bSelected;
- (IBAction)OnDelete:(id)sender;
@end
