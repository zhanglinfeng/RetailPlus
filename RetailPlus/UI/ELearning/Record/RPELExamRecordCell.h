//
//  RPELExamRecordCell.h
//  RetailPlus
//
//  Created by lin dong on 14-8-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPELExamRecordCell : UITableViewCell
{
    IBOutlet UILabel        * _lbPapaerCode;
    IBOutlet UILabel        * _lbPaperName;
    IBOutlet UILabel        * _lbScore;
    IBOutlet UILabel        * _lbExamDate;
}

@property (nonatomic,retain) RPELExamRecord * record;
@end
