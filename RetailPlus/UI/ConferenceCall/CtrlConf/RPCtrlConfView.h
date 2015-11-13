//
//  RPCtrlConfView.h
//  RetailPlus
//
//  Created by lin dong on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPConfDefine.h"
#import "RPMngChnView.h"
#import "RPYuanTelApi.h"

typedef enum
{
    RPCTRLCONFVIEWSTEP_BEGIN = 0,
    RPCTRLCONFVIEWSTEP_EDITCHN,
}RPCTRLCONFVIEWSTEP;

@protocol RPCtrlConfViewDelegate <NSObject>
    -(void)OnCtrlConfEnd;
@end

@interface RPCtrlConfView : UIView<ConferenceCtrlDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView                 * _viewFrame;
    IBOutlet UILabel                * _lbTheme;
    IBOutlet UILabel                * _lbGuestCount;
    IBOutlet UILabel                * _lbDate;
    IBOutlet UITableView            * _tbGuest;
    IBOutlet UILabel                * _lbConfDuration;
    IBOutlet UIButton               * _btnEditChn;
    
    IBOutlet UIImageView            * _ivSelChn;
    IBOutlet UILabel                * _lbSelChn;
    IBOutlet RPMngChnView           * _viewMngChn;
    
    RPCTRLCONFVIEWSTEP              _step;
    NSTimer                         * _timer;
    BOOL                            _bCloseConfNext;
}

@property (nonatomic,assign) id<RPCtrlConfViewDelegate> delegate;
@property (nonatomic,retain) RPConf * conf;

-(void)UpdateChnTip;
-(BOOL)OnBack;

-(IBAction)OnCloseConf:(id)sender;

@end
