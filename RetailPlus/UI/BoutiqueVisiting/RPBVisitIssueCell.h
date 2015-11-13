//
//  RPBVisitIssueCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RPBVisitIssueCellDelegate <NSObject>
-(void)OnDeleteIssue:(BVisitItem *)visitItem Issue:(InspIssue *)issue;
@end
@interface RPBVisitIssueCell : UITableViewCell
{
    IBOutlet UILabel    * _lbIssue;
    IBOutlet UIButton   * _btnDelete;
    IBOutlet UIView     * _viewVendor;
    IBOutlet UILabel    * _lbVendor;
}

@property (nonatomic,assign) BVisitItem * visitItem;
@property (nonatomic,assign) InspIssue * issue;
@property (nonatomic,assign) id<RPBVisitIssueCellDelegate> delegate;

-(IBAction)OnDelete:(id)sender;
@end
