//
//  RPBlockUISelectBodyCell.h
//  RetailPlus
//
//  Created by lin dong on 14-2-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPBlockUISelectBodyCell : UITableViewCell
{
    IBOutlet UILabel        * _lbTitle;
    IBOutlet UIImageView    * _ivTip;
}
@property (nonatomic) NSInteger nWidth;
@property (nonatomic) NSInteger nHeight;
@property (nonatomic,retain) NSString * strTitle;
@property (nonatomic) BOOL bSelected;
@end
