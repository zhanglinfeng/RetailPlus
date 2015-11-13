//
//  RPCallPlanListView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-13.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPAddCallPlanView.h"
#import "RPCallPlanCell.h"
#import "RPCourtesyCallView.h"
@protocol RPCallPlanListViewDelegate<NSObject>
-(void)endCallPlan;
@end
@interface RPCallPlanListView : UIView<UITableViewDataSource,UITableViewDelegate,RPAddCallPlanViewOKDelegate,RPCallPlanCellDelegate,RPCallRecordViewFromPlanDelegate>
{
    IBOutlet UILabel *_lbName;
    IBOutlet UILabel *_lbAddress;
    IBOutlet UIImageView *_ivHeader;
    IBOutlet UIView *_viewHead;
    IBOutlet UITableView *_tbCallPlanList;
    IBOutlet UIView *_viewBackground;
    NSMutableArray *_arrayPlanList;
    BOOL _bAddCallPlan;
    BOOL _bCourtesyCall;
    IBOutlet RPAddCallPlanView *_viewAddCallPlan;
    IBOutlet RPCourtesyCallView *_viewCourtesyCall;
    IBOutlet RPCourtesyCallRecordView *_viewCallRecord;
    
}
@property(nonatomic,assign)id<RPCallPlanListViewDelegate>delegate;
@property(nonatomic,strong)NSArray *arrayType;
- (IBAction)OnHelp:(id)sender;
-(IBAction)OnQuit:(id)sender;
- (IBAction)OnAddCallPlan:(id)sender;
-(BOOL)OnBack;
@end
