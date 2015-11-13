//
//  RPBVisitIssueTrackCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-8-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RPBVisitIssueTrackCellDelegate <NSObject>
-(void)endSelectIssue;
@end;
@interface RPBVisitIssueTrackCell : UITableViewCell

{
    IBOutlet UILabel *_lbPath;
    IBOutlet UILabel *_lbName;
    IBOutlet UILabel *_lbDate;
    IBOutlet UILabel *_lbIssueTitle;
    IBOutlet UILabel *_lbState;
    
    IBOutlet UILabel *_lbCount;
    IBOutlet UIView *_viewColor;
}
@property (strong, nonatomic) IBOutlet UIButton *btSelect;
@property (nonatomic,strong) BVisitIssueSearchRet *issueSearchRet;
@property (nonatomic,strong)StoreDetailInfo *store;
@property (nonatomic,weak)id<RPBVisitIssueTrackCellDelegate>delegate;
- (IBAction)OnSelete:(id)sender;
@end
