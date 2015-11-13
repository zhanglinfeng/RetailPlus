//
//  RPConfBookCell.m
//  RetailPlus
//
//  Created by lin dong on 14-6-19.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPConfBookCell.h"
#import "RPYuanTelApi.h"

extern NSBundle * g_bundleResorce;

@implementation RPConfBookCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBook:(RPConfBook *)book
{
    _book = book;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"MM/dd ccc."];
    NSString * strDate = [formatter stringFromDate:book.dateBooking];
    if ( [strDate isEqualToString:[formatter stringFromDate:[NSDate date]]])
        _lbDate.text = NSLocalizedStringFromTableInBundle(@"Today",@"RPString", g_bundleResorce,nil);
    else
        _lbDate.text = strDate;
    
    [formatter setDateFormat:@"HH:mm"];
    _lbTime.text = [formatter stringFromDate:book.dateBooking];
    
    _lbTheme.text = book.strCallTheme;
    
    _lbMemberCount.text = [NSString stringWithFormat:@"%d",book.nMemberCount];
    
    _lbHostPhone.text = book.strHostPhone;
    
    if (book.strHostPhone == nil && book.arrayMember == nil) {
        [[RPYuanTelApi defaultInstance] GetBookingConferenceDetail:book Success:^(id idResult) {
            _lbHostPhone.text = book.strHostPhone;
        } failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
}
@end
