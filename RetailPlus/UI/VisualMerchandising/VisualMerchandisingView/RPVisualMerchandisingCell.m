//
//  RPVisualMerchandisingCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPVisualMerchandisingCell.h"
#import "UIImageView+WebCache.h"
#import<CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
@implementation RPVisualMerchandisingCell

- (void)awakeFromNib
{
    // Initialization code
    _viewFrame.layer.cornerRadius=8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setVisualDisplay:(VisualDisplay *)visualDisplay
{
    _visualDisplay=visualDisplay;
    if (_visualDisplay.strImgUrl)
    {
        [_ivPic setImageWithURLString:_visualDisplay.strImgUrl];
    }
    _lbTitle.text=_visualDisplay.strTitle;
    _lbComments.text=[NSString stringWithFormat:@"%@:%@",_visualDisplay.strUserName,_visualDisplay.strComments];
    switch (_visualDisplay.rank) {
        case Rank_Manager:
            [_lbComments setColor:[UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1] fromIndex:0 length:_visualDisplay.strUserName.length];
            break;
        case Rank_StoreManager:
            [_lbComments setColor:[UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1] fromIndex:0 length:_visualDisplay.strUserName.length];
            break;
        case Rank_Assistant:
            [_lbComments setColor:[UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1] fromIndex:0 length:_visualDisplay.strUserName.length];
            break;
        case Rank_Vendor:
            [_lbComments setColor:[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1] fromIndex:0 length:_visualDisplay.strUserName.length];
            break;
        default:
            break;
    }
    [_lbComments setFont:[UIFont boldSystemFontOfSize:11] fromIndex:0 length:_lbComments.text.length];
    
    if (_visualDisplay.states==0)
    {
        _viewColor.backgroundColor=[UIColor colorWithRed:250.0f/255 green:195.0f/255 blue:0.0f/255 alpha:1];
        [_ivState setImage:[UIImage imageNamed:@"icon_pending_postlist@2x.png"]];
    }
    else if(_visualDisplay.states==1)
    {
        _viewColor.backgroundColor=[UIColor colorWithRed:190.0f/255 green:60.0f/255 blue:70.0f/255 alpha:1];
        [_ivState setImage:[UIImage imageNamed:@"icon_reject_postlist@2x.png"]];
    }
    else
    {
        _viewColor.backgroundColor=[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
        [_ivState setImage:[UIImage imageNamed:@"icon_pass_postlist@2x.png"]];
    }
    
}
@end
