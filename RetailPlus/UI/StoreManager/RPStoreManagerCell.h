//
//  RPStoreManagerCell.h
//  RetailPlus
//
//  Created by lin dong on 13-9-3.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPStoreManagerCell : UITableViewCell
{
    IBOutlet UIButton       * _btnPic;
    IBOutlet UILabel        * _lbStoreName;
    IBOutlet UILabel        * _lbAddress;
    IBOutlet UIImageView    * _ivStoreUser;
    IBOutlet UIImageView    * _ivInfoComplete;
}

@property (nonatomic,assign) StoreDetailInfo    * store;
@end
