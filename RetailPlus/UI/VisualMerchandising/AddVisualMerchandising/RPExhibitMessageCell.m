//
//  RPExhibitMessageCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPExhibitMessageCell.h"
extern NSBundle * g_bundleResorce;
@implementation RPExhibitMessageCell

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
    _tfComment.text=NSLocalizedStringFromTableInBundle(@"Input Message",@"RPString", g_bundleResorce,nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.delegate BeginEditing];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.delegate OnCommentChange:_tvComment.text];
   
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (_tvComment.text.length>0) {
        _tfComment.hidden=YES;
    }
    else
    {
        _tfComment.hidden=NO;
    }
}
@end
