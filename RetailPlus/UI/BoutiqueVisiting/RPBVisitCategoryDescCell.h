//
//  RPBVisitCategoryDescCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPBVisitCategoryDescCell : UITableViewCell
{
    IBOutlet UILabel        * _lbDesc;
    IBOutlet UILabel *_lbTitle;
    
}

@property (nonatomic,assign) BVisitItem * visitItem;
+(NSInteger)calcLabelHeight:(NSString *)strText;
@end
