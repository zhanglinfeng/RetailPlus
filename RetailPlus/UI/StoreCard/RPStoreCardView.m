//
//  RPStoreCardView.m
//  RetailPlus
//
//  Created by lin dong on 13-10-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPStoreCardView.h"
#import "UIImageView+WebCache.h"

@implementation RPStoreCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    self.layer.cornerRadius = 10;
    _viewWeather.layer.cornerRadius = 5;
    _viewTable1.layer.cornerRadius = 5;
    _viewTable2.layer.cornerRadius = 5;
    _viewTable3.layer.cornerRadius = 5;
    
    _viewTable1.layer.borderWidth = 1;
    _viewTable1.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    _viewTable2.layer.borderWidth = 1;
    _viewTable2.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    _viewTable3.layer.borderWidth = 1;
    _viewTable3.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    
    _btnStoreName.layer.cornerRadius = 5;
//    _btnStoreName.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _btnStoreName.layer.borderWidth = 1;
    
    _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width, 460);
    
    [self getDate];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(IBAction)OnSelectStore:(id)sender
{
    if (self.delegate) {
        [self.delegate OnSelectStore];
    }
}
-(void)getDate
{
    NSDate *nowTime =[NSDate date];
    NSCalendar*calendar=[NSCalendar currentCalendar];
    NSTimeInterval now=[nowTime timeIntervalSince1970]*1;
    int  t=now/1 +86400;
    int at=now/1 +86400*2;
    NSDate*tDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)t];
    NSDate*atDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)at];
    NSDateComponents*components1 =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:nowTime];
    NSDateComponents*components2=[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:tDate];
    NSDateComponents*components3=[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:atDate];
    _lbDate1.text=[NSString stringWithFormat:@"%i／%i",[components1 month],[components1 day]];
    _lbDate2.text=[NSString stringWithFormat:@"%i／%i",[components2 month],[components2 day]];
    _lbDate3.text=[NSString stringWithFormat:@"%i／%i",[components3 month],[components3 day]];
}
-(void)setStore:(StoreDetailInfo *)store
{
    _store = store;
//    [_btnStoreName setTitle:store.strStoreName forState:UIControlStateNormal];
//    [_btnStoreName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _lbStoreName.text = [ NSString stringWithFormat:@"%@ %@",store.strBrandName,store.strStoreName];
    _lbStoreName.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    [_lbStoreName Start];
    
    _lbLocate.text = store.strCityName;
    _lbPostCode.text = store.strStorePostCode;
    _lbAddress.text = store.strStoreAddress;
    _lbType.text = store.strStoreType;
    _lbOrganization.text = store.strStoreOrganize;
    _lbPhone.text = store.strPhone;
    
    [_ivImage setImageWithURLString:store.strStoreThumbBig placeholderImage:[UIImage imageNamed:@"icon_storeimage01_224.png"]];
    
    _lbFax.text = store.strFax;
    _lbEmail.text = store.strEmail;
    _lbShopHour.text = [NSString stringWithFormat:@"%@ - %@",store.strStartTime,store.strEndTime];
    _lbArea.text = store.strAreaSquare;
    _lbLastRecorated.text = store.strDecorationDate;
    _lbDealer.text = store.strDealerName;
    
    if (!store.isOwn) {
        _ivStoreUser.hidden = YES;
    }
    else
    {
        _ivStoreUser.hidden = NO;
    }
    
    if (!store.isPerfect) {
        _ivStoreInfoComplete.hidden = YES;
    }
    else
    {
        _ivStoreInfoComplete.hidden = NO;
    }
    
    
    [[RPSDK defaultInstance]GetWeatherInfo:_store.strWeatherCode/*@"101020100"*/ success:^(NSDictionary *weather) {
        _lbTemperature1.text = [weather objectForKey:@"temp1"];
        
        _ivWeather1.image=[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@.png",[weather objectForKey:@"img_title1"]]];
        _lbTemperature2.text = [weather objectForKey:@"temp2"];
        _ivWeather2.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@.png",[weather objectForKey:@"img_title3"]]];
        
        _lbTemperature3.text = [weather objectForKey:@"temp3"];
        _ivWeather3.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@.png",[weather objectForKey:@"img_title5"]]];
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
       
    }];
}

-(void)setFrame:(CGRect)frame
{
    if (frame.size.height != 139) {
        _nHeight = frame.size.height;
    }
    _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width, 460);
    [super setFrame:frame];
}

-(void)Hide:(BOOL)bHide
{
    [UIView beginAnimations:nil context:nil];
    
    if (!bHide)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _nHeight);
        [_btnHide setImage:[UIImage imageNamed:@"botton_pagerollup_01@2x.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 139);
        [_btnHide setImage:[UIImage imageNamed:@"botton_pageextend_01@2x.png"] forState:UIControlStateNormal];
    }
    
    [UIView commitAnimations];
    
    _bHide = bHide;
}

-(IBAction)OnHide:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    
    if (_bHide)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _nHeight);
        [_btnHide setImage:[UIImage imageNamed:@"botton_pagerollup_01@2x.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 139);
        [_btnHide setImage:[UIImage imageNamed:@"botton_pageextend_01@2x.png"] forState:UIControlStateNormal];
    }
    
    [UIView commitAnimations];
    
    _bHide = !_bHide;
}

@end
