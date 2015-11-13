//
//  RPInspReporterHeaderView.m
//  RetailPlus
//
//  Created by lin dong on 13-9-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPInspReporterHeaderView.h"

@implementation RPInspReporterHeaderView
extern NSBundle * g_bundleResorce;
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

-(void)setBExpand:(BOOL)bExpand
{
    _bExpand = bExpand;
    if (_bExpand) {
        _viewgap.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        _viewgap.frame = CGRectMake(_viewgap.frame.origin.x, self.frame.size.height - 1, _viewgap.frame.size.width, 1);
        
        _ivArrow.hidden = NO;
    }
    else
    {
        _viewgap.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        _viewgap.frame = CGRectMake(_viewgap.frame.origin.x, self.frame.size.height - 2, _viewgap.frame.size.width, 2);
        
        _ivArrow.hidden = YES;
    }
}
-(void)setSection:(InspReporterSection *)section
{
    _section = section;
    _lbTitle1.text = section.strTitle1;
    _lbTitle2.text = section.strTitle2;
    
    NSInteger nCount = 0;
    for (InspReporterUser * user in section.arrayUser) {
        if (user.bSelected) {
            nCount ++;
        }
    }
    _lbCount.text = [NSString stringWithFormat:@"%d",nCount];
}
-(void)setNState:(NSInteger)nState
{
    if (nState==0)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"(Unfinished)",@"RPString", g_bundleResorce,nil);
        _lbTitle1.text=[NSString stringWithFormat:@"%@%@",_section.strTitle1,s];
    }
    else
    {
        _lbTitle1.text = _section.strTitle1;
    }
}

@end
