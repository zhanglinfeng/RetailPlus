//
//  RPModifyCustomerViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-8-28.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPModifyCustomerViewController.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"
#import "RPChildrenCell.h"
//#import "MyChildren.h"
#import "RPMemorialDaysCell.h"
#import "RPBlockUISelectView.h"
#define kViewJobAndFamilyhight 330
extern NSBundle * g_bundleResorce;

@interface RPModifyCustomerViewController ()

@end


@implementation RPModifyCustomerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _arrayChildren=[[NSMutableArray alloc]init];
        _arrayMemorialDays=[[NSMutableArray alloc]init];
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"CLIENT PROFILE",@"RPString", g_bundleResorce,nil);
    
    CGSize sz = CGSizeMake(_svFrame.frame.size.width, _viewFrame.frame.size.height+100);
    _svFrame.contentSize = sz;
    
    _viewBackGround.layer.cornerRadius = 10;
    _viewBackGround.layer.masksToBounds=YES;
//    _viewFrame.layer.cornerRadius=6;
//    _viewBGJobAndFamily.layer.cornerRadius=6;
//    _viewBGPersonalProfile.layer.cornerRadius=6;
    
    _ivPic.layer.cornerRadius = 6;
    _ivPic.layer.shadowOffset = CGSizeMake(0, 1);
    _ivPic.layer.shadowRadius =3.0;
    _ivPic.layer.shadowColor =[UIColor blackColor].CGColor;
    _ivPic.layer.shadowOpacity =0.5;
    
    _viewTable1.layer.cornerRadius = 6;
    _viewTable2.layer.cornerRadius = 6;
    _viewTable3.layer.cornerRadius = 6;
    _viewTable4.layer.cornerRadius = 6;
    _viewTable4.layer.masksToBounds=YES;
    _viewTable5.layer.cornerRadius = 6;
    _viewTable5.layer.masksToBounds=YES;
    _viewTable6.layer.cornerRadius = 6;
    _viewTable6.layer.masksToBounds=YES;
    _viewTable7.layer.cornerRadius = 6;
    _viewTable7.layer.masksToBounds=YES;

    
    _switchSex = [[RPSwitchView alloc] initWithFrame:CGRectMake(0, 0, _viewSwitchSex.frame.size.width, _viewSwitchSex.frame.size.height)];
    _switchSex.delegate = self;
    [_viewSwitchSex addSubview:_switchSex];
    _switchSex.imgBack = [UIImage imageNamed:@"bg_gender_switch01@2x.png"];
    [_switchSex SetOn:NO];
    _lbSex.text=NSLocalizedStringFromTableInBundle(@"MALE",@"RPString", g_bundleResorce,nil);
    _bFemale=NO;
    
    _switchVIP=[[RPSwitchView alloc]initWithFrame:CGRectMake(0, 0, _viewSwitchVIP.frame.size.width, _viewSwitchVIP.frame.size.height)];
    _switchVIP.delegate=self;
    [_viewSwitchVIP addSubview:_switchVIP];
    _switchVIP.imgBack=[UIImage imageNamed:@"image_switcher_onoff@2x.png"];
    [_switchVIP SetOn:NO];
    [_ivVIP setImage:[UIImage imageNamed:@"icon_vip_off@2x.png"]];
    _bVip=NO;
    
//    _pickBirthDay = [[UIDatePicker alloc] init];
//    _pickBirthDay.datePickerMode = UIDatePickerModeDate;
//    [_pickBirthDay addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ]; 
    
//    _tfBirthDay.inputView = _pickBirthDay;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
//    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:0];
    _pickDate = [[RPDatePicker alloc] initDay:_tfBirthDay Format:dateFormatter curDate:date canDelete:YES];
    _tfBirthDay.text = @"";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped:)];
    [_svFrame addGestureRecognizer:tap];
    
    [_svFrame addSubview:_viewFrame];
    
    NSArray *array = [g_bundleResorce loadNibNamed:@"CustomView" owner:self options:nil];
    _viewStoreList = [array objectAtIndex:1];
    _viewStoreList.delegate = self;
    _viewStoreList.sitType = SituationType_ModifyCustomer;
    
//    _isAdd=YES;
    _bStoreList=NO;
    
    _nCareerIndex = -1;
    
    [[RPSDK defaultInstance]GetCustomerCareerList:^(NSArray * array) {
       
        _arrayCareer=array;
        for (int i=0; i<_arrayCareer.count; i++) {
            if ([_customer.strCareerId isEqualToString:[[_arrayCareer objectAtIndex:i]strCustomerCareerId] ]) {
                _tfCareer.text=[[_arrayCareer objectAtIndex:i]strCustomerCareerDesc];
                _nCareerIndex = i;
            }
        }
        
        
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
//    _customerCell.customerCellDelegate=self;
    
    _bModify=NO;
    
    _tfPhone1.keyboardType=UIKeyboardTypeNumberPad;
    _tfPhone2.keyboardType=UIKeyboardTypeNumberPad;
    _bQuit=NO;
    
    //TEST
//    _arrayCareer=[[NSMutableArray alloc]init];
//    for (int i=0; i<20; i++) {
//        CustomerCareer *cus=[[CustomerCareer alloc]init];
//        cus.strCustomerCareerDesc=[NSString stringWithFormat:@"%d",i];
//        cus.strCustomerCareerId=@"123";
//        [_arrayCareer addObject:cus];
//    }
    
    
    //*********************投影专用View********************//
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(_ivPic.frame.origin.x, _ivPic.frame.origin.y, _ivPic.frame.size.width, _ivPic.frame.size.height)];
    [_viewFrame insertSubview:view1 belowSubview:_ivPic];
    view1.backgroundColor=[UIColor whiteColor];
    view1.layer.cornerRadius = 6;
    view1.layer.shadowOffset = CGSizeMake(-4, 4);
    view1.layer.shadowRadius =3.0;
    view1.layer.shadowColor =[UIColor blackColor].CGColor;
    view1.layer.shadowOpacity =0.3;
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(_ivPic.frame.origin.x, _ivPic.frame.origin.y, _ivPic.frame.size.width, _ivPic.frame.size.height)];
    [_viewFrame insertSubview:view2 belowSubview:_ivPic];
    view2.backgroundColor=[UIColor whiteColor];
    view2.layer.cornerRadius = 6;
    view2.layer.shadowOffset = CGSizeMake(4, -4);
    view2.layer.shadowRadius =3.0;
    view2.layer.shadowColor =[UIColor blackColor].CGColor;
    view2.layer.shadowOpacity =0.3;
    
    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(_ivPic.frame.origin.x, _ivPic.frame.origin.y, _ivPic.frame.size.width, _ivPic.frame.size.height)];
    [_viewFrame insertSubview:view3 belowSubview:_ivPic];
    view3.backgroundColor=[UIColor whiteColor];
    view3.layer.cornerRadius = 6;
    view3.layer.shadowOffset = CGSizeMake(4, 4);
    view3.layer.shadowRadius =3.0;
    view3.layer.shadowColor =[UIColor blackColor].CGColor;
    view3.layer.shadowOpacity =0.3;
    
    UIView *view4=[[UIView alloc]initWithFrame:CGRectMake(_ivPic.frame.origin.x, _ivPic.frame.origin.y, _ivPic.frame.size.width, _ivPic.frame.size.height)];
    [_viewFrame insertSubview:view4 belowSubview:_ivPic];
    view4.backgroundColor=[UIColor whiteColor];
    view4.layer.cornerRadius = 6;
    view4.layer.shadowOffset = CGSizeMake(-4, -4);
    view4.layer.shadowRadius =3.0;
    view4.layer.shadowColor =[UIColor blackColor].CGColor;
    view4.layer.shadowOpacity =0.3;
    
    [[RPSDK defaultInstance] GetCustomerList:^(NSArray * array) {
        _arrayAllCustomer = array;
        
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
    
}

- (void)locationTapped:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)OnBack
{
    [self.view endEditing:YES];
    if (_bStoreList) {
        [UIView beginAnimations:nil context:nil];
        _viewStoreList.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        _bStoreList = NO;
        _bModify = YES;
        _bQuit = NO;
        return NO;
    }
    else
    {
        if (_isAdd)
        {
            if(!_bQuit)
            {
                NSString * strSave = NSLocalizedStringFromTableInBundle(@"SAVE",@"RPString", g_bundleResorce,nil);
                NSString * strDont = NSLocalizedStringFromTableInBundle(@"DON'T SAVE",@"RPString", g_bundleResorce,nil);
                NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
                NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Save changes before leave?",@"RPString", g_bundleResorce,nil);
                RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
                    if (indexButton==2)
                    {
                        _bQuit=YES;
                        [self.delegate OnAddCustomEnd];
                        
                    }
                    else if(indexButton==0)
                    {
                        _bQuit=NO;
                    }
                    else
                    {
                        [self OnSave];
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
        if (_bModify)
        {
            if(!_bQuit)
            {
                NSString * strSave = NSLocalizedStringFromTableInBundle(@"SAVE",@"RPString", g_bundleResorce,nil);
                NSString * strDont = NSLocalizedStringFromTableInBundle(@"DON'T SAVE",@"RPString", g_bundleResorce,nil);
                NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
                NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Save changes before leave?",@"RPString", g_bundleResorce,nil);
                RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
                    if (indexButton==2)
                    {
                        _bQuit=YES;
                        if (self.delegateModify) {
                            [self.delegateModify OnModifyCustomerBackEnd];
                        }
                        if (self.delegate) {
                            [self.delegate OnAddCustomEnd];
                        }
                        
                        
                    }
                    else if(indexButton==0)
                    {
                        _bQuit=NO;
                    }
                    else
                    {
                        [self OnSave];
                    }
                    
                    
                }otherButtonTitles:strSave,strDont, nil];
                [alertView show];
                return NO;
            }
            return YES;
            
            
        }
        else
        {
            return YES;
        }
        
    }
    return NO;
}
-(void)SelectSwitch:(RPSwitchView *)view isOn:(BOOL)bOn
{
    if (view==_switchVIP) {
        if (bOn) {
            [_ivVIP setImage:[UIImage imageNamed:@"icon_vip_on@2x.png"]];
            
        }
        else
        {
            [_ivVIP setImage:[UIImage imageNamed:@"icon_vip_off@2x.png"]];
            
        }
        _bVip=bOn;
    }
    else
    {
        if (bOn)
        {
//          [_lbMale setTextColor:[UIColor colorWithWhite:0.9 alpha:1]];
//          [_lbFemale setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
            _lbSex.text=NSLocalizedStringFromTableInBundle(@"FEMALE",@"RPString", g_bundleResorce,nil);
        }
        else
        {
//          [_lbMale setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
//          [_lbFemale setTextColor:[UIColor colorWithWhite:0.9 alpha:1]];
            _lbSex.text=NSLocalizedStringFromTableInBundle(@"MALE",@"RPString", g_bundleResorce,nil);
        }
        _bFemale =bOn;
    }
    
    _bModify=YES;
}

-(IBAction)OnSelPicture:(id)sender
{
    [self.view endEditing:YES];
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Please select the image source type?",@"RPString", g_bundleResorce,nil);
    NSString * strCamera = NSLocalizedStringFromTableInBundle(@"Camera",@"RPString", g_bundleResorce,nil);
    NSString * strPhotoLibrary = NSLocalizedStringFromTableInBundle(@"Photo Library",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (indexButton == 1) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
        }
        if (indexButton == 2) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        if (indexButton == 1 || indexButton == 2) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = sourceType;
            picker.allowsEditing = YES;
            picker.view.userInteractionEnabled = YES;
            
            [self.vcFrame presentViewController:picker animated:YES completion:^{
                
            }];
        }
    } otherButtonTitles:strCamera,strPhotoLibrary,nil];
    [alertView show];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    _bModify=YES;
    UIImage * imgCrop = [RPSDK CropImage:image withSize:CGSizeMake(640, 640)];
    [_btnPic setImage:imgCrop forState:UIControlStateNormal];
    _imgCustomer = imgCrop;
    [picker dismissModalViewControllerAnimated:NO];
}

//-(IBAction)OnSelVip:(id)sender
//{
//    _bVip = !_bVip;
//    if (_bVip)
//        [_btnVip setSelected:YES];
//    else
//        [_btnVip setSelected:NO];
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _bModify=YES;
    _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width, _viewFrame.frame.size.height + 300);
    
    if ( textField == _tfFirstName || textField == _tfPhone1)
    {
        if (_svFrame.contentOffset.y != _viewTable1.frame.origin.y - 10)
        {
            [_svFrame setContentOffset:CGPointMake(0,_viewTable1.frame.origin.y - 10) animated:YES];
        }
    }
    
    if ( textField == _tfPlace || textField == _tfBirthDay||textField==_tfBirthYear)
    {
        if (_svFrame.contentOffset.y != _viewTable2.frame.origin.y - 10)
        {
            [_svFrame setContentOffset:CGPointMake(0,_viewTable2.frame.origin.y - 10) animated:YES];
        }
    }
    if (textField == _tfEmail || textField == _tfPhone2)
    {
        if (_svFrame.contentOffset.y != _viewTable3.frame.origin.y - 10)
        {
            NSLog(@"%f",_svFrame.contentOffset.y);
            NSLog(@"%f",_viewTable3.frame.origin.y - 10);
            
            [_svFrame setContentOffset:CGPointMake(0,_viewTable3.frame.origin.y - 10) animated:NO];
            
            NSLog(@"%f",_svFrame.contentOffset.y);
        }
    }
        NSLog(@"_viewFrame.frame.size.height==%f",_viewFrame.frame.size.height);
        NSLog(@"textFieldDidBeginEditing==%f",_svFrame.contentSize.height);
    if (textField==_tfCareer) {
        
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width, _viewFrame.frame.size.height+100);
//    [_svFrame setContentOffset:CGPointMake(0,0) animated:YES];
//    if ([_svFrame.subviews objectAtIndex:1]==_viewJobAndFamily) {
//        [self showSize];
//    }

    NSLog(@"textFieldDidEndEditing==%f",_svFrame.contentSize.height);
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _bModify=YES;
    _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width, _viewFrame.frame.size.height + 300);
    
    if (textView==_tvMemorialDays) {
        [_svFrame setContentOffset:CGPointMake(0,_viewTable7.frame.origin.y - 10) animated:NO];
    }
    if (textView==_tvChildren) {
        [_svFrame setContentOffset:CGPointMake(0,_viewTable6.frame.origin.y - 10) animated:NO];
    }
    if (textView==_tvInterest) {
        [_svFrame setContentOffset:CGPointMake(0,_viewTable4.frame.origin.y - 10) animated:NO];
    }
    if (textView==_tvAddress) {
        [_svFrame setContentOffset:CGPointMake(0,_viewTable3.frame.origin.y - 10) animated:NO];
    }
        NSLog(@"textViewDidBeginEditing==%f",_svFrame.contentSize.height);
    
    
//    if ([_svFrame.subviews objectAtIndex:1]==_viewJobAndFamily) {
//        [self showSize];
//    }

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _bModify=YES;
    if (textField == _tfCareer) {
        [self OnSelectCareer];
        return NO;
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width, _viewFrame.frame.size.height+100);
//    [_svFrame setContentOffset:CGPointMake(0,0) animated:YES];
    NSLog(@"textViewDidEndEditing==%f",_svFrame.contentSize.height);
}

-(void)OnSelectCareer
{
    
//    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
//    CGPoint p=[_tfCareer.superview convertPoint:_tfCareer.frame.origin toView:keywindow];
//    
//    NSInteger nCount = _arrayCareer.count > 6 ? 6 : _arrayCareer.count;
//    _listViewCareer = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 198, nCount * 42)];
//    
//    _listViewCareer.datasource = self;
//    _listViewCareer.delegate = self;
//
//    [_listViewCareer show:CGPointMake(203,p.y+_tfCareer.frame.size.height+_listViewCareer.frame.size.height/2)];
    
    
    NSMutableArray *strArray=[[NSMutableArray alloc]init];
    for (int i=0; i<_arrayCareer.count;i++)
    {
        NSString *strTemp = [NSString  stringWithFormat:@"%@",[[_arrayCareer objectAtIndex:i]strCustomerCareerDesc]];
        [strArray addObject:strTemp];
    }
    
    
    
    NSString *mode=NSLocalizedStringFromTableInBundle(@"CAREER",@"RPString", g_bundleResorce,nil);
    
    RPBlockUISelectView *selectView= [[RPBlockUISelectView alloc]initWithTitle:mode clickButton:^(NSInteger indexButton) {
        if (indexButton>-1) {
            _nCareerIndex = indexButton;
            
            _tfCareer.text=[[_arrayCareer objectAtIndex:indexButton]strCustomerCareerDesc];
            
            [self.view endEditing:YES];
        }
        
    } curIndex:_nCareerIndex  selectTitles:strArray];
    [selectView show];
    
}

-(NSString *)GenEmptyString:(NSString *)str
{
    if (!str) {
        return @"";
    }
    return str;
}

-(void)setCustomer:(Customer *)customer
{
    _customer = customer;
    
    if (!customer.isVip) {
        [_ivVIP setImage:[UIImage imageNamed:@"icon_vip_off@2x.png"]];
        [_switchVIP SetOn:NO];
        _bVip = NO;
    }
    else
    {
        [_ivVIP setImage:[UIImage imageNamed:@"icon_vip_on@2x.png"]];
        [_switchVIP SetOn:YES];
        _bVip = YES;
    }
    
    switch (customer.Sex) {
        case Sex_Female:
            
            _lbSex.text=NSLocalizedStringFromTableInBundle(@"FEMALE",@"RPString", g_bundleResorce,nil);
            [_switchSex SetOn:YES];
            _bFemale=YES;
            break;
        case Sex_Male:
            
            [_switchSex SetOn:NO];
            _lbSex.text=NSLocalizedStringFromTableInBundle(@"MALE",@"RPString", g_bundleResorce,nil);
            _bFemale=NO;
            break;
        case Sex_NotAssign:
            [_switchSex SetOn:NO];
            _lbSex.text=NSLocalizedStringFromTableInBundle(@"MALE",@"RPString", g_bundleResorce,nil);
            _bFemale=NO;
            break;
        default:
            [_switchSex SetOn:NO];
            _lbSex.text=NSLocalizedStringFromTableInBundle(@"MALE",@"RPString", g_bundleResorce,nil);
            _bFemale=NO;
            break;
    }

    
    if (customer.strCustImgBig) {
        [_ivPic setImageWithURLString:customer.strCustImgBig];
    }
    
    _tfFirstName.text=customer.strFirstName;
    _tfPhone1.text = customer.strPhone1;
    
    _tfPlace.text = customer.strDistrict;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM-dd"];
    NSDate *date =[dateFormatter dateFromString:customer.strBirthDate];
    _pickDate = [[RPDatePicker alloc] initDay:_tfBirthDay Format:dateFormatter curDate:date canDelete:YES];
    if (customer.nBirthYear==0) {
        _tfBirthYear.text=@"";
    }
    else
    {
        _tfBirthYear.text=[NSString stringWithFormat:@"%d",customer.nBirthYear];
    }
    _tfEmail.text = customer.strEmail;
    
    _tfPhone2.text = customer.strPhone2;
    
    _tvAddress.text = customer.strAddress;
    _tvInterest.text=customer.strInterest;
    _tvChildren.text=customer.strChildrenDesc;
    _tvMemorialDays.text=customer.strMemorialDaysDesc;
    _tvInterest.text=customer.strInterest;
    
    _tfTitle.text=customer.strTitle;
    
    
}
-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}

-(void)OnSelectedStore:(StoreDetailInfo *)store
{
    _bStoreList = NO;
    
    [self dismissView:_viewStoreList];
    
    
    
    Customer * tempCustomer = [[Customer alloc] init];
    
    tempCustomer.strAddress = [self GenEmptyString:_tvAddress.text];
    
    if (_tfBirthDay.text.length != 0)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"MM-dd"];
        tempCustomer.strBirthDate = [dateFormatter stringFromDate:[_pickDate GetDay]];
    }
    else
    {
        tempCustomer.strBirthDate = @"";
    }
    
    tempCustomer.nBirthYear = [[self GenEmptyString:_tfBirthYear.text] intValue];
    tempCustomer.imgCust = _imgCustomer;
    tempCustomer.strDistrict = [self GenEmptyString:_tfPlace.text];
    tempCustomer.strEmail = [self GenEmptyString:_tfEmail.text];
    tempCustomer.strFirstName = [self GenEmptyString:_tfFirstName.text];
//    _customer.strSurName = [self GenEmptyString:_tfSurName.text];
    tempCustomer.isVip = _bVip;
    tempCustomer.strPhone1 = [self GenEmptyString:_tfPhone1.text];
    tempCustomer.strPhone2 = [self GenEmptyString:_tfPhone2.text];
    tempCustomer.strInterest=[self GenEmptyString:_tvInterest.text];
    tempCustomer.strTitle =[self GenEmptyString:_tfTitle.text];
    tempCustomer.strStoreId=store.strStoreId;
    
    NSString * careerId = @"";
    if (_nCareerIndex >= 0)
        careerId = [[_arrayCareer objectAtIndex:_nCareerIndex] strCustomerCareerId];
    tempCustomer.strCareerId =[self GenEmptyString:careerId];
    
    tempCustomer.strChildrenDesc =[self GenEmptyString:_tvChildren.text];
    tempCustomer.strMemorialDaysDesc =[self GenEmptyString:_tvMemorialDays.text];
    
    if (_bFemale)
        tempCustomer.sex = Sex_Female;
    else
        tempCustomer.sex = Sex_Male;
    
    BOOL bFound = NO;
    
    for (Customer *customer in _arrayAllCustomer)
    {
        if ([customer.strStoreId isEqualToString:store.strStoreId])
        {
            if ([customer.strPhone1 isEqualToString:[self GenEmptyString:_tfPhone1.text]])
            {
                NSString * strDesc = NSLocalizedStringFromTableInBundle(@"There is customer have the same mobile phone number,do you want to add the customer",@"RPString", g_bundleResorce,nil);
                NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
                NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
                
                RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
                    
                    if (indexButton == 1)
                    {
                        [SVProgressHUD showWithStatus:NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil)];
                        [[RPSDK defaultInstance] AddCustomer:tempCustomer Success:^(id dictResult) {
                            [self.delegate OnAddCustomEnd];
                            [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil)];
                        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
                        }];
                    }
                    
                } otherButtonTitles:strOK,nil];
                [alertView show];
                bFound = YES;
                break;
            }
        }
    }
    
    if (!bFound) {
        [SVProgressHUD showWithStatus:NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil)];
        [[RPSDK defaultInstance] AddCustomer:tempCustomer Success:^(id dictResult) {
            [self.delegate OnAddCustomEnd];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil)];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
        }];
    }
}

-(void)OnSelectStore
{
    _viewStoreList.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    _viewStoreList.tfSearch.text=@"";
    [self.view addSubview:_viewStoreList];
    
    [UIView beginAnimations:nil context:nil];
    _viewStoreList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    [_viewStoreList reloadStore];
    
//    _step = MAINTEN_SELECTSHOP;
}

- (BOOL)CheckInput:(NSString *)string {
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
    
}
-(BOOL)OutofRange
{
    NSDate *nowTime =[NSDate date];
    NSCalendar*calendar=[NSCalendar currentCalendar];
    NSDateComponents*components =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:nowTime];
    int year=[components year];
    if (_tfBirthYear.text.length==0) {
        return NO;
    }
    else if ([_tfBirthYear.text intValue]<1900||[_tfBirthYear.text intValue]>year-1)
    {
        return YES;
    }
    return NO;
}
-(void)OnSave
{
    if (_tvAddress.text.length>RPMAX_DESC_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Address length should not exceed 300 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    if (_tvChildren.text.length>RPMAX_DESC_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Children describe length should not exceed 300 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    if (_tvInterest.text.length>RPMAX_DESC_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Interesting length should not exceed 300 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    if (_tvMemorialDays.text.length>RPMAX_DESC_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"MemorialDays describe length should not exceed 300 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    if (_tfFirstName.text.length>RPMAX_NAME_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Name length should not exceed 20 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    if ([_tfFirstName.text isEqualToString:@""]||[_tfPhone1.text isEqualToString:@""]) {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Mobile phone number or \n name cannot be empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
    }
    else if (![self CheckInput:_tfPhone1.text])
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Mobile phone number\n must be numeric",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
    }
    else if([self OutofRange])
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"The year of birth is out of range",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
    }
    else
    {
        _bQuit=YES;
        if(_isAdd)
        {
            _bModify=NO;
            [self OnSelectStore];
            _bStoreList=YES;
        }
        else
        {
            Customer * tempCustomer = [[Customer alloc] init];
            tempCustomer.strCustomerId=_customer.strCustomerId;
            tempCustomer.strAddress = [self GenEmptyString:_tvAddress.text];
            if (_tfBirthDay.text.length != 0)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat: @"MM-dd"];
                tempCustomer.strBirthDate = [dateFormatter stringFromDate:[_pickDate GetDay]];
            }
            else
            {
                tempCustomer.strBirthDate = @"";
            }
            
            tempCustomer.nBirthYear=[[self GenEmptyString:_tfBirthYear.text] intValue];
            tempCustomer.imgCust = _imgCustomer;
            tempCustomer.strDistrict = [self GenEmptyString:_tfPlace.text];//
            tempCustomer.strEmail = [self GenEmptyString:_tfEmail.text];
            tempCustomer.strFirstName = [self GenEmptyString:_tfFirstName.text];
            //        _customer.strSurName = [self GenEmptyString:_tfSurName.text];
            tempCustomer.isVip = _bVip;
            tempCustomer.strPhone1 = [self GenEmptyString:_tfPhone1.text];
            tempCustomer.strPhone2 = [self GenEmptyString:_tfPhone2.text];
            tempCustomer.strInterest=[self GenEmptyString:_tvInterest.text];
            tempCustomer.strTitle =[self GenEmptyString:_tfTitle.text];
            tempCustomer.strStoreId=_customer.strStoreId;
            NSString * careerId = @"";
            if (_nCareerIndex >= 0)
                careerId = [[_arrayCareer objectAtIndex:_nCareerIndex] strCustomerCareerId];
            tempCustomer.strCareerId =[self GenEmptyString:careerId];
            
            tempCustomer.strChildrenDesc =[self GenEmptyString:_tvChildren.text];
            tempCustomer.strMemorialDaysDesc =[self GenEmptyString:_tvMemorialDays.text];
            if (_bFemale)
                tempCustomer.sex = Sex_Female;
            else
                tempCustomer.sex = Sex_Male;
            
            [[RPSDK defaultInstance] ModifyCustomer:tempCustomer Success:^(id dictResult) {
                if (self.delegateModify) {
                    [self.delegateModify OnModifyCustomerEnd];
                }
                if (self.delegate) {
                    [self.delegate OnAddCustomEnd];
                }
//                if (self.delegateEdit) {
//                    [self.delegateEdit OnEditCustomerEnd];
//                }
                [SVProgressHUD dismiss];
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                
            }];
        }
    }

}
-(IBAction)OnOK:(id)sender
{
    
    [self OnSave];
}

- (IBAction)OnPersonalProfile:(id)sender
{
    CGSize sz = CGSizeMake(_svFrame.frame.size.width, _viewFrame.frame.size.height+100);
    _svFrame.contentSize = sz;
    _viewBGPersonalProfile.backgroundColor=[UIColor lightGrayColor];
    _viewBGJobAndFamily.backgroundColor=[UIColor colorWithWhite:0.3 alpha:1];
    _lbPersonalProfile.textColor=[UIColor colorWithWhite:0.3 alpha:1];
    _lbJobAndFamily.textColor=[UIColor colorWithWhite:0.2 alpha:1];
    [_viewJobAndFamily removeFromSuperview];
    [_svFrame addSubview:_viewFrame];
}

- (IBAction)OnJobAndFamily:(id)sender
{
//    [self showSize];
    _svFrame.contentSize=CGSizeMake(_svFrame.frame.size.width, _viewJobAndFamily.frame.size.height);
    _viewBGPersonalProfile.backgroundColor=[UIColor colorWithWhite:0.3 alpha:1];
    _viewBGJobAndFamily.backgroundColor=[UIColor lightGrayColor];
    _lbJobAndFamily.textColor=[UIColor colorWithWhite:0.3 alpha:1];
    _lbPersonalProfile.textColor=[UIColor colorWithWhite:0.2 alpha:1];
    [_viewFrame removeFromSuperview];
    [_svFrame addSubview:_viewJobAndFamily];
}

-(void)showSize
{
    _viewChildren.frame=CGRectMake(10, 112, _viewChildren.frame.size.width, 38+38*_arrayChildren.count);
    
    _viewMemorialDays.frame=CGRectMake(10, 205+38*(_arrayChildren.count-1), _viewMemorialDays.frame.size.width, 38+_arrayMemorialDays.count*68);
    _viewJobAndFamily.frame=CGRectMake(0, 0, _viewJobAndFamily.frame.size.width, kViewJobAndFamilyhight+38*(_arrayChildren.count-1)+68*(_arrayMemorialDays.count-1));
    _svFrame.contentSize=CGSizeMake(_svFrame.frame.size.width, _viewJobAndFamily.frame.size.height);
}
//- (IBAction)OnAddChild:(id)sender {
//    MyChildren *children=[[MyChildren alloc]init];
//    children.sex=@"boy,";
//    children.age=12;
//    children.childrenInfo=@"这是我儿子，4岁，很调皮，不过很聪明，现在读4年级";
//    [_arrayChildren addObject:children];
//    [self showSize];
////    [_tvChildren reloadData];
//}

//- (IBAction)OnAddMemorialDay:(id)sender {
//    
//    MyMemorialDays *memorialDay=[[MyMemorialDays alloc]init];
//    memorialDay.memorialDate=@"May,15";
//    memorialDay.memorialContent=@"Merry Day";
//    [_arrayMemorialDays addObject:memorialDay];
//    [self showSize];
////    [_tvMemorialDays reloadData];
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_tbChildren) {
        return _arrayChildren.count;
    }
    else
    {
        return _arrayMemorialDays.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tbChildren) {
        return 38;
    }
    else
    {
        return 68;
    }

}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView==_tbChildren) {
//        RPChildrenCell *cell=(RPChildrenCell *)[tableView dequeueReusableCellWithIdentifier:@"RPChildrenCell"];
//        if (cell==nil) {
//            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"RPChildrenCell" owner:self options:nil];
//            cell=[nib objectAtIndex:0];
//        }
//        cell.customerCellDelegate=self;
//        MyChildren *children=[_arrayChildren objectAtIndex:indexPath.row];
//        cell.child=children;
//        cell.i=indexPath.row;
//        cell.tfAge.tag=indexPath.row;
//        return cell;
//        
//
//    }
//    else
//    {
//        RPMemorialDaysCell *cell=(RPMemorialDaysCell *)[tableView dequeueReusableCellWithIdentifier:@"RPMemorialDaysCell"];
//        if (cell==nil) {
//            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"RPMemorialDaysCell" owner:self options:nil];
//            cell=[nib objectAtIndex:0];
//        }
//        cell.memorialDayDelegate=self;
//        MyMemorialDays *memorialDay=[_arrayMemorialDays objectAtIndex:indexPath.row];
//        cell.memorial=memorialDay;
//        cell.i=indexPath.row;
//        cell.tfMemorialContent.tag=indexPath.row;
//        [cell.tfMemorialContent addTarget:self action:@selector(changeContentOffset:) forControlEvents:UIControlEventAllEditingEvents];
//        return cell;
//
//    }
//   
//}

-(void)changeContentOffset:(UITextField *)textfield
{
    
    _svFrame.contentSize=CGSizeMake(_svFrame.frame.size.width, _viewJobAndFamily.frame.size.height+300);
    
    NSLog(@"已经按下%d     %f",textfield.tag,_viewTable7.frame.origin.y+textfield.tag*68);
    [_svFrame setContentOffset:CGPointMake(0,_viewTable7.frame.origin.y+textfield.tag*68) animated:NO];
    NSLog(@"_sv%f",_svFrame.contentOffset.y);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"hahahhahah");
}
//-(void)OnDeleteChild:(MyChildren *)child
//{
//    
//    [_arrayChildren removeObject:child];
//    [self showSize];
//
////    [_tvChildren reloadData];
//}
//-(void)OnDeleteMemorialDay:(MyMemorialDays *)memorialDay
//{
//    [_arrayMemorialDays removeObject:memorialDay];
//    [self showSize];
////    [_tvMemorialDays reloadData];
//    
//}

//获取当前选中的是第几个cell里的textfield
-(int)contentOffset:(int)index
{
    return index;
}
//-(void)OnSelectAge:(MyChildren *)child Index:(int)index
//{
//    _indexChild=index;
//    _listViewAge=[[ZSYPopoverListView alloc]initWithFrame:CGRectMake(0, 0, 50, 42*30)];
//    _listViewAge.delegate=self;
//    _listViewAge.datasource=self;
//    [_listViewAge show:CGPointMake(181,300+ 38*index)];
//    [_tvChildren reloadData];
//}
//-(void)OnSelectSex:(MyChildren *)child Index:(int)index
//{
//    _indexChild=index;
//    _listViewSex = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 58, 42*2)];
//    _listViewSex.datasource = self;
//    _listViewSex.delegate = self;
//    [_listViewSex show:CGPointMake(130,301 + 38 * index)];
////    [_tvChildren reloadData];
//}

//-(void)selectSex:(MyChildren *)child Button:(UIButton *)btSex
//{
//    NSLog(@"bt.tag  %d",btSex.tag);
//    
//}

//- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//    return _arrayCareer.count;
//
//}
//
//- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    if (tableView==_listViewAge)
////    {
////        static NSString *identifier = @"VendorCellIdentifier";
////        UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
////        if (!cell) {
////            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
////        }
////        cell.textLabel.text = [NSString  stringWithFormat:@"%d",indexPath.row];
////        cell.selectionStyle = UITableViewCellSelectionStyleGray;
////        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
////        return cell;
////
////    }
////    else
////    {
//        static NSString *identifier = @"VendorCellIdentifier";
//        UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        }
////        _arraySex=[[NSMutableArray alloc]initWithObjects:@"girl,", @"boy,",nil];
//    
//        cell.textLabel.text = [NSString  stringWithFormat:@"%@",[[_arrayCareer objectAtIndex:indexPath.row]strCustomerCareerDesc]];
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
//        return cell;
////    }
//
//    
//    
//}
//
//-(void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//
//- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    MyChildren *child=[_arrayChildren objectAtIndex:_indexChild];
//////    if (tableView==_listViewSex)
//////    {
////        child.sex=[_arraySex objectAtIndex:indexPath.row];
//////    }
//////    else
//////    {
//////        child.age=indexPath.row;
//////    }
//////    [_tvChildren reloadData];
//    
//    _nCareerIndex = indexPath.row;
//    
//    _tfCareer.text=[[_arrayCareer objectAtIndex:indexPath.row]strCustomerCareerDesc];
//    [tableView dismiss];
//    [self.view endEditing:YES];
//}

//-(void)up:(BOOL)isUp
//{
//    if (YES) {
//        _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width, _viewFrame.frame.size.height + 300);
//    }
//    else
//    {
//        [self showSize];
//    }
//    
//}


//-(void)dateChanged:(id)sender{
//    UIDatePicker * control = (UIDatePicker*)sender;
//    NSDate* date = control.date;
//    /*添加你自己响应代码*/
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"dd-MM-yyyy"];
//    _tfBirthDay.text = [dateformatter stringFromDate:date];
//}
@end
