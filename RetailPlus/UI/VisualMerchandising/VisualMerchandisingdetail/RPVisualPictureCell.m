//
//  RPVisualPictureCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPVisualPictureCell.h"
#import "UIImageView+WebCache.h"
@implementation RPVisualPictureCell

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
-(void)setReplyImg:(ReplyImg *)replyImg
{
    if (replyImg.strThumbPath)
    {
        [_ivPic setImageWithURLString:replyImg.strImgPath];
    }
    _lbComment.text=replyImg.strComments;
}
-(void)setBSelected:(BOOL)bSelected
{
    
    _bSelected=bSelected;
    if (bSelected)
    {
        _ivSelect.hidden=NO;
//        _viewSelect.layer.borderColor=[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1].CGColor;
//        _viewSelect.layer.borderWidth=1;
        _viewSelect.backgroundColor=[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
        _lbComment.textColor=[UIColor whiteColor];
    }
    else
    {
        _ivSelect.hidden=YES;
//        _viewSelect.layer.borderColor=[UIColor clearColor].CGColor;
//        _viewSelect.layer.borderWidth=1;
        _viewSelect.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
        _lbComment.textColor=[UIColor darkGrayColor];
    }
}
@end
