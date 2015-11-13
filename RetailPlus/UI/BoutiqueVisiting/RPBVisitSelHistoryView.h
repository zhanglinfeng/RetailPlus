//
//  RPBVisitSelHistoryView.h
//  RetailPlus
//
//  Created by lin dong on 14-8-7.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPDocUnfinishedCell.h"

@protocol RPBVisitSelHistoryViewDelegate<NSObject>
-(void)OnSelectCacheData:(NSString *)strCacheDataId store:(StoreDetailInfo *)store;
-(void)OnHistoryQuit;
-(void)OnEditOtherReport:(BVisitListModel*)bVisitModel Store:(StoreDetailInfo *)storeInfo;
@end

@interface RPBVisitSelHistoryView : UIView<UITableViewDataSource,UITableViewDelegate,DocUnfinishedCellDelegate>
{
    IBOutlet UITableView    * _tbUnFinish;
    IBOutlet UIView         * _viewFrame;
    NSInteger               _nExpandCellIndex;
    NSArray                 * _arrayUnfinish;
    IBOutlet UIView         * _viewLeft;
    IBOutlet UIView         * _viewRight;
    IBOutlet UILabel        * _lbLeft;
    IBOutlet UILabel        * _lbRight;
    IBOutlet UILabel        * _lbLeftCount;
    IBOutlet UILabel        * _lbRightCount;
    NSInteger                 _type;//0表示自己未完成，1表示别人为完成
    NSMutableArray          * _arrayOtherUnfinish;
}

@property (nonatomic,assign) id<RPBVisitSelHistoryViewDelegate> delegate;
@property (nonatomic,assign) StoreDetailInfo                * storeSelected;
//-(void)ReloadData;
-(void)ReloadMyUnfinishData;
-(void)reloadOtherUnfinishData;
- (IBAction)OnMyUnfinished:(id)sender;
- (IBAction)OnReceivedUnfinished:(id)sender;
@end
