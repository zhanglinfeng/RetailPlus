//
//  RPCallRecordView.m
//  RetailPlus
//
//  Created by lin dong on 14-3-14.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCallRecordView.h"
#import "SVProgressHUD.h"
#import "RPCallRecordCell.h"
#import "RPBlockUIAlertView.h"
#import "RPBlockUISelectView.h"
extern NSBundle * g_bundleResorce;

@implementation RPCallRecordList
@end

@implementation RPCallRecord
@end

@implementation RPCallRecordView

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
    _arrayColor = [NSMutableArray arrayWithObjects:
                   [UIColor colorWithRed:221/255.0 green:68/255.0 blue:68/255.0 alpha:1],
                   [UIColor colorWithRed:252/255.0 green:136/255.0 blue:53/255.0 alpha:1],
                   [UIColor colorWithRed:252/255.0 green:176/255.0 blue:43/255.0 alpha:1],
                   [UIColor colorWithRed:164/255.0 green:186/255.0 blue:74/255.0 alpha:1],
                   [UIColor colorWithRed:81/255.0 green:180/255.0 blue:64/255.0 alpha:1],
                   [UIColor colorWithRed:7/255.0 green:194/255.0 blue:161/255.0 alpha:1],
                   [UIColor colorWithRed:76/255.0 green:128/255.0 blue:211/255.0 alpha:1],
                   [UIColor colorWithRed:70/255.0 green:93/255.0 blue:193/255.0 alpha:1],
                   [UIColor colorWithRed:152/255.0 green:70/255.0 blue:194/255.0 alpha:1],
                   [UIColor colorWithRed:220/255.0 green:77/255.0 blue:121/255.0 alpha:1],
                   nil];
    
    _viewFrame.layer.cornerRadius = 10;
    _viewData.layer.cornerRadius=6;
//    _viewData.layer.borderColor=[UIColor colorWithWhite:0.5 alpha:1].CGColor;
//    _viewData.layer.borderWidth=1;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSDate *nowDate=[NSDate date];
    _date=nowDate;
    _lbYear.text=[NSString stringWithFormat:@"%d",[RPSDK DateToYear:nowDate]];
    _lbMonth.text=[formatter stringFromDate:nowDate];

    _pickDate = [[RPDatePicker alloc] init:_tfDate Format:formatter curDate:nowDate canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    
    _label=[[UILabel alloc]initWithFrame:CGRectMake(80, 160, 160, 30)];
    _label.font=[UIFont systemFontOfSize:12];
    _label.textColor=[UIColor colorWithWhite:0.8 alpha:1];
    _label.numberOfLines=0;
    _label.backgroundColor=[UIColor clearColor];
    _label.textAlignment=NSTextAlignmentCenter;
    _label.text=NSLocalizedStringFromTableInBundle(@"There is NO call record in this store yet...",@"RPString", g_bundleResorce,nil);
    [self insertSubview:_label aboveSubview:_tbRecord];
    
    NSArray *array = [g_bundleResorce loadNibNamed:@"CustomView" owner:self options:nil];
    _viewStoreList = [array objectAtIndex:1];
    _viewStoreList.delegate = self;
    _viewStoreList.sitType = SituationType_CourtesyCall;
    
    _indexCalledBy=-1;
    _indexCustomer=-1;
    _indexPurpose=-1;
    NSString *strType1=NSLocalizedStringFromTableInBundle(@"PURPOSE ANALYSIS",@"RPString", g_bundleResorce,nil);
    NSString *strType2=NSLocalizedStringFromTableInBundle(@"CALLER ANALYSIS",@"RPString", g_bundleResorce,nil);
    NSString *strType3=NSLocalizedStringFromTableInBundle(@"CUSTOMER ANALYSIS",@"RPString", g_bundleResorce,nil);
    
    _arrayAnalysisType=[[NSArray alloc]initWithObjects:strType1,strType2,strType3, nil];
    _nChartType = 0;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}
-(BOOL)OnBack
{
    if (_bCallRecord)
    {
        [_viewCallRecord OnBack];
        [self dismissView:_viewCallRecord];
        _bCallRecord=NO;
        return NO;
    }
    if (_bStoreList)
    {
        [self dismissView:_viewStoreList];
        _bStoreList=NO;
        return NO;
    }
    return YES;
}
-(void)setArrayType:(NSArray *)arrayType
{
    _arrayType=arrayType;
}
-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _storeSelected=storeSelected;
    _lbStoreName.text=_storeSelected.strStoreName;
    _lbAddress.text= [NSString stringWithFormat:@"%@",_storeSelected.strBrandName];
    
    [_lbAddress Start];
    [_lbStoreName Start];
}
-(void)OnSelectedStore:(StoreDetailInfo *)store
{
    _bStoreList = NO;
    
    _storeSelected=store;
    _lbStoreName.text=_storeSelected.strStoreName;
    _lbAddress.text=[NSString stringWithFormat:@"%@",_storeSelected.strBrandName];
    
    [_lbAddress Start];
    [_lbStoreName Start];
    [self dismissView:_viewStoreList];
    [self ReloadData];
}
-(void)setUser:(UserDetailInfo *)user
{
    _user = user;
}
-(void)ReloadData
{
    
    _tfCustomer.text=@"";
    _tfPurpose.text=@"";
    _tfStaff.text=@"";
    _indexPurpose=-1;
    _indexCustomer=-1;
    _indexCalledBy=-1;
    if (!_viewMenu2.hidden)//如果菜单2展开，就缩回
    {
        [self OnMenu2:nil];
    }
    if (!_viewMenu1.hidden)//如果菜单1展开，就缩回
    {
        [self OnMenu1:nil];
    }
    if (_arrayRecord) {
        [_arrayRecord removeAllObjects];
        [_arrayRecordShow removeAllObjects];
        [_tbRecord reloadData];
    }
    
    [SVProgressHUD showWithStatus: NSLocalizedStringFromTableInBundle(@"Loading...",@"RPString", g_bundleResorce,nil)];
    
    [[RPSDK defaultInstance] GetCcInfoByStoreId:_storeSelected.strStoreId Date:_date Success:^(NSMutableArray * arrayResult) {
        _arrayRecord = arrayResult;
        //_arrayRecordShow = _arrayRecord;
        if (_arrayRecord.count==0)
        {
            _btMenu1.userInteractionEnabled=NO;
            _btMenu2.userInteractionEnabled=NO;
        }
        else
        {
            _btMenu1.userInteractionEnabled=YES;
            _btMenu2.userInteractionEnabled=YES;
        }
        _listRecord = [self CalcRecordList:_arrayRecord];
        [self FiltRecord:_tfCustomer.text CalledBy:_tfStaff.text Purpose:_tfPurpose.text HideFailed:_bHideFailed];
        [_tbRecord reloadData];
        
        
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
        _btMenu1.userInteractionEnabled=NO;
        _btMenu2.userInteractionEnabled=NO;
        [_tbRecord reloadData];
        [SVProgressHUD dismiss];
    }];
}
-(void)setEntrance:(int)entrance
{
    _entrance=entrance;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _viewCallRecord.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewCallRecord];
    [UIView beginAnimations:nil context:nil];
    _viewCallRecord.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    CourtesyCallInfo *info=(CourtesyCallInfo *)[_arrayRecordShow objectAtIndex:indexPath.row];
    if ([info.userCaller.strUserId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId])
    {
        _entrance=3;//3代表从自己记录进入，4代表从别人记录进入该界面
    }
    else
    {
        _entrance=4;
    }
    _viewCallRecord.entrance=_entrance;
    _viewCallRecord.delegateOKToRecordList=self;
    
    _viewCallRecord.courtesyCallInfo=info;
    _viewCallRecord.customer=info.customer;
    for (int i=0; i<_arrayType.count; i++)
    {
        if ([info.strCourtesyCallTypeId isEqualToString:[[_arrayType objectAtIndex:i]strCourtesyCallTypeId]])
        {
            _viewCallRecord.callType=[_arrayType objectAtIndex:i];
            break;
        }
    }
    _bCallRecord=YES;
    
    [self endEditing:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_arrayRecordShow.count==0)
    {
        _label.hidden=NO;
        
    }
    else
    {
        _label.hidden=YES;
    }
    return _arrayRecordShow.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPCallRecordCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPCallRecordCell"];
    if (cell==nil)
    {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPCallRecordCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
    }
    cell.arrayType=_arrayType;
    cell.info = (CourtesyCallInfo *)[_arrayRecordShow objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * s=NSLocalizedStringFromTableInBundle(@"DELETE",@"RPString", g_bundleResorce,nil);
    return s;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    CourtesyCallInfo *info = [_arrayRecordShow objectAtIndex:indexPath.row];
    [[RPSDK defaultInstance] DeleteCourtesyCallInfo:info.strID Success:^(id idResult) {
        [_arrayRecord removeObject:info];
        [_arrayRecordShow removeObject:info];
        [_tbRecord reloadData];
        [self ReloadChart];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_user.strUserId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId]) {
        return YES;
    }
    return NO;
}




-(void)RecordOKToRecordList
{
    [self dismissView:_viewCallRecord];
    _bCallRecord=NO;
    [self setUser:_user];
    [self ReloadData];
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}

-(IBAction)OnQuit:(id)sender
{
    [self endEditing:YES];
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to exit?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
             [self.delegate endCallRecordList];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
   
}

- (IBAction)OnSelectDate:(id)sender
{
    [_tfDate becomeFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _tfDate) {
        _date=[_pickDate GetDate];
        _lbYear.text=[NSString stringWithFormat:@"%d",[RPSDK DateToYear:_date]];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM"];
        _lbMonth.text=[formatter stringFromDate:_date];
        [self ReloadData];
    }
}


- (IBAction)OnSelectStore:(id)sender
{
    _viewStoreList.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _viewStoreList.tfSearch.text=@"";
//    [self insertSubview:_viewStoreList belowSubview:_viewfoot];
    [self addSubview:_viewStoreList];
    [UIView beginAnimations:nil context:nil];
    _viewStoreList.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bStoreList=YES;
    [_viewStoreList reloadStore];
}

- (IBAction)OnMenu1:(id)sender
{
    if (!_viewMenu2.hidden)//如果菜单2展开，就缩回
    {
        [self OnMenu2:nil];
    }
    
    _viewMenu1.hidden=!_viewMenu1.hidden;
     _ivTriangle1.hidden=_viewMenu1.hidden;
    if (!_viewMenu1.hidden)
    {
       
        _viewMenu1.frame=CGRectMake(0, -_viewMenu1.frame.size.height, _viewMenu1.frame.size.width, _viewMenu1.frame.size.height);
        [UIView beginAnimations:nil context:nil];
        _tbRecord.frame=CGRectMake(_tbRecord.frame.origin.x, _tbRecord.frame.origin.y+_viewMenu1.frame.size.height, _tbRecord.frame.size.width, _tbRecord.frame.size.height-_viewMenu1.frame.size.height);
        _viewMenu1.frame=CGRectMake(0, 42, _viewMenu1.frame.size.width, _viewMenu1.frame.size.height);
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        _tbRecord.frame=CGRectMake(_tbRecord.frame.origin.x, _tbRecord.frame.origin.y-_viewMenu1.frame.size.height, _tbRecord.frame.size.width, _tbRecord.frame.size.height+_viewMenu1.frame.size.height);
        [UIView commitAnimations];
    }
}

- (IBAction)OnMenu2:(id)sender
{
    if (!_viewMenu1.hidden)//如果菜单1展开，就缩回
    {
        [self OnMenu1:nil];
    }
    
    _viewMenu2.hidden=!_viewMenu2.hidden;
    _ivTriangle2.hidden=_viewMenu2.hidden;
    if (!_viewMenu2.hidden)
    {
        _viewMenu2.frame=CGRectMake(0, -_viewMenu2.frame.size.height, _viewMenu2.frame.size.width, _viewMenu2.frame.size.height);
        [UIView beginAnimations:nil context:nil];
        _tbRecord.frame=CGRectMake(_tbRecord.frame.origin.x, _tbRecord.frame.origin.y+_viewMenu2.frame.size.height, _tbRecord.frame.size.width, _tbRecord.frame.size.height-_viewMenu2.frame.size.height);
        _viewMenu2.frame=CGRectMake(0, 42, _viewMenu2.frame.size.width, _viewMenu2.frame.size.height);
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        _tbRecord.frame=CGRectMake(_tbRecord.frame.origin.x, _tbRecord.frame.origin.y-_viewMenu2.frame.size.height, _tbRecord.frame.size.width, _tbRecord.frame.size.height+_viewMenu2.frame.size.height);
        [UIView commitAnimations];
    }
}
-(void)changePic
{
    if (_indexCalledBy!=-1||_indexCustomer!=-1||_indexPurpose!=-1)
    {
        [_btMenu1 setBackgroundImage:[UIImage imageNamed:@"button_filter_active@2x.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_btMenu1 setBackgroundImage:[UIImage imageNamed:@"button_filter_nouse@2x.png"] forState:UIControlStateNormal];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_tfCustomer==textField)
    {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (int i=0; i<_listRecord.arrayCustomer.count; i++)
        {
            [array addObject:((RPCallRecord*)[_listRecord.arrayCustomer objectAtIndex:i]).strKey];
        }
        
        NSString *strDesc=NSLocalizedStringFromTableInBundle(@"Select customer",@"RPString", g_bundleResorce,nil);
        
        RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:strDesc clickButton:^(NSInteger indexButton) {
            if (indexButton>-1) {
                _indexCustomer=indexButton;
                //            _callType=[_arrayType objectAtIndex:indexButton];
                //            _courtesyCallInfo.strCourtesyCallTypeId=_callType.strCourtesyCallTypeId;
                _tfCustomer.text = ((RPCallRecord*)[_listRecord.arrayCustomer objectAtIndex:_indexCustomer]).strKey;
                _btDeleteCustomer.hidden=NO;
                [self FiltRecord:_tfCustomer.text CalledBy:_tfStaff.text Purpose:_tfPurpose.text HideFailed:_bHideFailed];
                [self changePic];
            }
        } curIndex:_indexCustomer  selectTitles:array];
        [selectView show];
        
        return NO;
    }
    
    if (_tfStaff==textField)
    {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (int i=0; i<_listRecord.arrayCalledBy.count; i++)
        {
            [array addObject:((RPCallRecord*)[_listRecord.arrayCalledBy objectAtIndex:i]).strKey];
        }
        
        NSString *strDesc=NSLocalizedStringFromTableInBundle(@"Select staff",@"RPString", g_bundleResorce,nil);
        
        RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:strDesc clickButton:^(NSInteger indexButton) {
            if (indexButton>-1) {
                _indexCalledBy=indexButton;
                //            _callType=[_arrayType objectAtIndex:indexButton];
                //            _courtesyCallInfo.strCourtesyCallTypeId=_callType.strCourtesyCallTypeId;
                _tfStaff.text = ((RPCallRecord*)[_listRecord.arrayCalledBy objectAtIndex:_indexCalledBy]).strKey;
                
                _btDeleteStaff.hidden=NO;
                [self FiltRecord:_tfCustomer.text CalledBy:_tfStaff.text Purpose:_tfPurpose.text HideFailed:_bHideFailed];
                [self changePic];
            }
        } curIndex:_indexCalledBy  selectTitles:array];
        [selectView show];
        return NO;
    }
    
    if (_tfPurpose==textField)
    {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (int i=0; i<_listRecord.arrayPurpose.count; i++)
        {
            [array addObject:((RPCallRecord*)[_listRecord.arrayPurpose objectAtIndex:i]).strKey];
        }
        
        NSString *strDesc=NSLocalizedStringFromTableInBundle(@"Select purpose",@"RPString", g_bundleResorce,nil);
        
        RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:strDesc clickButton:^(NSInteger indexButton) {
            if (indexButton>-1) {
                _indexPurpose=indexButton;
                //            _callType=[_arrayType objectAtIndex:indexButton];
                //            _courtesyCallInfo.strCourtesyCallTypeId=_callType.strCourtesyCallTypeId;
                _tfPurpose.text = ((RPCallRecord*)[_listRecord.arrayPurpose objectAtIndex:_indexPurpose]).strKey;
                _btDeletePurpose.hidden=NO;
                [self FiltRecord:_tfCustomer.text CalledBy:_tfStaff.text Purpose:_tfPurpose.text HideFailed:_bHideFailed];
                [self changePic];
            }
        } curIndex:_indexPurpose  selectTitles:array];
        [selectView show];
        return NO;
    }
    return YES;
}
- (IBAction)OnDeleteCustomer:(id)sender
{
    _tfCustomer.text=@"";
    _indexCustomer=-1;
    _btDeleteCustomer.hidden=YES;
    [self FiltRecord:_tfCustomer.text CalledBy:_tfStaff.text Purpose:_tfPurpose.text HideFailed:_bHideFailed];
    [self changePic];
}



- (IBAction)OnDelectCalledBy:(id)sender
{
    _tfStaff.text=@"";
    _indexCalledBy=-1;
    _btDeleteStaff.hidden=YES;
    [self FiltRecord:_tfCustomer.text CalledBy:_tfStaff.text Purpose:_tfPurpose.text HideFailed:_bHideFailed];
    [self changePic];
}


- (IBAction)OnDeletePurpose:(id)sender
{
    _tfPurpose.text=@"";
    _indexPurpose=-1;
    _btDeletePurpose.hidden=YES;
    [self FiltRecord:_tfCustomer.text CalledBy:_tfStaff.text Purpose:_tfPurpose.text HideFailed:_bHideFailed];
    [self changePic];
}


- (IBAction)OnSelectType:(id)sender
{
    NSString *strDesc=NSLocalizedStringFromTableInBundle(@"Select analysis type",@"RPString", g_bundleResorce,nil);
    
    RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:strDesc clickButton:^(NSInteger indexButton) {
        if (indexButton>-1) {
            _nChartType=indexButton;
            _lbType.text=[_arrayAnalysisType objectAtIndex:_nChartType];
            [self ReloadChart];
        }
    } curIndex:_nChartType  selectTitles:_arrayAnalysisType];
    [selectView show];
}

- (IBAction)OnNext:(id)sender
{
    [_viewChart next];
}


-(RPCallRecordList *)CalcRecordList:(NSMutableArray *)arrayList
{
    RPCallRecordList * listRecord = [[RPCallRecordList alloc] init];
    listRecord.arrayCustomer = [[NSMutableArray alloc] init];
    listRecord.arrayCalledBy = [[NSMutableArray alloc] init];
    listRecord.arrayPurpose = [[NSMutableArray alloc] init];
    for (CourtesyCallInfo * info in arrayList)
    {
        NSString * strCustomerKey =  [NSString stringWithFormat:@"%@",info.customer.strFirstName];
        NSString * strCalledByKey = [NSString stringWithFormat:@"%@",info.userCaller.strFirstName];
        NSString * strPurposeKey = @"";
        for (int i=0; i<_arrayType.count; i++)
        {
            if ([info.strCourtesyCallTypeId isEqualToString:[[_arrayType objectAtIndex:i]strCourtesyCallTypeId]])
            {
                strPurposeKey =[[_arrayType objectAtIndex:i]strCourtesyCallTips];
                break;
            }
        }
        
        BOOL bFound = NO;
        for (RPCallRecord * record in listRecord.arrayCustomer) {
            if ([record.strKey isEqualToString:strCustomerKey]) {
                record.nCount ++;
                bFound = YES;
                break;
            }
        }
        if (!bFound) {
            RPCallRecord * record = [[RPCallRecord alloc] init];
            record.strKey = strCustomerKey;
            record.nCount = 1;
            [listRecord.arrayCustomer addObject:record];
        }
        
        bFound = NO;
        for (RPCallRecord * record in listRecord.arrayCalledBy) {
            if ([record.strKey isEqualToString:strCalledByKey]) {
                record.nCount ++;
                bFound = YES;
                break;
            }
        }
        if (!bFound) {
            RPCallRecord * record = [[RPCallRecord alloc] init];
            record.strKey = strCalledByKey;
            record.nCount = 1;
            [listRecord.arrayCalledBy addObject:record];
        }
        
        bFound = NO;
        for (RPCallRecord * record in listRecord.arrayPurpose) {
            if ([record.strKey isEqualToString:strPurposeKey]) {
                record.nCount ++;
                bFound = YES;
                break;
            }
        }
        if (!bFound) {
            RPCallRecord * record = [[RPCallRecord alloc] init];
            record.strKey = strPurposeKey;
            record.nCount = 1;
            [listRecord.arrayPurpose addObject:record];
        }
    }
    return listRecord;
}

- (IBAction)OnHideFailed:(id)sender
{
    _bHideFailed = !_bHideFailed;
    _btnHideFailed.selected = _bHideFailed;
    
    [self FiltRecord:_tfCustomer.text CalledBy:_tfStaff.text Purpose:_tfPurpose.text HideFailed:_bHideFailed];
}

-(void)ReloadChart
{
    NSMutableArray * arrayColor = [[NSMutableArray alloc] init];
    NSMutableArray * arrayValue = [[NSMutableArray alloc] init];
    
    NSMutableArray * arrayType = nil;
    switch (_nChartType) {
        case 0:
            arrayType =_listRecordShow.arrayPurpose;
            break;
        case 1:
            arrayType = _listRecordShow.arrayCalledBy;
            break;
        case 2:
            arrayType = _listRecordShow.arrayCustomer;
            break;
        default:
            break;
    }
    NSInteger nIndex = 0;
    NSInteger nCount = 0;
    for (RPCallRecord * record in arrayType) {
        [arrayColor addObject:[_arrayColor objectAtIndex:nIndex % _arrayColor.count]];
        [arrayValue addObject:[NSNumber numberWithInteger:record.nCount]];
        nCount += record.nCount;
        nIndex++;
    }
    
    if (nIndex == 0) {
        _lbCurrent.text=@"";
        _lbCurrentData.text=@"";
        _lbTotal.text=@"";
    }
    
    [_viewChart removeFromSuperview];
    if (arrayValue.count > 0) {
        _viewChart = [[PieChartView alloc]initWithFrame:CGRectMake(0 , 0, _viewChartFrame.frame.size.width , _viewChartFrame.frame.size.width) withValue:arrayValue withColor:arrayColor];
        _viewChart.delegate = self;
        [_viewChartFrame addSubview:_viewChart];
        
        [_viewChart reloadChart];
    }
}

-(void)FiltRecord:(NSString *)strCustomer CalledBy:(NSString *)strCalledBy Purpose:(NSString *)strPurpose HideFailed:(BOOL)bHideFailed
{
    _arrayRecordShow = [[NSMutableArray alloc] init];
    for (CourtesyCallInfo * info in _arrayRecord)
    {
        NSString * strCustomerGet = [NSString stringWithFormat:@"%@",info.customer.strFirstName];
        NSString * strCalledByGet = [NSString stringWithFormat:@"%@",info.userCaller.strFirstName];
        NSString * strPurposeGet = @"";
        for (int i=0; i<_arrayType.count; i++)
        {
            if ([info.strCourtesyCallTypeId isEqualToString:[[_arrayType objectAtIndex:i]strCourtesyCallTypeId]])
            {
                strPurposeGet =[[_arrayType objectAtIndex:i]strCourtesyCallTips];
                break;
            }
        }
        
        BOOL bAdd = YES;
        if (strCustomer.length > 0 && ![strCustomer isEqualToString:strCustomerGet]) bAdd = NO;
        if (strCalledBy.length > 0 && ![strCalledBy isEqualToString:strCalledByGet]) bAdd = NO;
        if (strPurpose.length > 0 && ![strPurpose isEqualToString:strPurposeGet]) bAdd = NO;
        if (bHideFailed) {
            if (info.bSuccess == NO) bAdd = NO;
        }
        
        if (bAdd) {
            [_arrayRecordShow addObject:info];
        }
    }
    _lbResultCount.text=[NSString stringWithFormat:@"%d",_arrayRecordShow.count];
    _listRecordShow = [self CalcRecordList:_arrayRecordShow];
    
    [self ReloadChart];
    [_tbRecord reloadData];
}

- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per
{
    NSMutableArray * arrayType = nil;
    switch (_nChartType) {
        case 0:
            arrayType =_listRecordShow.arrayPurpose;
            break;
        case 1:
            arrayType = _listRecordShow.arrayCalledBy;
            break;
        case 2:
            arrayType = _listRecordShow.arrayCustomer;
            break;
        default:
            break;
    }
    
    float fPercent = 0;
    if (arrayType.count > 0) {
        RPCallRecord * record = [arrayType objectAtIndex:index];
        //    _lbChartDesc.text = [NSString stringWithFormat:@"%@ %d",record.strKey,record.nCount];
        _lbCurrent.text=[NSString stringWithFormat:@"%@",record.strKey];
        _lbCurrentData.text=[NSString stringWithFormat:@"%d",record.nCount];
        _lbCurrent.textColor=[_arrayColor objectAtIndex:index%_arrayColor.count];
        _lbCurrentData.textColor=[_arrayColor objectAtIndex:index%_arrayColor.count];
        _lbCurrentData.text=[NSString stringWithFormat:@"%d",record.nCount];
        _lbTotal.text=[NSString stringWithFormat:@"%d",_arrayRecordShow.count];
        
        if (_arrayRecordShow.count > 0) {
            fPercent = (float)record.nCount / _arrayRecordShow.count * 100;
        }
    }
    else
    {
        _lbCurrent.text=@"";
        _lbCurrentData.text=@"";
        _lbCurrent.textColor=[_arrayColor objectAtIndex:index%_arrayColor.count];
        _lbCurrentData.textColor=[_arrayColor objectAtIndex:index%_arrayColor.count];
        _lbCurrentData.text=@"";
        _lbTotal.text=@"";
    }
    
    [_viewChart setAmountText:[NSString stringWithFormat:@"%0.1f%%",fPercent] withColor:[_arrayColor objectAtIndex:index%_arrayColor.count]];
}
@end
