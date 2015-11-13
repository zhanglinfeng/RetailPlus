//
//  RPCallRecordCell.m
//  RetailPlus
//
//  Created by lin dong on 14-3-14.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCallRecordCell.h"

@implementation RPCallRecordCell
extern NSBundle * g_bundleResorce;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setArrayType:(NSArray *)arrayType
{
    _arrayType=arrayType;
}
-(void)setInfo:(CourtesyCallInfo *)info
{
    _info=info;
    _lbCustomerName.text=[NSString stringWithFormat:@"%@",info.customer.strFirstName];
    
    switch (info.userCaller.rank) {
        case Rank_Manager:
            _lbUserName.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
             _lbUserName.textColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
             _lbUserName.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
             _lbUserName.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
             _lbUserName.textColor = [UIColor colorWithWhite:0.7 alpha:1];
            break;
    }
    
    for (int i=0; i<_arrayType.count; i++)
    {
        if ([info.strCourtesyCallTypeId isEqualToString:[[_arrayType objectAtIndex:i]strCourtesyCallTypeId]])
        {
            _lbCallPurpose.text=[[_arrayType objectAtIndex:i]strCourtesyCallTips];
            break;
        }
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    _lbDate.text=[dateFormatter stringFromDate:info.dateCC];
    _ivVip.hidden=!info.customer.isVip;
    _lbUserName.text=[NSString stringWithFormat:@"%@",info.userCaller.strFirstName];
    if (info.datePlan)
    {
        _ivPlan.hidden=NO;
    }
    else
    {
        _ivPlan.hidden=YES;
    }
    
    if (info.nDuration == 0)
        _lbDuration.text = @"--'--\"";
    else
        _lbDuration.text = [NSString stringWithFormat:@"%02d'%02d\"",info.nDuration / 60,info.nDuration % 60];
    
    if (info.typeThrough == CourtesyCallThroughType_PSTN) {
        _ivVoipCall.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"icon_no_rp_call@2x" ofType:@"png"]];
    }
    else
    {
        _ivVoipCall.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"icon_rp_call@2x" ofType:@"png"]];
    }
    
    if (info.bSuccess) {
        _ivCallSuccess.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"icon_complete_call@2x" ofType:@"png"]];
    }
    else
    {
        _ivCallSuccess.image = [UIImage imageWithContentsOfFile:[g_bundleResorce pathForResource:@"icon_failed_call@2x" ofType:@"png"]];
    }
}
@end
