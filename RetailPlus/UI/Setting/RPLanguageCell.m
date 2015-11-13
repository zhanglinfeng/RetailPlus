//
//  RPLanguageCell.m
//  RetailPlus
//
//  Created by lin dong on 13-11-6.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPLanguageCell.h"

@implementation RPLanguageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)SetLang:(NSString *)strLangDesc Selected:(BOOL)bSelected
{
    _lbLangDesc.text = strLangDesc;
    [_btnLangSel setSelected:bSelected];
}
@end
