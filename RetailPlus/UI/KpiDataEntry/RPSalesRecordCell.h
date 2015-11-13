//
//  RPSalesRecordCell.h
//  RetailPlus
//
//  Created by zwhe on 14-1-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPSalesRecordCellDelegate <NSObject>
    -(void)OnValueChange;
    -(void)OnValueBeginChange:(UITableViewCell *)cell;
@end

@interface RPSalesRecordCell : UITableViewCell<UITextFieldDelegate>
{
    
}
@property (assign, nonatomic) id<RPSalesRecordCellDelegate> delegate;
@property (strong, nonatomic) KPISalesData *salesData;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;
@property (strong, nonatomic) IBOutlet UITextField *tfTxnQty;
@property (strong, nonatomic) IBOutlet UITextField *tfSalesQty;
@property (strong, nonatomic) IBOutlet UITextField *tfSalesAmount;
@end
