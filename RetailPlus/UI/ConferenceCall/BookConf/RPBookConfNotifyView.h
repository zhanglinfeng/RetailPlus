//
//  RPBookConfNotifyView.h
//  RetailPlus
//
//  Created by lin dong on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPConfDefine.h"

@protocol RPBookConfNotifyViewDelegate <NSObject>
    -(void)OnBookingSendMsgEnd;
@end

@interface RPBookConfNotifyView : UIView
{
    IBOutlet UITextView     * _tvMsg;
    IBOutlet UIView         * _viewFrame;
    IBOutlet UIButton       * _btnCheck;
    IBOutlet UIImageView    * _ivSendCheck;
    
    BOOL                    _bSendMsg;
}

@property (nonatomic,assign) id<RPBookConfNotifyViewDelegate> delegate;
@property (nonatomic,retain) RPConfBook * confBook;

@end
