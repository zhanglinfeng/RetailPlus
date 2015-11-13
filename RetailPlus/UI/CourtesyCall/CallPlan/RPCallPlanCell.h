//
//  RPCallPlanCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-13.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RPCallPlanCellDelegate<NSObject>
-(void)editPlan:(CourtesyCallInfo *)courtesyCallInfo;
@end
@interface RPCallPlanCell : UITableViewCell
{
    IBOutlet UILabel *_lbCustomerName;
    
    IBOutlet UILabel *_lbCallPurpose;
    IBOutlet UIImageView *_ivVip;
    IBOutlet UILabel *_lbDate;
    IBOutlet UIImageView *_ivReminder;
    IBOutlet UIImageView *_ivTime;
}
@property(nonatomic,assign)id<RPCallPlanCellDelegate>delegate;
@property(nonatomic,strong)CourtesyCallInfo *courtesyCallInfo;
@property(nonatomic,strong)NSArray *arrayType;
- (IBAction)OnEdit:(id)sender;
@end
