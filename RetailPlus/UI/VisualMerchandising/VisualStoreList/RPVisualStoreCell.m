//
//  RPVisualStoreCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPVisualStoreCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
@implementation RPVisualStoreCell

- (void)awakeFromNib
{
    // Initialization code
    _ivPic.layer.cornerRadius=3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setBEdit:(BOOL)bEdit
{
    if (bEdit)
    {
        [UIView beginAnimations:nil context:nil];
        _viewFrame.frame=CGRectMake(self.frame.origin.x, _viewFrame.frame.origin.y, 254, _viewFrame.frame.size.height);
        _ivSelect.hidden=NO;
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        _viewFrame.frame=CGRectMake(self.frame.origin.x, _viewFrame.frame.origin.y, 304, _viewFrame.frame.size.height);
        _ivSelect.hidden=YES;
         [UIView commitAnimations];
    }
}
-(void)setFollowStore:(FollowStore *)followStore
{
    _followStore=followStore;
    _lbStoreName.text=[NSString stringWithFormat:@"%@ %@",_followStore.strBrandName,_followStore.strStoreName];
    _lbNumber1.text=[NSString stringWithFormat:@"%d",_followStore.rejectCount];
    _lbNumber2.text=[NSString stringWithFormat:@"%d",_followStore.pendingCount];
    if (_followStore.rejectCount==0)
    {
        _ivState1.image=[UIImage imageNamed:@"icon_reject_off_storelist@2x.png"];
    }
    else
    {
        _ivState1.image=[UIImage imageNamed:@"icon_reject_storelist@2x.png"];
    }
    if (_followStore.pendingCount==0)
    {
        _ivState2.image=[UIImage imageNamed:@"icon_pending_off_storelist_@2x.png"];
    }
    else
    {
        _ivState2.image=[UIImage imageNamed:@"icon_pending_storelist@2x.png"];
    }
    if (followStore.strStoreThumb) {
        [_ivPic setImageWithURLString:_followStore.strStoreThumb placeholderImage:[UIImage imageNamed:@"icon_default_store_pic.png"]];
    }
    
}
-(void)setCheck:(BOOL)check
{
    _check=check;
    if (_check)
    {
        _ivSelect.image=[UIImage imageNamed:@"icon_selected_setup@2x.png"];
    
    }
    else
    {
        _ivSelect.image=[UIImage imageNamed:@"icon_noselected_setup@2x.png"];
        
    }
}
@end
