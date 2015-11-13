//
//  RPExhibitMessageCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTextViewPlaceholder.h"
@protocol RPExhibitMessageCellDelegate <NSObject>
-(void)OnCommentChange:(NSString *)comment;
-(void)BeginEditing;
@end
@interface RPExhibitMessageCell : UITableViewCell<UITextViewDelegate>
{
    
    
}
@property (assign, nonatomic) id<RPExhibitMessageCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextView *tvComment;
@property (strong, nonatomic) IBOutlet UILabel *tfComment;
@end
