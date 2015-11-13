//
//  RPTrafficDataView.m
//  RetailPlus
//
//  Created by zwhe on 14-1-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTrafficDataView.h"
#import "UIImageView+WebCache.h"
#import "RPTrafficDataCell.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@implementation RPTrafficDataView

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
    _view1.layer.cornerRadius=10;
    _ivPic.layer.cornerRadius=6;
    _ivPic.layer.borderWidth=1;
    _ivPic.layer.borderColor=[UIColor grayColor].CGColor;
    [_tbTrafficData setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _svFrame.contentSize=CGSizeMake(_svFrame.frame.size.width*2, _svFrame.frame.size.height);
    _svFrame.pagingEnabled=YES;
    //不显示水平滑动条
    _svFrame.showsVerticalScrollIndicator=NO;
    //不显示垂直滑动条
    _svFrame.showsHorizontalScrollIndicator=NO;
    //不允许反弹
    _svFrame.bounces = NO;
    _ivLeft.alpha=0.3;
    _ivRight.alpha=1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    //    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    //    NSDate * date = [NSDate dateWithTimeIntervalSince1970:0];
    NSDate *nowDate=[NSDate date];
    _pickDate = [[RPDatePicker alloc] init:_tfDate Format:dateFormatter curDate:nowDate canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick)];
    [self addGestureRecognizer:tap];
    tap.cancelsTouchesInView=NO;

    _arrayTrafficData=[[NSMutableArray alloc]init];
    [self setUpForDismissKeyboard];
    [self addHeader];

}
- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tbTrafficData;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self ReloadData];
    };
    _headerTraffic = header;
    
}
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    //    singleTapGR.cancelsTouchesInView = NO;
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [_tbTrafficData addGestureRecognizer:singleTapGR];
                    NSLog(@"ziji===%@",self);
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [_tbTrafficData removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self endEditing:YES];
   
}

-(void)tapGestureClick
{
    [self endEditing:YES];
}
-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _storeSelected=storeSelected;
    _lbStore.text=storeSelected.strStoreName;
    _lbPlace.text=storeSelected.strStoreAddress;
    
    [_ivPic setImageWithURLString:storeSelected.strStoreThumbBig placeholderImage:[UIImage imageNamed:@"icon_storeimage01_224.png"]];

    [self ReloadData];
    
}
- (IBAction)OnAdd:(id)sender {
    _bViewDailyTrafficRecord=YES;
    _viewDailyTrafficRecord.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewDailyTrafficRecord];
    _viewDailyTrafficRecord.arrayTrafficData=_arrayTrafficData;
    [_viewDailyTrafficRecord SetDate:[NSDate date ]];
    _viewDailyTrafficRecord.delegate = self;
    _viewDailyTrafficRecord.storeSelected=_storeSelected;
    [UIView beginAnimations:nil context:nil];
    _viewDailyTrafficRecord.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction)OnSelectDate:(id)sender
{
    [_tfDate becomeFirstResponder];
}

- (IBAction)OnQiut:(id)sender
{
    [self.delegate OnKPITrafficDataEntryEnd];
}
-(BOOL)OnBack
{
    [self endEditing:YES];
    if (_bViewDailyTrafficRecord)
    {
        if ([_viewDailyTrafficRecord OnBack])
        {
            [UIView beginAnimations:nil context:nil];
            _viewDailyTrafficRecord.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _bViewDailyTrafficRecord=NO;
            
        }
        return NO;
    }
    else
    {
        return YES;
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x ==0)
    {
        _ivLeft.alpha=0.3;
        _ivRight.alpha=1;
    }
    if(scrollView.contentOffset.x ==scrollView.frame.size.width)
    {
        _ivLeft.alpha=1;
        _ivRight.alpha=0.3;
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayTrafficDayData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _bViewDailyTrafficRecord=YES;
    _viewDailyTrafficRecord.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewDailyTrafficRecord];
    _viewDailyTrafficRecord.arrayTrafficData=_arrayTrafficData;
    _viewDailyTrafficRecord.storeSelected=_storeSelected;
    _viewDailyTrafficRecord.delegate=self;
    
    KPITrafficData *traffic=[_arrayTrafficDayData objectAtIndex:indexPath.row];
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[format dateFromString:[NSString stringWithFormat:@"%04d-%02d-%02d",traffic.nYear,traffic.nMonth,traffic.nDay]];
    [_viewDailyTrafficRecord SetDate:date];
    
    [UIView beginAnimations:nil context:nil];
    _viewDailyTrafficRecord.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPTrafficDataCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPTrafficDataCell"];
    if (cell==nil) {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPTrafficDataCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
        
    }
    cell.trafficDate=[_arrayTrafficDayData objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        
        KPITrafficData * traffic = [_arrayTrafficDayData objectAtIndex:indexPath.row];
        NSString *date=[NSString stringWithFormat:@"%04d-%02d-%02d",traffic.nYear,traffic.nMonth,traffic.nDay];
        [[RPSDK defaultInstance]DeleteKPITrafficData:_storeSelected.strStoreId Date:date Success:^(id idResult) {
            [self ReloadData];
            
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];

    }
}
-(void)OnChangeTrafficRecordEnd
{
    [UIView beginAnimations:nil context:nil];
    _viewDailyTrafficRecord.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bViewDailyTrafficRecord=NO;
    [self ReloadData];
   
}
-(void)OnUpdate
{
    [self ReloadData];
}

-(void)ReloadData
{
    [SVProgressHUD showWithStatus:@""];
    [[RPSDK defaultInstance]GetKPITrafficDataList:_storeSelected.strStoreId Success:^(NSMutableArray *arrayResult)
    {
        _arrayTrafficData=arrayResult;
        _arrayTrafficDayData=[[NSMutableArray alloc]init];
        KPITrafficData *dataHour=nil;
        
        for (KPITrafficData *data in _arrayTrafficData)
        {
            switch (data.mode) {
                case KPIMode_Day:
                    [_arrayTrafficDayData addObject:data];
                    break;
                case KPIMode_Hour:
                    if (dataHour==nil||data.nYear!=dataHour.nYear||data.nMonth!=dataHour.nMonth||data.nDay!=dataHour.nDay) {
                        dataHour=[[KPITrafficData alloc]init];
                        dataHour.nYear=data.nYear;
                        dataHour.nMonth=data.nMonth;
                        dataHour.nDay=data.nDay;
                        dataHour.mode=KPIMode_Hour;
                        dataHour.nTraffic=data.nTraffic;
                        [_arrayTrafficDayData addObject:dataHour];
                        
                    }
                    else
                    {
                        dataHour.nTraffic+=data.nTraffic;
                    }
                    break;
                    
                default:
                    break;
            }
        }
        [_tbTrafficData reloadData];
        [self showTotal];
        [SVProgressHUD dismiss];
    }Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}
-(void)showTotal
{
    NSDate *nowDate=[NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:nowDate];
    
    NSInteger nowMonth = [components month];
    NSInteger nowYear = [components year];
    
    long long yTraffic=0;
    long long mTraffic=0;
    for (KPITrafficData *data in _arrayTrafficData)
    {
        if (data.nYear==nowYear)
        {
            yTraffic += (long long)data.nTraffic;
        }
    }
    for (KPITrafficData *data in _arrayTrafficData) {
        if(data.nMonth==nowMonth)
        {
            mTraffic += (long long)data.nTraffic;
        }
    }
    _lbYTraffic.text=[RPSDK numberFormatter:[NSNumber numberWithLongLong:yTraffic]];
    _lbMTraffic.text=[RPSDK numberFormatter:[NSNumber numberWithLongLong:mTraffic]];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _tfDate)
    {
        
        _bViewDailyTrafficRecord=YES;
        _viewDailyTrafficRecord.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:_viewDailyTrafficRecord];
        _viewDailyTrafficRecord.arrayTrafficData=_arrayTrafficData;
        _viewDailyTrafficRecord.storeSelected=_storeSelected;
        _viewDailyTrafficRecord.delegate=self;
        
        [_viewDailyTrafficRecord SetDate:[_pickDate GetDate]];
        
        [UIView beginAnimations:nil context:nil];
        _viewDailyTrafficRecord.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];

    }
}
-(void)OnKPIDataEntryEnd
{
    [self.delegate OnKPITrafficDataEntryEnd];
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}

@end
