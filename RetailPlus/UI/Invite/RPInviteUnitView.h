//
//  RPInviteUnitView.h
//  RetailPlus
//
//  Created by lin dong on 13-8-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPInviteUnitViewDelegate <NSObject>
    -(void)SelectPosition:(InvitePosition *)position;
@end

@interface RPInviteUnitView : UIView<UITextFieldDelegate>
{
    IBOutlet UIView             * _viewFrame;
    IBOutlet UIView             * _viewSearchFrame;
    
    IBOutlet UITableView        * _tbUnit;
    IBOutlet UITextField        * _tfSearch;
    NSArray                     * _arrayPosition;
    NSMutableArray              * _arrayShowPosition;
}

@property (nonatomic,assign) InviteRole  * roleCurrent;
@property (nonatomic,assign) id<RPInviteUnitViewDelegate> delegate;
@end
