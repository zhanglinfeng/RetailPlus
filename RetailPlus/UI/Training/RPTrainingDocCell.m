//
//  RPTrainingDocCell.m
//  RetailPlus
//
//  Created by lin dong on 14-3-13.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTrainingDocCell.h"

@implementation RPTrainingDocCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDoc:(TrainingDoc *)doc
{
    _doc = doc;
    _lbCreator.text = doc.strCreator;
    _lbDate.text = doc.strDate;
    _lbDocTitle.text = doc.strFileName;
    
    if (doc.dbSize > 1024) {
        double fMB = doc.dbSize / 1024;
        _lbSize.text = [NSString stringWithFormat:@"%0.2f MB",fMB];
    }
    else
        _lbSize.text = [NSString stringWithFormat:@"%0.2f KB",doc.dbSize];
}

@end
