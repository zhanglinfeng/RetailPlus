//
//  RPTrafficTableView.h
//  RetailPlus
//
//  Created by lin dong on 13-8-14.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPTrafficTableView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView * _tableTraffic;
}
@end
