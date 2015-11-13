//
//  RPDailyTrafficRecordView.m
//  RetailPlus
//
//  Created by zwhe on 14-1-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPDailyTrafficRecordView.h"
#import "RPTrafficRecordCell.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
#import "RPBlockUISelectView.h"
extern NSBundle * g_bundleResorce;
@implementation RPDailyTrafficRecordView

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
    
    [_tbTrafficRecord setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *nowDate=[NSDate date];
    _pickDate = [[RPDatePicker alloc] init:_tfDate Format:dateFormatter curDate:nowDate canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationTapped:)];
    [self addGestureRecognizer:tap];
    tap.cancelsTouchesInView=NO;
    
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
//    _TrafficDate = date;
    
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    _TrafficDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%04d-%02d-%02d",nYear,nMonth,nDay]];

    _arrayTrafficDataHour = [[NSMutableArray alloc] init];
    for (NSInteger n = _nOpenHour; n < _nCloseHour; n ++) {
        KPITrafficData * dataTraffic = [[KPITrafficData alloc] init];
        dataTraffic.nYear = nYear;
        dataTraffic.nMonth = nMonth;
        dataTraffic.nDay = nDay;
        dataTraffic.nHour = n;
        dataTraffic.mode = KPIMode_Hour;
        dataTraffic.nTraffic=-1;
        [_arrayTrafficDataHour addObject:dataTraffic];
    }
    
    _TrafficDataDay = [[KPITrafficData alloc] init];
    _TrafficDataDay.nYear = nYear;
    _TrafficDataDay.nMonth = nMonth;
    _TrafficDataDay.nDay = nDay;
    _TrafficDataDay.mode = KPIMode_Day;
    _TrafficDataDay.nTraffic=-1;
    
    BOOL bFound = NO;
    _mode = KPIMode_Hour;
    [_btMode setTitle:[_arrayMode objectAtIndex:_mode] forState:UIControlStateNormal];
    if (_arrayTrafficData) {
        for (KPITrafficData * data in _arrayTrafficData) {
            if ((data.nYear == nYear) && (data.nMonth == nMonth) && (data.nDay == nDay)) {
                if (data.mode == KPIMode_Day) {
                    _mode = KPIMode_Day;
                    _TrafficDataDay.nTraffic=data.nTraffic;
                    [_btMode setTitle:[_arrayMode objectAtIndex:_mode] forState:UIControlStateNormal];
                     bFound = YES;
                    break;
                }
                else
                {
                    _mode = KPIMode_Hour;
                    
                    NSInteger nIndex = data.nHour - _nOpenHour;
                    if (nIndex >= 0 && nIndex < _arrayTrafficDataHour.count) {
                        KPITrafficData * dataHour = [_arrayTrafficDataHour objectAtIndex:nIndex];
                        dataHour.nTraffic=data.nTraffic;
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
        _TrafficDataDay.nTraffic=0;
            for (KPITrafficData * dataHour in _arrayTrafficDataHour)
        {
            if(dataHour.nTraffic>0)_TrafficDataDay.nTraffic+=dataHour.nTraffic;
            
        }
    }
    if (_TrafficDataDay.nTraffic >= 0) _tfTraffic.text = [RPSDK numberFormatter:[NSNumber numberWithInteger:_TrafficDataDay.nTraffic]];
    else
        _tfTraffic.text = @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    _pickDate = [[RPDatePicker alloc] init:_tfDate Format:dateFormatter curDate:_TrafficDate canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    
//    [_btMode setTitle:[_arrayMode objectAtIndex:_mode] forState:UIControlStateNormal];
    if (_mode == KPIMode_Day)
    {
        _tbTrafficRecord.hidden=YES;
    }
    else
    {
        _tbTrafficRecord.hidden=NO;
    }
    
    if (_mode == KPIMode_Hour)
    {
        
        [_tfTraffic setUserInteractionEnabled:NO];
        
        _tfTraffic.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%04d-%02d-%02d",_TrafficDataDay.nYear,_TrafficDataDay.nMonth,_TrafficDataDay.nDay]];
        NSTimeInterval nowDate=[[NSDate date] timeIntervalSince1970]*1;
        NSTimeInterval currentDate=[date timeIntervalSince1970]*1;
        if (nowDate>currentDate+86400*30)
        {
            [_tfTraffic setUserInteractionEnabled:NO];
        }
        else
        {
            [_tfTraffic setUserInteractionEnabled:YES];
        }
        
        
        
        _tfTraffic.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        
    }
    
    [_tbTrafficRecord reloadData];
}

- (void)locationTapped:(UITapGestureRecognizer *)tap
{
    [self endEditing:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayTrafficDataHour.count;
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
    RPTrafficRecordCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPTrafficRecordCell"];
    if (cell==nil) {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPTrafficRecordCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
        cell.delegate = self;
    }
    
    cell.trafficData=[_arrayTrafficDataHour objectAtIndex:indexPath.row];
    
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
    [self endEditing:YES];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
//    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%04d-%02d-%02d",_TrafficDataDay.nYear,_TrafficDataDay.nMonth,_TrafficDataDay.nDay]];
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
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField!=_tfDate)
    {
        _bSaved=NO;
        _viewRed.hidden=NO;
    }
    
    _rcFrameRectOrg = self.frame;
    [UIView beginAnimations:nil context:nil];
    self.frame = CGRectMake(self.frame.origin.x, -50, self.frame.size.width, self.frame.size.height);
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
    if (_tfTraffic.text.length>11)//加了逗号
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
                _TrafficDataDay.nTraffic =[self deleteString:_tfTraffic.text].integerValue;
                
                NSMutableArray * array = [[NSMutableArray alloc] init];
                [array addObject:_TrafficDataDay];
                [[RPSDK defaultInstance]SetKPITrafficData:_storeSelected.strStoreId TrafficData:array Success:^(id idResult) {

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
                [[RPSDK defaultInstance]SetKPITrafficData:_storeSelected.strStoreId TrafficData:_arrayTrafficDataHour Success:^(id idResult) {
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
    [[RPSDK defaultInstance] GetKPITrafficDataList:_storeSelected.strStoreId Success:^(NSMutableArray * arrayResult) {
        _arrayTrafficData = arrayResult;
        [self SetDate:_TrafficDate];
        [_delegate OnUpdate];
        NSString *s=NSLocalizedStringFromTableInBundle(@"modifications is saving",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showSuccessWithStatus:s];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
    }];
}


-(void)OnValueBeginChange:(UITableViewCell *)cell
{
    _bSaved=NO;
    _viewRed.hidden=NO;
    _rcFrameRectOrg = _viewBackground.frame;
    
    [UIView beginAnimations:nil context:nil];
    _viewBackground.frame = CGRectMake(_viewBackground.frame.origin.x, -_tbTrafficRecord.frame.origin.y, _viewBackground.frame.size.width, _viewBackground.frame.size.height);
    [UIView commitAnimations];
}

-(void)OnValueChange
{
    if (_mode == KPIMode_Hour) {
        _TrafficDataDay.nTraffic=0;
        for (KPITrafficData * dataHour in _arrayTrafficDataHour)
        {
            if (dataHour.nTraffic > 0) _TrafficDataDay.nTraffic += dataHour.nTraffic;
            
        }
    }
    if (_TrafficDataDay.nTraffic >= 0) _tfTraffic.text = [RPSDK numberFormatter:[NSNumber numberWithInteger:_TrafficDataDay.nTraffic]];
    else
        _tfTraffic.text = @"";
    
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
    self.frame = _rcFrameRectOrg;
    [UIView commitAnimations];
}

-(BOOL)OnBack
{
    
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
                [_delegate OnChangeTrafficRecordEnd];
                
            }
            else if(indexButton==0)
            {
                _bSaved=NO;
                _viewRed.hidden=NO;
            }
            else
            {
                [self OnSave:nil];
                [_delegate OnChangeTrafficRecordEnd];
            }
            
            
        }otherButtonTitles:strSave,strDont, nil];
        [alertView show];
        return NO;
        
    }
    else
    {
        return YES;
    }
   
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
    
    NSDate * date = [_TrafficDate copy];
    while (1) {
        BOOL bFound = NO;
        date = [date dateByAddingTimeInterval:-24*60*60];
        NSTimeInterval nowDate=[[NSDate date] timeIntervalSince1970]*1;
        NSTimeInterval currentDate=[date timeIntervalSince1970]*1;
        if (nowDate>currentDate+86400*30)
        {
            return;
        }
        for (KPITrafficData * dataTraffic in _arrayTrafficData) {
            NSDate * dateTraffic = [dateFormatter dateFromString:[NSString stringWithFormat:@"%04d-%02d-%02d",dataTraffic.nYear,dataTraffic.nMonth,dataTraffic.nDay]];
            
            if ([date isEqualToDate:dateTraffic]) {
                bFound = YES;
                break;
            }
            if ([dateTraffic compare:date] == NSOrderedAscending) {
                break;
            }
        }
        
        if (!bFound) {
            [self SetDate:date];
            break;
        }
    }

}
- (IBAction)FindEmptyPreDay:(id)sender
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
