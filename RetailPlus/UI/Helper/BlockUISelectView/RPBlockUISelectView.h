//
//  RPBlockUISelectView.h
//  RetailPlus
//
//  Created by lin dong on 14-2-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPBlockUISelectBodyView.h"

typedef void(^RPAlertSelectBlock)(NSInteger);

@interface RPBlockUISelectView : UIView<RPBlockUISelectBodyViewDelegate>
{
    UIView                  * _viewBackground;
    RPBlockUISelectBodyView * _viewBody;
    
    NSInteger               _nCurSel;
}

@property(nonatomic,copy)RPAlertSelectBlock block;

- (id)initWithTitle:(NSString *)title
        clickButton:(RPAlertSelectBlock)blockSet
           curIndex:(NSInteger)nCurSel
       selectTitles:(NSArray *)arrayTitle;

-(void)show;
@end
