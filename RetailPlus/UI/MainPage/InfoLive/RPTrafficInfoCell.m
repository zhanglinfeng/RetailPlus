//
//  RPTrafficInfoCell.m
//  RetailPlus
//
//  Created by zwhe on 14-1-23.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTrafficInfoCell.h"
#import "BlockUIAlertView.h"
extern NSBundle * g_bundleResorce;
@implementation RPTrafficInfoCell

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
-(void)setString1:(NSString *)string1
{
    _string1=string1;
}
-(void)setString2:(NSString *)string2
{
    _string2=string2;
}
-(void)setMaxAmount:(long long)maxAmount
{
    _maxAmount=maxAmount;
}
-(void)setMaxConversion:(long long)maxConversion
{
    _maxConversion=maxConversion;
}
-(void)setMaxProQty:(long long)maxProQty
{
    _maxProQty=maxProQty;
}
-(void)setMaxTraffic:(long long)maxTraffic
{
    _maxTraffic=maxTraffic;
}
-(void)setMaxTraQty:(long long)maxTraQty
{
    _maxTraQty=maxTraQty;
}
-(void)setKpiDomainData:(KPIDomainData *)kpiDomainData
{
    NSString *Traffic=NSLocalizedStringFromTableInBundle(@"Traffic",@"RPString", g_bundleResorce,nil);
    NSString *Conversion=NSLocalizedStringFromTableInBundle(@"Conversion Rate",@"RPString", g_bundleResorce,nil);
    NSString * TraQty= NSLocalizedStringFromTableInBundle(@"TraQty",@"RPString", g_bundleResorce,nil);
    NSString *ProQty=NSLocalizedStringFromTableInBundle(@"ProQty",@"RPString", g_bundleResorce,nil);
    NSString *Amount=NSLocalizedStringFromTableInBundle(@"Amount",@"RPString", g_bundleResorce,nil);
    _kpiDomainData=kpiDomainData;
    _lb1.text=kpiDomainData.strDomainName;
    if (kpiDomainData.bHasChild)
        _ivHasChild.hidden = NO;
    else
        _ivHasChild.hidden = YES;
    
//    _lb1.text=@"哈哈哈哈嘿嘿嘿";
    if ([_string1 isEqualToString:Traffic])
    {
        double f;
        if (_maxTraffic==0)
        {
            f=0;
        }
        else
        {
            f=(double)kpiDomainData.nTraffic/(float)_maxTraffic;
        }
        _lb2.text=[RPSDK numberFormatter:[NSNumber numberWithLongLong:kpiDomainData.nTraffic ]];
        _view1.frame=CGRectMake(_view1.frame.origin.x, _view1.frame.origin.y, _view1.frame.size.width*f, 4);
        
    }
    else if([_string1 isEqualToString:Conversion])
    {
        float f;
        if (_maxConversion==0)
        {
            f=0;
        }
        else
        {
            f=kpiDomainData.nConvPercent/(float)_maxConversion;
        }
        _lb2.text=[NSString stringWithFormat:@"%d%@",kpiDomainData.nConvPercent,@"%" ];
        _view1.frame=CGRectMake(_view1.frame.origin.x, _view1.frame.origin.y, _view1.frame.size.width*f, 4);
    }
    else if([_string1 isEqualToString:TraQty])
    {
        float f;
        if (_maxTraQty==0)
        {
            f=0;
        }
        else
        {
            f=(double)kpiDomainData.nTraQty/(double)_maxTraQty;
        }
        _lb2.text=[RPSDK numberFormatter:[NSNumber numberWithLongLong:kpiDomainData.nTraQty]];
        _view1.frame=CGRectMake(_view1.frame.origin.x, _view1.frame.origin.y, _view1.frame.size.width*f, 4);
    }
    else if([_string1 isEqualToString:ProQty])
    {
        float f;
        if (_maxProQty==0)
        {
            f=0;
        }
        else
        {
            f=kpiDomainData.nProQty/(double)_maxProQty;
        }
        _lb2.text=[RPSDK numberFormatter:[NSNumber numberWithLongLong:kpiDomainData.nProQty]];
        _view1.frame=CGRectMake(_view1.frame.origin.x, _view1.frame.origin.y, _view1.frame.size.width*f, 4);
    }
    else if([_string1 isEqualToString:Amount])
    {
        float f;
        if (_maxAmount==0)
        {
            f=0;
        }
        else
        {
            f=kpiDomainData.nAmount/(double)_maxAmount;
        }
        _lb2.text=[RPSDK numberFormatter:[NSNumber numberWithLongLong:kpiDomainData.nAmount]];
        _view1.frame=CGRectMake(_view1.frame.origin.x, _view1.frame.origin.y, _view1.frame.size.width*f, 4);
    }
    
    
    if ([_string2 isEqualToString:Traffic])
    {
        float f;
        if (_maxTraffic==0)
        {
            f=0;
        }
        else
        {
            f=kpiDomainData.nTraffic/(double)_maxTraffic;
        }
        _lb3.text=[RPSDK numberFormatter:[NSNumber numberWithLongLong:kpiDomainData.nTraffic]];
        _view2.frame=CGRectMake(_view2.frame.origin.x, _view2.frame.origin.y, _view2.frame.size.width*f, 4);
    }
    else if([_string2 isEqualToString:Conversion])
    {
        float f;
        if (_maxConversion==0)
        {
            f=0;
        }
        else
        {
            f=kpiDomainData.nConvPercent/(double)_maxConversion;
        }

        _lb3.text=[NSString stringWithFormat:@"%d%@",kpiDomainData.nConvPercent,@"%" ];
        _view2.frame=CGRectMake(_view2.frame.origin.x, _view2.frame.origin.y, _view2.frame.size.width*f, 4);
       
        
    }
    else if([_string2 isEqualToString:TraQty])
    {
        float f;
        if (_maxTraQty==0)
        {
            f=0;
        }
        else
        {
            f=kpiDomainData.nTraQty/(double)_maxTraQty;
        }

        _lb3.text=[RPSDK numberFormatter:[NSNumber numberWithLongLong:kpiDomainData.nTraQty]];
        _view2.frame=CGRectMake(_view2.frame.origin.x, _view2.frame.origin.y, _view2.frame.size.width*f, 4);
    }
    else if([_string2 isEqualToString:ProQty])
    {
        float f;
        if (_maxProQty==0)
        {
            f=0;
        }
        else
        {
            f=kpiDomainData.nProQty/(double)_maxProQty;
        }

        _lb3.text=[RPSDK numberFormatter:[NSNumber numberWithLongLong:kpiDomainData.nProQty ]];
        _view2.frame=CGRectMake(_view2.frame.origin.x, _view2.frame.origin.y, _view2.frame.size.width*f, 4);
    }
    else if([_string2 isEqualToString:Amount])
    {
        float f;
        if (_maxAmount==0)
        {
            f=0;
        }
        else
        {
            f=kpiDomainData.nAmount/(double)_maxAmount;
        }
        _lb3.text=[RPSDK numberFormatter:[NSNumber numberWithLongLong:kpiDomainData.nAmount] ];
        _view2.frame=CGRectMake(_view2.frame.origin.x, _view2.frame.origin.y, _view2.frame.size.width*f, 4);
    }

        
    
}

-(void)setBSelected:(BOOL)bSelected
{
    if (bSelected) {
        _view1.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
        _view2.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
        self.contentView.backgroundColor=[UIColor colorWithRed:55.0f/255 green:115.0f/255 blue:120.0f/255 alpha:1];
        _ivHasChild.image=[UIImage imageNamed:@"icon_kpi_extend_white@2x.png"];
        [_lb1 Start];
    }
    else
    {
        _view1.backgroundColor=[UIColor colorWithRed:55.0f/255 green:115.0f/255 blue:120.0f/255 alpha:1];
        _view2.backgroundColor=[UIColor colorWithRed:55.0f/255 green:115.0f/255 blue:120.0f/255 alpha:1];
        self.contentView.backgroundColor=[UIColor clearColor];
        _ivHasChild.image=[UIImage imageNamed:@"icon_kpi_extend_green@2x.png"];
        [_lb1 Stop];
    }
}
@end
