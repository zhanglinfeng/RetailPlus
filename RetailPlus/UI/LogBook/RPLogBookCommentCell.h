//
//  RPLogBookCommentCell.h
//  RetailPlus
//
//  Created by lin dong on 14-3-5.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPLogBookCommentCell : UITableViewCell
{
    
    IBOutlet UILabel *_lbName;
    IBOutlet UILabel *_lbComment;
    IBOutlet UILabel *_lbTime;
}

@property (nonatomic,retain) LogBookDetail  * comment;
@end
