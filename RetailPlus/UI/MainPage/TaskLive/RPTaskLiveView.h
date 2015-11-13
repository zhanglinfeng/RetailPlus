//
//  RPTaskLiveView.h
//  RetailPlus
//
//  Created by Brilance on 14-9-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSearch.h"
#import "MJRefreshHeaderView.h"

typedef enum
{
    COLORTYPE_GREY=0,
    COLORTYPE_PURPLE,
    COLORTYPE_RED,
    COLORTYPE_YELLOW,
    COLORTYPE_GREEN,
    COLORTYPE_BLUE,
    
}COLORTYPE;

@protocol RPTaskLiveViewDelegate <NSObject>
-(void)OnSelectTask:(TaskInfo *)info;
@end


@interface RPTaskLiveView : UIView <UITableViewDelegate,UITableViewDataSource,RPSearchDelegate>
{
    IBOutlet UIView *_viewTaskBG;
    IBOutlet UITableView *_tbTask;
    IBOutlet UIImageView *_ivArrow;
    IBOutlet UIView *_viewFilter;
    IBOutlet UIView *_viewHead;
    IBOutlet UILabel *_lbUnderWay;
    IBOutlet UILabel *_lbFinished;
    IBOutlet UIButton *_btnUnderWay;
    IBOutlet UIButton *_btnFinished;
    IBOutlet UIButton *_btnSponsor;
    IBOutlet UIButton *_btnOperator;
    IBOutlet UIView   *_viewFilterBtn;
    IBOutlet UIView *_viewSponsor;
    IBOutlet UILabel *_lbSponsor;
    IBOutlet UIView *_viewOperator;
    IBOutlet UILabel *_lbOperator;
    IBOutlet UIButton *_btnGrey;
    IBOutlet UIButton *_btnPurple;
    IBOutlet UIButton *_btnRed;
    IBOutlet UIButton *_btnYellow;
    IBOutlet UIButton *_btnGreen;
    IBOutlet UIButton *_btnBlue;
    IBOutlet UIView   * _viewSearchFrame;
    IBOutlet UIImageView *_ivSpread;
    IBOutlet UIImageView *_ivMarkUnFinished;
    IBOutlet UIImageView *_ivMarkFinished;
    
    
    RPSearch    * _search;
    BOOL        _bFiltFinish;
    BOOL        _bSponsor;
    BOOL        _bOperator;
    ColorType   _curColor;
    MJRefreshHeaderView *_headerInternal;
    NSTimer     * _getPointTimer;
}

@property (nonatomic,assign) id<RPTaskLiveViewDelegate> delegate;
@property (nonatomic,strong)NSArray* arrayInfos;

- (IBAction)OnFilter:(id)sender;

- (IBAction)OnUnderWayTask:(UIButton*)sender;

- (IBAction)OnFinishedTask:(UIButton*)sender;

- (IBAction)OnColorSelected:(UIButton*)sender;

- (IBAction)OnSponsorTask:(UIButton*)sender;

- (IBAction)OnOperatorTask:(UIButton*)sender;

- (void)OnUpdateTask;


@end
