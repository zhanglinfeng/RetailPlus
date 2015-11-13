//
//  RPVisualPictureCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPVisualPictureCell : UITableViewCell

{
    IBOutlet UIImageView *_ivPic;
    IBOutlet UILabel *_lbComment;
    IBOutlet UIView *_viewSelect;
    IBOutlet UIImageView *_ivSelect;
    
}
@property(nonatomic,strong)ReplyImg *replyImg;
@property(nonatomic)BOOL bSelected;
@end
