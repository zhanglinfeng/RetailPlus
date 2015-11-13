//
//  RPRelatedTaskView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-9-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPRelatedTaskView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *_tbTask;
}
@property (nonatomic,retain) NSMutableArray     * arrayTask;
@end
