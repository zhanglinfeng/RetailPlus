//
//  RPLiveVideoCamCell.h
//  RetailPlus
//
//  Created by lin dong on 14-4-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPLiveVideoCamCell : UITableViewCell
{
    IBOutlet UIImageView     * _ivCamera;
    IBOutlet UILabel         * _lbCamera;
}

@property (nonatomic,assign) LiveCamera * camera;
@end
