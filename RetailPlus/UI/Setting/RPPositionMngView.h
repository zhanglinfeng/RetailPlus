//
//  RPPositionMngView.h
//  RetailPlus
//
//  Created by lin dong on 14-9-2.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPAddPosition.h"

@interface RPPositionMngView : UIView<UITableViewDataSource,UITableViewDelegate,RPAddPositionDelegate>
{
    IBOutlet RPAddPosition * _addPosition;
    IBOutlet UIView        * _viewFrame;
    IBOutlet UITableView   * _tbPosition;
    IBOutlet UILabel       * _lbUserName;
    
    BOOL                   _bShowAddPos;
}

@property (nonatomic,assign) UserDetailInfo * loginProfile;

-(BOOL)OnBack;
@end
