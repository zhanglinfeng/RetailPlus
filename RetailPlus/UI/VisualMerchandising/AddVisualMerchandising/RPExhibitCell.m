//
//  RPExhibitCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPExhibitCell.h"
extern NSBundle * g_bundleResorce;
@implementation RPExhibitCell

- (void)awakeFromNib
{
    // Initialization code
    _tfRemark.text=NSLocalizedStringFromTableInBundle(@"Remark",@"RPString", g_bundleResorce,nil);;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Ondelete:(id)sender
{
    [self.delegate OnDeleteImg:_vmImage];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    _vmImage.strComments=_tvRemrak.text;
    [self.delegate EndEditing];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.delegate showIndex:self.index];
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (_tvRemrak.text.length>0)
    {
        _tfRemark.hidden=YES;
    }
    else
    {
        _tfRemark.hidden=NO;
    }
}
-(void)setVmImage:(VMImage *)vmImage
{
    _vmImage=vmImage;
    [_ivPic setImage:_vmImage.imgData];
    _tvRemrak.text=vmImage.strComments;
    if (_tvRemrak.text.length>0)
    {
        _tfRemark.hidden=YES;
    }
    else
    {
        _tfRemark.hidden=NO;
    }
//    _tvRemrak.placeholder=NSLocalizedStringFromTableInBundle(@"Remark",@"RPString", g_bundleResorce,nil);
}
@end
