//
//  RPSalesRecordCell.m
//  RetailPlus
//
//  Created by zwhe on 14-1-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPSalesRecordCell.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@implementation RPSalesRecordCell

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

-(void)awakeFromNib
{

}

-(void)setSalesData:(KPISalesData *)salesData
{
    _salesData=salesData;
    if (salesData.nAmount >= 0)
        _tfSalesAmount.text=[RPSDK numberFormatter:[NSNumber numberWithInteger:salesData.nAmount]];
    else
        _tfSalesAmount.text= @"";
    
    if (salesData.nProQty >= 0)
        _tfSalesQty.text=[RPSDK numberFormatter:[NSNumber numberWithInteger:salesData.nProQty]];
    else
        _tfSalesQty.text= @"";
    
    if (salesData.nTraQty >= 0)
        _tfTxnQty.text=[RPSDK numberFormatter:[NSNumber numberWithInteger:salesData.nTraQty]];
    else
        _tfTxnQty.text=@"";
    
    _lbDate.text= [NSString stringWithFormat:@"%02d:00",salesData.nHour];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%04d-%02d-%02d",_salesData.nYear,_salesData.nMonth,_salesData.nDay]];
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
    _tfSalesAmount.text=[self deleteString:_tfSalesAmount.text];
    _tfSalesQty.text=[self deleteString:_tfSalesQty.text];
    _tfTxnQty.text=[self deleteString:_tfTxnQty.text];
    if (_tfSalesAmount.text.length>9||_tfSalesQty.text.length>9||_tfTxnQty.text.length>9)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"No more than 9 digits",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        [_delegate OnValueChange];
        return;
    }
    if (_tfSalesAmount.text.length > 0)
    {
        _salesData.nAmount=_tfSalesAmount.text.integerValue;
    }
    else
        _salesData.nAmount=0;
    
    if (_tfSalesQty.text.length > 0)
    {

        _salesData.nProQty=_tfSalesQty.text.integerValue;
    }
    else
        _salesData.nProQty =0;
    
    if (_tfTxnQty.text.length > 0)
    {

        _salesData.nTraQty=_tfTxnQty.text.integerValue;
    }
    else
        _salesData.nTraQty=0;
    
    _salesData.mode=KPIMode_Hour;
    [_delegate OnValueChange];
}
@end
