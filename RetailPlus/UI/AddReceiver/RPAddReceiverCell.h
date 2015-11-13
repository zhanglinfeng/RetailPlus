//
//  RPAddReceiverCell.h
//  RetailPlus
//
//  Created by lin dong on 13-9-5.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPAddReceiverCellDelegate <NSObject>
-(void)OnSelectUser:(UserDetailInfo *)colleague bSelected:(BOOL)bSelect;
-(void)OnSelectEmail:(NSString *)strEmail bSelected:(BOOL)bSelect;
@end

@interface RPAddReceiverCell : UITableViewCell
{
    IBOutlet UIButton        * _btnPic;
    IBOutlet UIView          * _viewContact;
    IBOutlet UIView          * _viewLevel;
    IBOutlet UILabel         * _lbName;
    IBOutlet UILabel         * _lbRoleDesc;
    IBOutlet UIButton        * _btnSelected;
    IBOutlet UIImageView     * _ivLock; 
}


@property (nonatomic)BOOL                                   bSelect;
@property (nonatomic,assign) UserDetailInfo                 * colleague;
@property (nonatomic,assign) id<RPAddReceiverCellDelegate>  delegate;

@property (nonatomic)BOOL                                   bEmail;
@property (nonatomic,assign) NSString                       * strEmail;

-(IBAction)OnCheck:(id)sender;

@end
