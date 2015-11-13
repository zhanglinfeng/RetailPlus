//
//  RPBookConfEditUserView.h
//  RetailPlus
//
//  Created by lin dong on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPConfDefine.h"

@protocol RPBookConfEditUserViewDelegate <NSObject>
-(void)OnEditUserEnd;
@end

typedef enum
{
    BookConfEditUserMode_AddNew = 0,
    BookConfEditUserMode_ModifyHost,
    BookConfEditUserMode_ModifyGuest
}BookConfEditUserMode;

@interface RPBookConfEditUserView : UIView
{
    IBOutlet UIView          * _viewFrame;
    IBOutlet UIView          * _viewTextFrame;
    IBOutlet UITextField     * _tfPhone;
    IBOutlet UITextField     * _tfName;
    IBOutlet UITextField     * _tfEmail;
}

@property (nonatomic,assign) id<RPBookConfEditUserViewDelegate> delegate;
@property (nonatomic,retain) RPConfBookMember * member;
@property (nonatomic) BookConfEditUserMode mode;
@end
