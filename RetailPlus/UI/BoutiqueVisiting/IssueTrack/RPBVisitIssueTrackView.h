//
//  RPBVisitIssueTrackView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-8-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPIssueDetailView.h"
#import "RPRelatedTaskView.h"
@interface RPBVisitIssueTrackView : UIView
{
    IBOutlet UIView         * _viewLeft;
    IBOutlet UIView         * _viewRight;
    IBOutlet UILabel        * _lbLeft;
    IBOutlet UILabel        * _lbRight;
    IBOutlet UILabel        * _lbCount;
    IBOutlet UIView *_viewFrame;
    IBOutlet RPIssueDetailView *_viewIssueDetail;
    IBOutlet RPRelatedTaskView *_viewRelatedTask;
    IBOutlet UIScrollView *_svFrame;
    
}
@property (nonatomic,retain) InspIssue          * issue;
@property (nonatomic,retain) NSMutableArray     * arrayTask;
- (IBAction)OnIssueDetail:(id)sender;
- (IBAction)OnTask:(id)sender;
@end
