//
//  RPMngChnTableViewCell.h
//  RetailPlus
//
//  Created by lin dong on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPMngChnView.h"

@interface RPMngChnTableViewCell : UITableViewCell
{
    IBOutlet UIButton       * _btnStatus;
    IBOutlet UILabel        * _lbIndex;
    IBOutlet UILabel        * _lbUserName;
}

@property (nonatomic,assign) id<RPMngChnViewDelegate>   delegate;

@property (nonatomic,retain) RPConfAccount              * account;
@end
