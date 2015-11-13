//
//  RPUserListCell.m
//  RetailPlus
//
//  Created by lin dong on 14-3-14.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPUserListCell.h"
#import "UIImageView+WebCache.h"

@implementation RPUserListCell

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
    _lbName.adjustsFontSizeToFitWidth = YES;
    _lbTitle.adjustsFontSizeToFitWidth = YES;
    
    CALayer *sublayer = _ivThumb.layer;
    sublayer.cornerRadius = 6;
    sublayer.borderColor = [UIColor lightGrayColor].CGColor;
    sublayer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUser:(UserDetailInfo *)user
{
    _user = user;
    
    [_ivThumb setImageWithURLString:user.strPortraitImg placeholderImage:[UIImage imageNamed:@"icon_userimage01_224.png"]];
    
    _lbName.text =  [NSString stringWithFormat:@"%@",user.strFirstName];
    
    
    switch (_user.rank) {
        case Rank_Manager:
            _viewLevel.backgroundColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _viewLevel.backgroundColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _viewLevel.backgroundColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _viewLevel.backgroundColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }
    
    _lbTitle.text = [NSString stringWithFormat:@"%@ %@",user.strDomainName,user.strRoleName];
}
@end
