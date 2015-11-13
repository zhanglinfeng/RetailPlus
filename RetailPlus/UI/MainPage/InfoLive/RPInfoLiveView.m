//
//  RPInfoLiveView.m
//  RetailPlus
//
//  Created by zwhe on 14-1-23.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPInfoLiveView.h"
#import "RPTrafficInfoCell.h"
#import "RPBlockUIAlertView.h"
#import "RPBlockUISelectView.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@implementation RPInfoLiveView

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
    _viewBackground.layer.shadowOffset = CGSizeMake(0, 1);
    _viewBackground.layer.shadowRadius =3.0;
    _viewBackground.layer.shadowColor =[UIColor blackColor].CGColor;
    _viewBackground.layer.shadowOpacity =0.5;
    _view1.frame=CGRectMake(0, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
    [_svFrame addSubview:_view1];

    
    _view2.frame=CGRectMake(_svFrame.frame.size.width, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
    [_svFrame addSubview:_view2];
//    _view2.viewController=_viewController;
    
    _svFrame.contentSize=CGSizeMake(_svFrame.frame.size.width, _svFrame.frame.size.height);
    _svFrame.pagingEnabled=YES;
    //不显示水平滑动条
    _svFrame.showsVerticalScrollIndicator=NO;

//    _view1.trendDelegate=self;
    
    UILongPressGestureRecognizer *longPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong1:)];
    longPress1.minimumPressDuration = 0.8; //定义按的时间
    [_bt1 addGestureRecognizer:longPress1];
    
    UILongPressGestureRecognizer *longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong2:)];
    longPress2.minimumPressDuration = 0.8; //定义按的时间
    [_bt2 addGestureRecognizer:longPress2];    
    
    _currentString1=NSLocalizedStringFromTableInBundle(@"Traffic",@"RPString", g_bundleResorce,nil);
    _currentString2=NSLocalizedStringFromTableInBundle(@"TraQty",@"RPString", g_bundleResorce,nil);
    _str1 = NSLocalizedStringFromTableInBundle(@"Conversion Rate",@"RPString", g_bundleResorce,nil);
    _str2=NSLocalizedStringFromTableInBundle(@"ProQty",@"RPString", g_bundleResorce,nil);
    _str3=NSLocalizedStringFromTableInBundle(@"Amount",@"RPString", g_bundleResorce,nil);
    _array=[[NSMutableArray alloc]initWithObjects:_currentString1,_currentString2,_str1,_str2,_str3, nil];
    _array1=[[NSMutableArray alloc]initWithObjects:_currentString1,_str1,_str2,_str3, nil];
    _array2=[[NSMutableArray alloc]initWithObjects:_currentString2,_str1,_str2,_str3, nil];
    _parentNote=@"";
    _node=@"";
    
    _arrayNode=[[NSMutableArray alloc]init];
    _arrayName=[[NSMutableArray alloc]init];


    _TagUp1=0;
    _TagUp2=0;
   
    //cell长按事件
    UILongPressGestureRecognizer *longPressReger =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPressReger.minimumPressDuration = 0.5;
    [_tbTrafficInfo addGestureRecognizer:longPressReger];
    
    _nCellIndex=-1;
    
    _dateRange=[[KPIDateRange alloc]init];
    _dateRange.type=KPIDateRangeType_Day;
    _dateRange.date=[NSDate date];
    _view1.dateRange=_dateRange;
    _view2.dateRange=_dateRange;
    
    _lbCity.text=@"";
    _lb1.text=_currentString1;
    _lb2.text=_currentString2;
    
    [self loadData:YES];
}

//cell长按事件
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:_tbTrafficInfo];
    NSIndexPath *indexPath = [_tbTrafficInfo indexPathForRowAtPoint:point];
    if (indexPath==nil)return;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
 //       NSLog(@"UIGestureRecognizerStateBegan===%d",indexPath.row);
       
        NSString * str =@"";
        [SVProgressHUD showWithStatus:str];
    
        KPIDomainData *kpiDomainData = [_arrayDomainKPIData objectAtIndex:indexPath.row];
        [[RPSDK defaultInstance]GetSubDomainKPIData:kpiDomainData.strDomainID DateRange:_dateRange Success:^(NSMutableArray * arrayResult) {
            
            [SVProgressHUD dismiss];
            
            if (arrayResult.count > 0) {
                _parentNote=_node;
                _lbCity.text=kpiDomainData.strDomainName;
                [_arrayNode addObject:_parentNote];
                 _node=kpiDomainData.strDomainID;
                [_arrayName addObject:kpiDomainData.strDomainName];
                
                _nCellIndex=0;
                _arrayDomainKPIData=arrayResult;
                
                KPIDomainData *kpiDomainData = [_arrayDomainKPIData objectAtIndex:_nCellIndex];
                _view1.domainData = kpiDomainData;
                _view2.domainData = kpiDomainData;
                
                [_tbTrafficInfo reloadData];
                
                [self getMax];
                
                _ivParent.image=[UIImage imageNamed:@"button_go_parent@2x.png"];
            }
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD dismiss];
        }];
        
        
        
    }
//    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"UIGestureRecognizerStateChanged===%d",indexPath.row);
//    }
//    
//    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"UIGestureRecognizerStateEnded===%d",indexPath.row);
//    }
    
    
}

-(void)loadData:(BOOL)bChangeIndex
{
    NSString * str =@"";
    
    [SVProgressHUD showWithStatus:str];
    [[RPSDK defaultInstance]GetSubDomainKPIData:_node DateRange:_dateRange Success:^(NSMutableArray * arrayResult) {
        [SVProgressHUD dismiss];
        if (arrayResult.count > 0) {
            _arrayDomainKPIData=arrayResult;
            [self getMax];
       
            if(bChangeIndex) _nCellIndex=0;
            
            KPIDomainData *kpiDomainData = [_arrayDomainKPIData objectAtIndex:_nCellIndex];
            _view1.domainData = kpiDomainData;
            _view2.domainData = kpiDomainData;
            
            [_tbTrafficInfo reloadData];
            _ivParent.image=[UIImage imageNamed:@"button_go_parent_noactive@2x.png"];
            _iv1.image=[UIImage imageNamed:@"button_arrange_noactive@2x.png"];
            _iv2.image=[UIImage imageNamed:@"button_arrange_noactive@2x.png"];
        }
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
    }];
}
-(void)btnLong1:(UILongPressGestureRecognizer *)gestureRecognizer
{
//    KPIDomainData *kpiDomainData = [_arrayDomainKPIData objectAtIndex:0];
//    _view1.strDomainId = kpiDomainData.strDomainID;
//    _view2.strDomainId = kpiDomainData.strDomainID;
//    _nCellIndex=0;
    
    if([gestureRecognizer state]==UIGestureRecognizerStateBegan)
    {
      
        NSString *mode=NSLocalizedStringFromTableInBundle(@"Select the column you want to display",@"RPString", g_bundleResorce,nil);
        
        RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:mode clickButton:^(NSInteger indexButton) {
            if (indexButton>-1) {
                _strIndex1=indexButton;
                
                _currentString1=[_array1 objectAtIndex:indexButton];
                _lb1.text=_currentString1;
                _view1.lbLeft.text=_currentString1;
                _view2.lbLeft.text=_currentString1;
                [_view1 ReloadChart];
                [_view2 ReloadChart];
                
                _array2=[self getArray:_currentString1];
                [_tbTrafficInfo reloadData];
            }
            
        } curIndex:_strIndex1  selectTitles:_array1];
        [selectView show];
        
    }
   
    
    
}
-(void)btnLong2:(UILongPressGestureRecognizer *)gestureRecognizer
{
//    KPIDomainData *kpiDomainData = [_arrayDomainKPIData objectAtIndex:0];
//    _view1.strDomainId = kpiDomainData.strDomainID;
//    _view2.strDomainId = kpiDomainData.strDomainID;
//    _nCellIndex=0;
    if([gestureRecognizer state]==UIGestureRecognizerStateBegan)
    {
 
        NSString *mode=NSLocalizedStringFromTableInBundle(@"Select the column you want to display",@"RPString", g_bundleResorce,nil);
        
        RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:mode clickButton:^(NSInteger indexButton) {
            if (indexButton>-1) {
                _strIndex2=indexButton;
                
                _currentString2=[_array2 objectAtIndex:indexButton];
                _lb2.text=_currentString2;
                _view1.lbRight.text=_currentString2;
                _view2.lbRight.text=_currentString2;
                [_view1 ReloadChart];
                [_view2 ReloadChart];
                
                _array1=[self getArray:_currentString2];
                [_tbTrafficInfo reloadData];
            }
            
        } curIndex:_strIndex2  selectTitles:_array2];
        [selectView show];
        
        
    }
}

-(NSMutableArray*)getArray:(NSString *)string
{
    NSMutableArray *arraytemp=[[NSMutableArray alloc]init];
    for (int i=0;i<_array.count;i++)
    {
        
        if (string!=[_array objectAtIndex:i])
        {
            [arraytemp addObject:[_array objectAtIndex:i]];
        }
       
    }
    return arraytemp;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayDomainKPIData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPTrafficInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPTrafficInfoCell"];
    if (cell==nil)
    {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPTrafficInfoCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
    }
    
//    if (_nCellIndex==indexPath.row)
//    {
//        [cell changeColor];
//    }
    
    KPIDomainData *kpiDomainData=[[KPIDomainData alloc]init];
    kpiDomainData=[_arrayDomainKPIData objectAtIndex:indexPath.row];
    cell.string1=_currentString1;
    cell.string2=_currentString2;
    cell.maxAmount=_maxAmount;
    cell.maxConversion=_maxConversion;
    cell.maxProQty=_maxProQty;
    cell.maxTraffic=_maxTraffic;
    cell.maxTraQty=_maxTraQty;
    cell.kpiDomainData=kpiDomainData;
    cell.bSelected = (_nCellIndex==indexPath.row) ? YES : NO;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    KPIDomainData *kpiDomainData = [_arrayDomainKPIData objectAtIndex:indexPath.row];
    
    _view1.domainData = kpiDomainData;
    _view2.domainData = kpiDomainData;
    
    _nCellIndex=indexPath.row;
    [_tbTrafficInfo reloadData];
}

- (IBAction)OnUpOrDown:(id)sender
{
    if (_bBig) {
        
        [UIView beginAnimations:nil context:nil];
        _viewInfo.frame=CGRectMake(8, 252, _viewBackground.frame.size.width, self.frame.size.height-252);
        
        [UIView commitAnimations];
        [_btExpend setBackgroundImage:[UIImage imageNamed:@"button_foldchart@2x.png"] forState:UIControlStateNormal];
        _view1.alpha=1;
        _view2.alpha=1;
        _viewLine.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        _viewInfo.frame=CGRectMake(8, 36, _viewBackground.frame.size.width, self.frame.size.height-36);
        _view1.alpha=0;
        _view2.alpha=0;
        [UIView commitAnimations];
        [_btExpend setBackgroundImage:[UIImage imageNamed:@"button_openchart@2x.png"] forState:UIControlStateNormal];
//        _view1.hidden=YES;
//        _view2.hidden=YES;
        _viewLine.backgroundColor=[UIColor colorWithWhite:0.2 alpha:1];
    }
    _bBig=!_bBig;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView.contentOffset.x < _svFrame.frame.size.width)
//    {
//        _bTag=NO;
//        [_btSwitch setBackgroundImage:[UIImage imageNamed:@"botton_gototrend@2x.png"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        _bTag=YES;
//        [_btSwitch setBackgroundImage:[UIImage imageNamed:@"botton_gotocolumn@2x.png"] forState:UIControlStateNormal];
//    }
}
- (IBAction)OnSwitch:(id)sender
{
    if (_bTag) {
       
        _view1.frame=CGRectMake(0, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
        _view2.frame=CGRectMake(_svFrame.frame.size.width, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
        [_btSwitch setBackgroundImage:[UIImage imageNamed:@"button_gototrend@2x.png"] forState:UIControlStateNormal];
        
    }
    else
    {
       
        _view1.frame=CGRectMake(_svFrame.frame.size.width, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
        _view2.frame=CGRectMake(0, 0, _svFrame.frame.size.width, _svFrame.frame.size.height);
        [_btSwitch setBackgroundImage:[UIImage imageNamed:@"button_gotocolumn@2x.png"] forState:UIControlStateNormal];
       
    }
    _bTag=!_bTag;
}

-(void)sortByTrafficUp//从小到大
{
    for (int i = 0; i<[_arrayDomainKPIData count]; i++)
    {
        
        for(int j = i+1 ;j<[_arrayDomainKPIData count] ; j++)
        {
            long long a1 = ((KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i]).nTraffic;
            long long a2 = ((KPIDomainData *)[_arrayDomainKPIData objectAtIndex:j]).nTraffic;
            
            if(a1 > a2)
            {
                [_arrayDomainKPIData exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            
        }
        
    }
}

-(void)sortByTrafficDown//从大到小
{
    for (int i = 0; i<[_arrayDomainKPIData count]; i++)
    {
        
        for(int j = i+1 ;j<[_arrayDomainKPIData count] ; j++)
        {
            NSInteger a1 = [(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i]nTraffic];
            NSInteger a2 = [(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:j]nTraffic];
            
            if(a1 < a2)
            {
                [_arrayDomainKPIData exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            
        }
        
    }

}
-(void)sortByConversionUp
{
    for (int i = 0; i<[_arrayDomainKPIData count]; i++)
    {
        
        for(int j = i+1 ;j<[_arrayDomainKPIData count] ; j++)
        {
            
            NSInteger a1 = [[_arrayDomainKPIData objectAtIndex:i]nConvPercent];
            NSInteger a2 = [[_arrayDomainKPIData objectAtIndex:j]nConvPercent];
            
            if(a1 > a2)
            {
                [_arrayDomainKPIData exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            
        }
        
    }

}
-(void)sortByConversionDown
{
    for (int i = 0; i<[_arrayDomainKPIData count]; i++)
    {
        
        for(int j = i+1 ;j<[_arrayDomainKPIData count] ; j++)
        {
            
            NSInteger a1 = [[_arrayDomainKPIData objectAtIndex:i]nConvPercent];
            NSInteger a2 = [[_arrayDomainKPIData objectAtIndex:j]nConvPercent];
            
            if(a1 < a2)
            {
                [_arrayDomainKPIData exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            
        }
        
    }

}
-(void)sortByTraQtyUp
{
    for (int i = 0; i<[_arrayDomainKPIData count]; i++)
    {
        
        for(int j = i+1 ;j<[_arrayDomainKPIData count] ; j++)
        {
            
            NSInteger a1 = [(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i]nTraQty];
            NSInteger a2 = [(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:j]nTraQty];
            
            if(a1 > a2)
            {
                [_arrayDomainKPIData exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            
        }
        
    }

}
-(void)sortByTraQtyDown
{
    for (int i = 0; i<[_arrayDomainKPIData count]; i++)
    {
        
        for(int j = i+1 ;j<[_arrayDomainKPIData count] ; j++)
        {
            
            NSInteger a1 = [(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i]nTraQty];
            NSInteger a2 = [(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:j] nTraQty];
            
            if(a1 < a2)
            {
                [_arrayDomainKPIData exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            
        }
        
    }

}

-(void)sortByProQtyUp
{
    for (int i = 0; i<[_arrayDomainKPIData count]; i++)
    {
        
        for(int j = i+1 ;j<[_arrayDomainKPIData count] ; j++)
        {
            
            NSInteger a1 = [(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i]nProQty];
            NSInteger a2 = [(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:j]nProQty];
            
            if(a1 > a2)
            {
                [_arrayDomainKPIData exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            
        }
        
    }

}
-(void)sortByProQtyDown
{
    for (int i = 0; i<[_arrayDomainKPIData count]; i++)
    {
        
        for(int j = i+1 ;j<[_arrayDomainKPIData count] ; j++)
        {
            
            NSInteger a1 = [(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i]nProQty];
            NSInteger a2 = [(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:j]nProQty];
            
            if(a1 < a2)
            {
                [_arrayDomainKPIData exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            
        }
        
    }

}

-(void)sortByAmountUp
{
    for (int i = 0; i<[_arrayDomainKPIData count]; i++)
    {
        
        for(int j = i+1 ;j<[_arrayDomainKPIData count] ; j++)
        {
            
            NSInteger a1 = [(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i]nAmount];
            NSInteger a2 = [(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:j]nAmount];
            
            if(a1 > a2)
            {
                [_arrayDomainKPIData exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            
        }
        
    }

}
-(void)sortByAmountDown
{
    for (int i = 0; i<[_arrayDomainKPIData count]; i++)
    {
        
        for(int j = i+1 ;j<[_arrayDomainKPIData count] ; j++)
        {
            
            NSInteger a1 = [(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i]nAmount];
            NSInteger a2 = [(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:j]nAmount];
            
            if(a1 < a2)
            {
                [_arrayDomainKPIData exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            
        }
        
    }

}

-(void)sortUp:(NSString *)s
{
    NSString *Traffic=NSLocalizedStringFromTableInBundle(@"Traffic",@"RPString", g_bundleResorce,nil);
    NSString *Conversion=NSLocalizedStringFromTableInBundle(@"Conversion Rate",@"RPString", g_bundleResorce,nil);
    NSString * TraQty= NSLocalizedStringFromTableInBundle(@"TraQty",@"RPString", g_bundleResorce,nil);
    NSString *ProQty=NSLocalizedStringFromTableInBundle(@"ProQty",@"RPString", g_bundleResorce,nil);
    NSString *Amount=NSLocalizedStringFromTableInBundle(@"Amount",@"RPString", g_bundleResorce,nil);
    if ([s isEqualToString:Traffic])
    {
        [self sortByTrafficUp];
    }
    else if([s isEqualToString:Conversion])
    {
        [self sortByConversionUp];
    }
    else if([s isEqualToString:TraQty])
    {
        [self sortByTraQtyUp];
    }
    else if([s isEqualToString:ProQty])
    {
        [self sortByProQtyUp];
    }
    else if([s isEqualToString:Amount])
    {
        [self sortByAmountUp];
    }

}
-(void)sortDown:(NSString *)s
{
    NSString *Traffic=NSLocalizedStringFromTableInBundle(@"Traffic",@"RPString", g_bundleResorce,nil);
    NSString *Conversion=NSLocalizedStringFromTableInBundle(@"Conversion Rate",@"RPString", g_bundleResorce,nil);
    NSString * TraQty= NSLocalizedStringFromTableInBundle(@"TraQty",@"RPString", g_bundleResorce,nil);
    NSString *ProQty=NSLocalizedStringFromTableInBundle(@"ProQty",@"RPString", g_bundleResorce,nil);
    NSString *Amount=NSLocalizedStringFromTableInBundle(@"Amount",@"RPString", g_bundleResorce,nil);
    if ([s isEqualToString:Traffic])
    {
        [self sortByTrafficDown];
    }
    else if([s isEqualToString:Conversion])
    {
        [self sortByConversionDown];
    }
    else if([s isEqualToString:TraQty])
    {
        [self sortByTraQtyDown];
    }
    else if([s isEqualToString:ProQty])
    {
        [self sortByProQtyDown];
    }
    else if([s isEqualToString:Amount])
    {
        [self sortByAmountDown];
    }

}
- (IBAction)OnButton1:(id)sender
{
    KPIDomainData *kpiDomainData=[_arrayDomainKPIData objectAtIndex:_nCellIndex];
    [self saveId:kpiDomainData.strDomainID];
    if (_TagUp1==0)
    {
        [self sortDown:_currentString1];
        _TagUp1=1;
        _TagUp2=0;
        _iv1.image=[UIImage imageNamed:@"button_arrange_down@2x.png"];
        _iv2.image=[UIImage imageNamed:@"button_arrange_noactive@2x.png"];
    }
    else if(_TagUp1==1)
    {
        [self sortUp:_currentString1];
        _TagUp1=2;
        _TagUp2=0;
        _iv1.image=[UIImage imageNamed:@"button_arrange_up@2x.png"];
        _iv2.image=[UIImage imageNamed:@"button_arrange_noactive@2x.png"];
    }
    else
    {
        [self sortDown:_currentString1];
        _TagUp1=1;
        _TagUp2=0;
        _iv1.image=[UIImage imageNamed:@"button_arrange_down@2x.png"];
        _iv2.image=[UIImage imageNamed:@"button_arrange_noactive@2x.png"];
    }
//    KPIDomainData *kpiDomainData = [_arrayDomainKPIData objectAtIndex:0];
//    
//    _view1.strDomainId = kpiDomainData.strDomainID;
//    _view2.strDomainId = kpiDomainData.strDomainID;
//    
//    _nCellIndex=0;
    [self loadFromId];
    [_tbTrafficInfo reloadData];
}

- (IBAction)OnButton2:(id)sender
{
    KPIDomainData *kpiDomainData=[_arrayDomainKPIData objectAtIndex:_nCellIndex];
    [self saveId:kpiDomainData.strDomainID];
    if (_TagUp2==0)
    {
        [self sortDown:_currentString2];
        _TagUp2=1;
        _TagUp1=0;
         _iv2.image=[UIImage imageNamed:@"button_arrange_down@2x.png"];
        _iv1.image=[UIImage imageNamed:@"button_arrange_noactive@2x.png"];
    }
    else if(_TagUp2==1)
    {
        [self sortUp:_currentString2];
        _TagUp2=2;
        _TagUp1=0;
        _iv2.image=[UIImage imageNamed:@"button_arrange_up@2x.png"];
        _iv1.image=[UIImage imageNamed:@"button_arrange_noactive@2x.png"];
    }
    else
    {
        [self sortDown:_currentString2];
        _TagUp2=1;
        _TagUp1=0;
        _iv2.image=[UIImage imageNamed:@"button_arrange_down@2x.png"];
        _iv1.image=[UIImage imageNamed:@"button_arrange_noactive@2x.png"];
        
    }
//    KPIDomainData *kpiDomainData = [_arrayDomainKPIData objectAtIndex:0];
//    _view1.strDomainId = kpiDomainData.strDomainID;
//    _view2.strDomainId = kpiDomainData.strDomainID;
//    _nCellIndex=0;

    [self loadFromId];
    [_tbTrafficInfo reloadData];

}
//为了保持选中行不因相关操作变化，排序，进入下层，返回上层的这些操作之前记录的id
-(void)saveId:(NSString *)s
{
    _domainId=s;
}
//为了保持选中行不因相关操作变化，排序，进入下层，返回上层根据记录的id读取数据
-(void)loadFromId
{
    for (int i=0; i<_arrayDomainKPIData.count; i++)
    {
        KPIDomainData *data=[_arrayDomainKPIData objectAtIndex:i];
        if ([data.strDomainID isEqualToString:_domainId])
        {
            _nCellIndex=i;
            return;
        }
    }
}
//获取每一列的最大值，以便计算显示条的长度
-(void)getMax
{
    _maxAmount=0;
    _maxConversion=0;
    _maxProQty=0;
    _maxTraffic=0;
    _maxTraQty=0;
    
    for (int i=0; i<_arrayDomainKPIData.count; i++)
    {
        if (_maxAmount<[(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i] nAmount])
        {
            _maxAmount=[(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i] nAmount];
        }
        if (_maxConversion<[(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i] nConvPercent])
        {
            _maxConversion=[(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i] nConvPercent];
        }
        if (_maxProQty<[(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i] nProQty])
        {
            _maxProQty=[(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i] nProQty];
        }
        if (_maxTraffic<[(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i] nTraffic])
        {
            _maxTraffic=[(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i] nTraffic];
        }
        if (_maxTraQty<[(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i] nTraQty])
        {
            _maxTraQty=[(KPIDomainData *)[_arrayDomainKPIData objectAtIndex:i] nTraQty];
        }
    }
}

- (IBAction)OnCollect:(id)sender
{
    
}

- (IBAction)OnParent:(id)sender
{
   
//    _nCellIndex=0;
    if (_arrayNode.count>0)
    {
        NSString * str =@"";
        
        [SVProgressHUD showWithStatus:str];
        NSString *strNode=[_arrayNode objectAtIndex:_arrayNode.count-1];
        [[RPSDK defaultInstance]GetSubDomainKPIData:strNode DateRange:_dateRange Success:^(NSMutableArray * arrayResult) {
            [SVProgressHUD dismiss];
            if (arrayResult.count > 0) {
                
                
                
                _arrayDomainKPIData=arrayResult;
                [self saveId:_node];
                [self loadFromId];
                KPIDomainData *kpiDomainData = [_arrayDomainKPIData objectAtIndex:_nCellIndex];
                _view1.domainData = kpiDomainData;
                _view2.domainData = kpiDomainData;
                
                [_arrayName removeLastObject];
                if (_arrayName.count==0) {
                    _lbCity.text=@"";
                }
                else
                {
                    _lbCity.text=[_arrayName objectAtIndex:_arrayName.count-1];
                }
                
                [self getMax];
                
                _node=[_arrayNode objectAtIndex:_arrayNode.count-1];
                [_arrayNode removeObjectAtIndex:_arrayNode.count-1];
                if(_arrayNode.count<1)
                    _ivParent.image=[UIImage imageNamed:@"button_go_parent_noactive@2x.png"];
                [_tbTrafficInfo reloadData];
            }
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD dismiss];
        }];
    }
}

- (IBAction)OnRefresh:(id)sender {
    [self loadData:NO];
}

-(void)setDateRange:(KPIDateRange *)dateRange
{
    KPIDomainData *kpiDomainData=[_arrayDomainKPIData objectAtIndex:_nCellIndex];
    [self saveId:kpiDomainData.strDomainID];
    _dateRange=dateRange;
    _view1.dateRange=dateRange;
    _view2.dateRange=dateRange;
    [self loadData:NO];
    [self TriangleColor];
    [self loadFromId];
}
-(void)TriangleColor
{
    switch (_dateRange.type)
    {
        case KPIDateRangeType_Day:
        {
            NSTimeInterval current=[[NSDate date] timeIntervalSince1970]*1;
            NSTimeInterval nDate=[_dateRange.date timeIntervalSince1970]*1;
            //判断右Button颜色
            if (nDate>current-86400)
            {
                //button淡化
                [_btNextTrend setBackgroundImage:[UIImage imageNamed:@"button_back_block_arrow@2x.png"] forState:UIControlStateNormal];
                [_btNextColumn setBackgroundImage:[UIImage imageNamed:@"button_back_block_arrow@2x.png"] forState:UIControlStateNormal];
            }
            else
            {
                //button变黑
                [_btNextTrend setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
                [_btNextColumn setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
            }
            //判断左Button颜色
            if (nDate<=current-86400*365*(YEARCOUNT-1))
            {
                //button淡化
                [_btPreviousTrend setBackgroundImage:[UIImage imageNamed:@"button_forward_block_arrow@2x.png"] forState:UIControlStateNormal];
                [_btPreviousColumn setBackgroundImage:[UIImage imageNamed:@"button_forward_block_arrow@2x.png"] forState:UIControlStateNormal];
            }
            else
            {
                //button变黑
                [_btPreviousTrend setBackgroundImage:[UIImage imageNamed:@"button_forward_arrow@2x.png"] forState:UIControlStateNormal];
                [_btPreviousColumn setBackgroundImage:[UIImage imageNamed:@"button_forward_arrow@2x.png"] forState:UIControlStateNormal];
            }
        }
            break;
        case KPIDateRangeType_Month:
        {
            //判断右Button颜色
            if (_dateRange.nYear==[RPSDK DateToYear:[NSDate date]])
            {
                if (_dateRange.nIndex>=[RPSDK DateToMonth:[NSDate date]])
                {
                    //button淡化
                    [_btNextTrend setBackgroundImage:[UIImage imageNamed:@"button_back_block_arrow@2x.png"] forState:UIControlStateNormal];
                    [_btNextColumn setBackgroundImage:[UIImage imageNamed:@"button_back_block_arrow@2x.png"] forState:UIControlStateNormal];
                }
                else
                {
                    //button变黑
                    [_btNextTrend setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
                    [_btNextColumn setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
                }
            }
            else if (_dateRange.nYear<[RPSDK DateToYear:[NSDate date]])
            {
                //button变黑
                [_btNextTrend setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
                [_btNextColumn setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
            }
            //判断左Button颜色
            if (_dateRange.nYear<=[RPSDK DateToYear:[NSDate date]]-YEARCOUNT+1)
            {
                //button淡化
                [_btPreviousTrend setBackgroundImage:[UIImage imageNamed:@"button_forward_block_arrow@2x.png"] forState:UIControlStateNormal];
                [_btPreviousColumn setBackgroundImage:[UIImage imageNamed:@"button_forward_block_arrow@2x.png"] forState:UIControlStateNormal];
            }
            else
            {
                //button变黑
                [_btPreviousTrend setBackgroundImage:[UIImage imageNamed:@"button_forward_arrow@2x.png"] forState:UIControlStateNormal];
                [_btPreviousColumn setBackgroundImage:[UIImage imageNamed:@"button_forward_arrow@2x.png"] forState:UIControlStateNormal];
            }
        }
            break;
        case KPIDateRangeType_Quarter:
        {
            //判断右Button颜色
            if (_dateRange.nYear==[RPSDK DateToYear:[NSDate date]])
            {
                if (_dateRange.nIndex>=[RPSDK DateToQuarter:[NSDate date]])
                {
                    //button淡化
                    [_btNextTrend setBackgroundImage:[UIImage imageNamed:@"button_back_block_arrow@2x.png"] forState:UIControlStateNormal];
                    [_btNextColumn setBackgroundImage:[UIImage imageNamed:@"button_back_block_arrow@2x.png"] forState:UIControlStateNormal];
                }
                else
                {
                    //button变黑
                    [_btNextTrend setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
                    [_btNextColumn setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
                }
            }
            else if (_dateRange.nYear<[RPSDK DateToYear:[NSDate date]])
            {
                //button变黑
                [_btNextTrend setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
                [_btNextColumn setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
            }
            //判断左Button颜色
            if (_dateRange.nYear<=[RPSDK DateToYear:[NSDate date]]-YEARCOUNT+1)
            {
                //button淡化
                [_btPreviousTrend setBackgroundImage:[UIImage imageNamed:@"button_forward_block_arrow@2x.png"] forState:UIControlStateNormal];
                [_btPreviousColumn setBackgroundImage:[UIImage imageNamed:@"button_forward_block_arrow@2x.png"] forState:UIControlStateNormal];
            }
            else
            {
                //button变黑
                [_btPreviousTrend setBackgroundImage:[UIImage imageNamed:@"button_forward_arrow@2x.png"] forState:UIControlStateNormal];
                [_btPreviousColumn setBackgroundImage:[UIImage imageNamed:@"button_forward_arrow@2x.png"] forState:UIControlStateNormal];
            }
        }
            break;
        case KPIDateRangeType_Week:
        {
            //判断右Button颜色
            if (_dateRange.nYear==[RPSDK DateToYear:[NSDate date]])
            {
                if (_dateRange.nIndex>=[RPSDK DateToWeek:[NSDate date]])
                {
                    //button淡化
                    [_btNextTrend setBackgroundImage:[UIImage imageNamed:@"button_back_block_arrow@2x.png"] forState:UIControlStateNormal];
                    [_btNextColumn setBackgroundImage:[UIImage imageNamed:@"button_back_block_arrow@2x.png"] forState:UIControlStateNormal];
                }
                else
                {
                    //button变黑
                    [_btNextTrend setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
                    [_btNextColumn setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
                }
                
                
            }
            else if(_dateRange.nYear==[RPSDK DateToYear:[NSDate date]])
            {
                //button变黑
                [_btNextTrend setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
                [_btNextColumn setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
            }
            
            
            //判断左Button颜色
            if (_dateRange.nYear<=[RPSDK DateToYear:[NSDate date]]-YEARCOUNT+1)
            {
                //button淡化
                [_btPreviousTrend setBackgroundImage:[UIImage imageNamed:@"button_forward_block_arrow@2x.png"] forState:UIControlStateNormal];
                [_btPreviousColumn setBackgroundImage:[UIImage imageNamed:@"button_forward_block_arrow@2x.png"] forState:UIControlStateNormal];
            }
            else
            {
                //button变黑
                [_btPreviousTrend setBackgroundImage:[UIImage imageNamed:@"button_forward_arrow@2x.png"] forState:UIControlStateNormal];
                [_btPreviousColumn setBackgroundImage:[UIImage imageNamed:@"button_forward_arrow@2x.png"] forState:UIControlStateNormal];
            }
        }
            break;
        case KPIDateRangeType_Year:
        {
            //判断右Button颜色
            if (_dateRange.nYear==[RPSDK DateToYear:[NSDate date]])
            {
                //button淡化
                [_btNextTrend setBackgroundImage:[UIImage imageNamed:@"button_back_block_arrow@2x.png"] forState:UIControlStateNormal];
                [_btNextColumn setBackgroundImage:[UIImage imageNamed:@"button_back_block_arrow@2x.png"] forState:UIControlStateNormal];
            }
            else if (_dateRange.nYear<[RPSDK DateToYear:[NSDate date]])
            {
                
                //button变黑
                [_btNextTrend setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
                [_btNextColumn setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
            }
            //判断左Button颜色
            if (_dateRange.nYear<=[RPSDK DateToYear:[NSDate date]]-YEARCOUNT+1)
            {
                //button淡化
                [_btPreviousTrend setBackgroundImage:[UIImage imageNamed:@"button_forward_block_arrow@2x.png"] forState:UIControlStateNormal];
                [_btPreviousColumn setBackgroundImage:[UIImage imageNamed:@"button_forward_block_arrow@2x.png"] forState:UIControlStateNormal];
            }
            else
            {
                //button变黑
                [_btPreviousTrend setBackgroundImage:[UIImage imageNamed:@"button_forward_arrow@2x.png"] forState:UIControlStateNormal];
                [_btPreviousColumn setBackgroundImage:[UIImage imageNamed:@"button_forward_arrow@2x.png"] forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
}
-(void)OnPreviousDate:(id)sender
{
    //右button变黑
    [_btNextTrend setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
    [_btNextColumn setBackgroundImage:[UIImage imageNamed:@"button_back_arrow@2x.png"] forState:UIControlStateNormal];
    switch (_dateRange.type)
    {
        case KPIDateRangeType_Day:
        {
            NSTimeInterval now=[_dateRange.date timeIntervalSince1970]*1;
            int  p=now/1 -86400;
            NSDate*pDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)p];
            NSDate *currentDate=[NSDate date];
            NSTimeInterval current=[currentDate timeIntervalSince1970]*1;
            if(now<current-86400*365*(YEARCOUNT-1)) return;
            _dateRange.date=pDate;
            [self TriangleColor];
        }
            break;
        case KPIDateRangeType_Month:
        {
            _dateRange.nIndex--;
            if (_dateRange.nIndex<1)
            {
                _dateRange.nYear--;
                _dateRange.nIndex=12;
                [self TriangleColor];
                if (_dateRange.nYear<[RPSDK DateToYear:[NSDate date]]-YEARCOUNT+1)
                {
                    _dateRange.nYear++;
                    _dateRange.nIndex=1;
                    return;
                }
            }
        }
            break;
        case KPIDateRangeType_Quarter:
        {
            _dateRange.nIndex--;
            if (_dateRange.nIndex<1)
            {
                _dateRange.nYear--;
                _dateRange.nIndex=4;
                [self TriangleColor];
                if (_dateRange.nYear<[RPSDK DateToYear:[NSDate date]]-YEARCOUNT+1)
                {
                    _dateRange.nYear++;
                    _dateRange.nIndex=1;
                    return;
                }
            }
        }
            break;
        case KPIDateRangeType_Week:
        {
            _dateRange.nIndex--;
            if (_dateRange.nIndex<1) {
                _dateRange.nYear--;
                _dateRange.nIndex=53;
                [self TriangleColor];
                if (_dateRange.nYear<[RPSDK DateToYear:[NSDate date]]-YEARCOUNT+1)
                {
                    _dateRange.nYear++;
                    _dateRange.nIndex=1;
                    return;
                }
            }
        }
            break;
        case KPIDateRangeType_Year:
        {
            _dateRange.nYear--;
            [self TriangleColor];
            if (_dateRange.nYear<[RPSDK DateToYear:[NSDate date]]-YEARCOUNT+1)
            {
                _dateRange.nYear++;
                return;
            }
        }
            break;
        default:
            break;
    }
    
    _view1.dateRange = _dateRange;
    _view2.dateRange = _dateRange;
    [_view1 ReloadChart];
    [_view2 ReloadChart];
    [self loadData:NO];
}

-(void)OnNextDate:(id)sender
{
    //左button变黑
    [_btPreviousColumn setBackgroundImage:[UIImage imageNamed:@"button_forward_arrow@2x.png"] forState:UIControlStateNormal];
    [_btPreviousTrend setBackgroundImage:[UIImage imageNamed:@"button_forward_arrow@2x.png"] forState:UIControlStateNormal];
    switch (_dateRange.type)
    {
        case KPIDateRangeType_Day:
        {
            NSTimeInterval now=[_dateRange.date timeIntervalSince1970]*1;
            int  p=now/1 +86400;
            NSDate*pDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)p];
            
            NSDate *currentDate=[NSDate date];
            NSTimeInterval current=[currentDate timeIntervalSince1970]*1;
            
            if(p>current) return;
            
            _dateRange.date=pDate;
            [self TriangleColor];
        }
            break;
        case KPIDateRangeType_Month:
        {
            if (_dateRange.nYear==[RPSDK DateToYear:[NSDate date]])
            {
                
                if (_dateRange.nIndex>=[RPSDK DateToMonth:[NSDate date]])
                {
                    return;
                }
            }
            _dateRange.nIndex++;
            [self TriangleColor];
            if (_dateRange.nIndex>12)
            {
                _dateRange.nYear++;
                _dateRange.nIndex=1;
                //这个if语句可以去掉，不可能执行到里面去
                if (_dateRange.nYear>[RPSDK DateToYear:[NSDate date]])
                {
                    _dateRange.nYear--;
                    _dateRange.nIndex=12;
                    return;
                }
            }
        }
            break;
        case KPIDateRangeType_Quarter:
        {
            if (_dateRange.nYear==[RPSDK DateToYear:[NSDate date]])
            {
                if (_dateRange.nIndex>=[RPSDK DateToQuarter:[NSDate date]])
                {
                    return;
                }
            }
            
            _dateRange.nIndex++;
            [self TriangleColor];
            if (_dateRange.nIndex>4) {
                _dateRange.nYear++;
                _dateRange.nIndex=1;
                if (_dateRange.nYear>[RPSDK DateToYear:[NSDate date]])
                {
                    _dateRange.nYear--;
                    _dateRange.nIndex=4;
                    return;
                }
            }
        }
            break;
        case KPIDateRangeType_Week:
        {
            if (_dateRange.nYear==[RPSDK DateToYear:[NSDate date]])
            {
                if (_dateRange.nIndex>=[RPSDK DateToWeek:[NSDate date]])
                {
                    return;
                }
            }
            _dateRange.nIndex++;
            [self TriangleColor];
            if (_dateRange.nIndex>53) {
                _dateRange.nYear++;
                _dateRange.nIndex=1;
                if (_dateRange.nYear>[RPSDK DateToYear:[NSDate date]])
                {
                    _dateRange.nYear--;
                    _dateRange.nIndex=53;
                    return;
                }
            }
        }
            break;
        case KPIDateRangeType_Year:
        {
            _dateRange.nYear++;
            [self TriangleColor];
            if (_dateRange.nYear>[RPSDK DateToYear:[NSDate date]])
            {
                _dateRange.nYear--;
                return;
            }
        }
            break;
        default:
            break;
    }
    
    _view1.dateRange = _dateRange;
    _view2.dateRange = _dateRange;
    [_view1 ReloadChart];
    [_view2 ReloadChart];
    [self loadData:NO];
}

@end
