//
//  RPTaskViewController.h
//  RetailPlus
//
//  Created by Brilance on 14-9-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTaskBaseViewController.h"
#import "RPEditTaskView.h"
#import "RPRelatedIssueView.h"
#import "RPAddReceiverViewController.h"
#import "RPMainViewController.h"
#import "RPAddCalender.h"

@interface RPTaskViewController : RPTaskBaseViewController<RPEditTaskViewDelegate,RPAddReceiverViewControllerDelegate,RPAddCalenderDelegate>
{
    
    IBOutlet UIScrollView   *_svTaskInfo;
    IBOutlet UIView         *_viewTaskDetail;
    IBOutlet UIImageView    *_ivArrow;
    IBOutlet UIView         *_viewFilter;
    
    IBOutlet UIView         *_viewColor;
    IBOutlet UILabel        *_lbTaskTitle;
    IBOutlet UILabel        *_lbTaskDesc;
    IBOutlet UILabel        *_lbEndDate;
    IBOutlet UIImageView    *_ivTaskState;
    IBOutlet UIImageView    *_ivSponsor;
    IBOutlet UIImageView    *_ivOperator;
    IBOutlet UILabel        *_lbSponsorName;
    IBOutlet UILabel        *_lbOperatorName;
    IBOutlet UILabel        *_lbSponsorRoleName;
    IBOutlet UILabel        *_lbOperatorRoleName;
    IBOutlet UILabel        *_lbTaskCode;
    IBOutlet UILabel        *_lbCreateTime;
    
    IBOutletCollection(UIButton) NSArray *_btnArray;
    
    IBOutletCollection(UILabel) NSArray *_lbArray;
    
    RPAddReceiverViewController              * _vcAddReceiver;
    IBOutlet RPEditTaskView                  *_viewEditTask;
    BOOL                                     _bTask;
    IBOutlet RPRelatedIssueView              *_viewIssue;
    BOOL                                     _bViewIssue;
    BOOL                                     _bReceiverList;
}

@property (nonatomic,retain) id<RPMainViewControllerDelegate> delegate;
@property (nonatomic,retain) TaskInfo * info;

@property (nonatomic,retain)NSString* _EndDate;

- (IBAction)OnMoreOperation:(id)sender;

- (IBAction)OnOperatorChanged:(UIButton *)sender;

- (IBAction)OnAddCalendar:(UIButton *)sender;

- (IBAction)OnEditTask:(UIButton *)sender;

- (IBAction)OnDeleteTask:(UIButton *)sender;

- (IBAction)OnFinishedTask:(UIButton *)sender;

- (IBAction)OnRelatedIssue:(UIButton *)sender;


@end
