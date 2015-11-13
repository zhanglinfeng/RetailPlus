//
//  RPStoreCardViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-9-3.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
#import "RPStoreCardView.h"
#import "RPStoreBusinessDelegate.h"

@interface RPStoreCardViewController : RPTaskBaseViewController
{
    IBOutlet UIView         * _viewTask;
    IBOutlet UIView         * _viewDetail;
    IBOutlet UIScrollView   * _svTask;
    
    RPStoreCardView         * _viewStoreCard;
    BOOL                      _bSmall;
    IBOutlet UIButton *_btInspection;
    IBOutlet UIButton *_btHandover;
    IBOutlet UIButton *_btMaintenance;
    IBOutlet UIButton *_btBVisit;
    IBOutlet UIButton *_btKpi;
    IBOutlet UIButton *_btVideo;
    IBOutlet UIButton *_btLogBook;
    IBOutlet UIButton *_btnDailyStock;
    
    IBOutlet UILabel *_lbInspection;
    IBOutlet UILabel *_lbMaintenance;
    IBOutlet UILabel *_lbHandover;
    IBOutlet UILabel *_lbBVisit;
    IBOutlet UILabel *_lbKpi;
    IBOutlet UILabel *_lbVideo;
    IBOutlet UILabel * _lbLogBook;
    IBOutlet UILabel * _lbDailyStock;
}

@property (nonatomic,retain) StoreDetailInfo * store;
@property (nonatomic,assign) id<RPStoreBusinessDelegate> delegate;
@property (nonatomic,assign) UIViewController * vcCtrl;

-(IBAction)OnCVisit:(id)sender;
-(IBAction)OnHandOver:(id)sender;
-(IBAction)OnMaintenance:(id)sender;
-(IBAction)OnBVisit:(id)sender;
-(IBAction)OnLogbook:(id)sender;
-(IBAction)OnKPIEntry:(id)sender;
-(IBAction)OnEdit:(id)sender;
- (IBAction)OnDailyStock:(id)sender;
@end
