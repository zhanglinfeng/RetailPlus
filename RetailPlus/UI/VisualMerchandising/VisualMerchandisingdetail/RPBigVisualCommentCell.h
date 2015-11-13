//
//  RPBigVisualCommentCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPBigVisualCommentCell : UITableViewCell

{
    IBOutlet UILabel *_lbName;
    
    IBOutlet UILabel *_lbComment;
}
@property(nonatomic,strong)VMReply *vmReply;
@end
