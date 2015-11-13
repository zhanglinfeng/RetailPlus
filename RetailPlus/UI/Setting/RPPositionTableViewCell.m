//
//  RPPositionTableViewCell.m
//  RetailPlus
//
//  Created by lin dong on 14-9-2.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPPositionTableViewCell.h"

@implementation RPPositionTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPosition:(RPPosition *)position
{
    _position = position;
    _lbPosition.text = position.strPositionName;
    _lbRole.text = position.strRoleName;
    _lbPosition.textColor = [UIColor colorWithWhite:0.3f alpha:1];
    _lbRole.textColor = [UIColor colorWithWhite:0.5f alpha:1];
    
    switch(position.rank)
    {
        case Rank_Assistant:
            _viewRank.backgroundColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            if ([position.strPositionId isEqualToString:_strDefaultPostionId])
            {
                _lbPosition.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
                _lbRole.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
                _viewRankCard.backgroundColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            }
            break;
        case Rank_StoreManager:
            _viewRank.backgroundColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            if ([position.strPositionId isEqualToString:_strDefaultPostionId])
            {
                _lbPosition.textColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
                _lbRole.textColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
                _viewRankCard.backgroundColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            }
            break;
        case Rank_Manager:
            _viewRank.backgroundColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            if ([position.strPositionId isEqualToString:_strDefaultPostionId])
            {
                _lbPosition.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
                _lbRole.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
                _viewRankCard.backgroundColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            }
            break;
        case Rank_Vendor:
            _viewRank.backgroundColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            if ([position.strPositionId isEqualToString:_strDefaultPostionId])
            {
                _lbPosition.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
                _lbRole.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
                _viewRankCard.backgroundColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            }
            break;
        default:
            break;
    }
}
@end
