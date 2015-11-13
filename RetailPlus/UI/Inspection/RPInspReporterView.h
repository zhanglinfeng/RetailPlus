//
//  RPInspReporterView.h
//  RetailPlus
//
//  Created by lin dong on 13-9-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPInspReporterCmdCell.h"
#import "RPAddReceiverViewController.h"
#import "RPAddReceiverCell.h"
#import "RPInspReporterHeaderView.h"

@protocol RPInspReporterViewDelegate <NSObject>
-(void)OnEndAddUser:(InspReporters *)reporters;
@end

@interface RPInspReporterView : UIView<UITableViewDataSource,UITableViewDelegate,RPInspReporterCmdCellDelegate,RPAddReceiverViewControllerDelegate,RPAddReceiverCellDelegate,RPInspReporterHeaderViewDelegate>
{
    IBOutlet UILabel                         * _lbTitle;
    IBOutlet UITableView                     * _tbReport;
    IBOutlet UIView                          * _viewFrame;
    
    RPAddReceiverViewController              * _vcAddReceiver;
    
    NSInteger                                _nCurSectionIndex;
    
    BOOL                                     _bShowAddEmail;
    BOOL                                     _bShowAddColleague;
}

@property (nonatomic,retain) id<RPInspReporterViewDelegate> delegate;
@property (nonatomic,assign) NSString        * strTitle;
@property (nonatomic,retain) InspReporters * reporters;
@property (nonatomic,assign)NSInteger   nState;
-(IBAction)OnConfirmUser:(id)sender;
-(BOOL)OnBack;
- (IBAction)OnHelp:(id)sender;
@end
