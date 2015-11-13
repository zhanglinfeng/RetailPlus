//
//  RPTrafficRecordCell.m
//  RetailPlus
//
//  Created by zwhe on 14-1-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTrafficRecordCell.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@implementation RPTrafficRecordCell

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
-(void)setTrafficData:(KPITrafficData *)trafficData
{
    _trafficData=trafficData;
    if (trafficData.nTraffic >= 0)
        _tfTraffic.text=[RPSDK numberFormatter:[NSNumber numberWithInteger:trafficData.nTraffic]];
    else
        _tfTraffic.text= @"";
    _lbDate.text= [NSString stringWithFormat:@"%02d:00",trafficData.nHour];

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%04d-%02d-%02d",_trafficData.nYear,_trafficData.nMonth,_trafficData.nDay]];
    NSTimeInterval nowDate=[[NSDate date] timeIntervalSince1970]*1;
    NSTimeInterval currentDate=[date timeIntervalSince1970]*1;
    if (nowDate>currentDate+86400*30)
    {
        return NO;
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_delegate OnValueBeginChange:self];
}
-(NSString*)deleteString:(NSString*)s
{
    //创建可变字符串
    NSMutableString *mstrAmount =[NSMutableString stringWithString:s];
    NSString *str=[mstrAmount stringByReplacingOccurrencesOfString:@","withString:@""];
    return str;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _tfTraffic.text=[self deleteString:_tfTraffic.text];
    
    if (_tfTraffic.text.length>9)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"No more than 9 digits",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        [_delegate OnValueChange];
        return;
    }
    if (_tfTraffic.text.length>0) {
        _trafficData.nTraffic=_tfTraffic.text.integerValue;
    }
    else
    {
        _trafficData.nTraffic=0;
    }
    _trafficData.mode=KPIMode_Hour;
    [_delegate OnValueChange];
}
@end
