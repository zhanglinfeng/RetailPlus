//
//  RPCountMarkCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPCountMarkCell : UITableViewCell
{
    IBOutlet UIView *_viewFrame;
    
    IBOutlet UILabel *_lbMark1;
    IBOutlet UILabel *_lbMark2;
    IBOutlet UILabel *_lbMark3;
}
@property(nonatomic,assign)FavTagList *favTagList;
@end
