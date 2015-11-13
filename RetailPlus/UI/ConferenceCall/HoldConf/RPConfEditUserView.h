//
//  RPConfEditUserView.h
//  RetailPlus
//
//  Created by lin dong on 14-6-19.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPConfDefine.h"

@protocol RPConfEditUserViewDelegate <NSObject>
    -(void)OnEditUserEnd;
@end

typedef enum
{
    ConfUserEditMode_AddNew = 0,
    ConfUserEditMode_ModifyHost,
    ConfUserEditMode_ModifyGuest
}ConfUserEditMode;

@interface RPConfEditUserView : UIView
{
    IBOutlet UIView          * _viewFrame;
    IBOutlet UIView          * _viewTextFrame;
    IBOutlet UITextField     * _tfPhone;
    IBOutlet UITextField     * _tfName;
    IBOutlet UITextField     * _tfEmail;
}

@property (nonatomic,assign) id<RPConfEditUserViewDelegate> delegate;
@property (nonatomic,retain) RPConfGuest * guest;
@property (nonatomic) ConfUserEditMode mode;
@end
