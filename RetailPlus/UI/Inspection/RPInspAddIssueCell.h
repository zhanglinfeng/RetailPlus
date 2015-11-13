//
//  RPInspAddIssueCell.h
//  RetailPlus
//
//  Created by lin dong on 13-8-19.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPInspAddIssueCellDelegate <NSObject>
    -(void)OnAddIssue:(InspCatagory *)catagory;
@end

@interface RPInspAddIssueCell : UITableViewCell

@property (nonatomic,assign) InspCatagory * catagory;
@property (nonatomic,assign) id<RPInspAddIssueCellDelegate> delegate;

-(IBAction)OnAddIssue:(id)sender;
@end
