//
//  RPBVisitIssueTrackHeadView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-8-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBVisitIssueTrackHeadView.h"
#import "UIImageView+WebCache.h"
@implementation RPBVisitIssueTrackHeadView

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
    _ivStore.layer.cornerRadius=6;
    _ivStore.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _ivStore.layer.borderWidth=1;
}
-(void)setIssueSearchRetCatagory:(BVisitSearchRetCatagory *)issueSearchRetCatagory
{
    _issueSearchRetCatagory=issueSearchRetCatagory;
    _lbCount.text=[NSString stringWithFormat:@"%i",_issueSearchRetCatagory.arrayIssueSearchRet.count];
    if (_issueSearchRetCatagory.bExpend)
    {
        _ivTriangle.hidden=NO;
    }
    else
    {
        _ivTriangle.hidden=YES;
    }
    NSInteger n=0;
    for (BVisitIssueSearchRet *issueSearchRet in _issueSearchRetCatagory.arrayIssueSearchRet)
    {
        if (issueSearchRet.bSelected)
        {
            n++;
        }
    }
    if (n==0)
    {
        _issueSearchRetCatagory.bSelected=NO;
        [_btSelect setBackgroundImage:[UIImage imageNamed:@"button_chooseb1@2x.png"] forState:UIControlStateNormal];
    }
    else if(n<_issueSearchRetCatagory.arrayIssueSearchRet.count)
    {
        _issueSearchRetCatagory.bSelected=NO;
        [_btSelect setBackgroundImage:[UIImage imageNamed:@"button_chooseb3@2x.png"] forState:UIControlStateNormal];
    }
    else if(n==_issueSearchRetCatagory.arrayIssueSearchRet.count)
    {
        _issueSearchRetCatagory.bSelected=YES;
        [_btSelect setBackgroundImage:[UIImage imageNamed:@"button_chooseb2@2x.png"] forState:UIControlStateNormal];
    }
    [_ivStore setImageWithURLString:issueSearchRetCatagory.storeInfo.strStoreThumb placeholderImage:[UIImage imageNamed:@"icon_default_store_pic@2x.png"]];
    
    _lbAddress.text = issueSearchRetCatagory.storeInfo.strStoreAddress;
    if (issueSearchRetCatagory.storeInfo.strCity.length > 0) {
        _lbAddress.text = [NSString stringWithFormat:@"%@ %@",issueSearchRetCatagory.storeInfo.strCity,issueSearchRetCatagory.storeInfo.strStoreAddress];
    }
    _lbStoreName.text = [NSString stringWithFormat:@"%@ %@",issueSearchRetCatagory.storeInfo.strBrandName,issueSearchRetCatagory.storeInfo.strStoreName];
    [_ivStore setImageWithURLString:issueSearchRetCatagory.storeInfo.strStoreThumb placeholderImage:[UIImage imageNamed:@"icon_default_store_pic@2x.png"]];
}

- (IBAction)OnSelect:(id)sender
{
    _issueSearchRetCatagory.bSelected=!_issueSearchRetCatagory.bSelected;
    for (BVisitIssueSearchRet *issueSearchRet in _issueSearchRetCatagory.arrayIssueSearchRet)
    {
        issueSearchRet.bSelected=_issueSearchRetCatagory.bSelected;
    }
    [self.delegate endSelectCatagory];//刷新tableview
}

- (IBAction)OnExpend:(id)sender
{
    _issueSearchRetCatagory.bExpend=!_issueSearchRetCatagory.bExpend;
    [self.delegate endSelectCatagory];//刷新tableview
}
@end
