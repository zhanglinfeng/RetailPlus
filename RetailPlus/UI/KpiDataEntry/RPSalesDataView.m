//
//  RPSalesDataView.m
//  RetailPlus
//
//  Created by zwhe on 14-1-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPSalesDataView.h"
#import "RPKPIDateCell.h"
#import "UIImageView+WebCache.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@implementation RPSalesDataView

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
    [_tbSalesData setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    _bViewDailySalesRecord=NO;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    //    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    //    NSDate * date = [NSDate dateWithTimeIntervalSince1970:0];
    NSDate *nowDate=[NSDate date];
    _pickDate = [[RPDatePicker alloc] init:_tfDate Format:dateFormatter curDate:nowDate canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick)];
    [self addGestureRecognizer:tap];
    tap.cancelsTouchesInView=NO;

    _arraySalesData=[[NSMutableArray alloc]init];
    

    [self setUpForDismissKeyboard];
    
    [self addHeader];
}
- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tbSalesData;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self ReloadData];
    };
    _headerSales = header;
    
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
                    [_tbSalesData addGestureRecognizer:singleTapGR];
                    NSLog(@"ziji===%@",self);
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [_tbSalesData removeGestureRecognizer:singleTapGR];
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

-(void)loadData
{
    
}
-(BOOL)OnBack
{
    [self endEditing:YES];
    if (_bViewDailySalesRecord)
    {
        if ([_viewDailySalesRecord OnBack])
        {
            [UIView beginAnimations:nil context:nil];
            _viewDailySalesRecord.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            _bViewDailySalesRecord=NO;
        }
         return NO;
    }
    else
    {
        return YES;
    }
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
    _bViewDailySalesRecord=YES;
    _viewDailySalesRecord.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewDailySalesRecord];
    _viewDailySalesRecord.arraySalesData=_arraySalesData;
    [_viewDailySalesRecord SetDate:[NSDate date]];
    _viewDailySalesRecord.delegate = self;
    _viewDailySalesRecord.storeSelected=_storeSelected;
    [UIView beginAnimations:nil context:nil];
    _viewDailySalesRecord.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction)OnSelectDate:(id)sender
{
    _bDatePicker=YES;
    [_tfDate becomeFirstResponder];
    
}

- (IBAction)OnQuit:(id)sender
{
    [self.delegate OnKPIDataEntryEnd];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _tfDate) {
       
        
        _bViewDailySalesRecord=YES;
        _viewDailySalesRecord.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:_viewDailySalesRecord];
        _viewDailySalesRecord.arraySalesData=_arraySalesData;
        _viewDailySalesRecord.storeSelected=_storeSelected;
        _viewDailySalesRecord.delegate = self;
        [_viewDailySalesRecord SetDate:[_pickDate GetDate]];
        [UIView beginAnimations:nil context:nil];
        _viewDailySalesRecord.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];

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
    return _arraySalesDayData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _bViewDailySalesRecord=YES;
    _viewDailySalesRecord.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewDailySalesRecord];
    _viewDailySalesRecord.arraySalesData=_arraySalesData;
    _viewDailySalesRecord.storeSelected=_storeSelected;
    _viewDailySalesRecord.delegate = self;
    
    KPISalesData * sale = [_arraySalesDayData objectAtIndex:indexPath.row];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [format dateFromString:[NSString stringWithFormat:@"%04d-%02d-%02d",sale.nYear,sale.nMonth,sale.nDay]];
    [_viewDailySalesRecord SetDate:date];
    
    [UIView beginAnimations:nil context:nil];
    _viewDailySalesRecord.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPKPIDateCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPKPIDateCell"];
    if (cell==nil) {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPKPIDateCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
        
    }
    cell.salesData = [_arraySalesDayData objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
    
        KPISalesData * sale = [_arraySalesDayData objectAtIndex:indexPath.row];
        NSString *date=[NSString stringWithFormat:@"%04d-%02d-%02d",sale.nYear,sale.nMonth,sale.nDay];
        [[RPSDK defaultInstance]DeleteKPISalesData:_storeSelected.strStoreId Date:date Success:^(id idResult) {
            [self ReloadData];
            
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
}

-(void)OnChangeSalesRecordEnd
{
    [UIView beginAnimations:nil context:nil];
    _viewDailySalesRecord.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bViewDailySalesRecord=NO;
    [self ReloadData];
    
}
-(void)OnUpdate
{
    [self ReloadData];
}
-(void)ReloadData
{
    [SVProgressHUD showWithStatus:@""];
    [[RPSDK defaultInstance] GetKPISalesDataList:_storeSelected.strStoreId Success:^(NSMutableArray * arrayResult) {
        _arraySalesData = arrayResult;
        _arraySalesDayData = [[NSMutableArray alloc] init];
        
        
        KPISalesData * dataHour = nil;
        
        for (KPISalesData * data in _arraySalesData)
        {
            switch (data.mode) {
                case KPIMode_Day:
                    [_arraySalesDayData addObject:data];
                    break;
                case KPIMode_Hour:
                    if (dataHour == nil || data.nYear != dataHour.nYear || data.nMonth != dataHour.nMonth || data.nDay != dataHour.nDay) {
                        dataHour = [[KPISalesData alloc] init];
                        dataHour.nYear = data.nYear;
                        dataHour.nMonth = data.nMonth;
                        dataHour.nDay = data.nDay;
                        dataHour.mode = KPIMode_Hour;
                        dataHour.nAmount = data.nAmount;
                        dataHour.nProQty = data.nProQty;
                        dataHour.nTraQty = data.nTraQty;
                        [_arraySalesDayData addObject:dataHour];
                    }
                    else
                    {
                        dataHour.nAmount += data.nAmount;
                        dataHour.nProQty += data.nProQty;
                        dataHour.nTraQty += data.nTraQty;
                    }
                    break;
            }
        }
        [self showTotal];
        [_tbSalesData reloadData];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
    
}
-(void)showTotal
{
    NSDate *nowDate=[NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:nowDate];
    
    NSInteger nowMonth = [components month];
    NSInteger nowYear = [components year];

    long long ySales=0;
    long long mSales=0;
    for (KPISalesData *data in _arraySalesDayData)
    {
        if (data.nYear==nowYear)
        {
            ySales+=(long long)data.nAmount;
        }
    }
    for (KPISalesData *data in _arraySalesDayData) {
        if(data.nMonth==nowMonth)
        {
            mSales+=(long long)data.nAmount;
        }
    }
    _lbYSales.text=[RPSDK numberFormatter:[NSNumber numberWithLongLong:ySales]];
    _lbMSales.text=[RPSDK numberFormatter:[NSNumber numberWithLongLong:mSales]];
}
-(void)OnKPIDataEntryEnd
{
    [self.delegate OnKPIDataEntryEnd];
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}
@end
