//
//  RPInspIssueCell.h
//  RetailPlus
//
//  Created by lin dong on 13-8-19.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPInspIssueCellDelegate <NSObject>
    -(void)OnDeleteIssue:(InspCatagory *)catagory Issue:(InspIssue *)issue;
@end

@interface RPInspIssueCell : UITableViewCell
{
    IBOutlet UILabel    * _lbIssue;
    IBOutlet UIButton   * _btnDelete;
    IBOutlet UIView     * _viewVendor;
    IBOutlet UILabel    * _lbVendor;
}

@property (nonatomic,assign) InspCatagory * category;
@property (nonatomic,assign) InspIssue * issue;
@property (nonatomic,assign) id<RPInspIssueCellDelegate> delegate;

-(IBAction)OnDelete:(id)sender;
@end
