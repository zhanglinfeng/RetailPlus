//
//  RPInviteRoleVIew.h
//  RetailPlus
//
//  Created by lin dong on 13-8-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPInviteRoleViewDelegate <NSObject>
    -(void)SelectRole:(InviteRole *)role;
@end

@interface RPInviteRoleVIew : UIView<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView             * _viewFrame;
    IBOutlet UITableView        * _tbRole;
}
@property (nonatomic,retain) NSArray * arrayRole;
@property (nonatomic,assign) id<RPInviteRoleViewDelegate> delegate;

@end
