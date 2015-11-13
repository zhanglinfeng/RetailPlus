//
//  RPStoreMngNavBtn.h
//  RetailPlus
//
//  Created by lin dong on 14-9-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPStoreMngNavBtnDelegate <NSObject>
    -(void)OnDomain:(DomainInfo *)domain;
@end

@interface RPStoreMngNavBtn : UIView
{
    IBOutlet UILabel        * _lbDomainName;
    IBOutlet UIImageView    * _ivArrow;
}

@property (nonatomic,assign) id<RPStoreMngNavBtnDelegate> delegate;
@property (nonatomic,retain) DomainInfo * info;

@end
