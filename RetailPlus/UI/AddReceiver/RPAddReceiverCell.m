//
//  RPAddReceiverCell.m
//  RetailPlus
//
//  Created by lin dong on 13-9-5.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIButton+WebCache.h"
#import "RPAddReceiverCell.h"

@implementation RPAddReceiverCell

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

-(void)awakeFromNib
{
    _btnPic.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnPic.layer.borderWidth = 1;
    _btnPic.layer.cornerRadius = 5;
    _ivLock.layer.cornerRadius = 5;
}

-(void)setBSelect:(BOOL)bSelect
{
    [_btnSelected setSelected:bSelect];
    _bSelect = bSelect;
}

-(void)setColleague:(UserDetailInfo *)colleague
{
    _colleague = colleague;
    
    _viewLevel.hidden = NO;
    switch (_colleague.rank) {
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
             _viewLevel.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
            break;
    }
    
    [_btnPic setImageWithURLString:_colleague.strPortraitImg forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_userimage01_224.png"]];
    
    _lbName.text = [NSString stringWithFormat:@"%@",_colleague.strFirstName];
    _lbName.frame = CGRectMake(_lbName.frame.origin.x, 5, _lbName.frame.size.width, _lbName.frame.size.height);
    _lbRoleDesc.text = _colleague.strRoleName;
    _ivLock.hidden = (colleague.status == UserStatus_Locked ? NO : YES);
}

-(void)setStrEmail:(NSString *)strEmail
{
    _strEmail = strEmail;
    
    [_btnPic setImage:[UIImage imageNamed:@"icon_emailimage01@2x.png"] forState:UIControlStateNormal];
    _viewLevel.hidden = YES;
    _lbName.text = strEmail;
    _lbName.frame = CGRectMake(_lbName.frame.origin.x, 15, _lbName.frame.size.width, _lbName.frame.size.height);
    _lbRoleDesc.text = @"";
    _ivLock.hidden = YES;
}

-(IBAction)OnCheck:(id)sender
{
    _bSelect = !_bSelect;
    if (_bEmail)
        [self.delegate OnSelectEmail:self.strEmail bSelected:_bSelect];
    else
        [self.delegate OnSelectUser:self.colleague bSelected:_bSelect];
}
@end
