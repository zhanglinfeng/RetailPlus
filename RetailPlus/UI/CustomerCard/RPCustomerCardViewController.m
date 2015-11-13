//
//  RPCustomerCardViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-8-28.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "RPCustomerCardViewController.h"
#import "RPModifyCustomerViewController.h"
#import "SVProgressHUD.h"
#import "RPOwnedModel.h"

extern NSBundle * g_bundleResorce;

@interface RPCustomerCardViewController ()

@end

@implementation RPCustomerCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"CLIENT CARD",@"RPString", g_bundleResorce,nil);
    
    _viewFrame.layer.cornerRadius = 10;
    _viewTable1.layer.cornerRadius = 6;
    _viewTable2.layer.cornerRadius = 6;
    _viewTable3.layer.cornerRadius = 6;
    _viewTable4.layer.cornerRadius = 6;
    _viewTable5.layer.cornerRadius = 6;
    _viewTable6.layer.cornerRadius = 6;
    
    _viewFrame.frame = CGRectMake(_viewFrame.frame.origin.x, _viewFrame.frame.origin.y, _viewFrame.frame.size.width, _ivPic.frame.size.height + _btnSizeChg.frame.size.height);
    _bSmall = YES;
    [_btnSizeChg setImage:[UIImage imageNamed:@"botton_pageextend_01@2x.png"] forState:UIControlStateNormal];
    
    [_svDetail addSubview:_viewDetail];
    _svDetail.contentSize = CGSizeMake(_svDetail.frame.size.width, _viewDetail.frame.size.height);
    _bPurchaseRecord=NO;
    
    [[RPSDK defaultInstance]GetCustomerCareerList:^(NSArray * array) {
        
        _arrayCareer=array;
        for (int i=0; i<_arrayCareer.count; i++) {
            if ([_customer.strCareerId isEqualToString:[[_arrayCareer objectAtIndex:i]strCustomerCareerId] ]) {
                _lbCareer.text=[[_arrayCareer objectAtIndex:i]strCustomerCareerDesc];
            }
        }

        
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnEdit:(id)sender {   
    vcInsp = [[RPModifyCustomerViewController alloc] initWithNibName:NSStringFromClass([RPModifyCustomerViewController class]) bundle:g_bundleResorce];
    vcInsp.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView beginAnimations:nil context:nil];
    vcInsp.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [self.view addSubview:vcInsp.view];
    
    ((RPModifyCustomerViewController*)vcInsp).isAdd=NO;
    ((RPModifyCustomerViewController*)vcInsp).customer=_customer;
    ((RPModifyCustomerViewController*)vcInsp).delegateModify=self;
    ((RPModifyCustomerViewController*)vcInsp).vcFrame = self.vcFrame;
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"CLIENT PROFILE",@"RPString", g_bundleResorce,nil);
    [self.delegate OnReloadTitle];
    _bEdit=YES;
}
- (IBAction)OnPurchaseRecord:(id)sender
{
    //    [self.delegate OnPurchaseRecord];
    vcPurchaseRecord=[[RPPurchaseRecordViewController alloc]initWithNibName:NSStringFromClass([RPPurchaseRecordViewController class]) bundle:g_bundleResorce];
    vcPurchaseRecord.view.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    vcPurchaseRecord.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [self.view addSubview:vcPurchaseRecord.view];
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"PURCHASE RECORD",@"RPString", g_bundleResorce,nil);
    [self.delegate OnReloadTitle];
    _bPurchaseRecord=YES;
    vcPurchaseRecord.customer=_customer;
}
-(void)MakeCall:(NSString *)strPhone
{
    UIWebView* callWebview =[[UIWebView alloc] init];
    
    NSString * strPhoneNo = [NSString stringWithFormat:@"tel://%@",strPhone];
    NSURL *telURL =[NSURL URLWithString:strPhoneNo];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
    
    
}

- (IBAction)OnCall:(id)sender
{
    NSString *s=NSLocalizedStringFromTableInBundle(@"Please select phone No.",@"RPString", g_bundleResorce,nil);
    NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    if (_customer.strPhone1.length > 0 && _customer.strPhone2.length > 0) {
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:s cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1) {
                [self MakeCall:_customer.strPhone1];
            }
            if (indexButton == 2) {
                [self MakeCall:_customer.strPhone2];
            }
        } otherButtonTitles:_customer.strPhone1,_customer.strPhone2,nil];
        [alertView show];
        
        return;
    }
    
    if (_customer.strPhone1.length > 0)
    {
        [self MakeCall:_customer.strPhone1];
        return;
    }
    
    if (_customer.strPhone2.length > 0) {
        [self MakeCall:_customer.strPhone2];
        return;
    }

}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    switch ( result ) {
        case MessageComposeResultCancelled:
        {
            //click cancel button
        }
            break;
        case MessageComposeResultFailed:// send failed
            
            break;
        case MessageComposeResultSent:
        {
            
            //do something
        }
            break;
        default:
            break;
    }
}

-(void)MakeMsg:(NSString *)strPhone
{
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.recipients = [NSArray arrayWithObject:strPhone];
            picker.messageComposeDelegate =self;
            [self.vcFrame presentViewController:picker animated:YES completion:^{
                
            }];
        }
    }
}

- (IBAction)OnMessage:(id)sender
{
    NSString *s=NSLocalizedStringFromTableInBundle(@"Please select phone No.",@"RPString", g_bundleResorce,nil);
    NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    if (_customer.strPhone1.length > 0 && _customer.strPhone2.length > 0) {
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:s cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1) {
                [self MakeMsg:_customer.strPhone1];
            }
            if (indexButton == 2) {
                [self MakeMsg:_customer.strPhone2];
            }
        } otherButtonTitles:_customer.strPhone1,_customer.strPhone2,nil];
        [alertView show];
        
        return;
    }
    
    if (_customer.strPhone1.length > 0)
    {
        [self MakeMsg:_customer.strPhone1];
        return;
    }
    
    if (_customer.strPhone2.length > 0) {
        [self MakeMsg:_customer.strPhone2];
        return;
    }

}

- (IBAction)OnRemove:(id)sender {
}

- (IBAction)OnLinkageBreak:(id)sender
{
    NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Whether unbinding?",@"RPString", g_bundleResorce,nil);
    RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
        if (indexButton == 1) {
            [[RPSDK defaultInstance]LinkageBreakCustomer:_customer.strCustomerId Success:^(id idResult)
             {
                 [self.delegate OnAddCustomEnd];
                 [SVProgressHUD dismiss];
                 
             } Failed:^(NSInteger nErrorCode,NSString *strDesc)
             {
                 
             }];
        }
        
    }otherButtonTitles:strOK, nil];
    [alertView show];
    
    

}

-(IBAction)OnSizeChg:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    
    if (_bSmall) {
        NSInteger nHeight = _ivPic.frame.size.height + _viewDetail.frame.size.height + _btnSizeChg.frame.size.height;
        if (nHeight > _viewTask.frame.size.height - 20) {
            nHeight = _viewTask.frame.size.height - 20;
        }
        
        _viewFrame.frame = CGRectMake(_viewFrame.frame.origin.x, _viewFrame.frame.origin.y, _viewFrame.frame.size.width, nHeight);
        [_btnSizeChg setImage:[UIImage imageNamed:@"botton_pagerollup_01@2x.png"] forState:UIControlStateNormal];
    }
    else
    {
        _viewFrame.frame = CGRectMake(_viewFrame.frame.origin.x, _viewFrame.frame.origin.y, _viewFrame.frame.size.width, _ivPic.frame.size.height + _btnSizeChg.frame.size.height);
        [_btnSizeChg setImage:[UIImage imageNamed:@"botton_pageextend_01@2x.png"] forState:UIControlStateNormal];
    }
    
    _bSmall = !_bSmall;
    
    [UIView commitAnimations];
}


-(void)setCustomer:(Customer *)customer
{
    _tvAddress.editable=NO;
    _tvChildren.editable=NO;
    _tvMemorialDays.editable=NO;
    _tvInterest.editable=NO;
    
    
    _customer = customer;
    if ([_customer.strRelationUserId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId] &&
        [RPRights hasRightsFunc:[RPSDK defaultInstance].llRights type:RPRightsFuncType_Customer])
    {
        _btCourtesyCall.alpha=1;
        _lbCourtestCall.alpha=1;
        _btEdit.alpha=1;
        _lbEdit.alpha=1;
        _btLink.alpha=1;
        _lbLink.alpha=1;
        _btPurchase.alpha=1;
        _lbPurchase.alpha=1;
        
        _btCourtesyCall.userInteractionEnabled=YES;
        _btEdit.userInteractionEnabled=YES;
        _btLink.userInteractionEnabled=YES;
        _btPurchase.userInteractionEnabled=YES;
        
        if (![RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_CCall]) {
            _btCourtesyCall.alpha = 0.2;
            _lbCourtestCall.alpha = 0.2;
            _btCourtesyCall.userInteractionEnabled = NO;
        }
    }
    else
    {
        _btCourtesyCall.alpha=0.2;
        _lbCourtestCall.alpha=0.2;
        _btEdit.alpha=0.2;
        _lbEdit.alpha=0.2;
        _btLink.alpha=0.2;
        _lbLink.alpha=0.2;
        _btPurchase.alpha=0.2;
        _lbPurchase.alpha=0.2;
        
        _btCourtesyCall.userInteractionEnabled=NO;
        _btEdit.userInteractionEnabled=NO;
        _btLink.userInteractionEnabled=NO;
        _btPurchase.userInteractionEnabled=NO;
    }
    
    if (![RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_CCall])
    {
        UIImageView * iv = [[UIImageView alloc] initWithFrame:_btCourtesyCall.frame];
        iv.image = [UIImage imageNamed:@"button_lockedfunction.png"];
        [_btCourtesyCall.superview addSubview:iv];
    }
    
    if (customer.strCustImgBig) {
        [_ivPic setImageWithURLString:customer.strCustImgBig];
    }
    
    _lbCustomName.text=customer.strFirstName;
    _lbPhone1.text = customer.strPhone1;
    _lbStore.text=customer.strStoreDesc;
    _lbRelationUser.text=customer.strRelationUserName;
        _lbTitle.text=customer.strTitle;
    _lbLocation.text = customer.strDistrict;
    
//    _lbBirthDay.text = customer.strBirthDate;
    
//    if (customer.nBirthYear >= 1900) {
//        _lbBirthYear.text = [NSString stringWithFormat:@"%04d",customer.nBirthYear];
//    }
    if (customer.strBirthDate.length>0&&customer.nBirthYear>0)
    {
        if (customer.nBirthYear >= 1900)
        {
            _lbBirthDay.text=[NSString stringWithFormat:@"%d-%@",customer.nBirthYear,customer.strBirthDate];
        }
        else
        {
            _lbBirthDay.text = customer.strBirthDate;
        }
    }
    else if(customer.strBirthDate.length>0)
    {
        _lbBirthDay.text = customer.strBirthDate;
    }
    else
    {
        if (customer.nBirthYear >= 1900)
        {
            _lbBirthDay.text=[NSString stringWithFormat:@"%d",customer.nBirthYear];
        }
    }
    
    _lbEmail.text = customer.strEmail;
    
    _lbPhone2.text = customer.strPhone2;
    
    _tvAddress.text = customer.strAddress;
    
    _ivLink.hidden = !customer.isRelate;
    
    _ivVip.hidden = !customer.isVip;
    
    switch (customer.Sex) {
        case Sex_Female:
            _ivSex.hidden = NO;
            [_ivSex setImage:[UIImage imageNamed:@"icon_female_on_card@2x.png"]];
            break;
        case Sex_Male:
            _ivSex.hidden = NO;
            [_ivSex setImage:[UIImage imageNamed:@"icon_male_on_card@2x.png"]];
            break;
        case Sex_NotAssign:
            _ivSex.hidden = YES;
            break;
        default:
            _ivSex.hidden = YES;
            break;
    }
    
    _tvChildren.text=customer.strChildrenDesc;
    _tvMemorialDays.text=customer.strMemorialDaysDesc;
    _tvInterest.text=customer.strInterest;
    
}

-(BOOL)OnBack
{
    if (_bEdit) {
        if ([(RPModifyCustomerViewController*)vcInsp OnBack])
        {
            [UIView beginAnimations:nil context:nil];
            vcInsp.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            _bEdit=NO;
            self.strTaskName = NSLocalizedStringFromTableInBundle(@"CLIENT CARD",@"RPString", g_bundleResorce,nil);
            [self.delegate OnReloadTitle];
        }
        return NO;
    }
    if (_bPurchaseRecord) {
        if ([vcPurchaseRecord OnBack]) {
            [UIView beginAnimations:nil context:nil];
            vcPurchaseRecord.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            _bPurchaseRecord=NO;
            self.strTaskName = NSLocalizedStringFromTableInBundle(@"CLIENT CARD",@"RPString", g_bundleResorce,nil);
            [self.delegate OnReloadTitle];
        }
        return NO;
    }
    return YES;
}

-(void)OnModifyCustomerEnd
{
    [UIView beginAnimations:nil context:nil];
    vcInsp.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _bEdit=NO;
    [self.delegate OnAddCustomEnd];
}
-(void)OnModifyCustomerBackEnd
{
    [UIView beginAnimations:nil context:nil];
    vcInsp.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _bEdit=NO;
}

-(IBAction)OnCCall:(id)sender
{
    [self.delegateBusiness OnCustomerCCall:_customer];
}
@end
