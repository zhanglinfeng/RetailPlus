//
//  RPDailySalesRecordView.m
//  RetailPlus
//
//  Created by zwhe on 14-1-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPDailySalesRecordView.h"
#import "RPSalesRecordCell.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@implementation RPDailySalesRecordView

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
    _viewBackground.layer.cornerRadius=10;
    _view1.layer.cornerRadius=6;
    
    [_tbSalesRecord setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *nowDate=[NSDate date];
    _pickDate = [[RPDatePicker alloc] init:_tfDate Format:dateFormatter curDate:nowDate canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationTapped:)];
//    [self addGestureRecognizer:tap];
//    tap.cancelsTouchesInView=NO;
    
    NSString *mode1=NSLocalizedStringFromTableInBundle(@"Record by hour",@"RPString", g_bundleResorce,nil);
    NSString *mode2=NSLocalizedStringFromTableInBundle(@"Record by day",@"RPString", g_bundleResorce,nil);
    _arrayMode=[[NSArray alloc]initWithObjects:mode1,mode2, nil];
    
    _nOpenHour = 9;
    _nCloseHour = 23;
    
    _bSaved=YES;
    _viewRed.hidden=YES;
}

- (void)SetDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger nDay = [components day];
    NSInteger nMonth = [components month];
    NSInteger nYear = [components year];
  
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    _selDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%04d-%02d-%02d",nYear,nMonth,nDay]];
    
    _arraySalesDataHour = [[NSMutableArray alloc] init];
    for (NSInteger n = _nOpenHour; n < _nCloseHour; n ++) {
        KPISalesData * dataSale = [[KPISalesData alloc] init];
        dataSale.nYear = nYear;
        dataSale.nMonth = nMonth;
        dataSale.nDay = nDay;
        dataSale.nHour = n;
        dataSale.mode = KPIMode_Hour;
        dataSale.nAmount = -1;
        dataSale.nProQty = -1;
        dataSale.nTraQty = -1;
        [_arraySalesDataHour addObject:dataSale];
    }
    
    _salesDataDay = [[KPISalesData alloc] init];
    _salesDataDay.nYear = nYear;
    _salesDataDay.nMonth = nMonth;
    _salesDataDay.nDay = nDay;
    _salesDataDay.mode = KPIMode_Day;
    _salesDataDay.nAmount = -1;
    _salesDataDay.nProQty = -1;
    _salesDataDay.nTraQty = -1;
    
    BOOL bFound = NO;
    _mode = KPIMode_Hour;
    [_btMode setTitle:[_arrayMode objectAtIndex:_mode] forState:UIControlStateNormal];
    if (_arraySalesData) {
        for (KPISalesData * data in _arraySalesData) {
            if ((data.nYear == nYear) && (data.nMonth == nMonth) && (data.nDay == nDay)) {
                if (data.mode == KPIMode_Day) {
                    _mode = KPIMode_Day;
                    _salesDataDay.nAmount = data.nAmount;
                    _salesDataDay.nProQty = data.nProQty;
                    _salesDataDay.nTraQty = data.nTraQty;
                    bFound = YES;
                    [_btMode setTitle:[_arrayMode objectAtIndex:_mode] forState:UIControlStateNormal];
                    break;
                }
                else
                {
                    _mode = KPIMode_Hour;
                    
                    NSInteger nIndex = data.nHour - _nOpenHour;
                    if (nIndex >= 0 && nIndex < _arraySalesDataHour.count) {
                       KPISalesData * dataHour = [_arraySalesDataHour objectAtIndex:nIndex];
                       dataHour.nAmount = data.nAmount;
                       dataHour.nProQty = data.nProQty;
                       dataHour.nTraQty = data.nTraQty;
                    }
                }
                bFound = YES;
            }
            else
            {
                if (bFound) break;
            }
        }
    }
    
    if (!bFound)
        _bAdd = YES;
    else
        _bAdd = NO;
    
    [self updateUI];
}

- (void)updateUI
{
    if (_mode == KPIMode_Hour) {
        _salesDataDay.nAmount = 0;
        _salesDataDay.nProQty = 0;
        _salesDataDay.nTraQty = 0;
        for (KPISalesData * dataHour in _arraySalesDataHour)
        {
            if (dataHour.nAmount > 0) _salesDataDay.nAmount += dataHour.nAmount;
            if (dataHour.nProQty > 0) _salesDataDay.nProQty += dataHour.nProQty;
            if (dataHour.nTraQty > 0) _salesDataDay.nTraQty += dataHour.nTraQty;
        }
    }
    if (_salesDataDay.nAmount >= 0) _tfSalesAmount.text = [RPSDK numberFormatter:[NSNumber numberWithInteger:_salesDataDay.nAmount]];
    else
        _tfSalesAmount.text = @"";
    
    if (_salesDataDay.nProQty >= 0) _tfSalesQty.text = [RPSDK numberFormatter:[NSNumber numberWithInteger:_salesDataDay.nProQty]];
    else
        _tfSalesQty.text = @"";
    
    if (_salesDataDay.nTraQty >= 0) _tfTxnQty.text = [RPSDK numberFormatter:[NSNumber numberWithInteger:_salesDataDay.nTraQty]];
    else
        _tfTxnQty.text = @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    _pickDate = [[RPDatePicker alloc] init:_tfDate Format:dateFormatter curDate:_selDate canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    
//    [_btMode setTitle:[_arrayMode objectAtIndex:_mode] forState:UIControlStateNormal];
    if (_mode == KPIMode_Day)
    {
        _tbSalesRecord.hidden=YES;
    }
    else
    {
        _tbSalesRecord.hidden=NO;
    }
    
    if (_mode == KPIMode_Hour)
    {
        [_tfSalesAmount setUserInteractionEnabled:NO];
        [_tfSalesQty setUserInteractionEnabled:NO];
        [_tfTxnQty setUserInteractionEnabled:NO];
        
        _tfSalesAmount.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        _tfSalesQty.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        _tfTxnQty.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%04d-%02d-%02d",_salesDataDay.nYear,_salesDataDay.nMonth,_salesDataDay.nDay]];
        NSTimeInterval nowDate=[[NSDate date] timeIntervalSince1970]*1;
        NSTimeInterval currentDate=[date timeIntervalSince1970]*1;
        if (nowDate>currentDate+86400*30)
        {
            [_tfSalesAmount setUserInteractionEnabled:NO];
            [_tfSalesQty setUserInteractionEnabled:NO];
            [_tfTxnQty setUserInteractionEnabled:NO];
        }
        else
        {
            [_tfSalesAmount setUserInteractionEnabled:YES];
            [_tfSalesQty setUserInteractionEnabled:YES];
            [_tfTxnQty setUserInteractionEnabled:YES];
        }
        
        
        _tfSalesAmount.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        _tfSalesQty.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        _tfTxnQty.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    }
    
    [_tbSalesRecord reloadData];
}

//- (void)locationTapped:(UITapGestureRecognizer *)tap
//{
//    [self endEditing:YES];
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arraySalesDataHour.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPSalesRecordCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPSalesRecordCell"];
    if (cell==nil) {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPSalesRecordCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
        cell.delegate = self;
    }

    cell.salesData=[_arraySalesDataHour objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}

- (IBAction)OnMode:(id)sender
{
    
    if (!_bAdd) return;
//
//    _modeList = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 198, 42*_arrayMode.count)];
//    _modeList.datasource = self;
//    _modeList.delegate = self;
//    [_modeList show:CGPointMake(203,235)];
    
    NSString *mode=NSLocalizedStringFromTableInBundle(@"MODE",@"RPString", g_bundleResorce,nil);
    RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:mode clickButton:^(NSInteger indexButton) {
        
        _mode=indexButton;
        [_btMode setTitle:[_arrayMode objectAtIndex:indexButton] forState:UIControlStateNormal];
        [self updateUI];
    } curIndex:_mode selectTitles:_arrayMode];
    [selectView show];
}

-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _storeSelected=storeSelected;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
//    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%04d-%02d-%02d",_salesDataDay.nYear,_salesDataDay.nMonth,_salesDataDay.nDay]];
//    NSTimeInterval nowDate=[[NSDate date] timeIntervalSince1970]*1;
//    NSTimeInterval currentDate=[date timeIntervalSince1970]*1;
//    if (nowDate>currentDate+86400*30)
//    {
//        return NO;
//    }
    if(textField==_tfDate)
    {
        if (!_bSaved)
        {
            NSString * strSave = NSLocalizedStringFromTableInBundle(@"SAVE",@"RPString", g_bundleResorce,nil);
//            NSString * strDont = NSLocalizedStringFromTableInBundle(@"DON'T SAVE",@"RPString", g_bundleResorce,nil);
            NSString *strCancel=NSLocalizedStringFromTableInBundle(@"DON'T SAVE",@"RPString", g_bundleResorce,nil);
            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Data of this day is modified,do you want to save before switch date?",@"RPString", g_bundleResorce,nil);
            RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
                if(indexButton==0)
                {
                    _bSaved=YES;
                    _viewRed.hidden=YES;
                    [textField becomeFirstResponder];
                }
                else
                {
                    [self OnSave:nil];
                    
//                    [textField becomeFirstResponder];
                    
//                    [self performSelectorOnMainThread:@selector(OnSave:) withObject:nil waitUntilDone:YES];
//                    [self performSelectorOnMainThread:@selector(showKeyboard) withObject:nil waitUntilDone:YES];
                    
                    
                }
                
                
            }otherButtonTitles:strSave, nil];
            [alertView show];
            return NO;
            
        }
        else
        {
            return YES;
        }
    }
    return YES;

}

-(void)showKeyboard
{
    [_tfDate becomeFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField!=_tfDate)
    {
        _bSaved=NO;
        _viewRed.hidden=NO;
    }
    
    _rcFrameRectOrg = _viewBackground.frame;
    [UIView beginAnimations:nil context:nil];
    _viewBackground.frame = CGRectMake(_viewBackground.frame.origin.x, -50, _viewBackground.frame.size.width, _viewBackground.frame.size.height);
    [UIView commitAnimations];
}
-(NSString*)deleteString:(NSString*)s
{
    //创建可变字符串
    NSMutableString *mstrAmount =[NSMutableString stringWithString:s];
    NSString *str=[mstrAmount stringByReplacingOccurrencesOfString:@","withString:@""];
    return str;
}
- (IBAction)OnSave:(id)sender
{
    if (_tfSalesAmount.text.length>11||_tfSalesQty.text.length>11||_tfTxnQty.text.length>11)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"No more than 9 digits",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    if(_bSaved)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"There is no modifications can be saved",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
    }
    else
    {
        switch (_mode) {
            case KPIMode_Day:
            {
                [SVProgressHUD showWithStatus:@""];
                _salesDataDay.nAmount=[self deleteString:_tfSalesAmount.text].integerValue;
                _salesDataDay.nProQty = [self deleteString:_tfSalesQty.text].integerValue;
                _salesDataDay.nTraQty = [self deleteString:_tfTxnQty.text].integerValue;
                
                NSMutableArray * array = [[NSMutableArray alloc] init];
                [array addObject:_salesDataDay];
                [[RPSDK defaultInstance]SetKPISalesData:_storeSelected.strStoreId SalesData:array Success:^(id idResult) {
                    _bSaved=YES;
                    _viewRed.hidden=YES;
                    [self ReloadData];
                } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                    [SVProgressHUD dismiss];
                }];
            }
                break;
            case KPIMode_Hour:
            {
                [SVProgressHUD showWithStatus:@""];
                
                [[RPSDK defaultInstance]SetKPISalesData:_storeSelected.strStoreId SalesData:_arraySalesDataHour Success:^(id idResult) {
                    _bSaved=YES;
                     _viewRed.hidden=YES;
                    [self ReloadData];
                } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                    [SVProgressHUD dismiss];
                }];
            }
                break;
            default:
                break;
        }
    }
}

-(void)ReloadData
{
    [[RPSDK defaultInstance] GetKPISalesDataList:_storeSelected.strStoreId Success:^(NSMutableArray * arrayResult) {
        _arraySalesData = arrayResult;
        [self SetDate:_selDate];
        [_delegate OnUpdate];
        NSString *s=NSLocalizedStringFromTableInBundle(@"modifications is saving",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showSuccessWithStatus:s];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
    }];
}

-(void)OnValueBeginChange:(UITableViewCell *)cell
{
//    [_tfDate resignFirstResponder];
    _bSaved=NO;
     _viewRed.hidden=NO;
    _rcFrameRectOrg = _viewBackground.frame;
    
    [UIView beginAnimations:nil context:nil];
    _viewBackground.frame = CGRectMake(_viewBackground.frame.origin.x, -_tbSalesRecord.frame.origin.y, _viewBackground.frame.size.width, _viewBackground.frame.size.height);
    [UIView commitAnimations];
}

-(void)OnValueChange
{
    if (_mode == KPIMode_Hour) {
        _salesDataDay.nAmount = 0;
        _salesDataDay.nProQty = 0;
        _salesDataDay.nTraQty = 0;
        for (KPISalesData * dataHour in _arraySalesDataHour)
        {
            if (dataHour.nAmount > 0) _salesDataDay.nAmount += dataHour.nAmount;
            if (dataHour.nProQty > 0) _salesDataDay.nProQty += dataHour.nProQty;
            if (dataHour.nTraQty > 0) _salesDataDay.nTraQty += dataHour.nTraQty;
        }
    }
    if (_salesDataDay.nAmount >= 0) _tfSalesAmount.text = [RPSDK numberFormatter:[NSNumber numberWithInteger:_salesDataDay.nAmount]];
    else
        _tfSalesAmount.text = @"";
    
    if (_salesDataDay.nProQty >= 0) _tfSalesQty.text = [RPSDK numberFormatter:[NSNumber numberWithInteger:_salesDataDay.nProQty]];
    else
        _tfSalesQty.text = @"";
    
    if (_salesDataDay.nTraQty >= 0) _tfTxnQty.text = [RPSDK numberFormatter:[NSNumber numberWithInteger:_salesDataDay.nTraQty]];
    else
        _tfTxnQty.text = @"";
    
    [UIView beginAnimations:nil context:nil];
    _viewBackground.frame = _rcFrameRectOrg;
    [UIView commitAnimations];
}

//- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _arrayMode.count;
//}
//
//- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identifier = @"VendorCellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    
//    
//    cell.textLabel.text = [NSString  stringWithFormat:@"%@",[_arrayMode objectAtIndex:indexPath.row]];
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
//    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
//    cell.textLabel.textAlignment=NSTextAlignmentCenter;
//    return cell;
//}
//
//-(void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//
//- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView dismiss];
//    _mode = indexPath.row;
//    
//    [self updateUI];
//    [self endEditing:YES];
//}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _tfDate) {
        [self SetDate:[_pickDate GetDate]];
    }
    
    [UIView beginAnimations:nil context:nil];
    _viewBackground.frame = _rcFrameRectOrg;
    [UIView commitAnimations];
}

-(BOOL)OnBack
{
    [self endEditing:YES];
    if (!_bSaved)
    {
        NSString * strSave = NSLocalizedStringFromTableInBundle(@"SAVE",@"RPString", g_bundleResorce,nil);
        NSString * strDont = NSLocalizedStringFromTableInBundle(@"DON'T SAVE",@"RPString", g_bundleResorce,nil);
        NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Save changes before leave?",@"RPString", g_bundleResorce,nil);
        RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
            if (indexButton==2)
            {
                _bSaved=YES;
                _viewRed.hidden=YES;
                [_delegate OnChangeSalesRecordEnd];
                
                
                
            }
            else if(indexButton==0)
            {
                _bSaved=NO;
                _viewRed.hidden=NO;
            }
            else
            {
                [self OnSave:nil];
                [_delegate OnChangeSalesRecordEnd];
                
            }
            
            
        }otherButtonTitles:strSave,strDont, nil];
        [alertView show];
        return NO;

    }
    else
    {
        return YES;
    }
    _bSaved=YES;
    _viewRed.hidden=YES;
    
}

- (IBAction)OnQuit:(id)sender
{
    if (_bSaved)
    {
        NSString * strYes = NSLocalizedStringFromTableInBundle(@"YES",@"RPString", g_bundleResorce,nil);
        NSString * strNo = NSLocalizedStringFromTableInBundle(@"NO",@"RPString", g_bundleResorce,nil);
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Whether to quit KPI data entry tool",@"RPString", g_bundleResorce,nil);
        RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strNo clickButton:^(NSInteger indexButton) {
             if(indexButton==0)
            {
               
            }
            else
            {
                [self.delegate OnKPIDataEntryEnd];
                
            }
            
            
        }otherButtonTitles:strYes, nil];
        [alertView show];
    }
    else
    {
        
        NSString * strSave = NSLocalizedStringFromTableInBundle(@"SAVE",@"RPString", g_bundleResorce,nil);
        NSString * strDont = NSLocalizedStringFromTableInBundle(@"DON'T SAVE",@"RPString", g_bundleResorce,nil);
        NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Save changes before leave?",@"RPString", g_bundleResorce,nil);
        RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
            if (indexButton==2)
            {
                _bSaved=YES;
                _viewRed.hidden=YES;
                 [self.delegate OnKPIDataEntryEnd];
                
                
                
            }
            else if(indexButton==0)
            {
                _bSaved=NO;
                _viewRed.hidden=NO;
            }
            else
            {
                [self OnSave:nil];
                [self.delegate OnKPIDataEntryEnd];
                
            }
            
            
        }otherButtonTitles:strSave,strDont, nil];
        [alertView show];
    }
    
}

-(void)findEmpty
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate * date = [_selDate copy];
    while (1) {
        BOOL bFound = NO;
        date = [date dateByAddingTimeInterval:-24*60*60];
        
        NSTimeInterval nowDate=[[NSDate date] timeIntervalSince1970]*1;
        NSTimeInterval currentDate=[date timeIntervalSince1970]*1;
        if (nowDate>currentDate+86400*30)
        {
            return;
        }
        
        for (KPISalesData * dataSale in _arraySalesData) {
            NSDate * dateSale = [dateFormatter dateFromString:[NSString stringWithFormat:@"%04d-%02d-%02d",dataSale.nYear,dataSale.nMonth,dataSale.nDay]];
            
            if ([date isEqualToDate:dateSale]) {
                bFound = YES;
                break;
            }
            if ([dateSale compare:date] == NSOrderedAscending) {
                break;
            }
        }
        
        if (!bFound) {
            [self SetDate:date];
            break;
        }
    }

}

-(IBAction)FindEmptyPreDay:(id)sender
{
    if (!_bSaved)
    {
        NSString * strSave = NSLocalizedStringFromTableInBundle(@"SAVE",@"RPString", g_bundleResorce,nil);
//        NSString * strDont = NSLocalizedStringFromTableInBundle(@"DON'T SAVE",@"RPString", g_bundleResorce,nil);
        NSString *strCancel=NSLocalizedStringFromTableInBundle(@"DON'T SAVE",@"RPString", g_bundleResorce,nil);
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Save changes before search?",@"RPString", g_bundleResorce,nil);
        RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
             if(indexButton==0)
            {
                _bSaved=YES;
                _viewRed.hidden=YES;
                [self findEmpty];
            }
            else
            {
                [self OnSave:nil];
                
                
            }
            
            
        }otherButtonTitles:strSave, nil];
        [alertView show];
       
        
    }
    else
    {
        [self findEmpty];
    }
    

    
    
    
    
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}
@end
