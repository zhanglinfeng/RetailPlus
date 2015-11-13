//
//  RPConfHistoryView.h
//  RetailPlus
//
//  Created by lin dong on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPConfHistoryDetailView.h"

@protocol RPConfHistoryViewDelegate <NSObject>
    -(void)OnHistoryEnd;
    -(void)OnRepeatConf:(RPConf *)conf;
@end

@interface RPConfHistoryView : UIView<UITableViewDataSource,UITableViewDelegate,RPConfHistoryDetailViewDelegate,UITextFieldDelegate>
{
    IBOutlet UIView                     * _viewFrame;
    IBOutlet UIView                     * _viewSearchFrame;
    IBOutlet UITextField                * _tfSearch;
    IBOutlet UITableView                * _tbConfHistory;
    IBOutlet RPConfHistoryDetailView    * _viewHistoryDetail;
    
    NSMutableArray                      * _arrayConf;
    NSMutableArray                      * _arrayConfShow;
    BOOL                                _bShowDetail;
}

@property (nonatomic,assign) id<RPConfHistoryViewDelegate> delegate;

-(void)ReloadData;
-(BOOL)OnBack;

@end
