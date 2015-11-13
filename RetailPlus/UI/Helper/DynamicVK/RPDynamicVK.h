//
//  RPDynamicVK.h
//  RetailPlus
//
//  Created by lin dong on 14-3-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPDynamicVK : NSObject<UITextFieldDelegate>
{
    UITextField * _tfInput;
    UITextView  * _tvInput;
    UIButton    * _btnClose;
    UILabel     * _lbTextCount;
    NSString    * _strLast;
    NSInteger   _lastKeyBoarHeight;
}

+(RPDynamicVK *)defaultInstance;
-(void)AddDynamicCloseButton;

@end
