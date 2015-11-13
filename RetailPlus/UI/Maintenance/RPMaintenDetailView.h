//
//  RPMaintenDetailView.h
//  RetailPlus
//
//  Created by lin dong on 13-9-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPInspIssueView.h"
#import "RPInspAddIssueCell.h"
#import "RPInspIssueCell.h"
#import "RPMaintenIssueView.h"
#import "RPMaintenAddView.h"

@protocol RPMaintenDetailViewDelegate <NSObject>
-(void)OnMaintenEnd;
@end

@interface RPMaintenDetailView : UIView<RPInspAddIssueCellDelegate,RPInspIssueCellDelegate,RPInspIssueViewDelegate,RPMaintenAddViewDelegate>
{
    IBOutlet UIView             * _viewFrame;
    IBOutlet UITableView        * _tbIssue;
    IBOutlet RPMaintenIssueView * _viewIssue;
    IBOutlet RPMaintenAddView   * _viewAdditional;
    IBOutlet UILabel            * _lbCount;
    
    
    BOOL                        _bShowIssueView;
    BOOL                        _bShowAddView;
}

@property (nonatomic,assign) id<RPMaintenDetailViewDelegate>  delegate;
@property (nonatomic,assign) UIViewController               * vcFrame;
@property (nonatomic,assign) StoreDetailInfo                * storeSelected;
@property (nonatomic,assign) MaintenanceData                * dataMainten;
@property (nonatomic,assign) NSMutableArray                 * arrayVendor;
@property (nonatomic,assign) NSMutableArray                 * arrayContact;

-(BOOL)OnBack;
-(IBAction)OnAdditional:(id)sender;
-(IBAction)OnCache:(id)sender;
- (IBAction)OnHelp:(id)sender;
@end
