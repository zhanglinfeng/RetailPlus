//
//  RPLogBookSearchDetailView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-5.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPLogBookCell.h"
@protocol RPLogBookSearchDetailViewDelegate<NSObject>
-(void)refreshLogBook;
@end
@interface RPLogBookSearchDetailView : UIView<UITableViewDataSource,UITableViewDelegate,RPLogBookCellDelegate>
{
    IBOutlet UIView       *_viewBackground;
    IBOutlet UILabel      * _lbStoreTitle;
    IBOutlet UILabel      * _lbStoreName;
    IBOutlet UITableView  * _tbDetail;
}
@property(nonatomic,assign)id<RPLogBookSearchDetailViewDelegate>delegete;
@property (nonatomic,retain) LogBookDetail        * detail;
@property (nonatomic,assign) StoreDetailInfo      * storeSelected;
@end
