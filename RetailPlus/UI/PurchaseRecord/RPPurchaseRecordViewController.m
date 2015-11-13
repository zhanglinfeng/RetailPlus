//
//  RPPurchaseRecordViewController.m
//  RetailPlus
//
//  Created by zwhe on 13-12-26.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "RPPurchaseRecordViewController.h"
#import "RPPurchaseRecordCell.h"
#import "RPPurchaseRecordClass.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@interface RPPurchaseRecordViewController ()

@end

@implementation RPPurchaseRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _tfAmount.secureTextEntry = YES;
        _tfQty.secureTextEntry = YES;
        _tfUnitPrice.secureTextEntry = YES;
        _bModify=NO;
    }
    return self;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _bModify=YES;
}
-(BOOL)OnBack
{
    [self.view endEditing:YES];
    if (_bAddFrame) {
        if (_bModify)
        {
            NSString * strSave = NSLocalizedStringFromTableInBundle(@"SAVE",@"RPString", g_bundleResorce,nil);
            NSString * strDont = NSLocalizedStringFromTableInBundle(@"DON'T SAVE",@"RPString", g_bundleResorce,nil);
            NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Save changes before leave?",@"RPString", g_bundleResorce,nil);
            RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
                if (indexButton==2)
                {
                    [UIView beginAnimations:nil context:nil];
                    _viewAddFrame.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                    [UIView commitAnimations];
//                    [_viewAddFrame removeFromSuperview];
                    _bAddFrame=NO;
                    _bModify=NO;
                    
                }
                else if(indexButton==0)
                {
                    
                }
                else
                {
                    [self OnOK];
                }
                
                
            }otherButtonTitles:strSave,strDont, nil];
            [alertView show];
            return NO;
        }
        else
        {
            [UIView beginAnimations:nil context:nil];
            _viewAddFrame.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
//            [_viewAddFrame removeFromSuperview];
            _bAddFrame=NO;
            _bModify=NO;
        }
    }
    else
    {
        return YES;
    }
    return NO;
}

-(void)setCustomer:(Customer *)customer
{
    _customer = customer;
    
    _ivHeader.image = [UIImage imageNamed:@"icon_userimage01_224.png"];
    
    if (customer.strCustImgBig) {
        [_ivHeader setImageWithURLString:customer.strCustImgBig placeholderImage:[UIImage imageNamed:@"icon_userimage01_224.png"]];
    }

    
//    [_ivHeader setImageWithURL:[NSURL URLWithString:[customer.strCustImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
 
    _lbName.text = customer.strFirstName;
    _lbAddress.text = customer.strAddress;
    _lbAddress.adjustsFontSizeToFitWidth = YES;
    _lbLinker.text = customer.strRelationUserName;
    switch (customer.rankRelationUser) {
        case Rank_Manager:
            _view4.backgroundColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _view4.backgroundColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _view4.backgroundColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _view4.backgroundColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }
    
    _ivVIP.hidden = customer.isVip ? NO : YES;
    
    [self ReloadData];
}

-(void)setLine
{
    _viewLine1.frame=CGRectMake(_viewLine1.frame.origin.x, _tbPurchaseRecord.frame.origin.y+38*_recordArray.count,1,_viewLine1.frame.size.height);
    _viewLine2.frame=CGRectMake(_viewLine2.frame.origin.x, _tbPurchaseRecord.frame.origin.y+38*_recordArray.count,1,_viewLine2.frame.size.height);
    _viewLine3.frame=CGRectMake(_viewLine3.frame.origin.x, _tbPurchaseRecord.frame.origin.y+38*_recordArray.count,1,_viewLine3.frame.size.height);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"PURCHASE RECORD",@"RPString", g_bundleResorce,nil);
//    _viewBG.layer.cornerRadius=10;
//    _viewBackground.layer.cornerRadius=10;
//    _view1.layer.cornerRadius=10;
    _view3.layer.cornerRadius=10;
    _view5.layer.cornerRadius=6;
    _viewAddBG.layer.cornerRadius=10;
    

    [_tbPurchaseRecord setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _ivHeader.layer.cornerRadius=4;
    _ivHeader.layer.borderWidth=1;
    _ivHeader.layer.borderColor=[UIColor grayColor].CGColor;
    _view4.layer.cornerRadius=3;
    _viewAddBG.layer.cornerRadius=10;
    _view5.layer.cornerRadius=6;
    
//    [self loadData];//加载数据
    [self addPrompt];//提示添加购买记录
    
//    _recordArray=[[NSMutableArray alloc]init];
    
//    _lbTotalSum.text=@"TOTAL PUECHASED:";
//    _lbSum.text=@"";
    
//    _lbAverage.text=@"AVERAGE PUECHASED:";
//    _lbAver.text=@"";
    
    _lbTotalSum.frame=CGRectMake(0, 12, _lbTotalSum.frame.size.width, _lbTotalSum.frame.size.height);
    _lbSum.frame=CGRectMake(140, 12, _lbSum.frame.size.width, _lbSum.frame.size.height);
    _lbAverage.frame=CGRectMake(240, 12, _lbAverage.frame.size.width, _lbAverage.frame.size.height);
    _lbAver.frame=CGRectMake(380, 12, _lbAver.frame.size.width, _lbAver.frame.size.height);
    // 滑动的 Recognizer
    UISwipeGestureRecognizer *swipeRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    //设置滑动方向left
    [swipeRecognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_view2 addGestureRecognizer:swipeRecognizerLeft];
    // 滑动的 Recognizer
    UISwipeGestureRecognizer *swipeRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    //设置滑动方向right
    [swipeRecognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [_view2 addGestureRecognizer:swipeRecognizerRight];
    
    _bAddFrame=NO;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    //    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSDate * date = [NSDate date];
    _pickDate = [[RPDatePicker alloc] init:_tfDate Format:dateFormatter curDate:date canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped:)];
    [_viewAddFrame addGestureRecognizer:tap];
    
    _ivLeft.alpha=0.3;
    _tfAmount.keyboardType=UIKeyboardTypeNumberPad;
    _tfQty.keyboardType=UIKeyboardTypeNumberPad;
    _tfUnitPrice.keyboardType=UIKeyboardTypeNumberPad;
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField==_tfQty||textField==_tfUnitPrice)
    {
        if(_tfQty.text!=nil&&_tfUnitPrice!=nil)
        {
            int  number1=[[_tfQty text]intValue];
            double number2=[[_tfUnitPrice text]doubleValue];
            _tfAmount.text=[NSString stringWithFormat:@"%0.2f",number1*number2];
        }
    }
}

- (void)locationTapped:(UITapGestureRecognizer *)tap
{
    [_viewAddFrame endEditing:YES];
}

////加载数据
//-(void)loadData
//{
//    RPPurchaseRecordClass *record=[[RPPurchaseRecordClass alloc]init];
//    record.recordAmount=1000;
//    record.recordDate=@"2013/12/30";
//    record.recordQty=2;
//    record.recordUnitPrice=500;
//    record.recordProductName=@"宝珀6654-3642 -55B腕表";
//    [_recordArray addObject:record];
//    
//    RPPurchaseRecordClass *record1=[[RPPurchaseRecordClass alloc]init];
//    record1.recordAmount=2400;
//    record1.recordDate=@"2013/12/29";
//    record1.recordQty=3;
//    record1.recordUnitPrice=800;
//    record1.recordProductName=@"乌克兰小猪";
//    [_recordArray addObject:record1];
//    
//    RPPurchaseRecordClass *record2=[[RPPurchaseRecordClass alloc]init];
//    record2.recordAmount=100;
//    record2.recordDate=@"2013/12/28";
//    record2.recordQty=20;
//    record2.recordUnitPrice=5;
//    record2.recordProductName=@"红烧鸡腿";
//    [_recordArray addObject:record2];
//    
//    RPPurchaseRecordClass *record3=[[RPPurchaseRecordClass alloc]init];
//    record3.recordAmount=45;
//    record3.recordDate=@"2013/12/30";
//    record3.recordQty=30;
//    record3.recordUnitPrice=1.5;
//    record3.recordProductName=@"张记狗不理鲜肉包";
//    [_recordArray addObject:record3];
//    
//    
//    
//}
//提示用户增加购买记录
-(void)addPrompt
{
    
    _ivAdd.image=[UIImage imageNamed:@"image_notice_frame@2x.png"];
    

    _lbAdd.text=NSLocalizedStringFromTableInBundle(@"Touch + to add Purchase Record",@"RPString", g_bundleResorce,nil);
//    _lbAdd.font=[UIFont systemFontOfSize:14];
//    _lbAdd.textColor=[UIColor colorWithWhite:0.9 alpha:1];
    
    
    if (_recordArray.count<1) {
        _ivAdd.hidden=NO;
        _lbAdd.hidden=NO;
        
        
    }
    else
    {
        _ivAdd.hidden=YES;
        _lbAdd.hidden=YES;
        
    }
}
-(void)leftSwipe:(UISwipeGestureRecognizer*)recognizer
{
    //处理滑动操作
//    CGPoint translation = [recognizer locationInView:self.view];
//    NSLog(@"Swipe - start location: %f,%f", translation.x, translation.y);
    [UIView beginAnimations:nil context:nil];
    _lbTotalSum.frame=CGRectMake(-240, 12, _lbTotalSum.frame.size.width, _lbTotalSum.frame.size.height);
    _lbSum.frame=CGRectMake(-100, 12, _lbSum.frame.size.width, _lbSum.frame.size.height);
    _lbAverage.frame=CGRectMake(0, 12, _lbAverage.frame.size.width, _lbAverage.frame.size.height);
    _lbAver.frame=CGRectMake(140, 12, _lbAver.frame.size.width, _lbAver.frame.size.height);
    _ivLeft.alpha=1;
    _ivRight.alpha=0.3;
    [UIView commitAnimations];
    
}
-(void)rightSwipe:(UISwipeGestureRecognizer*)recognizer
{
    //处理滑动操作
//    CGPoint translation = [recognizer locationInView:self.view];
//    NSLog(@"Swipe - start location: %f,%f", translation.x, translation.y);
    [UIView beginAnimations:nil context:nil];
    _lbTotalSum.frame=CGRectMake(0, 12, _lbTotalSum.frame.size.width, _lbTotalSum.frame.size.height);
    _lbSum.frame=CGRectMake(140, 12, _lbSum.frame.size.width, _lbSum.frame.size.height);
    _lbAverage.frame=CGRectMake(240, 12, _lbAverage.frame.size.width, _lbAverage.frame.size.height);
    _lbAver.frame=CGRectMake(380, 12, _lbAver.frame.size.width, _lbAver.frame.size.height);
    _ivLeft.alpha=0.3;
    _ivRight.alpha=1;
    [UIView commitAnimations];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordArray.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPPurchaseRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPPurchaseRecordCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPPurchaseRecordCell" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
    }
    CustomerPurchase *record=[[CustomerPurchase alloc]init];
    record=[_recordArray objectAtIndex:indexPath.row];
     cell.record=record;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CustomerPurchase *tempRecord = [_recordArray objectAtIndex:indexPath.row];
    _record=tempRecord;
    
    _bAddFrame=YES;
    _viewAddFrame.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewAddFrame];
    [UIView beginAnimations:nil context:nil];
    _viewAddFrame.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    _tfAmount.text=[NSString stringWithFormat:@"%@",_record.numProductAmount];
    _tfDate.text=_record.strPurchaseDate;
    _tfProductName.text=_record.strProductName;
    _tfQty.text=[NSString stringWithFormat:@"%@",_record.numProductQty];
    _tfUnitPrice.text=[NSString stringWithFormat:@"%@",_record.numProductPrice];
    _strModifyPurchaseId = tempRecord.strPurchaseId;

    _isAdd=NO;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        CustomerPurchase *tempRecord = [_recordArray objectAtIndex:indexPath.row];
        
        [[RPSDK defaultInstance] DeleteCustomerPurchase:_customer.strCustomerId PurchaseId:tempRecord.strPurchaseId Success:^(id idResult) {
            [self ReloadData];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * s=NSLocalizedStringFromTableInBundle(@"DELETE",@"RPString", g_bundleResorce,nil);
    return s;
}
- (IBAction)OnAdd:(id)sender
{
//    _bModify=YES;
    _isAdd=YES;
    _bAddFrame=YES;
    _viewAddFrame.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewAddFrame];
    [UIView beginAnimations:nil context:nil];
    _viewAddFrame.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    _tfAmount.text=@"";
    _tfProductName.text=@"";
    //_tfDate.text=@"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate * date = [NSDate date];
    _pickDate = [[RPDatePicker alloc] init:_tfDate Format:dateFormatter curDate:date canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    
    _tfQty.text=@"";
    _tfUnitPrice.text=@"";
}
- (BOOL)CheckInput:(NSString *)string {
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
    
}

-(void)OnOK
{
    if([_tfQty.text isEqualToString:@""]||[_tfUnitPrice.text isEqualToString:@""]||[_tfProductName.text isEqualToString:@""])
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Product name or unitprice \n or QTY cannot be empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
    }
    else if (!([self CheckInput:_tfQty.text]&&[self CheckInput:_tfUnitPrice.text]))
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"QTY and unitprice \n must be numeric",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
    }
    else
    {
        _bAddFrame=NO;
        
        if (_isAdd) {
            CustomerPurchase * purchase = [[CustomerPurchase alloc] init];
            purchase.strProductName = _tfProductName.text;
            purchase.strPurchaseDate = _tfDate.text;
            purchase.numProductAmount = [NSNumber numberWithDouble:_tfAmount.text.doubleValue];
            purchase.numProductPrice = [NSNumber numberWithDouble:_tfUnitPrice.text.doubleValue];
            purchase.numProductQty = [NSNumber numberWithDouble:_tfQty.text.integerValue];
            purchase.strStoreId = _customer.strStoreId;
            
            [[RPSDK defaultInstance] AddCustomerPurchase:_customer.strCustomerId Purchase:purchase Success:^(id idResult) {
                [UIView beginAnimations:nil context:nil];
                _viewAddFrame.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
                
                [self ReloadData];
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                
            }];
        }
        else
        {
            CustomerPurchase * purchase = [[CustomerPurchase alloc] init];
            purchase.strProductName = _tfProductName.text;
            purchase.strPurchaseDate = _tfDate.text;
            purchase.numProductAmount = [NSNumber numberWithDouble:_tfAmount.text.doubleValue];
            purchase.numProductPrice = [NSNumber numberWithDouble:_tfUnitPrice.text.doubleValue];
            purchase.numProductQty = [NSNumber numberWithDouble:_tfQty.text.integerValue];
            purchase.strStoreId = _customer.strStoreId;
            purchase.strPurchaseId = _strModifyPurchaseId;
            
            [[RPSDK defaultInstance]ModifyCustomerPurchase:_customer.strCustomerId Purchase:purchase Success:^(id idResult) {
                [UIView beginAnimations:nil context:nil];
                _viewAddFrame.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
                
                [self ReloadData];
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                
            }];
        }
        
    }

}

- (IBAction)OnSave:(id)sender
{
    [self OnOK];
}

-(void)ReloadData
{
    _lbSum.text=@"";
    _lbAver.text=@"";
    
    [[RPSDK defaultInstance]GetCustomerPurchaseList:_customer.strCustomerId Success:^(NSArray * array){
        _recordArray=array;
        [_tbPurchaseRecord reloadData];
        double dTotal = 0;
        double dAverage = 0;
        NSInteger nQty = 0;
        for (CustomerPurchase * purchase in _recordArray) {
            dTotal += [purchase.numProductAmount doubleValue];
            nQty += [purchase.numProductQty integerValue];
        }
        if (nQty != 0)
            dAverage = dTotal / nQty;
        
        _lbSum.text=[NSString stringWithFormat:@"¥%0.2f",dTotal];
        _lbAver.text=[NSString stringWithFormat:@"¥%0.2f",dAverage];
        
        [self addPrompt];
        [self setLine];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}
@end
