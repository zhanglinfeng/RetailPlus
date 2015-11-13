//
//  RPBVisitHeaderView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPBVisitHeaderView.h"

@implementation RPBVisitHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setExpand:(BOOL)bExpand
{
    _bExpand = bExpand;
    if (bExpand) {
        //     _viewGap.backgroundColor = [UIColor colorWithRed:55.0f/255 green:115.0f/255 blue:120.0f/255 alpha:1];
        _imgExpand.hidden = NO;
    }
    else
    {
        //     _viewGap.backgroundColor = [UIColor colorWithRed:127.0f/255 green:127.0f/255 blue:127.0f/255 alpha:1];
        _imgExpand.hidden = YES;
    }
    
    
}

-(void)awakeFromNib
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
    [self addGestureRecognizer:tap];
}

- (void)taped:(id)sender
{
    if (!_visitItem.bMark&&_visitItem.mark==BVisitMark_EMPTY)//判断是否第一次展开，如果没有标记过就是
    {
        _visitItem.mark=BVisitMark_YES;
        _visitItem.bMark=YES;
    }
    if ([self.delegate respondsToSelector:@selector(sectionTapped:)]) {
        if (_bExpand)
            [self.delegate sectionTapped:-1];
        else
            [self.delegate sectionTapped:self.nIndex];
    }
    
}

-(void)setVisitItem:(BVisitItem *)visitItem
{
    _visitItem = visitItem;
    
    _lbCatName.text = visitItem.strItemTitle;
    
    _lbIssueCount.text = [NSString stringWithFormat:@"%d",_visitItem.arrayIssue.count];
    if (_visitItem.arrayIssue == nil || _visitItem.arrayIssue.count == 0)
        _lbIssueCount.hidden = YES;
    else
        _lbIssueCount.hidden = NO;
    
    switch (_visitItem.mark) {
        case BVisitMark_EMPTY:
        {
            _imgMarked.hidden=YES;
        }
            break;
        case BVisitMark_NONE:
        {
            _imgMarked.hidden=NO;
            _imgMarked.image=[UIImage imageNamed:@"icon_status_na@2x.png"];
        }
            break;
        case BVisitMark_NO:
        {
            _imgMarked.hidden=NO;
            _imgMarked.image=[UIImage imageNamed:@"icon_status_nocheck@2x.png"];
        }
            break;
        case BVisitMark_YES:
        {
            _imgMarked.hidden=NO;
            _imgMarked.image=[UIImage imageNamed:@"icon_status_check@2x.png"];
        }
            break;
        default:
            break;
    }
    
}
@end
