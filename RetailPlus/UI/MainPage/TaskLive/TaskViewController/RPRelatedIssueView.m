//
//  RPRelatedIssueView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-9-21.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPRelatedIssueView.h"
#import "UIButton+WebCache.h"
@implementation RPRelatedIssueView

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
    _viewDesc.layer.cornerRadius=5;
    _viewDesc.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _viewDesc.layer.borderWidth=1;
    _viewTitle.layer.cornerRadius=5;
    _viewTitle.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _viewTitle.layer.borderWidth=1;
    _btPic1.layer.cornerRadius=6;
    _btPic1.layer.borderWidth=1;
    _btPic1.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btPic2.layer.cornerRadius=6;
    _btPic2.layer.borderWidth=1;
    _btPic2.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btPic3.layer.cornerRadius=6;
    _btPic3.layer.borderWidth=1;
    _btPic3.layer.borderColor=[UIColor lightGrayColor].CGColor;
}
-(void)setIssueId:(NSString *)issueId
{
    [[RPSDK defaultInstance]GetBVisitIssueById:issueId Success:^(InspIssue* idResult) {
        _issue=idResult;
        [self setIssue:_issue];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}



-(void)setIssue:(InspIssue *)issue
{
    _issue=issue;
    _tfTitle.text=issue.strIssueTitle;
    _tvDesc.text=issue.strIssueDesc;
    NSInteger nBtnIndex = 0;
    for (InspIssueImage * image in _issue.arrayIssueImg) {
        if (image.strUrl) {
            switch (nBtnIndex) {
                case 0:
                    [_btPic1 setImageWithURLString:image.strUrl forState:UIControlStateNormal];
                    break;
                case 1:
                    [_btPic2 setImageWithURLString:image.strUrl forState:UIControlStateNormal];
                    break;
                case 2:
                    [_btPic3 setImageWithURLString:image.strUrl forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
        else
        {
            switch (nBtnIndex) {
                case 0:
                    [_btPic1 setImage:[UIImage imageNamed:@"icon_addpicture01@2x.png"] forState:UIControlStateNormal];
                    break;
                case 1:
                    [_btPic2 setImage:[UIImage imageNamed:@"icon_addpicture01@2x.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [_btPic3 setImage:[UIImage imageNamed:@"icon_addpicture01@2x.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
        nBtnIndex ++;
    }
}
@end
