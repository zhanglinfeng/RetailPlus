//
//  RPStoreInfoView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-19.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPStoreCardView.h"
@interface RPStoreInfoView : UIView
{
    
    RPStoreCardView         * _viewStoreCard;
}
@property (nonatomic,strong) StoreDetailInfo * storeInfo;
@end
