//
//  RPBVisitIssueMapCell.h
//  RetailPlus
//
//  Created by lin dong on 14-7-29.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPBVisitIssueMapCell : UITableViewCell
{
    IBOutlet UILabel        * _lbNoMap;
    IBOutlet UILabel        * _lbMapTitle;
    IBOutlet UIImageView    * _ivMap;
}

@property (nonatomic,retain) StoreShopMap * map;
@property (nonatomic) BOOL bHasLocation;
@property (nonatomic) BOOL bHasMap;

@end
