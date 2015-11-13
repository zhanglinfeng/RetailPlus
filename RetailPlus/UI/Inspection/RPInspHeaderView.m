//
//  RPInspHeaderView.m
//  RetailPlus
//
//  Created by lin dong on 13-8-19.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPInspHeaderView.h"

@implementation RPInspHeaderView

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
    if ([self.delegate respondsToSelector:@selector(sectionTapped:)]) {
        if (_bExpand)
            [self.delegate sectionTapped:-1];
        else
            [self.delegate sectionTapped:self.nIndex];
    }
}

-(void)setCategory:(InspCatagory *)category
{
    _category = category;
    
    _lbCatName.text = category.strCatagoryName;
    
    
    _lbIssueCount.text = [NSString stringWithFormat:@"%d",_category.arrayIssue.count];
    if (_category.arrayIssue == nil || _category.arrayIssue.count == 0)
        _lbIssueCount.hidden = YES;
    else
        _lbIssueCount.hidden = NO;
    
    if (category.markCatagory != MARK_NONE)
        _imgMarked.hidden = NO;
    else
        _imgMarked.hidden = YES;
    
    _imgMark1.image = [UIImage imageNamed:@"Icon_star_smallgray@2x.png"];
    _imgMark2.image = [UIImage imageNamed:@"Icon_star_smallgray@2x.png"];
    _imgMark3.image = [UIImage imageNamed:@"Icon_star_smallgray@2x.png"];
    _imgMark4.image = [UIImage imageNamed:@"Icon_star_smallgray@2x.png"];
    _imgMark5.image = [UIImage imageNamed:@"Icon_star_smallgray@2x.png"];
    
    switch (_category.markCatagory) {
        case MARK_1:
            _imgMark1.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            break;
        case MARK_2:
            _imgMark1.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark2.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            break;
        case MARK_3:
            _imgMark1.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark2.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark3.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            break;
        case MARK_4:
            _imgMark1.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark2.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark3.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark4.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            break;
        case MARK_5:
            _imgMark1.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark2.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark3.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark4.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            _imgMark5.image = [UIImage imageNamed:@"Icon_star_small@2x.png"];
            break;
        default:
            break;
    }
    
}
@end
