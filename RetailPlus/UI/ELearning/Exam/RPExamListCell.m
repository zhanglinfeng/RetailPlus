//
//  RPExamListCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPExamListCell.h"
extern NSBundle * g_bundleResorce;
@implementation RPExamListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setPaper:(RPELPaper *)paper
{
    _lbNumber.text=paper.strNo;
    if (paper.nScore<0)
    {
        _lbLastScore.alpha=0.3;
        _lbLastScore.text=NSLocalizedStringFromTableInBundle(@"NO SCORE",@"RPString", g_bundleResorce,nil);
        _lbScore.text=@"";
        _lbScore.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
    }
    else
    {
        _lbLastScore.alpha=1;
        _lbLastScore.text=NSLocalizedStringFromTableInBundle(@"LATEST SCORE",@"RPString", g_bundleResorce,nil);
        int temp=(int)paper.nScore;
        if ((paper.nScore-temp)==0)
        {
            _lbScore.text=[NSString stringWithFormat:@"%i",temp];
        }
        else
        {
            _lbScore.text=[NSString stringWithFormat:@"%0.1f",paper.nScore];
        }
        
    }
    
    _lbTitle.text=paper.strTitle;
}
@end
