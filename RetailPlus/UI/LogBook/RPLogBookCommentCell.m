//
//  RPLogBookCommentCell.m
//  RetailPlus
//
//  Created by lin dong on 14-3-5.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPLogBookCommentCell.h"
extern NSBundle * g_bundleResorce;
@implementation RPLogBookCommentCell

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
-(void)setComment:(LogBookDetail *)comment
{
    _comment=comment;
    switch (comment.userPost.rank) {
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
    _lbName.text=[NSString stringWithFormat:@"%@",comment.userPost.strFirstName] ;
    if (comment.strDesc && comment.strDesc.length > 0) {
        _lbComment.text=comment.strDesc;
    }
    else
    {
        _lbComment.text=NSLocalizedStringFromTableInBundle(@"Have read",@"RPString", g_bundleResorce,nil);
    }
    
    _lbTime.text=[self getDate:comment.dtPostTime];
    
    _lbComment.adjustsFontSizeToFitWidth = YES;
}
@end
