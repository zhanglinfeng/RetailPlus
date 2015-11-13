//
//  RPMainPageViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-9-22.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "RPSystemTaskBaseViewController.h"
#import "RPDocLiveView.h"
#import "RPStoreBusinessDelegate.h"
#import "RPInfoLiveView.h"
#import "RPDateSettingView.h"
#import "RPTaskLiveView.h"

@protocol RPMainPageViewControllerDelegate <NSObject>
-(void)OnSelectTask:(TaskInfo *)info;
@end


@interface RPMainPageViewController : RPSystemTaskBaseViewController<MFMailComposeViewControllerDelegate,UIScrollViewDelegate,TrendViewDelegate,ColumnViewDelegate,RPDateSettingViewDelegate,RPTaskLiveViewDelegate,RPDocLiveViewDelegate,RPStoreSelectDelegate>
{
    MFMailComposeViewController * _mailPicker;
    
    IBOutlet UIView             * _viewframe;
    IBOutlet UIView             * _viewframe2;
    IBOutlet UIImageView        * _ivFrame3;
    IBOutlet UIImageView        * _ivChart;
    IBOutlet UIScrollView       * _svFrame;
    IBOutlet UIImageView        * _ivPage1;
    IBOutlet UIImageView        * _ivPage2;
    IBOutlet UIImageView        * _ivPage3;
    IBOutlet UILabel            * _lbTitle;
    IBOutlet UIImageView        * _ivShakeTip;
    
    IBOutlet RPDocLiveView      * _viewDoc;
    IBOutlet RPInfoLiveView     * _viewInfo;
    IBOutlet RPDateSettingView  * _viewDateSetting;
    IBOutlet RPTrendView        * _viewTrend;
    IBOutlet RPColumnView       * _viewColumn;
    IBOutlet RPTaskLiveView     * _viewTask;
    
    RPStoreListView             *_viewStoreList;
    BOOL                        _bViewDateSetting;
    BOOL                        _bViewDomainSelect;
}

@property (nonatomic,assign) UIViewController * vcFrame;
@property (nonatomic,assign) id<RPMainPageViewControllerDelegate> delegateMain;
@property (nonatomic,assign) id<RPDocLiveDelegate> delegate;
@property (nonatomic,assign) id<RPStoreBusinessDelegate> delegateStore;
//@property (nonatomic,weak)id<RPMainPageViewControllerDelegate>mainPageDelegate;
-(void)Reload;
-(IBAction)OnChangeChart:(id)sender;
//- (IBAction)OnSettingDate:(id)sender;
-(NSInteger)GetPageIndex;

-(void)UpdateTask;
@end

