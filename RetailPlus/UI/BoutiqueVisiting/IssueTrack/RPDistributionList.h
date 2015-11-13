//
//  RPDistributionList.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-9-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPBVisitIssueTrackCell.h"
#import "RPBVisitIssueTrackHeadView.h"
#import "RPBVisitIssueTrackView.h"
#import "RPAddTaskView.h"
@interface RPDistributionList : UIView<UITableViewDelegate,UITableViewDataSource,RPBVisitIssueTrackCellDelegate,RPBVisitIssueTrackHeadViewDelegate,RPAddTaskViewDelegate>
{
    IBOutlet RPBVisitIssueTrackView *_viewIssueTrack;
    BOOL _bIssueView;
    IBOutlet UITableView *_tbIssue;
    NSMutableArray *_arraySearch;
    IBOutlet UIView *_viewFrame;
    IBOutlet RPAddTaskView *_viewTask;
    BOOL _bTask;
    BVisitIssueSearchData *_issueSearchData;
}
@property (nonatomic,retain)NSString *reportId;
-(BOOL)OnBack;
-(IBAction)OnOK:(id)sender;
@end
