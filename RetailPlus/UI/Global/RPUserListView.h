//
//  RPUserListView.h
//  RetailPlus
//
//  Created by lin dong on 14-3-14.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPUserSelectDelegate <NSObject>
    -(void)OnSelectUser:(UserDetailInfo *)user;
@end

@interface RPUserListView : UIView
{
    IBOutlet UIView         * _viewFrame;
    IBOutlet UITableView    * _tbUser;
    NSMutableArray          * _arrayUser;
}

@property (nonatomic,retain) id<RPUserSelectDelegate> delegate;

-(void)reloadUser;
-(void)dismiss;
@end
