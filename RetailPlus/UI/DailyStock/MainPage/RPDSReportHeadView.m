//
//  RPDSReportHeadView.m
//  RetailPlus
//
//  Created by lin dong on 14-7-9.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPDSReportHeadView.h"

@implementation RPDSReportHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    _nGatherWidth = _viewCurrentStockFrame.frame.size.width;
    _nGatherHeight = _viewCurrentStockFrame.frame.size.height;
    _nGap = 2;
    _bShowCurrentStock = YES;
    _bShowInOutStock = YES;
    _bShowLastStock = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(NSString *)ThumbStringFromInterger:(NSInteger)nCount
{
//    if (nCount > 10000)
//    {
//        float f = (float)nCount / 10000;
//        return [NSString stringWithFormat:@"%0.1fM",f];
//    }
    
    if (nCount >=10000)
    {
        float f = (float)nCount / 1000;
        return [NSString stringWithFormat:@"%0.1fK",f];
    }
    
    return [NSString stringWithFormat:@"%d",nCount];
}

-(void)setDetail:(RPDSDetail *)detail
{
    _detail = detail;
    
    _lbLastStockCount.text = [self ThumbStringFromInterger:detail.nLastAmount];
    _lbInCount.text = [self ThumbStringFromInterger:detail.nInAmount];
    NSLog(@"%@",_lbInCount.text);
    _lbOutCount.text = [self ThumbStringFromInterger:detail.nOutAmount];
    _lbCurrentStockCount.text = [self ThumbStringFromInterger:detail.nCurrentAmount];
    
    if (detail.nLastAmount == 0) {
        _lbLastStockCount.hidden = YES;
        _lbLastStockNA.hidden = NO;
    }
    else
    {
        _lbLastStockCount.hidden = NO;
        _lbLastStockNA.hidden = YES;
    }
    
    if (detail.nInAmount == 0 && detail.nOutAmount == 0) {
        _lbInCount.hidden = YES;
        _lbInSymb.hidden = YES;
        _lbOutCount.hidden = YES;
        _lbOutSymb.hidden = YES;
        _lbInOutNA.hidden = NO;
    }
    else
    {
        _lbInCount.hidden = NO;
        _lbInSymb.hidden = NO;
        _lbOutCount.hidden = NO;
        _lbOutSymb.hidden = NO;
        _lbInOutNA.hidden = YES;
    }
    
    if (detail.nCurrentAmount == 0) {
        _lbCurrentStockCount.hidden = YES;
        _lbCurrentStockNA.hidden = NO;
    }
    else
    {
        _lbCurrentStockCount.hidden = NO;
        _lbCurrentStockNA.hidden = YES;
    }
    
    switch (detail.arrayTags.count) {
        case 0:
            _btnTag1.hidden = YES;
            _btnTag2.hidden = YES;
            _btnTag3.hidden = YES;
            break;
        case 1:
        {
            RPDSTag * tag = [detail.arrayTags objectAtIndex:0];
            [_btnTag1 setTitle:tag.strTagName forState:UIControlStateNormal];
            
            _btnTag1.hidden = NO;
            _btnTag2.hidden = YES;
            _btnTag3.hidden = YES;
        }
            break;
        case 2:
        {
            RPDSTag * tag = [detail.arrayTags objectAtIndex:0];
            [_btnTag1 setTitle:tag.strTagName forState:UIControlStateNormal];
            tag = [detail.arrayTags objectAtIndex:1];
            [_btnTag2 setTitle:tag.strTagName forState:UIControlStateNormal];
            
            _btnTag1.hidden = NO;
            _btnTag2.hidden = NO;
            _btnTag3.hidden = YES;
        }
            break;
        case 3:
        default:
        {
            RPDSTag * tag = [detail.arrayTags objectAtIndex:0];
            [_btnTag1 setTitle:tag.strTagName forState:UIControlStateNormal];
            tag = [detail.arrayTags objectAtIndex:1];
            [_btnTag2 setTitle:tag.strTagName forState:UIControlStateNormal];
            tag = [detail.arrayTags objectAtIndex:2];
            [_btnTag3 setTitle:tag.strTagName forState:UIControlStateNormal];
            
            _btnTag1.hidden = NO;
            _btnTag2.hidden = NO;
            _btnTag3.hidden = NO;
        }
            break;
    }
}

-(IBAction)OnSelLast:(id)sender
{
    [self.delegate OnSelectLastStock:_detail];
}

-(IBAction)OnSelCurrent:(id)sender
{
    [self.delegate OnSelectCurrentStock:_detail];
}

-(IBAction)OnSelInOut:(id)sender
{
    [self.delegate OnSelectIOStock:_detail];
}

-(IBAction)OnSelTag:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    [self.delegate OnSelectTag:btn.titleLabel.text];
}

-(void)setBShowCurrentStock:(BOOL)bShowCurrentStock
{
    _bShowCurrentStock = bShowCurrentStock;
    [self ReArrangePos];
}

-(void)setBShowInOutStock:(BOOL)bShowInOutStock
{
    _bShowInOutStock = bShowInOutStock;
    [self ReArrangePos];
}

-(void)setBShowLastStock:(BOOL)bShowLastStock
{
    _bShowLastStock = bShowLastStock;
    [self ReArrangePos];
}

-(void)setTypeExpand:(RPDSReportExpandType)typeExpand
{
    _typeExpand = typeExpand;
    [self UpdateColor];
}

-(void)setBGatherMode:(BOOL)bGatherMode
{
    _bGatherMode = bGatherMode;
    [self UpdateColor];
}

-(void)setBOpenReport:(BOOL)bOpenReport
{
    _bOpenReport = bOpenReport;
    [self UpdateColor];
}

-(void)setStrGatherTag:(NSString *)strGatherTag
{
    _strGatherTag = strGatherTag;
    [self UpdateColor];
    
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    for (NSInteger n = 0; n < 3; n ++) {
        _rcGather[n] =  CGRectMake(frame.size.width - (n + 1) * _nGatherWidth - n * _nGap, frame.size.height - _nGatherHeight, _nGatherWidth, _nGatherHeight);
    }
    
    for (NSInteger n = 0; n < 4; n ++) {
        _rcTag[n] = CGRectMake(0, frame.size.height - _nGatherHeight, frame.size.width - n * _nGatherWidth - n * _nGap, _nGatherHeight);
    }
    [self ReArrangePos];
}

-(void)UpdateUI
{
    [self ReArrangePos];
    [self UpdateColor];
}

-(void)ReArrangePos
{
    [UIView beginAnimations:nil context:nil];
    NSInteger nCount = 0;
    if (_bShowCurrentStock) {
        _viewCurrentStockFrame.frame = _rcGather[nCount];
        nCount ++;
        _viewCurrentStockFrame.hidden = NO;
    }
    else
        _viewCurrentStockFrame.hidden = YES;
    
    if (_bShowInOutStock) {
        _viewInOutFrame.frame = _rcGather[nCount];
        nCount ++;
        _viewInOutFrame.hidden = NO;
    }
    else
        _viewInOutFrame.hidden = YES;
    
    if (_bShowLastStock) {
        _viewLastStockFrame.frame = _rcGather[nCount];
        nCount ++;
        _viewLastStockFrame.hidden = NO;
    }
    else
        _viewLastStockFrame.hidden = YES;
    
    _viewTagFrame.frame = _rcTag[nCount];
    [UIView commitAnimations];
}

-(void)UpdateTagBtnColor:(UIButton *)btn
{
    if (_bGatherMode) {
        [btn setBackgroundImage:[UIImage imageNamed:@"image_label_current_white.png"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    }
    else
    {
        if ([btn.titleLabel.text isEqualToString:_strGatherTag]) {
            [btn setBackgroundImage:[UIImage imageNamed:@"image_label_current_green.png"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"image_label_current.png"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
        }
    }
}

-(void)UpdateColor
{
    _viewLastStockFrame.backgroundColor = [UIColor whiteColor];
    _lbLastStockCount.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    _lbLastStockNA.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    
    _viewInFrame.backgroundColor = [UIColor whiteColor];
    _viewOutFrame.backgroundColor = [UIColor whiteColor];
    _lbInSymb.textColor = [UIColor colorWithRed:55.0f/255.0f green:115.0f/255.0f blue:120.0f/255.0f alpha:1];
    _lbInCount.textColor = [UIColor colorWithRed:55.0f/255.0f green:115.0f/255.0f blue:120.0f/255.0f alpha:1];
    _lbInOutNA.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    _lbOutSymb.textColor =  [UIColor colorWithRed:201.0f/255.0f green:69.0f/255.0f blue:54.0f/255.0f alpha:1];
    _lbOutCount.textColor = [UIColor colorWithRed:201.0f/255.0f green:69.0f/255.0f blue:54.0f/255.0f alpha:1];
    _lbInCount.textColor = [UIColor colorWithRed:55.0f/255.0f green:115.0f/255.0f blue:120.0f/255.0f alpha:1];
    
    _viewCurrentStockFrame.backgroundColor = [UIColor whiteColor];
    if (_bOpenReport)
        _lbCurrentStockCount.textColor = [UIColor colorWithRed:55.0f/255.0f green:115.0f/255.0f blue:120.0f/255.0f alpha:1];
    else
        _lbCurrentStockCount.textColor = [UIColor colorWithRed:225.0f/255.0f green:130.0f/255.0f blue:0.0f/255.0f alpha:1];
        
    _lbCurrentStockNA.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    
    _ivCurrentExpandTip.hidden = YES;
    _ivIOExpandTip.hidden = YES;
    _ivLastExpandTip.hidden = YES;
    
    switch (_typeExpand) {
        case RPDSReportExpandType_NONE:
            break;
        case RPDSReportExpandType_Current:
            _ivCurrentExpandTip.hidden = NO;
            _lbCurrentStockCount.textColor = [UIColor whiteColor];
            _lbCurrentStockNA.textColor = [UIColor whiteColor];
            if (_bOpenReport)
                _viewCurrentStockFrame.backgroundColor = [UIColor colorWithRed:55.0f/255.0f green:115.0f/255.0f blue:120.0f/255.0f alpha:1];
            else
                _viewCurrentStockFrame.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:130.0f/255.0f blue:1.0f/255.0f alpha:1];
            break;
        case RPDSReportExpandType_IO:
            _ivIOExpandTip.hidden = NO;
            _lbInOutNA.textColor = _lbInSymb.textColor = _lbInCount.textColor = _lbOutSymb.textColor = _lbOutCount.textColor = [UIColor whiteColor];
            _viewInFrame.backgroundColor = [UIColor colorWithRed:83.0f/255.0f green:152.0f/255.0f blue:201.0f/255.0f alpha:1];
            _viewOutFrame.backgroundColor = [UIColor colorWithRed:201.0f/255.0f green:69.0f/255.0f blue:54.0f/255.0f alpha:1];
            break;
        case RPDSReportExpandType_Last:
            _ivLastExpandTip.hidden = NO;
            _lbLastStockCount.textColor = [UIColor whiteColor];
            _lbLastStockNA.textColor = [UIColor whiteColor];
            _viewLastStockFrame.backgroundColor = [UIColor colorWithRed:127.0/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1];
            break;
    }
    
    [self UpdateTagBtnColor:_btnTag1];
    [self UpdateTagBtnColor:_btnTag2];
    [self UpdateTagBtnColor:_btnTag3];
    
    if (_bGatherMode) {
        _viewCurrentStockFrame.backgroundColor = _viewLastStockFrame.backgroundColor = _viewInFrame.backgroundColor = _viewOutFrame.backgroundColor = _viewTagFrame.backgroundColor = [UIColor colorWithRed:154.0f/255.0f green:174.0f/255.0f blue:107.0f/255.0f alpha:1];
        
        _lbCurrentStockCount.textColor = _lbCurrentStockNA.textColor = _lbInCount.textColor = _lbInOutNA.textColor = _lbInSymb.textColor = _lbLastStockCount.textColor = _lbLastStockNA.textColor = _lbOutCount.textColor = _lbOutSymb.textColor = [UIColor whiteColor];
    }
}

@end
