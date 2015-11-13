//
//  RPMaintenContactView.h
//  RetailPlus
//
//  Created by lin dong on 13-9-16.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSYPopoverListView.h"

@interface RPMaintenContactView : UIView
{
    IBOutlet UIView   * _viewFrame;
    IBOutlet UIButton * _btnContactName;
    IBOutlet UIButton * _btnSelectContact;
    IBOutlet UITextField  * _tfUserName;
    IBOutlet UITextField  * _tfPhone;
    IBOutlet UIView       * _viewVertSplit;
    

    
    NSString              * _strColleagueName;
    int                   _curIndex;
}

@property (nonatomic,retain) NSMutableArray * arrayContact;
@property (nonatomic,retain) MaintenContact      * contact;

@property (nonatomic,retain) UITextField  * tfUserName;
@property (nonatomic,retain) UITextField  * tfPhone;
@property (nonatomic,retain) UIButton     * btnSelectContact;
@property (nonatomic)        BOOL         isColleague;

-(void)OnConfirm;

@end
