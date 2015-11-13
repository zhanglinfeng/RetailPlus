//
//  RPMCViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-9-10.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "RPMCMsgCell.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"
#import "RPInfoCenterCommentView.h"
#import "RPMCReportCell.h"

#define kInfomationCenterNotification @"InfomationCenterNotify"

@protocol RPMCViewControllerDelegate <NSObject>
    -(void)OnICSelectUser:(UserDetailInfo *)user;
@end

@interface RPMCViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,RPInfoCenterCommentViewDelegate,RPMCReportCellDelegate>
{
    IBOutlet UIView         * _viewBorder;
    IBOutlet UIView         * _viewHideBar;
    IBOutlet UIScrollView   * _svFrame;
    IBOutlet UIButton       * _btnMsg;
    IBOutlet UIButton       * _btnReport;
    IBOutlet UIButton       * _btnTask;
    IBOutlet UILabel        * _lbTitle;
    IBOutlet RPInfoCenterCommentView   * _viewBroadCast;
    
    IBOutlet UITableView    * _tbReport;
    IBOutlet UITableView    * _tbMsg;
    IBOutlet UITableView    * _tbTask;
    
    IBOutlet UIImageView    * _ivRecMark;
    
    
    MJRefreshFooterView     * _footerMsg;
    MJRefreshHeaderView     * _headerMsg;
    MJRefreshFooterView     * _footerReport;
    MJRefreshHeaderView     * _headerReport;
    MJRefreshFooterView     * _footerTask;
    MJRefreshHeaderView     * _headerTask;
    
    MPMoviePlayerController * _moviePlayer;
    NSString                * _strCurPlayRecordUrl;
    
    NSTimer                 * _timer;
    
    NSInteger               _nTouchBegin;
    CGRect                  _rcOriginalViewFrame;
    BOOL                    _bInited;
    ICType                  _curType;
    
    NSMutableArray          * _arrayReport;
    NSMutableArray          * _arrayMessage;
    NSMutableArray          * _arrayTask;
    
    NSInteger               _nUnReadReport;
    NSInteger               _nUnReadMessage;
    NSInteger               _nUnReadTask;
}

-(IBAction)OnSelectSection:(id)sender;
-(IBAction)OnBack:(id)sender;
-(IBAction)onBroadCast:(id)sender;

-(void)ReloadMessage;
-(void)ClearMessage;
-(void)OnBack;

@property (nonatomic,assign) id<RPMCViewControllerDelegate> delegate;
@end
