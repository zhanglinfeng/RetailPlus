//
//  RPTaskCell.h
//  RetailPlus
//
//  Created by Brilance on 14-9-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPTaskCell : UITableViewCell
{
    
    IBOutlet UIView *_viewColor;
    IBOutlet UILabel *_lbTaskCode;
    IBOutlet UIImageView *_ivCalendar;
    IBOutlet UILabel *_lbEndDate;
    IBOutlet UIImageView *_ivTaskState;
    IBOutlet UILabel *_lbTaskTitle;
    IBOutlet UIView *_viewSponsor;
    IBOutlet UIView *_viewOperator;
    IBOutlet UILabel *_lbSponsor;
    IBOutlet UILabel *_lbOperator;
    IBOutlet UIImageView *_ivNewMark;
}

@property(nonatomic,strong) TaskInfo* taskInfo;

@end
