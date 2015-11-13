//
//  RPLiveVideoSelCamView.h
//  RetailPlus
//
//  Created by lin dong on 14-4-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPLiveVideoView.h"

@protocol RPLiveVideoSelCamViewDelegate <NSObject>
-(void)OnLiveVideoEnd;
@end

@interface RPLiveVideoSelCamView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView                 * _viewFrame;
    IBOutlet UILabel                * _lbStore;
    IBOutlet UITableView            * _tbCamera;
    IBOutlet RPLiveVideoView        * _viewLive;
    NSMutableArray                  * _arrayCamera;
    
}

@property (nonatomic,assign) id<RPLiveVideoSelCamViewDelegate> delegate;
@property (nonatomic,assign) StoreDetailInfo * storeSelected;

-(BOOL)OnBack;
-(IBAction)OnLiveVideoEnd:(id)sender;

@end
