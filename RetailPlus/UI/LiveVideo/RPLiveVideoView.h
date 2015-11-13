//
//  RPLiveVideoView.h
//  RetailPlus
//
//  Created by lin dong on 14-4-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPlaySDK.h"
#import "VideoPlayInfo.h"
#import "RecordInfo.h"
#import "CaptureInfo.h"
#import "VideoPlayUtility.h"

@interface RPLiveVideoView : UIView
{
    IBOutlet UIView     * _viewPlay;
    IBOutlet UILabel    * _lbCamera;
    IBOutlet UILabel    * _lbStoreName;
    IBOutlet UIView     * _viewMenu;
    
    VP_HANDLE           _vpHandle;
    NSMutableArray      * _arrayCamera;
    NSInteger           _nIndex;
    NSString            * _strStoreName;
    NSThread            * _networkRequestThread;
    IBOutlet UIButton *_btBef;
    IBOutlet UIButton *_btNext;
}

- (void)showVideo:(NSMutableArray *)arrayCamera index:(NSInteger)nIndex storeName:(NSString *)strStoreName;
- (IBAction)OnClose:(id)sender;
- (IBAction)OnBef:(id)sender;
- (IBAction)OnNext:(id)sender;

@end
