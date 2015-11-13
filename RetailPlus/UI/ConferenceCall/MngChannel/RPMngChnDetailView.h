//
//  RPMngChnDetailView.h
//  RetailPlus
//
//  Created by lin dong on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPConfDefine.h"
#import "RPMngChnView.h"

@interface RPMngChnDetailView : UIView
{
    IBOutlet UIView          * _viewFrame;
    IBOutlet UIView          * _viewTextFrame;
    IBOutlet UITextField     * _tfUserName;
    IBOutlet UITextField     * _tfPassWord;
}

@property (nonatomic,assign) id<RPMngChnViewDelegate>   delegate;
@property (nonatomic,retain) RPConfAccount              * account;

@end
