//
//  RPTrafficRecordCell.h
//  RetailPlus
//
//  Created by zwhe on 14-1-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RPTrafficRecordCellDelegate <NSObject>
-(void)OnValueChange;
-(void)OnValueBeginChange:(UITableViewCell *)cell;
@end

@interface RPTrafficRecordCell : UITableViewCell<UITextFieldDelegate>
@property (assign, nonatomic) id<RPTrafficRecordCellDelegate> delegate;
@property (strong, nonatomic) KPITrafficData *trafficData;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;
@property (strong, nonatomic) IBOutlet UITextField *tfTraffic;

@end
