//
//  RPBVisitIssueTrackCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-8-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBVisitIssueTrackCell.h"

@implementation RPBVisitIssueTrackCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setIssueSearchRet:(BVisitIssueSearchRet *)issueSearchRet
{
    _issueSearchRet=issueSearchRet;
    _lbPath.text=[NSString stringWithFormat:@"%@/%@/%@",_issueSearchRet.strModelName,_issueSearchRet.strCatagoryName,_issueSearchRet.strItemName];
    _lbIssueTitle.text=_issueSearchRet.issue.strIssueTitle;
    _lbName.text=_issueSearchRet.strUserName;
    switch (_issueSearchRet.rank) {
        case Rank_Manager:
            _lbName.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbName.textColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _lbName.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _lbName.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }
    _lbDate.text=_issueSearchRet.strPostTime;
    _btSelect.selected=_issueSearchRet.bSelected;
    
    NSInteger n=0;
    for (int i=0; i<_issueSearchRet.arrayTask.count; i++)
    {
        TaskInfo *task=(TaskInfo*)[_issueSearchRet.arrayTask objectAtIndex:i];
        if (task.state==TASKSTATE_finished)
        {
            n++;
        }
    }
    if (_issueSearchRet.arrayTask.count==0)
    {
        _viewColor.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
    }
    else if(n==_issueSearchRet.arrayTask.count)
    {
        _viewColor.backgroundColor=[UIColor colorWithRed:150.0/255 green:170.0/255 blue:44.0/255 alpha:1];
    }
    else
    {
        _viewColor.backgroundColor=[UIColor colorWithRed:255.0/255 green:203.0/255 blue:51.0/255 alpha:1];
    }
    _lbCount.text=[NSString stringWithFormat:@"%i/%i",n,_issueSearchRet.arrayTask.count];
    
}
- (IBAction)OnSelete:(id)sender
{
    _issueSearchRet.bSelected=!_issueSearchRet.bSelected;
    [self.delegate endSelectIssue];
}
@end
