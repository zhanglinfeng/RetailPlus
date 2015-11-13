//
//  RPItemFinishedView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-29.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPItemFinishedView.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
#import "RPBlockUIAlertView.h"
@implementation RPItemFinishedView

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
}
-(void)setPaper:(RPELPaper *)paper
{
    _paper=paper;
    _viewSub.backgroundColor=[UIColor colorWithRed:135.0/255 green:150.0/255 blue:85.0/255 alpha:1];
//    for (RPELQuestion *question in _paper.arrayQuestions)
//    {
//        if (question.arrayAnswers.count<1)
//        {
//            _viewSub.backgroundColor=[UIColor colorWithRed:202.0/255 green:82.0/255 blue:43.0/255 alpha:1];
//            break;
//        }
//    }
    
    NSInteger x=0;
    NSInteger y=0;
    _lbAll.text=[NSString stringWithFormat:@"/%i",_paper.arrayQuestions.count];
    NSInteger n=0;
    _lbFinished.text=[NSString stringWithFormat:@"%i",n];
    for (int i=0; i<_paper.arrayQuestions.count; i++)
    {
        _viewButtonContent.contentSize=CGSizeMake(_viewButtonContent.frame.size.width, y+70);
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(x, y, 70, 50);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.contentEdgeInsets = UIEdgeInsetsMake(0,0, 5, 0);
        button.titleLabel.font=[UIFont systemFontOfSize:20.0];
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.layer.cornerRadius=2;
        [button setTitle:[NSString stringWithFormat:@"%i",i+1] forState:UIControlStateNormal];
        button.tag=i;
        [button addTarget:self action:@selector(OnSelTask:) forControlEvents:UIControlEventTouchUpInside];
        if (((RPELQuestion *)[_paper.arrayQuestions objectAtIndex:i]).arrayAnswers.count>0)
        {
            button.backgroundColor=[UIColor colorWithRed:135.0/255 green:150.0/255 blue:85.0/255 alpha:1];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            n++;
            _lbFinished.text=[NSString stringWithFormat:@"%i",n];
            if (n==_paper.arrayQuestions.count) {
                _lbFinished.textColor=[UIColor colorWithRed:135.0/255 green:150.0/255 blue:85.0/255 alpha:1];
            }
            else
            {
                _lbFinished.textColor=[UIColor colorWithRed:202.0/255 green:82.0/255 blue:43.0/255 alpha:1];
            }
        }
        else
        {
            button.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
            [button setTitleColor:[UIColor colorWithRed:202.0/255 green:82.0/255 blue:43.0/255 alpha:1] forState:UIControlStateNormal];
            _viewSub.backgroundColor=[UIColor colorWithRed:202.0/255 green:82.0/255 blue:43.0/255 alpha:1];
        }
        [_viewButtonContent addSubview:button];
        
        x=x+74;
        if (x>_viewButtonContent.frame.size.width-70)
        {
            x=0;
            y=y+56;
        }
    }
 }


-(void)OnSelTask:(UIButton *)button
{
    [self.delegate selectQuestion:button.tag];
}
- (IBAction)OnSubmit:(id)sender
{
    if ([_lbFinished.text isEqualToString:@"0"])
    {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTableInBundle(@"The examination paper answer cannot be empty",@"RPString", g_bundleResorce,nil)];
        return;
    }
    
    [[RPSDK defaultInstance]UploadExam:_paper Success:^(id idResult) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil)];
        [self.delegate addSubmitPaper:_paper];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
         [[RPSDK defaultInstance]UploadExamTemp:_paper];
        [self.delegate addSubmitPaper:_paper];
    }];
    
}

@end
