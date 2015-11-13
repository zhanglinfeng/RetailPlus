//
//  RPBVisitIssueTrackView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-8-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBVisitIssueTrackView.h"
#import "UIButton+WebCache.h"
@implementation RPBVisitIssueTrackView

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
    _viewFrame.layer.cornerRadius=10;
    _viewIssueDetail.frame=CGRectMake(0, 0, _svFrame.frame.size.width,  _svFrame.frame.size.height);
    _viewRelatedTask.frame=CGRectMake(_svFrame.frame.size.width, 0, _svFrame.frame.size.width,  _svFrame.frame.size.height);
    [_svFrame setContentSize:CGSizeMake(_svFrame.frame.size.width*2, _svFrame.frame.size.height)];
    [_svFrame addSubview:_viewIssueDetail];
    [_svFrame addSubview:_viewRelatedTask];
    //不显示水平滑动条
    _svFrame.showsVerticalScrollIndicator=NO;
    //不显示垂直滑动条
    _svFrame.showsHorizontalScrollIndicator=NO;
    //不允许反弹
    _svFrame.bounces = NO;
    
}
-(void)setIssue:(InspIssue *)issue
{
    _issue=issue;
    _viewIssueDetail.issue=_issue;
    
}
-(void)setArrayTask:(NSMutableArray *)arrayTask
{
    _arrayTask=arrayTask;
    NSInteger n=0;
    for (TaskInfo *task in _arrayTask)
    {
        if (task.state==TASKSTATE_finished)
        {
            n++;
        }
        
        
    }
    _lbCount.text=[NSString stringWithFormat:@"%i/%i",n,_arrayTask.count];
    _viewRelatedTask.arrayTask=_arrayTask;
}
- (IBAction)OnIssueDetail:(id)sender {
    _viewLeft.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _lbLeft.textColor=[UIColor colorWithWhite:0.3 alpha:1];
    _viewRight.backgroundColor=[UIColor colorWithWhite:0.3 alpha:1];
    _lbRight.textColor=[UIColor colorWithWhite:0.5 alpha:1];
   [_svFrame setContentOffset:CGPointMake(0,0) animated:NO];
}

- (IBAction)OnTask:(id)sender {
    _viewRight.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _lbRight.textColor=[UIColor colorWithWhite:0.3 alpha:1];
    _viewLeft.backgroundColor=[UIColor colorWithWhite:0.3 alpha:1];
    _lbLeft.textColor=[UIColor colorWithWhite:0.5 alpha:1];
    [_svFrame setContentOffset:CGPointMake(_svFrame.frame.size.width,0) animated:NO];
}
@end
