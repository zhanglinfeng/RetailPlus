//
//  RPStoreListCell.h
//  RetailPlus
//
//  Created by lin dong on 13-8-20.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPStoreListCell : UITableViewCell
{
    IBOutlet UIImageView * _ivThumb;
    IBOutlet UILabel     * _lbStore;
    IBOutlet UILabel     * _lbAddress;
}

-(void)setStore:(StoreDetailInfo *)store;

@end
