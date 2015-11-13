//
//  RPBVisitMarkCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSwitchView.h"
@protocol RPBVisitMarkCellDelegate <NSObject>
-(void)OnMark:(BVisitItem *)visitItem;
-(void)OnAddIssue:(BVisitItem *)visitItem;
@end
@interface RPBVisitMarkCell : UITableViewCell<RPSwitchViewDelegate>
{
    IBOutlet UILabel              * _lbCheck;
    
    IBOutlet UIView               * _viewSwitch;
    IBOutlet UIButton             * _btNA;
    IBOutlet UILabel              * _lbNA;
    UIView                        * _coverageView;
    RPSwitchView                  * _switch;
    BOOL                            _bCheck;//yes打勾，no打叉
    IBOutlet UIView *_viewClose;
    IBOutlet UIButton *_btClose;
    IBOutlet UILabel *_lbOpen;
}

@property (nonatomic,assign) BVisitItem * visitItem;
@property (nonatomic,assign) id<RPBVisitMarkCellDelegate> delegate;
- (IBAction)OnNA:(id)sender;
- (IBAction)OnAddIssue:(id)sender;
- (IBAction)OnCloseIssue:(id)sender;
- (IBAction)OnOpenIssue:(id)sender;
@end
