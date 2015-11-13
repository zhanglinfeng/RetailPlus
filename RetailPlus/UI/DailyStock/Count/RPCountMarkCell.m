//
//  RPCountMarkCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCountMarkCell.h"

@implementation RPCountMarkCell

- (void)awakeFromNib
{
    // Initialization code
    _viewFrame.layer.cornerRadius=4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFavTagList:(FavTagList *)favTagList
{
    _favTagList=favTagList;
//    NSLog(@"wwwwwwww%@",[_favTagList.arrayTag objectAtIndex:0]);
//    if ([_favTagList.arrayTag objectAtIndex:0]==nil)
//    {
//        _lbMark1.text=@"";
//    }
//    else
//    {
        _lbMark1.text=((RPDSTag *)[_favTagList.arrayTag objectAtIndex:0]).strTagName;
//    }
//    if ([_favTagList.arrayTag objectAtIndex:1]==nil)
//    {
//        _lbMark2.text=@"";
//    }
//    else
//    {
         _lbMark2.text=((RPDSTag *)[_favTagList.arrayTag objectAtIndex:1]).strTagName;
//    }
//    if ([_favTagList.arrayTag objectAtIndex:2]==nil)
//    {
//        _lbMark3.text=@"";
//    }
//    else
//    {
        _lbMark3.text=((RPDSTag *)[_favTagList.arrayTag objectAtIndex:2]).strTagName;
//    }
    
}
@end
