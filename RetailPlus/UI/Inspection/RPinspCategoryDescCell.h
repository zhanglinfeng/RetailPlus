//
//  RPinspCategoryDescCell.h
//  RetailPlus
//
//  Created by lin dong on 13-9-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPinspCategoryDescCell : UITableViewCell
{
    IBOutlet UILabel        * _lbDesc;
    IBOutlet UILabel        * _lbTitle;
}

@property (nonatomic,assign) InspCatagory * category;
@end
