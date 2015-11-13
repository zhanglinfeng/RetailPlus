//
//  RPTrainingFolderCell.h
//  RetailPlus
//
//  Created by lin dong on 14-3-25.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPTrainingFolderCell : UITableViewCell
{
    IBOutlet UILabel    * _lbFolderName;
}
@property(nonatomic,retain) TrainingFolder * folder;
@end
