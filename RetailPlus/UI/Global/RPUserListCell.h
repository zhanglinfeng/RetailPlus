//
//  RPUserListCell.h
//  RetailPlus
//
//  Created by lin dong on 14-3-14.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPUserListCell : UITableViewCell
{
    IBOutlet UIImageView * _ivThumb;
    IBOutlet UILabel     * _lbName;
    IBOutlet UILabel     * _lbTitle;
    IBOutlet UIView      * _viewLevel;
}

@property (nonatomic,retain) UserDetailInfo * user;

-(void)setUser:(UserDetailInfo *)user;
@end
