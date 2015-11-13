//
//  RPLiveVideoCamCell.m
//  RetailPlus
//
//  Created by lin dong on 14-4-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPLiveVideoCamCell.h"

@implementation RPLiveVideoCamCell

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCamera:(LiveCamera *)camera
{
    _camera = camera;
    _lbCamera.text = camera.strCameraName;
}
@end
