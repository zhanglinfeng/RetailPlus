//
//  RPCourtesyCallViewController.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-11.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
#import "RPMainViewController.h"
#import "RPCourtesyCallView.h"
#import "RPCallPlanListView.h"
#import "RPUserListView.h"
#import "RPCallRecordView.h"
#import "RPStoreListView.h"

typedef enum
{ 
    COURTESYSTEP_FIRST = 0,
    COURTESYSTEP_QUICKSTART,
    COURTESYSTEP_CALLPLAN,
    COURTESYSTEP_CALLRECORD,
    COURTESYSTEP_SELUSER,
    COURTESYSTEP_SELSTORE
}COURTESYSTEP;

@interface RPCourtesyCallViewController : RPTaskBaseViewController<RPCourtesyCallViewDelegate,RPCourtesyCallRecordViewDelegate,RPCallPlanListViewDelegate,RPAddCallPlanViewDelegate,RPUserSelectDelegate,RPAddCallPlanViewOKDelegate,RPCallRecordListViewDelegate,RPStoreSelectDelegate>
{
    IBOutlet UIView               *_viewBackground;
    COURTESYSTEP                   _step;
    IBOutlet RPCourtesyCallView   *_viewCourtesyCall;
    NSArray                       *_arrayCallType;
    IBOutlet RPCourtesyCallRecordView *_viewCallRecord;
    IBOutlet RPCallPlanListView *_viewCallPlanList;
    RPUserListView                  * _viewSelectUser;
    IBOutlet RPAddCallPlanView *_viewAddCallPlan;
    IBOutlet RPCallRecordView       * _viewRecord;
    RPStoreListView             * _viewStoreList;
    IBOutlet UIView *_viewBottom;
    
}

@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;
@property (nonatomic,assign) UIViewController * vcFrame;
@property(nonatomic,strong)Customer *customer;
@property (nonatomic,assign) StoreDetailInfo * storeSelected;
- (IBAction)OnHelp:(id)sender;
- (IBAction)OnQuickStart:(id)sender;
- (IBAction)OnCallPlan:(id)sender;
- (IBAction)OnCallRecord:(id)sender;
-(void)OnCallWithCustomer:(Customer*)customer;

@end
