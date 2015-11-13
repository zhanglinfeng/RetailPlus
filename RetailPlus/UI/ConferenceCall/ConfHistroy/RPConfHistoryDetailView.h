//
//  RPConfHistoryDetailView.h
//  RetailPlus
//
//  Created by lin dong on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPConfDefine.h"

@protocol RPConfHistoryDetailViewDelegate <NSObject>
    -(void)OnQuit;
    -(void)OnRepeat:(RPConf *)conf;
@end

@interface RPConfHistoryDetailView : UIView
{
    IBOutlet UIView                     * _viewFrame;
    IBOutlet UILabel                    * _lbConfTheme;
    IBOutlet UILabel                    * _lbCount;
    IBOutlet UILabel                    * _lbDateTime;
    IBOutlet UITableView                * _tbMember;
}

@property (nonatomic,assign) id<RPConfHistoryDetailViewDelegate> delegate;
@property (nonatomic,assign) RPConf * conf;
@end
