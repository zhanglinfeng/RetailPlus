//
//  RPPurchaseRecordCell.m
//  RetailPlus
//
//  Created by zwhe on 13-12-27.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPPurchaseRecordCell.h"

@implementation RPPurchaseRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setRecord:(CustomerPurchase *)record
{
 //   UIScrollView *sv=[self.subviews objectAtIndex:0];
 //   sv.bounces=NO;
    _record=record;
    _lbProductName.text=record.strProductName;
    _lbAmount.text=[NSString stringWithFormat:@"%@",record.numProductAmount];
    _lbDate.text=record.strPurchaseDate;
    _lbQty.text=[NSString stringWithFormat:@"%@",record.numProductQty];
}

//- (void)willTransitionToState:(UITableViewCellStateMask)state
//{
//    
//    
//    [super willTransitionToState:state];
//    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask)
//    {
//        for (UIView* subview in self.subviews)
//        {
//            
//            NSLog(@"=======%@",NSStringFromClass([subview class]));
//            
//            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellScrollView"])
//            {
//            
//                UIImageView *deleteBtn = [[UIImageView alloc]initWithFrame:CGRectMake(304, 0, 100, 38)];
//                [deleteBtn setImage:[UIImage imageNamed:@"delete.png"]];
//                [[subview.subviews objectAtIndex:0] addSubview:deleteBtn];
//            }
//        }
//    }
//}
@end
