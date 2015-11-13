//
//  RPTrainingFolderCell.m
//  RetailPlus
//
//  Created by lin dong on 14-3-25.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTrainingFolderCell.h"

@implementation RPTrainingFolderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFolder:(TrainingFolder *)folder
{
    _folder = folder;
    _lbFolderName.text = folder.strFolderName;
}
@end
