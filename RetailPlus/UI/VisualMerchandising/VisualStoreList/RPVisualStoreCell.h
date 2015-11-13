//
//  RPVisualStoreCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPVisualStoreCell : UITableViewCell
{
    IBOutlet UIView                     *_viewFrame;
    IBOutlet UIImageView                *_ivPic;
    IBOutlet UILabel                    *_lbStoreName;
    IBOutlet UIImageView                *_ivState1;
    IBOutlet UIImageView                *_ivState2;
    IBOutlet UILabel                    *_lbNumber1;
    IBOutlet UILabel                    *_lbNumber2;
    IBOutlet UIImageView                *_ivSelect;
    
}
@property(nonatomic,strong)FollowStore *followStore;
@property(nonatomic)BOOL bEdit;
@property(nonatomic)BOOL check;


@end
