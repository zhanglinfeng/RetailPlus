//
//  RPTrainingDocCell.h
//  RetailPlus
//
//  Created by lin dong on 14-3-13.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPTrainingDocCell : UITableViewCell
{
    IBOutlet UILabel * _lbDocTitle;
    IBOutlet UILabel * _lbDate;
    IBOutlet UILabel * _lbCreator;
    IBOutlet UILabel * _lbSize;
}
@property(nonatomic,retain) TrainingDoc * doc;
@end
