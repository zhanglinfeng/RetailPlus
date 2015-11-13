//
//  RPStoreMngNavView.h
//  RetailPlus
//
//  Created by lin dong on 14-9-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPStoreMngNavBtn.h"

@protocol RPStoreMngNavViewDelegate <NSObject>
    -(void)OnDomainChange:(DomainInfo *)domain;
@end

@interface RPStoreMngNavView : UIView<RPStoreMngNavBtnDelegate>
{
    IBOutlet UIView     * _viewNavFrame;
    NSMutableArray      * _arrayDomainBtn;
}

@property (nonatomic,assign) id<RPStoreMngNavViewDelegate> delegate;
@property (nonatomic,retain) NSArray            * arrayDomainTree;
@property (nonatomic,retain) DomainInfo         * domainCurrent;
@end
