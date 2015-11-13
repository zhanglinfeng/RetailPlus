//
//  RPUnfinishedReportCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-8-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPUnfinishedReportCell.h"

@implementation RPUnfinishedReportCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDoc:(Document *)doc
{
    NSString * str = doc.strDocType;
    NSRange range = [str rangeOfString:@"BVISIT "];
    NSString * strResult = [str substringFromIndex:range.location + range.length];
    _lbReportName.text = strResult;
    switch (doc.rankAuthor) {
        case Rank_Manager:
            _lbAuthorName.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbAuthorName.textColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _lbAuthorName.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _lbAuthorName.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }
    _lbDate.text=doc.strCreateTime;
    _lbAddress.text=doc.strUnfinishDesc;
}

-(void)setBVisitModel:(BVisitListModel *)bVisitModel
{
    _bVisitModel=bVisitModel;
    _lbAuthorName.text=_bVisitModel.strUserName;
    switch (_bVisitModel.rank) {
        case Rank_Manager:
            _lbAuthorName.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbAuthorName.textColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _lbAuthorName.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _lbAuthorName.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }
    _lbAddress.text=bVisitModel.strStoreName;
    _lbDate.text=bVisitModel.strDate;
    _lbReportName.text=bVisitModel.strReportTitle;
}
@end
