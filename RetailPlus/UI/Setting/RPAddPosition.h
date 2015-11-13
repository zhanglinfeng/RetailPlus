//
//  RPAddPosition.h
//  RetailPlus
//
//  Created by lin dong on 14-9-2.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPInviteRoleVIew.h"
#import "RPInviteUnitVIew.h"

@protocol RPAddPositionDelegate <NSObject>
    -(void)OnAddPositionEnd;
@end

@interface RPAddPosition : UIView<RPInviteRoleViewDelegate,RPInviteUnitViewDelegate>
{
    IBOutlet UIView                 * _viewFrame;
    IBOutlet RPInviteRoleVIew       * _viewRole;
    IBOutlet RPInviteUnitView       * _viewUnit;
    IBOutlet UIButton               * _btnRole;
    IBOutlet UIButton               * _btnUnit;

    UIView                          * _viewShow;
    NSMutableArray                  * _arrayRange;
    NSMutableArray                  * _arrayUnit;
    
    InviteRole                      * _roleCurrent;
    InvitePosition                  * _positionCurrent;
}

@property (nonatomic,assign) id<RPAddPositionDelegate> delegate;
@property (nonatomic,retain) UserDetailInfo * loginProfile;

-(void)ClearData;
-(BOOL)OnBack;

@end
