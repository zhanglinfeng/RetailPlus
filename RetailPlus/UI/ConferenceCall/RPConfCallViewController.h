//
//  RPConfCallViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPMainViewController.h"
#import "RPMngChnView.h"
#import "RPHoldConfView.h"
#import "RPBookConfView.h"
#import "RPCtrlConfView.h"
#import "RPConfHistoryView.h"

typedef enum
{
    RPCONFCALLSTEP_MAIN = 0,
    RPCONFCALLSTEP_MNGCHN,
    RPCONFCALLSTEP_HOLDCONF,
    RPCONFCALLSTEP_BOOKCONF,
    RPCONFCALLSTEP_CTRLCONF,
    RPCONFCALLSTEP_CONFHISTORY,
}RPCONFCALLSTEP;

@interface RPConfCallViewController : RPTaskBaseViewController<RPHoldConfViewDelegate,RPCtrlConfViewDelegate,RPConfHistoryViewDelegate,RPBookConfViewDelegate>
{
    IBOutlet UIView             * _viewBottom;
    IBOutlet UILabel            * _lbSelChn;
    IBOutlet UIButton           * _btnSelChn;
    IBOutlet UIView             * _viewTip;
    IBOutlet RPMngChnView       * _viewMngChn;
    IBOutlet RPHoldConfView     * _viewHoldConf;
    IBOutlet RPBookConfView     * _viewBookConf;
    IBOutlet RPCtrlConfView     * _viewCtrlConf;
    IBOutlet RPConfHistoryView  * _viewHistoryConf;
    
    RPCONFCALLSTEP              _step;
}

@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;

-(IBAction)OnMngChn:(id)sender;
-(IBAction)OnHoldConf:(id)sender;

@end
