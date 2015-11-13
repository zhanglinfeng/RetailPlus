//
//  RPPositionTableViewCell.h
//  RetailPlus
//
//  Created by lin dong on 14-9-2.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPPositionTableViewCell : UITableViewCell
{
    IBOutlet UIView             * _viewRank;
    IBOutlet UILabel            * _lbRole;
    IBOutlet UILabel            * _lbPosition;
    IBOutlet UIView             * _viewRankCard;
}

@property (nonatomic,retain) RPPosition     * position;
@property (nonatomic,retain) NSString       * strDefaultPostionId;
@end
