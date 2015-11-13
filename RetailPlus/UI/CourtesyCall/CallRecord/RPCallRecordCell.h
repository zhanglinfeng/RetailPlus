//
//  RPCallRecordCell.h
//  RetailPlus
//
//  Created by lin dong on 14-3-14.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPCallRecordCell : UITableViewCell
{
    IBOutlet UILabel *_lbDate;
    IBOutlet UILabel *_lbUserName;
    IBOutlet UILabel *_lbCallPurpose;
    IBOutlet UILabel *_lbCustomerName;
    IBOutlet UILabel *_lbDuration;
    IBOutlet UIImageView *_ivVip;
    IBOutlet UIImageView *_ivPlan;
    IBOutlet UIImageView *_ivVoipCall;
    IBOutlet UIImageView *_ivCallSuccess;
}

@property(nonatomic,strong) NSArray *arrayType;
@property (nonatomic,retain) CourtesyCallInfo * info;
@end
