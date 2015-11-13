//
//  RPLogBookSearchCell.m
//  RetailPlus
//
//  Created by lin dong on 14-3-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPLogBookSearchCell.h"
#import "MarkupParser.h"
extern NSBundle * g_bundleResorce;
@implementation RPLogBookSearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSString *)getDate:(NSDate *)date
{
    NSString *s;
    NSDate *nowTime =[NSDate date];
    NSCalendar*calendar=[NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDateComponents*components1 =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:nowTime];
    
    NSDateComponents*components2 =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:date];
    if ([components1 year]==[components2 year]&&[components1 month]==[components2 month]&&[components1 day]==[components2 day])
    {
        NSString *str=NSLocalizedStringFromTableInBundle(@"Today",@"RPString", g_bundleResorce,nil);
        s=[NSString stringWithFormat:@"%@ %02d:%02d",str,[components2 hour],[components2 minute]];
    }
    else
    {
        s=[dateFormatter stringFromDate:date];
    }
    return s;
}
-(void)setSearchDetail:(LogBookDetail *)searchDetail
{
    _searchDetail=searchDetail;
//    NSString *text=[NSString stringWithFormat:@"Posted by <font color=\"orange\">%@ %@",searchDetail.userPost.strFirstName,searchDetail.userPost.strSurName];
//    MarkupParser *p = [[MarkupParser alloc]init];
//    NSAttributedString *attString = [p attrStringFromMarkup:text];
//    [self.lbName setAttString:attString];
    switch (searchDetail.userPost.rank) {
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
    _lbStoreName.text = [NSString stringWithFormat:@"%@ %@",searchDetail.store.strBrandName,searchDetail.store.strStoreName];
    _lbName.text=[NSString stringWithFormat:@"%@",searchDetail.userPost.strFirstName];
    CGSize lbNameSize = [_lbName.text sizeWithFont:_lbName.font constrainedToSize:CGSizeMake( MAXFLOAT,_lbName.frame.size.height)];
    _lbName.frame = CGRectMake(320-lbNameSize.width-8, 53, lbNameSize.width + 4, 14);
    _lbPost.frame = CGRectMake(320-63-lbNameSize.width-8, 53, 63, 14);
    
    _lbTitle.text=searchDetail.strTitle;
    _lbDesc.text=searchDetail.strDesc;
    _lbTime.text=[self getDate:searchDetail.dtPostTime];
    if (_searchDetail.strTagDesc.length==0) {
        _lbTagDesc.text = [NSString stringWithFormat:@"[%@]",NSLocalizedStringFromTableInBundle(@"Other",@"RPString", g_bundleResorce,nil)];
    }else{
        _lbTagDesc.text = [NSString stringWithFormat:@"[%@]",searchDetail.strTagDesc];
    }
    
}
@end
