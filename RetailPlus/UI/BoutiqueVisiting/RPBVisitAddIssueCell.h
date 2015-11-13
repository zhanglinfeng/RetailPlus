//
//  RPBVisitAddIssueCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RPBVisitAddIssueCellDelegate <NSObject>
-(void)OnAddIssue:(BVisitItem *)visitItem;
@end
@interface RPBVisitAddIssueCell : UITableViewCell
@property (nonatomic,assign) BVisitItem * visitItem;
@property (nonatomic,assign) id<RPBVisitAddIssueCellDelegate> delegate;

-(IBAction)OnAddIssue:(id)sender;
@end
